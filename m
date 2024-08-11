Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A6424B28
	for <patches@lists.linux.dev>; Sun, 11 Aug 2024 11:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723375325; cv=none; b=tXU7zZa1O6Y5KZc9Uwk9cv/3Nhn1IwxriNGdqmK/BeyZKwsHsF2g2jpX0ipaJPjlppi7Y+o0bp/ffEDlVIddFCcK7dRnTUM5wSYgCcSvZLifJpY4aqEOOq2e69RFCaP7Kk9mbUefaA01uEz/8WhBaSJjJPuSdezAwZ3sEJNSvJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723375325; c=relaxed/simple;
	bh=WB+HTTvu/+yDXuGjc/zdOw/Oxu0DVfS1BPI97Om7kMU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=a0FMWztXuobV4q+lyorVBxG9aWDgWkbhnOEky1R9ID1ah/AdL2fFgK3u+MRSRkh892DV83N/tAEnganQcHNunjIWU8+GdL7/yJ5BQ8cn4sa7d0yoQ+dXMVLLUE5/Lff0JYTcr1ch5uE2A973+vWGI5An1Sar7PFp9oUHU9xGYJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=C0VxXu37; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="C0VxXu37"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1723375319; bh=WB+HTTvu/+yDXuGjc/zdOw/Oxu0DVfS1BPI97Om7kMU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=C0VxXu37vMjwqGAyyHK/GFi8QvXZsHjhao8La3DeJqAcAxSb/5FTpd6rV51e/HZTN
	 ByxZgDg9xSFAJSjhoc+u8VFCUucH00L9Znp4V6L7AbUbUQ3r4CwR2gbYUhE4cDGSmX
	 ZnU8gmVbMstyNXOsLGp3aUOS5UOrRLUnJkokHUyY=
Date: Sun, 11 Aug 2024 13:22:00 +0200 (GMT+02:00)
From: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh_?= <thomas@t-8ch.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Joel Granados <j.granados@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Message-ID: <08653c1b-ebc4-4f79-b718-636df0def362@t-8ch.de>
In-Reply-To: <2024081152-retriever-reword-e74a@gregkh>
References: <20240807150019.412911622@linuxfoundation.org> <20240807150019.868023928@linuxfoundation.org> <0352ae40-ba3e-4d27-84c6-19926a787c33@t-8ch.de> <2024081152-retriever-reword-e74a@gregkh>
Subject: Re: [PATCH 6.6 015/121] sysctl: treewide: drop unused argument
 ctl_table_root::set_ownership(table)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <08653c1b-ebc4-4f79-b718-636df0def362@t-8ch.de>

Hi Greg,

Aug 11, 2024 12:45:38 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:

> On Wed, Aug 07, 2024 at 06:38:13PM +0200, Thomas Wei=C3=9Fschuh wrote:
>> Hi Greg,
>>
>> On 2024-08-07 16:59:07+0000, Greg Kroah-Hartman wrote:
>>> 6.6-stable review patch.=C2=A0 If anyone has any objections, please let=
 me know.
>>
>> I don't think this has any value being backported to any version.
>
> Did you miss this line:
>
>>> Stable-dep-of: 98ca62ba9e2b ("sysctl: always initialize i_uid/i_gid")

I did. Thanks and sorry for the noise.

FWIW it should be trivial to break the dependency,
but it's probably not worth to complicate it.

Thomas
