Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7E3255F56;
	Tue, 24 Jun 2025 08:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750752240; cv=none; b=qWkc2SaKQBrmtwi1i8/bP9Jjw1PV66SNbmkRrNoNT4KUVlORNKZqftWTIm6T9T2Aof6WpzRpK2l7D97u1s3EW5IO5hdUli2LE0kMAVq+ICLXCzyFmZATGYcsHYB20Yftd1fYP6Ztw3UPAVNYdetu/kMyeJehxQuw/4I3d7RnVec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750752240; c=relaxed/simple;
	bh=jyg+J812OVmwxWsr9CT39jEIx3YIoKY+j9Sh+B80VJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mMh3vkg+MZTz6DA63Bp1NoWEZNvjt6fYhyFtXlNUm7qFD5o5tFbfXPJ4+CZN0PcvhAXNJxZSuvas9NZYOjX85VBKbBBnL3hgyXmF0LyzOajCND0L3HdHLkmXfStw5451oRrhokrpZtpWRMqTMZQu//hcCGdz9GCtp1IvrKxmZ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=D+d6mKnf; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="D+d6mKnf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=tDVYWPNmh2zmkOG4aeyg7FLxnv6pvxsoz93ZF16Mfig=; t=1750752238;
	x=1751184238; b=D+d6mKnf63usbMEUaamfkzFkzxelHu9UIxm/5ySvaGRGF6I7VdZ/Qoz0BpPb1
	LTfk4ysylbA9E2roAueKXKssdrTi995QLVWzYjOpajtakRE477+tyFyz9a5fjkXBzDeDzCsl85zIv
	IRp4HXtalWVDHMogfu+Va3y3Gq0jcBVddiTwARpf91HYIzOhuT0Xvuq+pY2hlwhS3oZdwRgPrwjEP
	sCWGCWXLE0gc6lN4SOcKu8WZUBM1NRlAfhChtGPNT2znsJwOuRRuiH67+nsHB5tECxfJCzQmF15ZT
	oAv6+CYoaGGu5d49ikFW6LjC5qygCnk5h6cqoI6na9n6ur2tGw==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1uTy1K-008aN8-1z;
	Tue, 24 Jun 2025 09:24:42 +0200
Message-ID: <025d9611-2a7f-40fd-9124-7b62fe6c5e84@leemhuis.info>
Date: Tue, 24 Jun 2025 09:24:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 515/592] rust: devres: fix race in Devres::drop()
To: Benno Lossin <lossin@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>, Sasha Levin <sashal@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Christian Heusel <christian@heusel.eu>
References: <20250623130700.210182694@linuxfoundation.org>
 <20250623130712.686988131@linuxfoundation.org>
 <DAUALX71J38F.2E1VBF0YH27KQ@kernel.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <DAUALX71J38F.2E1VBF0YH27KQ@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1750752238;c80e4504;
X-HE-SMSGID: 1uTy1K-008aN8-1z

[CCing Miguel (JFYI) as well as Christian, who reported the build
error[1] with 6.15.4-rc1 (which I'm seeing as well[2]) caused by the
patch this mail is about according to Benno.]

[1] https://lore.kernel.org/all/a0ebb389-f088-417b-9fd4-ac8c100d206f@heusel.eu/

[2] https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora-rc/fedora-42-x86_64/09200694-stablerc-fedorarc-releases/builder-live.log.gz

On 24.06.25 01:14, Benno Lossin wrote:
> On Mon Jun 23, 2025 at 3:07 PM CEST, Greg Kroah-Hartman wrote:
>> 6.15-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Danilo Krummrich <dakr@kernel.org>
>>
>> [ Upstream commit f744201c6159fc7323c40936fd079525f7063598 ]
>>
>> In Devres::drop() we first remove the devres action and then drop the
>> wrapped device resource.
>>
>> The design goal is to give the owner of a Devres object control over when
>> the device resource is dropped, but limit the overall scope to the
>> corresponding device being bound to a driver.
> [...] 
> This is missing the prerequisite patch #1 from
> 
>     https://lore.kernel.org/all/20250612121817.1621-1-dakr@kernel.org

You afaics mean 1b56e765bf8990 ("rust: completion: implement initial
abstraction") [v6.16-rc3] – which did not cleanly apply to 6.15.4-rc1 in
a quick test; it was also not possible to revert this patch ("rust:
devres: fix race in Devres::drop()") cleanly; reverting worked after
reverting "rust: devres: do not dereference to the internal Revocable"
First, but that lead to another build error:
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora-rc/fedora-42-x86_64/09202837-stablerc-fedorarc-releases/builder-live.log.gz

Ciao, Thorsten
