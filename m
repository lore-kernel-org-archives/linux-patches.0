Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D48390991
	for <patches@lists.linux.dev>; Mon, 18 May 2026 19:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132733; cv=none; b=twOcNDicutmer7nhizKtzz3p4l4sPOmlChJy8/Eo5QvoUPsLaDZOsxK0sHAf7CFfGTDf5IaFvfc6vr2lONq8BpvUnWJ192WR+mLpuTHu+ALHTxpYlJIn9CmIgsPfBFIlegAOKcayfum+wo5cilcs9K8kPli8Q86kq1x+T4TCOLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132733; c=relaxed/simple;
	bh=weo+MBRG/g1PNMDtnZKYbZc6wxN9ad89bpvSP5ejePw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MSo47JaAzXqdrMrDwZPGQkDaB2V2oS2hasRmY1snNN7RPepkNbVuI+WTHx1BUVqbmSOfEy0a6vOpzsFJ1nkG72eJa9Kzqr23j7qdnhjC+tb76GuqIAYxxh+el32NqiFGHay7u6xrynIw4pyvEKVxvzONuseTRgAcG/O3hriR4/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from mop.sam.mop (1.5.5.2.4.d.e.f.f.f.5.f.9.d.6.0.a.5.c.d.c.d.9.1.0.b.8.0.1.0.0.2.ip6.arpa [IPv6:2001:8b0:19dc:dc5a:6d9:f5ff:fed4:2551])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sam)
	by smtp.gentoo.org (Postfix) with ESMTPSA id D04AA342655;
	Mon, 18 May 2026 19:32:10 +0000 (UTC)
From: Sam James <sam@gentoo.org>
To: Sasha Levin <sashal@kernel.org>
Cc: gregkh@linuxfoundation.org,  ardb@kernel.org,
  herbert@gondor.apana.org.au,  patches@lists.linux.dev,
  stable@vger.kernel.org,  dist-kernel@gentoo.org,  kernel@gentoo.org
Subject: Re: [PATCH 6.6 404/474] crypto: nx - Migrate to scomp API
In-Reply-To: <20260518155236.reply-0001@kernel.org>
Organization: Gentoo
References: <87y0hha5dw.fsf@gentoo.org> <20260518155236.reply-0001@kernel.org>
User-Agent: mu4e 1.14.1; emacs 31.0.60
Date: Mon, 18 May 2026 20:32:07 +0100
Message-ID: <87lddgbjk8.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Sasha Levin <sashal@kernel.org> writes:

> On Sun, May 17, 2026, Sam James wrote:
>> This fails to build. I think it's this patch. I did try figure out why
>> but I couldn't spot it when comparing branches (and all other branches
>> are fine).
>>
>> /var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/drivers/crypto/nx/nx-common-pseries.c:1023:35:
>> error: initialization of 'void * (*)(struct crypto_scomp *)' from
>> incompatible pointer type 'void * (*)(void)'
>> [-Wincompatible-pointer-types]
>
> Thanks Sam. The root cause is that upstream 980b5705f4e7 ("crypto: nx -
> Migrate to scomp API") was written against the post-v6.6 simplified
> scomp API (alloc_ctx(void) / free_ctx(void *)), whereas v6.6 still uses
> the older alloc_ctx(struct crypto_scomp *tfm) / free_ctx(struct
> crypto_scomp *, void *) prototypes. The migration was pulled in as
> Stable-dep-of for adb3faf2db1a, but that fix does not actually require
> the scomp migration.

Thank you!

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEBBAEWCgCpFiEEJaa7iN2bdkxrVUHCc4QJ9SDfkZAFAmoLaTgbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25z
Lm9wZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQyNUE2QkI4OEREOUI3NjRDNkI1NTQx
QzI3Mzg0MDlGNTIwREY5MTkwDxxzYW1AZ2VudG9vLm9yZwAKCRBzhAn1IN+RkPqq
AP0Q1MFpmEp7hmHn5aMz1kxObp/RpPi/9pCdO2OiTzN6CQD/YmIhP8XbdAMJlsl/
USF4rnN3UH35o+lLGNkWIgE/XQw=
=iZ8l
-----END PGP SIGNATURE-----
--=-=-=--
