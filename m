Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5781937997A
	for <patches@lists.linux.dev>; Mon, 23 Feb 2026 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883625; cv=none; b=jdctUqqX7J9229tWg9VUKjT9ffVopM+/XLBLzRX8J1gQeWB30FG/nPSPKS7tvZR69qVw9tnOMvCE00c4rCz4eYBUk2wG999HGpPsSqDBYK0LPf7aiOVVyQYro/4TxR/ej2Sx3rxYV8F+UJo7aFPDAcdhFw0kUSvZbXhCjR/IyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883625; c=relaxed/simple;
	bh=a47+wjzEFQM3mE5wXVcS4PxdztrWL6jwdpKX8/S97lc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qD7RBnRX0BuDINMGibYsF7EfduDXsUJ+sWC+Kh+jcxhchWfXTfEc7MpVwaIAZFWzM+e5nLruA3d9pM5i5A+TVq3ILd7/rb+ebxkwGH7UNpVvCcMuKj14u48jLdZ9VHShIeVUQ1xns0ojfao5sJAs+Du0SenBBLBf+VWWXmrYMkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=bJM3WAk7; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="bJM3WAk7"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A433040423
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1771883623; bh=02HXq/OpBLcQvKpjpOkKgJLkQHTj8Uut5lZbJ3ywpks=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bJM3WAk77Oeg6Oqu0IUzwEG2TqKsl7A6gAY2CuCRKbU6GHjEL8DDwENv1pt4rKhgg
	 2UBEhQU92deOaiLC8RM/nkhqCbA7SmIphQOdUFJOV/dJlBDVJ/GAbm+cidsd4SKjZB
	 ApULdr4ufSLIal/R2LqIQdriui6AAQ4DoslLkLJTbm+dG3kCodinRhZXimMD7+v3Sr
	 z8Av8/+5HtRplEwe36Is+todPGjWkUrs2kwtazjIv1tp8JcZdYpCB0UAKwSLndcfrK
	 IbdEyRnus3hhTH98eJkEAYFnAFWPoTiNn6QrgmcLoXlL2DugBP3waH0qXLnro1kD9h
	 bg1y4+F59+WGA==
Received: from localhost (c-71-229-227-126.hsd1.co.comcast.net [71.229.227.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id A433040423;
	Mon, 23 Feb 2026 21:53:43 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Askar Safin <safinaskar@gmail.com>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] doc: early_userspace_support.rst: trivial fix:
 directory -> file
In-Reply-To: <20260220165238.4162735-1-safinaskar@gmail.com>
References: <20260220165238.4162735-1-safinaskar@gmail.com>
Date: Mon, 23 Feb 2026 14:53:42 -0700
Message-ID: <871pib3z4p.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Askar Safin <safinaskar@gmail.com> writes:

> Trivial fix.
>
> Signed-off-by: Askar Safin <safinaskar@gmail.com>
> ---
>  .../driver-api/early-userspace/early_userspace_support.rst      | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/driver-api/early-userspace/early_userspace_support.rst b/Documentation/driver-api/early-userspace/early_userspace_support.rst
> index 61bdeac1b..60d1e1bc9 100644
> --- a/Documentation/driver-api/early-userspace/early_userspace_support.rst
> +++ b/Documentation/driver-api/early-userspace/early_userspace_support.rst
> @@ -73,7 +73,7 @@ usr/gen_initramfs.sh.  This means that CONFIG_INITRAMFS_SOURCE
>  can really be interpreted as any legal argument to
>  gen_initramfs.sh.  If a directory is specified as an argument then
>  the contents are scanned, uid/gid translation is performed, and
> -usr/gen_init_cpio file directives are output.  If a directory is
> +usr/gen_init_cpio file directives are output.  If a file is
>  specified as an argument to usr/gen_initramfs.sh then the

"Trivial fix" is not a great changelog ... but I've applied the patch,
thanks.

jon
