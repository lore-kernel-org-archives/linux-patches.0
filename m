Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F457B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 04:12:58 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso11888484pjb.2
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 20:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678507977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vLTThIkYcoCngH56pYkNsVkm23MjZJswdqWOSvqOZqw=;
        b=qAeuVIiCbuIpx5nHJ0kTuIriVwPVSi6qkQSiVZkG4jIJn/EMXD10NIoaczL228Gl2f
         dVBjYXSlekcXPcFnGSeT8Yl05u6cT783WDt/RCIFPnwv8O/9NkWIBMDAaZka+kke0i3x
         YuQch68NfL2BqZMPaCRs8guJ8+l2n+UVEcqYJkLFZTAMZBa0Xc5bChskBw8EjdyqjNRJ
         2M8+lUeTmgHvl+vX4PcK1JgrJDbTFwb2UKNNIXZ+PdwcnsB5gYtcRwzord4Vm/GY1/ia
         ucp/EkRauu3G3GpOmSaw/FcbyDaMcflK9QDwk2ijcsTvCFqiKiLVeiCtTXgr/SVfxJm8
         QlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678507977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLTThIkYcoCngH56pYkNsVkm23MjZJswdqWOSvqOZqw=;
        b=Tq8DUlj01gjsNz4OOrsfiH0L9zTrwHWS7sm6xCbNjda5t19/o0jFSf+3esbZ2QcOQu
         6mq4R88RAp1kDm2ltm+p/AFJWQ52SwCmx15qa0NPer99zf4wErpwRM020bqgI5jSJuWU
         sU/9VcJL/Xj261TWkXgGTRzv0TMn4K9VK7boAIMUFipGFPje00K4XfNC2rNnncQHItj6
         caw5dVhqoFpijhIfBVN7E3mATFrCAjGD9ettcVsy5vCgfLMU+rwg67pUwjtwSLtGzQy3
         LR6hXbVzSn0sd0sw7T58PdTuMSnwiAc2j79fsoq7JOtIjy54UednEX/tzVJqJ1vuwX0j
         tqpQ==
X-Gm-Message-State: AO0yUKU+IYSD9gcPE65n6cdZvCY0AaL0aXGyG8SieF1XmAifwV+Qb93Y
	x8JoaDm6z5FpnzqlYn0TbtY=
X-Google-Smtp-Source: AK7set/TcWYDhnSmSlBMjMQk8GLLDzeoMqHWQleedhh7GVW9nOLjhWBW1itL6T4yBuVSpdBgIFJsQA==
X-Received: by 2002:a17:90b:4f8e:b0:237:f925:f46 with SMTP id qe14-20020a17090b4f8e00b00237f9250f46mr28348790pjb.24.1678507977382;
        Fri, 10 Mar 2023 20:12:57 -0800 (PST)
Received: from debian.me (subs28-116-206-12-51.three.co.id. [116.206.12.51])
        by smtp.gmail.com with ESMTPSA id bv17-20020a17090af19100b002342ccc8280sm693609pjb.6.2023.03.10.20.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 20:12:56 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 041E5106670; Sat, 11 Mar 2023 11:12:53 +0700 (WIB)
Date: Sat, 11 Mar 2023 11:12:53 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/136] 5.15.100-rc1 review
Message-ID: <ZAv/xZGpPjUjC6XT@debian.me>
References: <20230310133706.811226272@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8fumRTGUtjhB1icP"
Content-Disposition: inline
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>


--8fumRTGUtjhB1icP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 02:42:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.100 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--8fumRTGUtjhB1icP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAv/vAAKCRD2uYlJVVFO
o6qCAP4yciaKajRkIqbm7u/IljbNNsaY2VU2t8xmetbpeD9WVAEAglkaI79rveqq
rMEB46DIkdjqPTbdbZa6QkRcw8a53AE=
=ccXS
-----END PGP SIGNATURE-----

--8fumRTGUtjhB1icP--
