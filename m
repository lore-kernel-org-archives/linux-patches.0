Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF4D1851
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 03:59:07 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 7-20020a17090a098700b002298931e366so3048840pjo.2
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 19:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WLeCTKLOjsvJHGKffA44iOpzJOsW8nOqwiD1dGMipgc=;
        b=i5ewKIi6NmayJpWmf1uhY2f9ADFWtqN8MjCV1G9YcYOzB1aC6pvH4k0za0mVE2KXoc
         fKgrxF8nEua2tMY4yevTFGJ5/Dw8h5kzNkn8P7/HU9xDoIaT8X4dN4ubqQUSciTPrP6N
         ySOUwE3wYWWANlD+AWKMtUYyiCU7BC/YR33IGDo+M+sbIuRM2iw4RfTfK0181CkEZYJl
         mg2lbH1GGaHz83cBxByUxXsiKby4t3aaKYfIBJHiYSqXtV+NK3eznVQz17K/8hnaqOcZ
         DjifQ0A9NPkO2b5HsCxGzgzn3i/yvxkSK0YnzOPnwpTppOS0dUB4qv6O8/zhJ5R2Fdad
         IyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLeCTKLOjsvJHGKffA44iOpzJOsW8nOqwiD1dGMipgc=;
        b=WbIMXpun0ZKgVuays3pZn6KX10BppcezqCLKavEXmQp66xA65RhSf68/JY9Nc8fRV7
         oVAdNWCKUZoJDBVOG5eggnYBNKYybkawPlam6cX17qKFMvA9xM2Z2TapDssi1kLdiulR
         axSvXX407XmxcVhY5Md+HcG5PT30d/Zt5homsIMADBLP8yygkpovodLqkbtRGSui+ZlH
         mEEvAnvwjsJ/k0UpSmppjxJFWoFti3+siYgj3VjyD9TUfx73U1kclY33Apb9lnJ30Cpi
         YQZGMceXoh6yPzBuV1oklAK11KnmRyQhmrPzuHfEgDEG3xBf3v5yh4qxncUGJLGpFwyI
         nyuw==
X-Gm-Message-State: AFqh2kpXljpXd7TleuTAZ5Um38raVxPG+Rbtn2f0Qe/TaZFSyMjvA9n4
	Evi+LcJF8dmJpbnMT6quWDM=
X-Google-Smtp-Source: AMrXdXtAdF94FlVNkhaTxEB6Edd39GQT/6YNBQtDvnkZJj9WIYyVV4ZBTiiz2e1r9Audfm89OUNsTg==
X-Received: by 2002:a17:903:2014:b0:194:a7b2:4329 with SMTP id s20-20020a170903201400b00194a7b24329mr1140920pla.28.1673927946592;
        Mon, 16 Jan 2023 19:59:06 -0800 (PST)
Received: from debian.me (subs03-180-214-233-20.three.co.id. [180.214.233.20])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b0019327f40bfasm17265428plw.119.2023.01.16.19.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 19:59:05 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 061E1103EEA; Tue, 17 Jan 2023 10:59:02 +0700 (WIB)
Date: Tue, 17 Jan 2023 10:59:02 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
Message-ID: <Y8YdBuxEbU4G0PQe@debian.me>
References: <20230116154747.036911298@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DvcbpAMx1RoohX50"
Content-Disposition: inline
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>


--DvcbpAMx1RoohX50
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2023 at 04:50:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--DvcbpAMx1RoohX50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8Yc/gAKCRD2uYlJVVFO
o+wIAQCm6LCIEDiRLBDdPRnkc4ubppdvhaGdUdIDnut/0mco1wEA6vE1WnwkqqT4
AGkzFsk1A6a3ZGzpxUn6jHVTMw+hZwc=
=OLbD
-----END PGP SIGNATURE-----

--DvcbpAMx1RoohX50--
