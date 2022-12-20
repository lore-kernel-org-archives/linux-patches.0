Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908A1112
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 04:44:54 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id f9so7584285pgf.7
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 20:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jscwxWbGTQh3V/X3HM7yeZTkdq5F9CqnGRpZa3D6+1Y=;
        b=Xmgf/xB/3OC4XMY3JxFpqlKM9ywdNrKN7cOkc3/EydfooJ37CAxHQjZNhSuXccUq+K
         S9xKoVx9z7F36Ii8SdTpZNNlRrFgN+LuwnDmPJhyMlYqgyezFBjYoVDb5tvtTydrxdP6
         kGD/QF8Ffc+kV2Zo7hpAt4e+6Dn5UBCr22x6rzcsCXRypyloE5QwDYIlCe3xkDeO13DG
         QG1VswEDDCcNqLvjIPMNi8JC6I21vMljFUWEMDFwaWgCpG80TgEqxPUIgqtesPLQsZ8f
         0OP6vzy2NDmsmlKYu1UzlOrx5KegYk8fkfy95049oFuEcX3LDCSOQN/A3e8J6/d53ve+
         f78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jscwxWbGTQh3V/X3HM7yeZTkdq5F9CqnGRpZa3D6+1Y=;
        b=1UacmwQQhSLP4+BRxRGrHkH7s2RHTxqqc88xsqCKXIPQsxvtigKNaYozi97F+ErvM3
         J22MYYEqz9SUlV0F513ZmxxeRo8WLcPb+1+fKjotF9c7ksq5omb6Pm6vmmfqIqmEiACV
         3iQN4y/ycz4/qGQz/Vab0olA+JOSmOKi61LxbzRZJfTTjo3QXU9v6DRwStuuseWLMm1i
         nE0Rp2RFQ2fO4rsv0BXI68vSH4T+cxDrSRpD8zqDHaHRoOSFWls7z7JKb6jkW/zP3c9d
         kKsjo4GXZOu3roY1ZleZdEO63LAks8zotN0LwdgC+SkxTC4RUZo6tKVtrW/zy4qmWuPi
         CYUA==
X-Gm-Message-State: AFqh2krn6yqDXNgKC+vnu/vX6jZtFTJ3Xsi175ophrRuUUviVrsHzsS6
	SLjWFASPJQgMmbrd5XuPjls=
X-Google-Smtp-Source: AMrXdXvgkFWO4kBOJJKM9rtchi8/oud6vBwnPtroYv+0ygbi1rUywEDbaTAws/QRLdvUB+CfQwfDlw==
X-Received: by 2002:a05:6a00:2a06:b0:577:3523:bd23 with SMTP id ce6-20020a056a002a0600b005773523bd23mr12612539pfb.27.1671511493814;
        Mon, 19 Dec 2022 20:44:53 -0800 (PST)
Received: from debian.me (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id x123-20020a628681000000b0056d73ef41fdsm7536561pfd.75.2022.12.19.20.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:44:53 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id AC79E103D28; Tue, 20 Dec 2022 11:44:49 +0700 (WIB)
Date: Tue, 20 Dec 2022 11:44:49 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <Y6E9wVf3X6rMXdm3@debian.me>
References: <20221219182944.179389009@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="G5LYBMy45k6QnfAB"
Content-Disposition: inline
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>


--G5LYBMy45k6QnfAB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--G5LYBMy45k6QnfAB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6E9tAAKCRD2uYlJVVFO
o5N0AP9FjNJ8lv+hbDpJt7mTlBNmtGcpMStulcA42aUsNvqbKwD/YNsUT7/xQZZn
cJ/+PJz8attRjXNrk0ujTjs75ItuVQk=
=mrG+
-----END PGP SIGNATURE-----

--G5LYBMy45k6QnfAB--
