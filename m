Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467D53CE48C
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 12:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775738875; cv=pass; b=gsuJ91OxGSlpCd67FFr81uYcIdr5Td7gyDtmKF0cNctiN/Lau/OM8bDXbHgGnPU7TUI45VIXN/8dpTmgvlb1oJPfyLEQ8UiOyEIaf1L60ws85N1ttvIBqXprCnH5EaS0BMmZvLJNbgWqQJYT4RL5yPjmmbCaTL3Uzt2TIshcz3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775738875; c=relaxed/simple;
	bh=gp844TgNbVN4Boctbpe1hqdTAmWlS0VRvFZ6t8UR8qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oz44lxe2+Ecfaw2n7+VWRFIoFDTy2r4TwPgJ+SKYl9+MFsITAFGVQGRZuFYCN9SDkF9+oW0Ya9NJ9wSOud9u7/t6HMe7xXtL6kSckBzlPdnXsgXU8aaM1GDXT4jmdjQwXyr/PYCtaCAJDSNI3vOjAX/8n14TGenGNfSWweeo6WE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=I37KKiH1; arc=pass smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="I37KKiH1"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12c1fcce8f8so4400277c88.1
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 05:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775738873; cv=none;
        d=google.com; s=arc-20240605;
        b=S+Ixwq32MyJxW6jhUfOvHOGIA4hM201BVS6Pk8QVzaXlf0dWPb4Q3rFMSDng4DdyRm
         WCGY2R6D4hfUgBH7dRWRovGqJkLGl5+mbvXIEd5bb9bcDoR8rboe3yQb70IxN1GCy9FP
         cc8vXnnhbICnVLZoaOAZZzWE7qF12E0Doef6LTu/fRuWPtq5rlj0F3264golOSqqkkKh
         r77UuXIw7MvkfXOj8Qrl2WtSVtyhGP6hCfbP/37IG3lR/kUrkOFdkW7b0chHBXvNV0o7
         U6m3sRZjFy/SxAcwaRHpeGhgdovtS2vj/CA60lKgx8I7DrajwrXPrjIp2roV21FNB7Rc
         8hYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=clF8G1qfvN08Sp4J/MPRuZGu4kx06Gnjll/MPTIavwQ=;
        fh=agLZZBlUOA4Y/KDcKvesYlCdxtEyAd5md7NtO6SK19k=;
        b=cLNfrmF5idMgL9+h3sa8fJlLqB0yBJ6Ibxf5Z9W0bqTt4m/pXXyeEdQ5yhZ4IjyAz+
         MlEmMcdsYByakm4pFzvMNwv2ClXKD5ok+2j58xRrn7A1cmR1xcs2H+fG9lr+uS15P9k8
         cRdvZJExe7uU8bKe6kbF+JWbh95BadqNax5VcbbxULd8fCTR+brca27CLf7SpbNGIopB
         KmmOl06aq1pLfXNAO8CjbgJu0is9jwPYopOcuxNIdvPssoX7QCDPHry1oGobSX42iqPf
         HhyVzxAk3i8uWbEvtZw5Lqzi13BczLc26bn1GnkxlflZYLnfnU8p0UmDyQiRhVrV/4qt
         9woQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1775738873; x=1776343673; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=clF8G1qfvN08Sp4J/MPRuZGu4kx06Gnjll/MPTIavwQ=;
        b=I37KKiH13IgtAUOPJC5j6KJZpyyFb2cYvu41et7ku1naOqMf5fOIeOC88y1RfPCNqZ
         86PVanS6TslUY8e5KMoxhRSRGGURQChxUJYXj0H+xmumGIl36NF0TCX92Oleo7uoHzPs
         JxgiHFij+2tdHto//YWbWKP93+efiAMhXXXcnxpEjJd6Dy7+e1EU41YQjRIq6nW/DlGC
         ga70PUBDQ/ZlbOfRatwBpkzBiu1I6YlnGUsyURIBB943VAWaum7PVP6uWD2aV7h8+GHu
         uMwXJrRwI4LilNX1CY1CXhrHK6WiiuV4acp9vrK/2D6i4i2QzjAHgneBxrBuqycWKO1T
         teZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775738873; x=1776343673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=clF8G1qfvN08Sp4J/MPRuZGu4kx06Gnjll/MPTIavwQ=;
        b=EibcNS7ZdSjQWNcqioIwzWrGfZTL7mnmIRNGcxOjRgw145Tl+MvhGstdDaL0GWOEA4
         jTJgGYwyEy/tViWLFJbUqTpXiMWaUTV370cq6vZkgJliUgVoqcNRaVTaeDnzQCIdg/I6
         Kb1O+Z6hJ3K7OqMk7vs0HTJ8ZOb8oKGBJJAcc7h+HcuhBgbPCxOxN7ON7wxwtZPORfqD
         zRIGDkjnmHRpk3df6hJ6YxC7WiGS2/wpzqfE1VNA0SJGmAeZmpN0P6MuZI0Cre3ntxho
         gG3QzI1dziw8zGBZEHRuILSVlQidv5+7/X8JaLG3hKZ0GOizrlv97FV3DqIck2s/7Hdb
         mdDw==
X-Forwarded-Encrypted: i=1; AJvYcCWDeUVWvkF8Y8O5l4yoXD5m3wyp+KecAjgDemVRGV/QUq4yfIBB2YUqwUJ41HRgU1pBXuFzZbJ2@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8aGGeWsxwL1uByu61vBgdt4hN2CiW+GOoGvi70o+Z8zX3tobY
	f3/bwEOYkoq0pipdCsPIBDKMbMaX1bgrXehD5vRkY8Ngt5GDMPjafT9AZidkuTPADFGZnJwySy4
	eDV1X3C5f7QrQNHx9Zo1VelPzMOGPO1fmmTcMgbh0rA==
X-Gm-Gg: AeBDiet++Q4ELvEBSSkE5VHJyPzRRDY3CjAASpxvu85WKA5zsFSxOKqab2TwlYp5G4Y
	DPx/wJo6YwUu6E6uTLMuuXdIdB7bz1USHFbahy5iOCSiO1zFBxtf5Ad3OokXbJRNbOLVoSoie9H
	mc3IqI1s80RMvoq1x6FMhYEWvdd1acZ2XTAD+6a4cNrSQdkJZ7LrhlD6lJLh5y4ytytsryvTRyN
	gFK1nwPdxDsihoubV5ujMDYZqSEx5YGJxNfwMV2AEMQGsxH+hnpOxPsQELtJneZ5lo+bfxkyKPO
	f3GClGo2
X-Received: by 2002:a05:7022:ec14:b0:128:bae0:e03c with SMTP id
 a92af1059eb24-12bfb765c2emr15030680c88.30.1775738872880; Thu, 09 Apr 2026
 05:47:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260409091742.514769762@linuxfoundation.org>
In-Reply-To: <20260409091742.514769762@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 9 Apr 2026 21:47:37 +0900
X-Gm-Features: AQROBzDpesM5rBlFRlPesY5ydN6kgOYpzmgUph8X1hZLOKx52MExGMjSyoyKCmo
Message-ID: <CAKL4bV6JjJL-z9-k-2gPAm+JkfDq_a0j6WBzdnFdtw4wbyhJoA@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Apr 9, 2026 at 6:34=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 11 Apr 2026 09:16:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.12-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.19.12-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.12-rc2rv-g0d57c706dc2f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Thu Apr  9 21:18:43 JST 2026

Thanks
