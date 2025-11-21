Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2ED21E098
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749472; cv=none; b=S5PoWK7HxuiJmq84cMBJeN35IkwMhSURtJdpHe6GXrx/qJF/H+86r/mJyPmiDlgb3pNmVI3Z0P5voI8F/FMMFG1n9+6J16hQrMby++en/0xQ0UgJkAruxhY9CJsAzuwWxky7UqeD4/nlGyop2j2rK9KHMtjr22Mv5Hu3POnxtUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749472; c=relaxed/simple;
	bh=jNCChF70TmcG1oxsqs2yj42USLaIEY76NYg7HDWfwOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N0j7IsLxaEN9U2zKpt3LRBhm67C4/6djkHTTBVkes0ZtgTYlbJUo/6dwJZiuDWm1jrdXui8M+cNsjWDrYDs6nDLOSvt35UfO5ByGwvGZRkcqhMJhXB2B6BnoeYhwfWrPD3QoFLyanwxnxZOoEOSIQ1GuYaL8AXO2oZXw/NlrX2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oq7HdEyJ; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oq7HdEyJ"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5957ac0efc2so2364900e87.1
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 10:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763749469; x=1764354269; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O5mWUnL4huWsnw5EWuPaRB82TmFIMgBdgOLKjzC8Skc=;
        b=Oq7HdEyJUOXvtmebGx29F7V9dlXjOtPYijecJ0E3GuWodTh6zu5XZSmzFTI6H5nENq
         26Iq6PLixLAywzA13onhHZFp7Xg9ZPYyaE5zUH9t+hGoDj8Nh2FaJaQVm/NqOaEvCrjG
         YptMt2wIZ3wPNq0+u0viu5PJ4MR8dx0c2MOYvIsIlA4vsUHeCaFTenK3Ixyb+LqRM0ZY
         YyaQjNgk94mLZP58QiymyH3I99jUYr+G5QVx0tu7pj7y8wseodQwy50Fyouf9s4MKYbl
         KKkFXHAzif4TCC+qU1GVcMku4hiwZBPA2GCswqvCO364Tlu2+F7CbwfIz8GWzxNI96Ut
         FFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763749469; x=1764354269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O5mWUnL4huWsnw5EWuPaRB82TmFIMgBdgOLKjzC8Skc=;
        b=iDPssf8ZgkTFV1NPT5hp4yxr8gmtg+ZxiMQNElchJLdNb96NZcY9SIMQMijxjglEuP
         Zr6PAUR9Q1ahtTz384xAvaysSFzkzLtPPghlQ0dXnD453ZZ7iDEXviVwx87Z9mo3oepp
         urnxT+7FovmEl7Ffem45Fn7A2wShSZ0ioPpO9zlp8yAuzqyYia8mXjGCbj/ciLGdshcs
         zZ5NToTltK+2jQ9vk+LozSc9GEgu45+aBpbDcF1duhE2J5sJWbYnqnmWSvgKAZ4yP0Kg
         IUxZ3sm4aFay+iXH7kilVUEym6rwGr1XoWcTf6Dv/ME0ueY2VwVOoQI9uZquSbxoNhQm
         I9wA==
X-Forwarded-Encrypted: i=1; AJvYcCUBS1+E1KyooaF6dDRaWS82iybxTLNzdVbIt6C6i/feObJwX3NMUmnHn8/9vFmgciwvjwSui6Fm@lists.linux.dev
X-Gm-Message-State: AOJu0YwvDXrK6VNfWp4+y4gSSqeV/kPn/p1R+PADe+tSvC9raCbPXFwf
	XO2+oQs3jjfeGcTqM4mCYE6pLzrxUQkbrjyfppRJAalSHdtiuMJ2U/whIpnChvKZV002ZyQUN0a
	ci6MsFKrSjuT6OdEY7Kn3GP7qKS9ae00=
X-Gm-Gg: ASbGncuVj8oJzxL1mw2wBYM3LNnniDXrqZLuXj4R6tX0YyxTxRJcF1HiDCft/otpSOF
	wRvoUCDUlhxIOB8PQOoYjE889YViP9B65iAh+SaY49JJ4HA2Y0Kf2O6fE0AAZkFM87FGT5wGKk4
	rsfhi6qpkaIB1l0RLcGWFhhT1jnAuYKZkaJ4NUAXEyEFLF/SRD7NMYKvoaB3KjtbWPrkoSUjm5m
	YjdL+GQdoSRuLNUlKRKHbiEZgmkQml7OXPZNTyfPsBopSXhSM8nWOC/16GJ1UEceYkeqQg=
X-Google-Smtp-Source: AGHT+IH2KMPGKNydn7qVBYyXp308cBa89ak1G75ivZYx9VUApmkU7FL2M6S133kw4HCcg1ICiDcb2fxuCsx5UyJ7ufg=
X-Received: by 2002:a05:6512:3b8c:b0:595:83c6:222a with SMTP id
 2adb3069b0e04-596a3e62a27mr1039627e87.0.1763749468725; Fri, 21 Nov 2025
 10:24:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121160640.254872094@linuxfoundation.org>
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 21 Nov 2025 23:54:16 +0530
X-Gm-Features: AWmQ_bkUWxBZOylRnsOR5UY-ThzszbxIaDsx9VMfs0sdcxAJcJiK_1oL-VyEuVs
Message-ID: <CAC-m1rqiy1gNYFw3GCiujNbXvScPO+E3D=p4b-fFPkT6R0Qdaw@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 9:37=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.9-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Build and Boot Report for 6.17.9-rc2

The kernel version 6.17.9 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues. No dmesg regressions.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.17.9
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : c2a456a29ad6042b4ca41d6d1ab4604d60e3bef9

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
