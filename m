Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578182C08D0
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 15:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776785837; cv=pass; b=MQ86yy1Twnb5AvhQkSM8WCaDWU7qh6FLG7NPqwME6RsS/GnSl8iPvexJ/rSKycGIpi5SV2iLjmxdk7YFxGMpmpObI0y6LEhZ0kTH+QqfPFUTwAf4/O8i+Rq+VdhBTtsesh+FCFt3ylkTJhG/N+i9i3z6jIVxSWVdiCgpB6rguPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776785837; c=relaxed/simple;
	bh=ZJNM/DhpwGHejaKlgQebXATtZUhpDf4eVwHFv2Xw1PI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rbSFFfwqZQzyzP8W3RosPZxpDmxPCKRYJgR+elu6ZgeQhb0WWKudZAQDeIYw/Y+TnavF4fV9gzD9yoJOL0mvaDgq0wpRjmzMFQHICH1mWc7Grho2TJRwitoq131V7BNDKcwVlrE2D8zK40TcTN3SSPdEgqx3n90rTO/myoe3mnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VTS7NJ2x; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VTS7NJ2x"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a0ff30b240so6594697e87.0
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 08:37:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776785833; cv=none;
        d=google.com; s=arc-20240605;
        b=eCswjxE7IzbCOaLCKUYHv+6WtehXEV+Xi0+tmC1OPBEf1ZC7uy41wGL+kMpQ8G4A6r
         RkvDVLBEl62KyICQDt9RpOE+he9/A0A+H55u3A5qlttbNfZFD0vt3EwRKgWRvQt2rZxt
         I0hrK7mR31eOGf2JRWoOfzVGWB5stcZ/rSsj0it+ZZKHAJ2ifsLKRSdhHzmZlzybJE6d
         CbIH3VQ2o+uUImFIIbrWtj7+HaE6GmYmUUHDGsqTUiwKaYKBeUmi3TphQ3JME6qeUJea
         hEZFoq29Hh32kS2NwM9V/zLUmqRXwTZLRiv9ILRPue/5q/8gT3DPur88jRHy97LI9Mc/
         ujJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O7TkNfinPruH6soCVp/2Lcir3uulDXSVd0kmYifurIw=;
        fh=F3Ewx8wGzHvBnA3XpnX3hd6B6MS5X9PjxoteFdnpr2k=;
        b=lP/OdRsPyj5KkdkkeE+3pFXszWPQ/lisFOCpJHspXc6ZCG5jlEEfK30p0g/JIXBPyO
         cW7Se/QdlTNTGy8BqFQqxwcg7AOn2DA2lLX40a0OZidvnv3OssWvT7r2L1x1RhRoRcXy
         GkUb8DiutRuTlaDmFGaNYJTEGxoaulsEsHNh5A0xMXRJ6OnRgeP+KngACaalgzdG9xUI
         gyPAY8u76yWEsMuC0bzcUgVktd8J8SqFgsG3Vsm4YOl9jXFsC2pBZXSUYDmeMLjS8DNw
         GlktzQA+dWjyGuPOBEd10uK1GaOI/4X/4BllV2Td+x10y+BuLbayrXegBcPwVXFm99Dp
         tGtg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776785833; x=1777390633; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7TkNfinPruH6soCVp/2Lcir3uulDXSVd0kmYifurIw=;
        b=VTS7NJ2xLiZWnkkO6Qgs3FO+pdIVHduzCszjakLFWuexTegW0j7OFeFlrGFvX0yEtI
         4+TlrR4vBEt9mVVdfDtsahexck7fP9GiiTPyrHfXbfxOESpruFPqGucO+GRo+nVT1Nav
         PFcAIk4HT2U61b87I8Wnu+Jrl58Pz81hNUagN/cYlD943SikMYgXtcKIXf5m183Ci6DH
         1eQ1KNrEkC7K/oytir8LUpWAZoXdhD/Z86rhgRwlcqBlv38MfLdwMUdwvr2WX7MpRds9
         BXuT9IyGrxWG9zPhEuKnJGWNnwRU8DqnvU8mjR6TSdzd78UIxVpNGdOU24vK0Jfhj16X
         7j2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776785833; x=1777390633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O7TkNfinPruH6soCVp/2Lcir3uulDXSVd0kmYifurIw=;
        b=r4fhd8YCrTD1oHaeuL6AcGLIVhBgLVE7P61Xs8SfNClAk7CYwrZO020KWQwj/L89Vs
         S7yuJOJjpKZN4xEPlBSKiTfFCptDltQNpy56UZ32wV63/XdmX3WbutVPlecrYJdXY/TI
         dOMflGHbEuK5uiDCKlNpSF5sjMj/2+5479+SGB4773UouefjMeawH3vTPYRHQKGpXqk6
         iT46kYm5o8QL7BnySCqHgKflfT8U9bCeoD/aBeFZe5G5T5MdGQ2ZpnAky1a/uWYDqeTB
         qGu1bZoSEXz7m1gXhb5/wdWFskjA0yRPoBpSUvg/9+QO1/lklyNrGZvxVtf3jn3bFjbb
         TaPA==
X-Forwarded-Encrypted: i=1; AFNElJ9oF2IfOLA+ZNEPKSS0bRESoAsb4WEOA7J5RIwwVGPdj4AfFC8CC8IIqB7TNUUGwZ03CDeF0MbP@lists.linux.dev
X-Gm-Message-State: AOJu0YzU/k1W2hnZBtZk8i3U4BOiPz8WWDap1BhVIgzMnQfKJwRf8BVu
	J8Kxpy6q1aFwEENeV5idBTpo+Qt8izbkxdbu5VGS/HKHFFuQdW/EQZZ2WFm7QdupBYamhJku/KN
	AqnJUQIO/ppgw9RcfKtJnZbAabBgDVu4=
X-Gm-Gg: AeBDiesPGNezf0OGQE7eIlETEnb1tqYcH6Yfrw3B3V0wktI01NU26t/bqsHfuQJ9BGl
	vC172omqDSS/IuiyyCiM5+0wVyQiPTxlxSAUAnlagwTpZI817FPJYEXF0Tv6DYTz1i2riLusuCV
	CF6W1aUsRLN8SfH4LPRshunHqUM3hZvpaLJbETmLNTDXidenQuDEiAWN6itBdjzUZSUxuanX1ZZ
	PiegbGL5H3FthCuuq7LL1ZHxKnFgJZFcd42pgGty/x2aX26Kz0iEwRgWZwrzEtPdr9xZbLS3lT1
	IqQ9KsPR4SSsz0n1j+Q8BoBX2rJzAkQLfWqTFCyPv6karybKO7A=
X-Received: by 2002:a05:6512:230d:b0:5a4:7ec:145a with SMTP id
 2adb3069b0e04-5a4172c7577mr6697398e87.10.1776785832528; Tue, 21 Apr 2026
 08:37:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260420153935.605963767@linuxfoundation.org>
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 21 Apr 2026 21:07:00 +0530
X-Gm-Features: AQROBzCqCimJhZglqtBgcwb9PGh2rhWT2ikrhu2AMY7rmFw4u65lxWLJ1o13eqI
Message-ID: <CAC-m1rpBw=gofkzAOZQ2CnK7uVYF=w5MLuvQHWYR291JbY-xvA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
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

On Mon, Apr 20, 2026 at 9:28=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.24 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2026 15:38:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.24-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

tested kernel version 6.18.24-rc1 by building and booting it in a virtual
environment on both x86_64 and arm64 architectures.

Build:
The kernel was built using the default configurations:

x86_64_defconfig for x86_64
defconfig for arm64

The build completed successfully on both architectures without any errors.

Boot:
The generated kernel images were booted in a QEMU-based virtual
environment. The system booted successfully to userspace on both
x86_64 and arm64.

Post-boot checks:

No kernel panics were observed.
No obvious errors or regressions were seen in dmesg.
Basic system functionality appears to be working as expected.

Overall, 6.18.24-rc1 builds and boots successfully on x86_64 and arm64
in a virtual setup.

Regards,
Dileep Malepu.
