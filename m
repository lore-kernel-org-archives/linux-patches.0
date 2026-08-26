Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FE73822B1
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787749766; cv=none; b=tarnUulzlwyReulD6XG85GrE6pPGGOpiHY733nzfWlSMiem6DD01lZc0CVL2DCntFP3O8MXzkgB5xUa+K2lKDtcbk9rubXOq9hng7I++Xa1j1HZGO9dFLanMhfeb4kb5fD5yhQXqPK7pC9r4gj5ibMy05BpCLT2BmGTtAYhWEJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787749766; c=relaxed/simple;
	bh=UQxkqTK3/1ZsLFibCpvCrUBH5dRiA4vZDvb8AlwtX3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xsx3Z6n4lltYs4uRe8MFMhE+vZG8ECY0giRSI2tAGzXKlMcVJFNlS0u+fs+rcVTLtO09NICn9nj9oQPAkRI0V8fwnx+lZge4hBKF3A3Ai/dbyGXEYjauhusIMz08INwgSxtq5IL8MNtH94jgLbSP8GQWkubSnYEmNCLH5pOxlpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DlSfzpqr; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DlSfzpqr"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c252cd2b3c1so67403966b.2
        for <patches@lists.linux.dev>; Wed, 26 Aug 2026 06:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787749764; x=1788354564; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6JXi2pwwnfsDJ7n9zXvp9v+SjJvo9VFU+ep7dFFjZug=;
        b=DlSfzpqrbg00tAebqXzSi9HEogJb0eKjXTzMtXVXdp7c99kMC3tPXvoOwQW1lvwpdR
         pJrleOv723KHQzgKLUUnUcWZfQVTuBHUSil84z9J+6d3r5yliS8/I/YTLLsQOOoQhbVQ
         fNIrSAaUWf/cvj4NUxFTBv0pWDTQwvKZbY3fFvUY8qlQqcVsEL1RQAxIDqrp7PR1brEA
         isiVQ0Zpv3fqoaRep4iz0DcVkg24sPBkyoQrZXqmhfpeDp1fBMznQZRZL1kyDMIoxoJX
         i8q4VKR5feC6R+NBrMAtS4x5i3e1KzsXTzeI1DBnRvz5ZpCIQHskA+lbJxxqY3YbiFxP
         kT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787749764; x=1788354564;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6JXi2pwwnfsDJ7n9zXvp9v+SjJvo9VFU+ep7dFFjZug=;
        b=DL1JtNwKMyjU2kxRScn9fyhx4dvTq3eKyuaP47ixuMP8/ZMuSlclcgE9po/nIqYy8B
         pEs27/hixCzgOmx35TE9A9K8leOsC59j/N1HX/M2f0WNayf/WmO4NL6HoP3jfFCKeOCx
         S9PK0qgHRd6JVcwV7RLcIX8jVnhRX2rTpmiNOMVPB3uJNvnZeGCUEBp56wIA4No2Dt9s
         lueHXmTsSK19TKYKXX4CLBPU3K7BTNQTA1fJt8fUx8jxOGTOZLDjzK7R2hmMo4GxMrUx
         gmJKFk2vRNkb0aS+VTYQs2OL7ffEaEhIPF0ricBGSclneK5reyHUeueX7nIt8QzUk/I6
         E+NA==
X-Gm-Message-State: AFuF++mgtp2ZR3fLoR34md7qyxtzx7826Zbcv+Yb/UKu2fD8nTkGQLsX
	RibCNST+Hijja9smMadlm4PbBnDk1A3Ds+H/0n9k+o3/zsYiaEzSjDQ=
X-Gm-Gg: AR+sD13vWl3fR+ofcyvmKO8xpMRSWB+CiIExPcnO2d9V+kMqmvFjN4v++1R5UHTWOwo
	b4r3s+jeW/vJW7/TMsSAqB4KIS8L8w2G2/IL1pdncHj48wy4RkY+gEs3fjBC2oBvrJ32WwMnv2q
	E8+75YF0oTH/E6RghgmM/X/Yr5rs0M/wuHNE/Xb7FD9/PnTNYjkQRpc+TScweCau7WRXKr0tYV4
	lEru4R17fgaBcv0uLqUzDRkEAfREPQtPHjSPI4kK/1VJhs/R9oTZRxQY7LGYmsS/SCoce7oxqxM
	Mxb2Ox1bGAMNX6vV7d4mQNaXtaWR/23NdvsnzTEW7oX6Wp9BijMlS0H6m1wcl4bAjc6YNP1IJ3J
	ODMsB/a22thuRrprxzsn1EfcNPgfI6S0gn6Jc+xB41naXCPeor1fGOZYYPrBpjAysWcF2KtLutX
	7I03APXxzVipJ74f4c8La0mMfm7lk9yqQJa1bdAxVPimwC01zo8waQowx4gXNL2So6Ds3fBFbLs
	1pxewK27rVANTayYXbxGlBM+n5D1AyqL9UwTjo=
X-Received: by 2002:a17:907:6091:b0:c1c:2007:298e with SMTP id a640c23a62f3a-c250c408972mr942154366b.24.1787749763224;
        Wed, 26 Aug 2026 06:09:23 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace5e.dip0.t-ipconnect.de. [91.42.206.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2533945d0esm586566b.9.2026.08.26.06.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 06:09:22 -0700 (PDT)
Message-ID: <ed8a1a2b-c375-4504-9b5e-370b2ccd6e08@googlemail.com>
Date: Wed, 26 Aug 2026 15:09:21 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/77] 6.12.106-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.580275153@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.08.2026 um 15:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.106 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
