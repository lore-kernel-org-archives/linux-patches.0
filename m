Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFA5A4D
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 03:54:37 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-686f090310dso422781b3a.0
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 20:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691639677; x=1692244477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T65HFgviXpuQEaQuQvJWe048FrBItQM2dkf3KrcfKV8=;
        b=C9qm/u7YyrXmjda5G+F/h6m5IrosXpbx8Zo1GkosHnocctdAGcoPWQYAtsb+LqWjYl
         eIfwmQPpN4XkSnzqZOsFlciTEmCSzIzirW1/xKjUJVMwLjAvwoaCJ7C2JmAbU3bDiDez
         1iEl2+4kbY+EuUEaygJkY6RRjIhL97TLgGSMcmN9z+QmSBgTM4LBtrjUZbNZ+PZ6o6+/
         CWUFl4CyJqFD89g2FukpX+LxbMdVJlgC2g/hJDcUm2+QhNpHZA3sWfA5U7iZYrR6S3OL
         TnA3Ww8axH5y4IMzG8cr33vXqOYUZET4yhWtGCM8DdiZavnEFsWSglQhIA41NclvCwTL
         h8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691639677; x=1692244477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T65HFgviXpuQEaQuQvJWe048FrBItQM2dkf3KrcfKV8=;
        b=C77mLOcFEp7cCSuYVsVamRYYoMYb+O8UT7yhvL3V1Ide/8LJEI1BIGDTL57rWyIo32
         hmc6BC4ArlZInOVO8X/nbniaLooDk6MiIt5iUxZrhqztM74XBzTFFMqvXpuqg5MV4jOU
         Od70c8BBBIlTEuKgEuWIX6c35ZcBP76XzY9w84up5kypf1Kk9Q+7WQ3GJe6y4WqcysOn
         VZ2qs352BXeE2Ic2qeGXz+1XbCx+P2U/bCljLXKXc4a575waLyew9rHzX8ILgdsW91WU
         AKaQTCmq8ERhVmdGQDtX6jfPYFvwBz6pRTwO0ALUUcUBKZHsNk0iElm5DRcX75XQPSzq
         MlzQ==
X-Gm-Message-State: AOJu0YwRnIRErzt9pvOv8kab0CWoaTy3ri9AOzYF0wS7tmOUf6C5iRRH
	QTnWgb9/9UL8tr02zJvK+s8=
X-Google-Smtp-Source: AGHT+IG3Xxt6oSCMxaIbRsqGyZbK+xF0XdK+eC/wYNbGojqgMJ+7VvX16KBfh2wj6UsPsYAMR1SpoA==
X-Received: by 2002:a05:6a20:244a:b0:12f:382d:2a37 with SMTP id t10-20020a056a20244a00b0012f382d2a37mr1667840pzc.15.1691639677329;
        Wed, 09 Aug 2023 20:54:37 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id 8-20020aa79108000000b00686da0e163bsm400650pfh.11.2023.08.09.20.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 20:54:36 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id C8BC08196A01; Thu, 10 Aug 2023 10:54:33 +0700 (WIB)
Date: Thu, 10 Aug 2023 10:54:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Message-ID: <ZNRfef0jTqcRQdNI@debian.me>
References: <20230809103636.615294317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lNMSrdUV5XmaBB9f"
Content-Disposition: inline
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>


--lNMSrdUV5XmaBB9f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 09, 2023 at 12:39:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.45 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--lNMSrdUV5XmaBB9f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZNRfdAAKCRD2uYlJVVFO
o3OvAQCm9b1Hq80VY7zGgilAcxvVPXZFTbY8E1GKCTVt1OZs4AD6A1WnH1L0p/lB
t0w715x/P76S9vcD9G/33BrpmEGFAwI=
=UB92
-----END PGP SIGNATURE-----

--lNMSrdUV5XmaBB9f--
