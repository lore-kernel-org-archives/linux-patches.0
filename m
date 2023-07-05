Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2E910FE
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 06:58:49 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b8a462e0b0so7748345ad.3
        for <patches@lists.linux.dev>; Tue, 04 Jul 2023 23:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688540328; x=1691132328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eOBekDUo3aipR+GfrPkz/lBRM9kv+I/UnJZ1bWtQhbY=;
        b=kne59eDqFdRnpjPhStuLzwuz+YDVUhmmKeqSHqHqLYyM8Mx36L7+BjMRrjKBQsaZFn
         a1k9jKJWO/96LQUltnKeV7RrW/lgYMnxXmSrm9sOrA4YoYct5x2GCtzQ9lpCi1AYpFIb
         tESHMxS5Bvi8+DKLsQihkvH9ZCrrNoGYw+wIZSOfcpI8n1tofTsFjwpIOhmA6fqtwFSl
         IJnRTrybtirGbX06wH7Wgn/3s7nFoqyIb8vxpC9koMIeRXqSgyy9oga/zu5FKAOcn7kD
         ESvt/PKbaXnbfSYQ5pwTUj4W9YUNYA98J/+0nhvc1cZ2cBZqivnPfNtmg/33GJdzJrC8
         BKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688540328; x=1691132328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOBekDUo3aipR+GfrPkz/lBRM9kv+I/UnJZ1bWtQhbY=;
        b=Q9RZX/h40pCeinkEktNEYHtC4b2iL6BE8PjWNB7LIn0df3OydMTxSjfTo+Vdxj9Rif
         ZzG3iMX4X/GRkMDx7xnzpC/dMEAEepvQU+ektlM2yrw9q/8ZBgxOWD9RabcazlgEkJjl
         zTGS+728D8OVnF6E8csZezORH8AoVCC5YJFJIMVi4pL6wjdEiv1siJ5IupJRMXlh94sm
         tEcbZz23triH70kX7ypAFwdrKViLfvVANtsGfA43EyjdU22TBjQUpRAt0FvUMP/HPslm
         LVSlduiRe9tGOi72IjZBEO93k/rQY4VjCTWaCpnxl8wjss7XdWO48L1PhA0YglDwd0xr
         HaPg==
X-Gm-Message-State: ABy/qLbmnA8ksk/KFzP1/w1zcL/gSRaVB0SeVN9nI1PaKnvWCCfh7zwE
	b/DoTRcRItBfhOzX+ytIoJ4=
X-Google-Smtp-Source: APBJJlGJh47YE1+DxQRpHxFoXP7erWWhRznO03XdtQE8sGDLNFyyo1zLqh4sST49Hn/8ANgjgHDFRQ==
X-Received: by 2002:a17:903:246:b0:1b1:99c9:8ce1 with SMTP id j6-20020a170903024600b001b199c98ce1mr13265300plh.51.1688540328442;
        Tue, 04 Jul 2023 23:58:48 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902e9d500b001b8649e52f8sm9490928plk.254.2023.07.04.23.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 23:58:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 2FAF78061696; Wed,  5 Jul 2023 13:58:43 +0700 (WIB)
Date: Wed, 5 Jul 2023 13:58:42 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/13] 6.1.38-rc2 review
Message-ID: <ZKUUovHusmwmZR1S@debian.me>
References: <20230704084611.071971014@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/qHfQp2kcWQ1L9Da"
Content-Disposition: inline
In-Reply-To: <20230704084611.071971014@linuxfoundation.org>


--/qHfQp2kcWQ1L9Da
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 04, 2023 at 09:48:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.38 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--/qHfQp2kcWQ1L9Da
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZKUUngAKCRD2uYlJVVFO
ozhZAP9kql9Y4fampzYuzVfCougXR8SF4O6k5UH3zH47EFr6IAD/TKLMLdQUqa/Z
i6rYxXb1rxe2G8Ak4sv0ANy0mVUpwAw=
=EBqP
-----END PGP SIGNATURE-----

--/qHfQp2kcWQ1L9Da--
