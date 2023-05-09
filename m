Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D476116
	for <patches@lists.linux.dev>; Tue,  9 May 2023 13:32:14 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-64384274895so4177767b3a.2
        for <patches@lists.linux.dev>; Tue, 09 May 2023 06:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683639134; x=1686231134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jQ/yIyYnbZbKg8g90S1XE68/Rwvr6KsEAjyFTeYtEj4=;
        b=B0ArtTWyhv49+8tDuQVz36UQeupkIqIeW/hIB3NQny8MY5BJA2j5vBH6KdVHLNqEuz
         vAGXZYBT6UoqQ835CLCxCN0ZucH6FYlCoqd3BKKIXo7VOUKOvxFr7KNd336xqYn5yoVx
         aiFmODeMz8EkinkPgCwzfsWydiej+FLrEfs2Ica1WnSylchx5y5Yp9M0cFP1f4RdqWWN
         31A4Mq519mCs9s/k3ZQSQS0VtGi0Vf0O/qpHf52OXNo+JobrpPFF4CIgWRfNndpdpb5/
         2waeVPP3188Eei9k8cc0K9ED0XkmQ7Rjv3bw3m5B1KWo0fT6cP24k4JNyo9sTo+eg8HQ
         q2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683639134; x=1686231134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQ/yIyYnbZbKg8g90S1XE68/Rwvr6KsEAjyFTeYtEj4=;
        b=EgdjTUijDCVaP9ArZdRRdZ4pnsrs57m8yMoc3eOEJj+LYXYuOnEjtbG5yJWeuygTxW
         fmRSkZPPlps86m0DRWaaV2rEcUA3sgr9s1RDVqS09kslgM//iGj4ZwHc8YjWE4yqUMs+
         nvIVtLMBONX05uq/c1pdimQURBNDDET21szfhoWAEDZ4My6jM/wyAFKHNeCR1t6dADsd
         54CWXWY6ex6H4+j+frqb3nUkB/YTSs7o41xGbZmHlJ0ZMd2tzpurkgqdsSJ/2cr/Y8YK
         bnVq3s1Ia5Jf8NGv/WYS3rJcxg2mbna3qxYINg2VsoxT+jJeQJB5F0OwynzbEuWNWoE6
         TEsw==
X-Gm-Message-State: AC+VfDw6uo/1YNwx+3fCV7TTVKPrvox4XEoPiVIG4xYVQjGargdEGtXm
	ZAsDvu8QlZTsZ3rzgkuxsBU=
X-Google-Smtp-Source: ACHHUZ56B1e7eSUBx1TVQvPl5q9DlYEj4Pkuc3M88jxpkdO/XkcUggXdtrTSDN6cUUt7oiABFIB/7Q==
X-Received: by 2002:a05:6a20:7f85:b0:100:4a2f:4777 with SMTP id d5-20020a056a207f8500b001004a2f4777mr8621991pzj.38.1683639133781;
        Tue, 09 May 2023 06:32:13 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-84.three.co.id. [180.214.233.84])
        by smtp.gmail.com with ESMTPSA id g15-20020a63f40f000000b0053031f7a367sm1321523pgi.85.2023.05.09.06.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 06:32:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 5D0A91068FD; Tue,  9 May 2023 20:32:09 +0700 (WIB)
Date: Tue, 9 May 2023 20:32:08 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/662] 6.2.15-rc2 review
Message-ID: <ZFpLWPBfs9daaGFc@debian.me>
References: <20230509030701.507375024@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CO2BRZQ9++T4pGG8"
Content-Disposition: inline
In-Reply-To: <20230509030701.507375024@linuxfoundation.org>


--CO2BRZQ9++T4pGG8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 09, 2023 at 05:27:04AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 662 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled in my computer (Acer Aspire E15, Intel Core i3
Haswell).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--CO2BRZQ9++T4pGG8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFpLUgAKCRD2uYlJVVFO
ozjwAQC3sIqABNO1Z/zaCV9Yls5fdOEscEWTXiOyoiGJfqB6ygD/acEu3g5s76Xg
VpuNm5J4YJGqpadmkGbAODQQYSp2hgY=
=m4KZ
-----END PGP SIGNATURE-----

--CO2BRZQ9++T4pGG8--
