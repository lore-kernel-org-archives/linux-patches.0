Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7E123A6
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 05:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708580015; cv=none; b=Xm8MOEMnV87xhr4YKzTzus70PrVVUqpH8DZpMZ2WZFWwn3ifRxLm1PJrtevWTC5OANxfttZCdmZ7JOSG83uHgo58cibFWke9UEnXAUUdM33NMizbRogYIMzC/G5N/rT+qi12sedHUL6+4iPemebwtVjpBWalreg0zdsCQcIdDQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708580015; c=relaxed/simple;
	bh=SjP09MIy5YrK4sMKfNGCxf0ioGyri+S9EeUXCbe6IgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDnc+0k41foVSEDYnDpQ6ETKYKHjGG0mArzCgCpVn5QNZu29CmpvdKpSnG0NAwb19HR5ebmlqFeNJxIVoxt+MhEVimq249higoyMqspuwkI8usIJbM99q8R+pQVfPFsJgUZg9PsPHQ4CULD66lM8rUzqO2xqFDG34JaYMcJ5Kj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=enTTlx2V; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enTTlx2V"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc09556599so11592875ad.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 21:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708580012; x=1709184812; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L+lHBLhqVXp2YQ4A5zGdD+Duum45+0C9WP1ZVERV5iA=;
        b=enTTlx2VLo3s0pXM1kkhPp5vuBe0fBBKIAB6rglpmPt4DpKjwY9NukmEYWN9XRKf6V
         zHvZh+m6Dr7WeKbv49t9b2V+vDY/H0RqqepdGk12o7qjBn6pAh6niLzme1KDb7Xg+yMK
         RE+0q5PylykFFjUz1KAmvbL6SQkpwNIMkzmHOggAPlhw7MnLzIMknnjEFIKPSf9y7YhO
         dYIktdI0c/L7DypRZ+3KOlrLBAYvNG1T1Gpslzlzie5aLnxwIUMUlRpsVNz8Sgo6yRgG
         +wK0EHQkFdkOWicYGp/6kIflXTQjLgckGwa5EQYn+GWhovOxO7k0E3VaPDQalEJN1GAj
         KXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708580012; x=1709184812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+lHBLhqVXp2YQ4A5zGdD+Duum45+0C9WP1ZVERV5iA=;
        b=mrzh0b7VoLO0UIO5aeM6uhtaYxpmXrQCFXmD8Qjnku96Lm9LKrLZMhbKrty0X9FmLT
         JXkAIRwQVOGU8FxpB5ejXBaTWFzO3KypYLMxgkMLNmRMADijinaGPX/S+0t/wIqhMps6
         fS41EbflS0brxEPlqQyzDb0hSrsNqCpOPy55Krsqg2RhEjIKEbdDFmCNeeRn0zIX9HYK
         ItpAj9vEkbphSBFaK9B2PJpdj5Akx0Z5nur3GG832u7CVbo/WVKzXyWiX6uOFF8ASN0X
         cmtop+p6evJ3kxSSAh3bMkEL2J+V8idyT2tUV8JFssHBdzds4DT/b27z94vH501pnLTc
         Humw==
X-Gm-Message-State: AOJu0YxtmpjIflZRmwUHulSNQMS8tOtxMyQ6o3ILLxcUIZy/s5Lr9Zes
	kbZDTK4oDmQ2CGE8c+bN7/uuY3g+attZnKDpjXcIaCzAiVsiDdvL
X-Google-Smtp-Source: AGHT+IGvqYjMRMIOhHwvjPVPpo/zs2OklMM3A/J93Dc3dUWoGR2+XWobHkvolqz2mp8VEWV+kjpTqg==
X-Received: by 2002:a17:902:eec1:b0:1d9:3bb5:2819 with SMTP id h1-20020a170902eec100b001d93bb52819mr15940134plb.34.1708580012496;
        Wed, 21 Feb 2024 21:33:32 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id jw11-20020a170903278b00b001db67377e8dsm9034917plb.248.2024.02.21.21.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 21:33:31 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 71003184796FC; Thu, 22 Feb 2024 12:33:29 +0700 (WIB)
Date: Thu, 22 Feb 2024 12:33:29 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/313] 6.7.6-rc2 review
Message-ID: <ZdbcqQYF0cD-uG8H@archie.me>
References: <20240221125951.434262489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kYz+BPLFKsL1ZW2w"
Content-Disposition: inline
In-Reply-To: <20240221125951.434262489@linuxfoundation.org>


--kYz+BPLFKsL1ZW2w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 02:01:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.6 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--kYz+BPLFKsL1ZW2w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZdbcpAAKCRD2uYlJVVFO
o68oAQCyGaN9p3WdnCO8ttpfii3cSp0ajf7AZq/wLMAiO+sbWAEApc1c3se98ZTx
dxNmNbEINMT2967mVg+PIstUm+Bruwg=
=Sm9h
-----END PGP SIGNATURE-----

--kYz+BPLFKsL1ZW2w--
