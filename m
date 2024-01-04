Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B2818EBF
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 05:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfhT8kuF"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d3e2972f65so496935ad.3
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 21:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704345615; x=1704950415; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g3NzzRz631nrmHxCWhVwS62FIh58ttvyDrTrVUoW0lw=;
        b=kfhT8kuFoEF1PPQrGhNiKlL7GpBUofFah7c2i1nsyyTBLplhoEpPuH9sLeYaqWLSfj
         rxDyNL44lgW1rSPooHvNEo7DfyLaA/BDlJtg6VYTPeLaEznyDzEO5jJ7xXeO4E/qdhXR
         1/nQbAG1IdOrO8t9Ztv4O0UKZtzCo5RZCJ0aG6GRJaWA2wjgIQI9F35UiNn89ok9e9fX
         Y5Spnz+mfUUMKwh/pOqjCVQFaEib3tQ9vM2NDFCIrmZjUj1pqGAvFsgt3BNN6jH7MQkU
         sG4tocGWUvm1JPrmaKGs/YQD47yroQpVVn/6q6X4eeeWLwHJuBdq+YPr2t7labqMkOK+
         di7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704345615; x=1704950415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g3NzzRz631nrmHxCWhVwS62FIh58ttvyDrTrVUoW0lw=;
        b=XqRFO/3f0nvLWxJ+LEnA5G4lVwqOoyximxuZ6wwaEhqezH11IaYZwOhmsOxjrAEa3B
         r84RQyR6Mpcq3ZWBABCfDdI7/RJW9QkOQvY3XgsTEOr84x1i1mUEew54ScRJZ+qudcEQ
         hV6ksoErBxs4U3UaM8TqhxXfNgSmO0y6TMHgmcvX3eeB7k6aeharg5Q2PiCbdYkDBq5H
         SObanC0FCcpOfkn8v88MPMX9A1D8YCDPkBbsM7nO+8iIoYZ/jfUohX8UBMcXmzas4aDe
         L7oQjyMShdqVSQVRitOPuxMQfOAjB0ctsOAyZWM54dGFNU+4lQcju0DuZN7G+E3ln8hm
         e06Q==
X-Gm-Message-State: AOJu0YzLPXeXBPU02yKpsWRZ/WWxJIJCE+xrrTh6u7zaEoelQSYEIInK
	sAE/nODjmX4LWhtnXXTPamI=
X-Google-Smtp-Source: AGHT+IHjISQRzYh9tkBeu5tmOF7gvQHMQ0tUCQ/ANdl6BpSWfWZ36Dbys8MO+YxDFI819ttVLUoMWw==
X-Received: by 2002:a17:902:db07:b0:1d4:cbfc:1ccb with SMTP id m7-20020a170902db0700b001d4cbfc1ccbmr56654plx.64.1704345615332;
        Wed, 03 Jan 2024 21:20:15 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902c3c400b001d395d3df30sm24573015plj.130.2024.01.03.21.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 21:20:14 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 118BC184790CB; Thu,  4 Jan 2024 12:20:10 +0700 (WIB)
Date: Thu, 4 Jan 2024 12:20:10 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
Message-ID: <ZZZACjAEBXL0DvO2@archie.me>
References: <20240103164834.970234661@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gCL66V2puD9uMZI8"
Content-Disposition: inline
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>


--gCL66V2puD9uMZI8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 03, 2024 at 05:55:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--gCL66V2puD9uMZI8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZZY/+gAKCRD2uYlJVVFO
o+iSAQDVZqyJauaNs1nMTVxRDf7yh24q/4XMnshBmztqxidgwgD9H7p1j+LlAuUX
0EiwvKAigIjgLEgD+gp0nUlBby33pAc=
=cKlU
-----END PGP SIGNATURE-----

--gCL66V2puD9uMZI8--
