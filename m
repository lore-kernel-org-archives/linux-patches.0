Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88AD233D7C
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731089480; cv=none; b=KQykaHpmvUQrEZxSNuL56kLXojwrl652vd1rLLD9Y4QyTILW6an75GfV1MrF0G7IucIuwGfnnEqhkEHyij+pQB2LP96u3wbi9mUY+tmzTEEkDkwhoNsJoT1OhmpkavjJlkFgbSz22EREk+z8DUqQ5D3wROBpmRHXuj22A7xcbYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731089480; c=relaxed/simple;
	bh=zfcC/sJtOzsxSdqMutQW4OAIMYV9gnC6SPF3zIJH/wM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jArLU0YElf7OwFnt7WYUWKDL0BdiG6w1DFAO/upqDmxHlXqLioiHbT3v8os2LtyeYJtBFelTtYeblDIY9HBhjV5Lefiqxjyqq8V43CRU6u9t9Xoh5RpmQT3WJCRqQWWU+4Fwi3JhM3YmaJhXHMNkVTVU3pAnCxGwfV1UToSi34w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=IFcQ53Kg; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="IFcQ53Kg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1731089476;
	bh=zfcC/sJtOzsxSdqMutQW4OAIMYV9gnC6SPF3zIJH/wM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=IFcQ53KgR4uSpGEw/5ahUJ6nJEY1qhObQpqKxuKnu1FFIFPbWYhkYap7LPWJ1wCKn
	 HvBMCA4DKDvczQTii52bdnJOQnsJduG23HUhvEqs9AGnKfF8euT4xJBzhJmAgAhviz
	 8MRV/52NgEetOtqodvX4HycFoyiZLOmiRqa1isZc=
Date: Fri, 8 Nov 2024 13:11:08 -0500 (EST)
From: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas@weissschuh.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Message-ID: <d4fd2fc7-bd3a-4ce1-91a2-9afdc092e881@weissschuh.net>
In-Reply-To: <20241108175437.GD2564051@thelio-3990X>
References: <20241107-sysfs-const-mmap-fix-cdx-v1-1-2ed9b7cd5f8b@kernel.org> <f005d74e-7b35-42de-a80f-e5650e3d164d@weissschuh.net> <20241108175437.GD2564051@thelio-3990X>
Subject: Re: [PATCH] cdx: Fix cdx_mmap_resource() after constifying attr in
 ->mmap()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <d4fd2fc7-bd3a-4ce1-91a2-9afdc092e881@weissschuh.net>

Nov 8, 2024 12:54:41 Nathan Chancellor <nathan@kernel.org>:

> On Fri, Nov 08, 2024 at 12:23:50PM -0500, Thomas Wei=C3=9Fschuh wrote:
>> Nov 7, 2024 12:07:56 Nathan Chancellor <nathan@kernel.org>:
>>> Fixes: 94a20fb9af16 ("sysfs: treewide: constify attribute callback of b=
in_attribute::mmap()")
>>
>> I'm not sure about the Fixes tag.
>> cdx.c is not yet in mainline and this change should be folded into the c=
dx patch or the sysfs patch, depending on their order in the merge window.
>> I guess Greg will take care of it.
>
> This code is in mainline, so I think the Fixes tag is correct?

Indeed. Sorry for the noise.
I re-checked this before writing the other mail, but somehow failed.
(Maybe because I did it on a phone)

I'm wondering how this got through 0day, too.
Anyways, it shouldn't matter.
Thanks again for the fix!

> =C2=A0 $ git grep cdx_mmap_resource v6.12-rc1 drivers/cdx/cdx.c
> =C2=A0 v6.12-rc1:drivers/cdx/cdx.c: * cdx_mmap_resource - map a CDX resou=
rce into user memory space
> =C2=A0 v6.12-rc1:drivers/cdx/cdx.c:static int cdx_mmap_resource(struct fi=
le *fp, struct kobject *kobj,
> =C2=A0 v6.12-rc1:drivers/cdx/cdx.c:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 res_attr->mmap =3D cdx_mmap_resource;
>
> The error is reproducible on driver-core-next since that is what I based
> this change on.
>
> Thanks for the review!
>
> Cheers,
> Nathan

