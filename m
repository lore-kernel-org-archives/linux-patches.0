Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8321E38F632
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 18:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773943982; cv=pass; b=ZMmBDq3HSiFjzB7nL6eTW/FweyJsZKra4uwuoIbSbZSkf1FjG2+kUw6olP5VcjCZ/En2mZZj0nz1sN5nvsYsjlnsbiIMQkT5SebdGx4n/lxlEOWEM7CQ95VuJCL5A1oZB0lPrBVH/SsbPQwOXkLQieXVjcCtJDUEcjbpo4kVwQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773943982; c=relaxed/simple;
	bh=fVXpKfFbS1NA201vpH2gm3whwcE7r9au/YcVO/S80us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IN4Ug5l2EX1zt3+wVO9pyuYP/O1R81Hr/xXmyJ/PFdxMJKMcoDdwTQzBdeQjttqX+eGDfxYDjMo/Mca3Xn31d0OnDHVu0rSDpSs55KnfSORWy4TcdvIS4AoYSBo9TIC68I07UClZ3HYzeiwBChdVPQJ31Zrd4RGaNrUFn4Usnjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ls0dZtgF; arc=pass smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ls0dZtgF"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12732165d1eso1670353c88.1
        for <patches@lists.linux.dev>; Thu, 19 Mar 2026 11:13:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773943981; cv=none;
        d=google.com; s=arc-20240605;
        b=Wdxgnb2C49H+WWvE2qJoCAFAROPUgq0BAtoAiJDEi2gUXEg8MSrXJks7xG4MnC7718
         iZtk4LEujY8LOsi0h6L05v9iRDdeeE2x6lp/AI3qpfjK9Q3njDWmmny+MhejYIOAioak
         Zk7iFm/hd1ZEtnlPyMjwg5EGVJwjLf+gO0iTinwHQg1SoDYcg8diuGC5A6PuNW2yKtQ3
         mW0jlY7fq/QZgTUseTwTZVzVl8t/HafpXb2XMQrH8rhzNzRcKNixCIBeH1UoQ/CIyJQ3
         Byrr8F0Q8Es/okC2P8Q05rsjFtYn/g+yRr/gMXDal7fAnYcNAaaciLE31M+T5h8g0cOY
         NKfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qteTQcOugr4VV4wEDV6SAPkDNUqZE7Yr0R+JB4MUJqs=;
        fh=agfPOGqG/KrQjD5rqK+w6j8d4xcHETy4z+xZNbx+Jek=;
        b=gX5tB+VXZOkPALbk186twzLVW6PqyCAP86u571iBZWmjgT1g0EB4LfWpakoZm1fYzY
         2vU8yXqxH4gT/CBW23vjyzEg+3FHKqWKz1QmtzgZjqIV2010RC2TXR3uL3xH2kiJ2ccB
         LZZmnaUpcLPUHvIXskdnUp1TqVGkRGak7YE6OGFDsJrhHBGyELI9BUtt5ohNfTZxMb5j
         IAyvBFBZhfb5wKzOXqCgl+C3P+rR7pciAhs6pUBR9armRbBPbQJRuI67fTK8qg66dwoc
         Y8/2XXawN6GcIgJ1mVtrTJA3PgnRidY2ikP5H6rmQKuAbKnfg6+T1SWiz/buRmWsx+2X
         23ig==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773943981; x=1774548781; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qteTQcOugr4VV4wEDV6SAPkDNUqZE7Yr0R+JB4MUJqs=;
        b=ls0dZtgFKJklkkUkk/pDtsiFl+ox6OI7hzKD8ByASE5HScyWuGdSzeUA/tW9dnjD3S
         +KrvwHaJ3OapqFsIKl99DCaObDfu+ZKSfKB5FyEu2KjOnLAXVVIncSaZ0WaQcwKH4Pep
         2jf7TAd316xvYwqSxgNoPrnhZOfuqWgebBjssEkA3uHNMKRMdbgWH2GC7Oc71InzjlOr
         u+pRPrUbpr7AZJtRw1U7vuD9RaKLrYsloUQ+GrjaPcYJWruemFlxInWsa0qk7k7N0p7V
         0liLNuCdsJm2FEBCeoOz8UVUJ/hUPZjfKxSx0PaKPAmx4KQs5IzK/WxWqkJnxWuLaJ6e
         P5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773943981; x=1774548781;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qteTQcOugr4VV4wEDV6SAPkDNUqZE7Yr0R+JB4MUJqs=;
        b=Z5tqs/aqP8fRVdSM194qbRGZX26HlBmlo1+2fDNxucPoh5yHNLsWld9cTatiyaJamY
         wh/q9veqYMb2rZ29UASBiRBhnTrKsmV0Ci4c7nFBhDYDF/DxMI3PIWWPfN/L09UjoPUD
         2RoffV1LO54wOT0kjcFh00cGgAz5yf5IF/G5tzVXcvabhijzb6D1/UvHksCc8NIczywR
         BeaopSAhByv3XE6fjE+8yLkDqMFZA9HbhBymp33Qb0Q/RonGhwjJEqDNNMWVjef909Wm
         RkObEvVepYit2AGdt9njNjArkzTPLO+gZeD07c1ptgpbzBJMMFIxTMq3Hwh3/N7q62Xo
         Fk6A==
X-Forwarded-Encrypted: i=1; AJvYcCXuzZSTy5rBg9r2CcIpn4KSUoKIKN90ho6pS06NsVCCAZ2hjYCpvsZ++Nkm2PdrBCcFUEeKVKOI@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8mHGiQyFstZ8yfRk2pCEkYemLzM0eN/hiJukFZYID5iJdP6zk
	oPj0I4AtoDOPgikl8xvUx5RKzaVTmbDDdITLX6+e01Glv/uP7HifQBc05ihi39WNpTHJyHse9fT
	G1BfBFsaJ8vhJikBepsFkJKuRgNgCvI4=
X-Gm-Gg: ATEYQzy2Hc9oIubRAZHGgBHoxMSnyISXLqtwtsM7t/LFuOR0pvXF3Cu3zD2rS9fDCxo
	KiTEbQHkTB7smF1xnaOEmjNpHuag1aRjaCuqu7P/D2TAoDXOCeTJ5IGdRznVluoZX4be3hOkGYU
	LD6FQtlLbvj1/gOLgSqz3KEw6pE3qg21YrsEiK3JZ5MqFZpAgCPYZTo4QqXsbUF6eCyZUjBdmk3
	/UG1WNidzc94RdmvQzfxCMU6eIUNEDjtRWDRxSaqVZMqxYJ2bJELs1YAnSNJThes4NO7lpVop/m
	2b6KMe8hKGGv5PR6Uu1ejMbH5m7WmWeyi0FQM9r8zTwydROpJSHqhPVCfjTeJEX+mH+hQ7p0eXG
	PSBYjYRZ/H2R/rZ54THaW0AP2IbGYCtBzd+TZ7v/PhzuYWJppXoFHZb94MRkKppmCguzCbrACKi
	ntrz1dOEnkwFuPtOAAsLA=
X-Received: by 2002:a05:7300:572a:b0:2be:80c4:2c89 with SMTP id
 5a478bee46e88-2c1095a60camr221530eec.6.1773943980470; Thu, 19 Mar 2026
 11:13:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260318122547.233850204@linuxfoundation.org> <9f7e4bd1-ec3d-4181-a677-156e6f58e537@sirena.org.uk>
In-Reply-To: <9f7e4bd1-ec3d-4181-a677-156e6f58e537@sirena.org.uk>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 19 Mar 2026 19:12:48 +0100
X-Gm-Features: AaiRm5007LB-oHxdFSkTZyhDYCjaojvToDY41lTtXPdllLqfxF3U365nWh9kJzY
Message-ID: <CADo9pHjpdgr7HG4WjcrOKAy8+dGy+jgNdmAMY=nPqfxRaHsi7w@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
To: Mark Brown <broonie@kernel.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den tors 19 mars 2026 kl 12:50 skrev Mark Brown <broonie@kernel.org>:
>
> On Wed, Mar 18, 2026 at 01:28:05PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.19.9 release.
> > There are 379 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> Tested-by: Mark Brown <broonie@kernel.org>
