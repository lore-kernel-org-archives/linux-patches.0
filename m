Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A5F7494
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 06:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707029495; cv=none; b=gnRyO204ne5tMjvsXtkkYu5putSK9J5OUtPmEZ2KHhFHUaglMLAFnJQ72o4zY+f+jJZjaG+W4Qdk3SlvvJUDqoudyUgGEr6PfWGitDqwYcExej0uOQuy2abJWS9tw/pH5JwM+eWXcfnxd1yRODc8qxJWf6Q6jW2h1TkIKepYVR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707029495; c=relaxed/simple;
	bh=TWYStyek2yVFcxjdK1fNZqAcriCNEswKCVwF/MvulMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TdVd0MNXwl7yNv9HTtIpG3NQkwXXWxk0ICNX6IjlI2UXBF1toC6ZK1MMZBG9ImDGQ+WHbBP0pgN0gin4dTrv2DWHV3pw96XFgCv1gGlwJs1xg+NmvKQ2bw5ReBHsqU/fE1Tsmr+lKrVBG0TqyD3/8uMejbpg9f+Q7PvmNEnr/FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRuOoF7V; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRuOoF7V"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5bdbe2de25fso3290659a12.3
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 22:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707029493; x=1707634293; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=806upVwJJIqrdHZYBEdu7UNncPOKx7M8gRsklLDCWtw=;
        b=kRuOoF7VO5nyxDnKqPg11pSctj0jKnxbfkIftfs63qFK9DN+vn7SXFgMfq8wNfVE8X
         jHRlD3n9s669vgq+U+UJF+LLhPlo6xzvHAitHshuRX0e4rcMmjET/sV1RaJGGsIVMU83
         Vg3trNiTurfvRiBt3GvtrvAemYQrSEMVXF69Aa+g7ljhQEjBPDu7yR5KNcQCES6sIzzf
         hLGavF7IkFcN5x2pBjsI+sPfBiqFH2oq3KwpZu2q+I5hrkBdSJ9QB5aU9cm4EEJjiGIg
         gGf80pspcBkP1Lum2H1iht++0tHynmCtT89eIQ8j1bOwV1Eie3pl54npfUvZp2Sjtgxg
         Nlqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707029493; x=1707634293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=806upVwJJIqrdHZYBEdu7UNncPOKx7M8gRsklLDCWtw=;
        b=LUM7FkYJ/nmSq8dhlOP0dc1uWwA2dOPMw1r7VRsFINOWfP7tMTGHj2ErVovrNpmvvm
         P9CoWSJ5o7rscDbxowDO5iVM3zXMJNDwbNKVKJpV2TEWY2yrW3GXlfa2VggYwIivqvPT
         R8b0c5mPuQW7wdxOgLHvXv8cWrQTIXZV3v/FL6WNCqqTgxiyboqnhoX9i6wZw0fFan/+
         WSHTrll6FbvLTFxXNZLzWs3RJ9k6eJUskaEM1CK4wmzddpGZIuRzR4aZINEQHJxWiEOS
         lvvJ4TQeqlivmMZ5SZX3cickj7DgmsCFHM+8Jy7LNo31AjuxrUeWB4oSSW2f8txJUCN9
         w7cw==
X-Gm-Message-State: AOJu0YzogyiMeDeAaamHbd7ZMLEocdOwJ2OT5dlIb4pB0Ba8VYzsZNZ1
	tbqx3N8icqUXgCl3Wz+XkyN4TctgfEGQhTmN8Rv+OWLIMnFXbiU8
X-Google-Smtp-Source: AGHT+IGk/vsXMjb+tMFduJVmtfptw5PVcP57IfsIzRz+/YTnLvCX0NAD1/hLjsceQNZjqKmRTY9lkQ==
X-Received: by 2002:a17:903:1cf:b0:1d9:8b4f:909e with SMTP id e15-20020a17090301cf00b001d98b4f909emr4233496plh.35.1707029493167;
        Sat, 03 Feb 2024 22:51:33 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUPUiSTLGMAbftianwgz4yYTknTZoq4FcECIUAbj0CjVv+k6+ciAQmNSPsrorUm+hDz5JkfOzYZ/wDPDhAYo9q3SPdNdh40QWKaIz0cmN3Bw2bllRKFbNYLa33QLJcJL89KyxQeqaHCc7fjVfeMa+Qfh8/OKzAtbTr4PrTOkz3fpSLHZcStMhROybWPe3qMU/ivVz+PXg248OKIXqDqJ2DKjZQTwiCsf/ICidO+LVAQVaN5swcAD84d3hyX88qTMQB2BYikZZ5oBI4F782XjUiftUzm07wiNZ9EahcZQ/Xa8RCynKHgSd/V6vk2uoPHz+FbhjwJzVgq4nkU8SUOLQLUpw0coNpbe5TRLf56TYBPz/acuT8L/JIbx5ezQ/obtaoONxddIPkuiHHIVmjMCb+GpD2kPIlXEwyBbKDAw7oHvPquMvqh++jgSJo65HKbyDKXlKmxiBH/S9tDCmvX9pCOlGrxu9bwyNFbKUWA6/OiJ1wXyOqc+FNDpuahx6VR/ubibe/NpJaTPZNvGy4eR6/EavX7iUsJO7LtMtvYjA==
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f7cc00b001d8ffe741basm4125133plw.36.2024.02.03.22.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 22:51:32 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 5D5441846855D; Sun,  4 Feb 2024 13:51:28 +0700 (WIB)
Date: Sun, 4 Feb 2024 13:51:28 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/326] 6.6.16-rc2 review
Message-ID: <Zb8z8OBV0CI8ZSVB@archie.me>
References: <20240203174810.768708706@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YW6O7mIOwnm0dUVX"
Content-Disposition: inline
In-Reply-To: <20240203174810.768708706@linuxfoundation.org>


--YW6O7mIOwnm0dUVX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 03, 2024 at 09:52:59AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.16 release.
> There are 326 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--YW6O7mIOwnm0dUVX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZb8z6gAKCRD2uYlJVVFO
ozUlAPwNme3FmvCgq4hk0g36NC3AOYHMFgFALcsVW5ExqnvHpQEA2UJJpwWlDJk1
VuPdN08hMaqU15neYQjlKPujZshscQk=
=DtpE
-----END PGP SIGNATURE-----

--YW6O7mIOwnm0dUVX--
