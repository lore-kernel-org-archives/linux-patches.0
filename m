Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601D5208A0
	for <patches@lists.linux.dev>; Wed, 30 Oct 2024 00:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730249102; cv=none; b=Rxoznd+3bDKVbg41OKsXrBbjTBC9uJKTPYwc9sJhvS0HN8pDAL2fqZjAW8GjNdHHz5fGQYVjtCSgb+nWyd7+SHlRrB8FvfqqRlGOoBWlMdH/yzUlgO2uxrDgJdFqD2ogzAlV4bwy9/euUuNkch4E2PoOgGYJfukm8GogrBV3afg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730249102; c=relaxed/simple;
	bh=pXio2wdUDMoiGFHfLw3/Vx7YceKDVC7pdKMIjgzX2OE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDASkxIB2YoDFYsEd9mwm8sHs8FXc1Lpb2eA+C6OApTer0vLe6H5k58g+hJ+szrMQz53//VWldXOvH9qOevXcjk3RJnNtFlWcJGIvLdXB7WhEddultfAIXXjaUDC/vilhg+wBI3rgIdFvzrtQHqIWYSdHfQQS1BkAvPkSATpkdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrtCn/99; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrtCn/99"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20c714cd9c8so64006175ad.0
        for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730249100; x=1730853900; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A24LiSsyJiEk/qFejTrPE3fT4wSdNc0P2TRo47qCLuU=;
        b=WrtCn/99YH7dADpYOU7Tx2Kjal3DkD8Rtxi1+addYUczkeHxdFpf8st6xNtvzmR7f9
         8erbD4gZI0qIBhi4aypXwyWEIDcEZgo5GrNy8COGk4mMpB1mVeqc00OAEUWqLiPknodU
         OCqtxsHdo9NN8wwmft58UgA4zP1Lhovb290DU3D50RzulfGxqle7fnXv15Xt9kUbN6OV
         x2t3/guLH6BkwA0Qq6vCoYk3ootSc8saWf2Pv/QARnGF3QQAZFSl/pxzRw8UArOAhcek
         kR/Qzs6JamSo3J6ZtlKyyO5cNV4PZ/ddkaMxc6JqWjjA2AgQ2khqq/ZbQxGqYqm3FXOl
         y/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730249100; x=1730853900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A24LiSsyJiEk/qFejTrPE3fT4wSdNc0P2TRo47qCLuU=;
        b=cIsO6a+KJgQhthAE4AT/lj5DDvIXhP5ktfZcXfYXjaloJEsnED9eI8UkAiZnpt82MN
         EC4jsv02mfoadJk0wHjbxZrMBPTS3u8FBVIOHvF5HpBMfzgVi5dchCAGD6jFeIMjB6F6
         vaJNlUWrIXIoqN6aX10wjzK2oQfqYtnkoS2WMZBmvoXei7E+OAAML17jd4JrUH4ebkaw
         URxqu2A8T5e7dTd6hdIsp9JlknigSVpCRDXZm+bhnjc0knr5acACEZP9BzVaPBjjgEoI
         zhn7wDQJgqW/Vd/bCuiD+GBAA5eP8Of4NU2MZISDBfxDcf7bKWxPzjhcBrTz9XWN1zfL
         0Z7Q==
X-Gm-Message-State: AOJu0YzxyO0wwNW2DEibEwZKtnYsg5skQRPUAO/+BWyr1ne3HESEpZac
	xiL40MiueaVVcqYjpBAj2y8S9HpuGv5yVRkPlfJbHc8fwr+UV57o
X-Google-Smtp-Source: AGHT+IGLFUz+xvFh/xCkAuS0PEoCSFQEaY+yvArAdCO8ZetW8ehW0ohQ7yGuHyH/hxr5H8CPb9Qxjg==
X-Received: by 2002:a17:903:234c:b0:20c:528d:7063 with SMTP id d9443c01a7336-210c689ce77mr184766895ad.19.1730249099454;
        Tue, 29 Oct 2024 17:44:59 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc01368csm72176725ad.164.2024.10.29.17.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 17:44:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 29FD8462A27B; Wed, 30 Oct 2024 07:44:49 +0700 (WIB)
Date: Wed, 30 Oct 2024 07:44:48 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] Documentation: admin: reorganize kernel-parameters
 intro
Message-ID: <ZyGBgN406j-K5BCh@archie.me>
References: <20241029180320.412629-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e4u8eU8RmbDUTVAt"
Content-Disposition: inline
In-Reply-To: <20241029180320.412629-1-rdunlap@infradead.org>


--e4u8eU8RmbDUTVAt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 11:03:20AM -0700, Randy Dunlap wrote:
> --- linux-next-20241025.orig/Documentation/admin-guide/kernel-parameters.=
rst
> +++ linux-next-20241025/Documentation/admin-guide/kernel-parameters.rst
> @@ -27,6 +27,16 @@ kernel command line (/proc/cmdline) and
>  when it loads a module, so the kernel command line can be used for
>  loadable modules too.
> =20
> +This document may not be entirely up to date and comprehensive. The comm=
and
> +"modinfo -p ${modulename}" shows a current list of all parameters of a l=
oadable
> +module. Loadable modules, after being loaded into the running kernel, al=
so
> +reveal their parameters in /sys/module/${modulename}/parameters/. Some o=
f these
> +parameters may be changed at runtime by the command
> +``echo -n ${value} > /sys/module/${modulename}/parameters/${parm}``.
> +
> +Special handling
> +----------------
> +
>  Hyphens (dashes) and underscores are equivalent in parameter names, so::
> =20
>  	log_buf_len=3D1M print-fatal-signals=3D1
> @@ -39,8 +49,8 @@ Double-quotes can be used to protect spa
> =20
>  	param=3D"spaces in here"
> =20
> -cpu lists:
> -----------
> +cpu lists
> +~~~~~~~~~
> =20
>  Some kernel parameters take a list of CPUs as a value, e.g.  isolcpus,
>  nohz_full, irqaffinity, rcu_nocbs.  The format of this list is:
> @@ -82,12 +92,17 @@ so that "nohz_full=3Dall" is the equivalen
>  The semantics of "N" and "all" is supported on a level of bitmaps and ho=
lds for
>  all users of bitmap_parselist().
> =20
> -This document may not be entirely up to date and comprehensive. The comm=
and
> -"modinfo -p ${modulename}" shows a current list of all parameters of a l=
oadable
> -module. Loadable modules, after being loaded into the running kernel, al=
so
> -reveal their parameters in /sys/module/${modulename}/parameters/. Some o=
f these
> -parameters may be changed at runtime by the command
> -``echo -n ${value} > /sys/module/${modulename}/parameters/${parm}``.
> +Metric suffixes
> +~~~~~~~~~~~~~~~
> +
> +The [KMG] suffix is commonly described after a number of kernel
> +parameter values. 'K', 'M', 'G', 'T', 'P', and 'E' suffixes are allowed.
> +These letters represent the _binary_ multipliers 'Kilo', 'Mega', 'Giga',
> +'Tera', 'Peta', and 'Exa', equaling 2^10, 2^20, 2^30, 2^40, 2^50, and
> +2^60 bytes respectively. Such letter suffixes can also be entirely omitt=
ed.
> +
> +Kernel Build Options
> +--------------------
> =20
>  The parameters listed below are only valid if certain kernel build optio=
ns
>  were enabled and if respective hardware is present. This list should be =
kept
> @@ -212,10 +227,5 @@ a fixed number of characters. This limit
>  and is between 256 and 4096 characters. It is defined in the file
>  ./include/uapi/asm-generic/setup.h as COMMAND_LINE_SIZE.
> =20
> -Finally, the [KMG] suffix is commonly described after a number of kernel
> -parameter values. These 'K', 'M', and 'G' letters represent the _binary_
> -multipliers 'Kilo', 'Mega', and 'Giga', equaling 2^10, 2^20, and 2^30
> -bytes respectively. Such letter suffixes can also be entirely omitted:
> -
>  .. include:: kernel-parameters.txt
>     :literal:

The docs LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--e4u8eU8RmbDUTVAt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZyGBfAAKCRD2uYlJVVFO
ozreAP98bImbnVqWw/hsvw9b4m7/9BAt1OopbPNjFN3Mw9GocwEA4BMrvhr02iVF
kMbYrGun7BKAOwC2PqC++WQOsqLaHgw=
=idfp
-----END PGP SIGNATURE-----

--e4u8eU8RmbDUTVAt--
