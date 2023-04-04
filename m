Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56797C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 03:57:50 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso32660873pjb.2
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 20:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680580670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X83KCjdEK4T1hTeVfZLCAmpcMx+WY5WGo1yjmpuoFY0=;
        b=oq3XFCwGZiXf34KBortg9bkf70ZMlaDht0ktfRbBRS7y0qjhlChdfbhkO9hd0zbS0r
         zNeoDd5Z9dbGGUndflQDKNsvuy6GO4sApUa5PcOFu785whnRHzDX4y2ECwLY7MUqo9Od
         SGDMcJu9IfBHmyrCCbkEajT67JHRKuuQMu3bLM5HVxHXZ2jKkgfAn8OvDblBkRr1SE+E
         P1ihcE03PtUmOw2g/RAc0Lzm7tttFYbNMa2x9RhgiojB41KPFfdD2moXblejwcaR4MK4
         VeTG6PlWbZHRDnHdnTvfahag1UAzasfmxd68DxdBajUiVHE6lwKUW/MMjEWpuZioJeg0
         j1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680580670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X83KCjdEK4T1hTeVfZLCAmpcMx+WY5WGo1yjmpuoFY0=;
        b=CxTC4tHrhh4Y2J2voROk/8gbYGX9g9XqPbvM4YXqlheeDQdu+w3EmVVylFdhXKxEbt
         tAs/R6ieaj6QeeA4T7A4ZfDyWFNYftJGUwC5fxtG1d3s/2R+fqeRbxxoRQq+lz+7f7av
         n4tFWlWungS3n1W8YrS9p7UhYv3inimv0zPgTjG6tgZKMp/uQNBuaRPXBSdSQNrUKfBe
         fV+ffXqsVOc+x4lvcftr0pqq+HIPpYY6BQf0ir03Bpv+Xh17ZxKzimBVvv/4oFJ6kaGa
         Woi5IhQAcYxaCc1FL0nSWeLFFi5fU9wqyr5HlQ9H7BrhsJSAiByKedKhO2M3dFIuLtwi
         FQMQ==
X-Gm-Message-State: AAQBX9fG71i8Rq9JRmXjsDArkLBLJX54QnL7EIsLhWhsN9h0Xbfv8oM8
	DASQAnPpF91dW8IEKSMJ+xEgy0//EM/b8A==
X-Google-Smtp-Source: AKy350aA0gIOmG7NVFgGWhbVMzrwLDGJv2GOkUP/HnQ0c/JDE6vsHoRKeJF8b9596TgF/7xSOCYJJQ==
X-Received: by 2002:a17:90b:4a50:b0:239:ea16:5b13 with SMTP id lb16-20020a17090b4a5000b00239ea165b13mr1371109pjb.14.1680580670314;
        Mon, 03 Apr 2023 20:57:50 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-87.three.co.id. [180.214.233.87])
        by smtp.gmail.com with ESMTPSA id kr15-20020a170903080f00b001a1ca6dc38csm7308518plb.118.2023.04.03.20.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 20:57:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A43A7106782; Tue,  4 Apr 2023 10:57:46 +0700 (WIB)
Date: Tue, 4 Apr 2023 10:57:46 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Message-ID: <ZCugOvsPTEg9A0nO@debian.me>
References: <20230403140416.015323160@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5SJdshfoX489i1R0"
Content-Disposition: inline
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>


--5SJdshfoX489i1R0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 04:07:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--5SJdshfoX489i1R0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCugNQAKCRD2uYlJVVFO
oxJXAQClKhOw1JlBz0nW4dpboPW5D5LZD5B0B5gkzM7vLQOEtgD/S6Y7Zdqp/PVq
qqML2XTrdIrdrjKeQa2IpHEeFyrFzgc=
=7dUL
-----END PGP SIGNATURE-----

--5SJdshfoX489i1R0--
