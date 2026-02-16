Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3F83321B0;
	Mon, 16 Feb 2026 16:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771257698; cv=none; b=vD1zr4Kfs4dAaO1oH5X8jXc4RbKtOoD9xAnsQMPAqbMKxen61ynP17ML6285fMTOWypg4m9Bg4VFw3B7YMbpkczGANsIPE1QUzlW9Xcc/xnMuCIp/OlAaxDs0IS3NoSeJ+Maq9C1xT8RHZZF4R+H55ginl0XXizU1MkJnspb6CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771257698; c=relaxed/simple;
	bh=jIVr4EMhbxLfBhJVNM0uEaoaqlclfdp51xNGeOTr5GA=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=RjPzreJPd4mEqFqymwT1uYnZs2VhmxcOO99RDAkTExEpVcuekrVShyJdsJMt1VHktCw1OptF7tGy95sOZlbLttQHNmqICSTPD6P1XMKnM3itJ/0QldcNpKuwO2eAHWJyPxrrd1e0igAyAUalpwAA93rrKzK8xvwbiBPbEtB1Q0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCtA6DBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCtA6DBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884F3C116C6;
	Mon, 16 Feb 2026 16:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771257698;
	bh=jIVr4EMhbxLfBhJVNM0uEaoaqlclfdp51xNGeOTr5GA=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=LCtA6DBCVr2TBT0CKrY9VzbcKdaAfJZKXvoj0/rq4OZKGoPR/Re+zt5a2cymZ2kDP
	 8fsXBmWb4FWDjLLH3kMul1dyw8djkfljTza8dDj5BsxWrV5PRKLTRIiOof0J/t0902
	 QzuwmEFerI/QaM6eYs4w8xkxTcT5I/t6HpQ9BoQ4n+Zi3gLQF8Mjbu6cQZnt1EKFiV
	 HBVCDGCbxAgj9RR09OluRcyPb1/RTNX3ZWwjJGdMz2/Z6VjCqwn/NHU9bUw3j4IexT
	 wyOacJbmuBKoDbzGysoiCy5qyl4lS1iS33dMxU5I8de2PCojIR9g6hsMGRUPcI5scz
	 YZu4FV30SqvIg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 16 Feb 2026 17:01:33 +0100
Message-Id: <DGGIG6WA0F2Y.Q5UZ6D6EE43W@kernel.org>
To: "Mark Brown" <broonie@kernel.org>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
Cc: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
 <akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
 <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
 <pavel@nabladev.com>, <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
 <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <achill@achill.org>, <sr@sladewatkins.com>
References: <20260213134704.728003077@linuxfoundation.org>
 <bde6d2f9-f554-49f1-9af8-084c4cdea035@sirena.org.uk>
 <DGGI5PT256ZX.E11J217J4EEK@kernel.org>
In-Reply-To: <DGGI5PT256ZX.E11J217J4EEK@kernel.org>

On Mon Feb 16, 2026 at 4:47 PM CET, Danilo Krummrich wrote:
> On Mon Feb 16, 2026 at 3:27 PM CET, Mark Brown wrote:
>> On Fri, Feb 13, 2026 at 02:48:19PM +0100, Greg Kroah-Hartman wrote:
>>> Gui-Dong Han <hanguidong02@gmail.com>
>>>     driver core: enforce device_lock for driver_match_device()
>>
>> This breaks boot on at least the Arm Juno platform, upstream it
>> introduced regressions on quite a few systems due to drivers registering
>> in the probe of other devices.  That's obviously not a great pattern but
>> a regreession is a regression.
>
> Just for reference, I've also sent the following to the stable patch appl=
y
> notice:
>
> "This commit reveals a few driver bugs resulting in deadlocks without the
> following fixes:
>
>   - 1. ed1ac3c977dd ("iommu/arm-smmu-qcom: do not register driver in prob=
e()")

One additional note, we want this commit backported regardless, as it also =
fixes
commit 0b4eeee2876f ("iommu/arm-smmu-qcom: Register the TBU driver in
qcom_smmu_impl_init").

I.e. the current code is racy in terms of async probe and the driver is nev=
er
unregistered even if built as module and the module is unloaded, which is a
potential UAF.

>   - 2. 730e5ebff40c ("gpio: omap: do not register driver in probe()")
>   - 3. https://lore.kernel.org/lkml/20260212235842.85934-1-dakr@kernel.or=
g/
>
> The third one will hopefully be picked up by the clk folks soon.
>
> (1) should be required since v6.11, (2) since (basically forever) v2.6.22=
 and
> (3) since v5.11.
>
> We should also consider that we do not know if (especially older) stable =
trees
> have similar cases that we did not catch in linux-next."
>
> - Danilo

