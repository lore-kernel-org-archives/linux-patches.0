Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F84346A0C
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 07:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775719239; cv=pass; b=Kz/L9AmUcRNW0gqQhNCEN6pxGHZ7IIxa7xpLcB5QSBFMaGRp99otbnTLESpMi6uOxkdFhIINvcwU7RW3saUaZ9aJdZAPnSXlzpNRFxMmruwsZQqLOCMEkz7xdcMCUgpYz0E4wWhG3tpDdfpId4TU4bjWdwST4r1rmAsUCxXqjzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775719239; c=relaxed/simple;
	bh=+Hicyg5v15Su7GwMFOU52nCKmlDelvMgyCZh31GLXIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q3NAce+ld4buW7g7SnTs5RpjqiMGIIWdkBXdmGzJEM64fDtiHLZEi214AotwDPg7OSJdIdo8xL6zYhO6O8EhIssD0DdkTFcbi/Ksw1G4c3LVj6cIMGM82qCfAN+h2UKrRLk3uhR0GvagR9jCGe/7Q174iAKolUyIhzT9Sb72sog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asn58TC4; arc=pass smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asn58TC4"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2c15849aa2cso503189eec.0
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 00:20:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775719237; cv=none;
        d=google.com; s=arc-20240605;
        b=F1+3gJ5sGfwDwKhr3l9I70jppugoAnCRsimoklThT/cZb4/cVhrvN7Hwkrg4kUeiVN
         yf2ABgLiwGHokRSg3vgA1ERsLyqnRUwkmZU6ODytCrA2Sv0hAaeJ8demtN6GovGxzOlO
         LLja7nV8dfYavp0WBcTSrbRZn2ZOAbsqlynhso9Wn7tF3X7d0q4OFykOv30oDJ6/qAOI
         KgTfGCDrZr1VvsVhkSz1HeboeI/aO79xIWR1Tx2dU9RElSFX1dYjs147INM8o/PZzTgZ
         eLqTz2gxQCsREgoA7DmFxoxcuXXzCHi6ZWmR2O91X1BPXfrKEQmw1i5Cdqo9ZpNvUTeF
         Nakg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/Wi6/GuqpYSjyJG33BMyiqTpw0EbstROAqNs1xZ42YQ=;
        fh=KXDlUubdy2CfxfobBTpINcO0vpt1LU+a9eluhSX3Qb4=;
        b=K8LfGV7QaORu+IQTt4P+exTgsyPIvKJ0+KnbQehRTZJhWx0xfM4nOzPPHNFedSCVWP
         ysJ9ZijeHKsXfrPr2tTNiIvEk+0f04zcBzecF0XK+2QpKVgjGL5PIVx4raLvBRX+BxkP
         IeGEaFAgI9eAj9TqtCWW40aV5vgMLXMWgG0l2SK7jEc6n7QZ4JOssUzfQszxMp88e6vd
         hCyoVHWCEubVFgG3TxeF9uERs74KbWziX0MKpxG/VaCeqA3z48rMXn4tk7MEkz6VLzrl
         eEVmJgngIncYwihnUbAvr0k+/dAaHRvthn5LysP1aRpfVRya4SiUDA8RFL7CcHH7HfsZ
         xq4g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775719237; x=1776324037; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/Wi6/GuqpYSjyJG33BMyiqTpw0EbstROAqNs1xZ42YQ=;
        b=asn58TC4zwdvR5aB/6MFjzeWWkyOxtuSUl6zRhYzz/0f/r1ZCKoYoS9894Jnmc4l/+
         psvGCf6SuKabtb4hgAwqiRK8drsFR1DqB+sL3NQt7Ua/YUw3SUiskozW0c+fJOj1GqYa
         0kt0Hme2o9RdyQ4foenYg/wQEkscVkdR73W6aiMXRfZz/lr9TltTLIOcJVjZ43y36lMl
         kTGDkILvxqnveKptywPLO94tLIAnXSPFLFYNwqdMKv6iSmbcTpVBemoUdfxTNmNuVSyX
         ag6sIA6gUavbHkNS0mHiT6uXlbEZJQjXo9xtRyfJx/6IXlpBxuxwLAm4mghYQ/xK61Ns
         RxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775719237; x=1776324037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Wi6/GuqpYSjyJG33BMyiqTpw0EbstROAqNs1xZ42YQ=;
        b=LjFR1+Q2sCVv8KxRKcvHGefLEyc8PXAK8qsYIx0ayHA9IJ2GG+JXXtYM01f/sZWyg9
         hqqaug7rq6lj4iRyOGNsGZ9Q13dciluC1yFfHZylgq6DmMmikWfo8cRcoefAvgBdLJFg
         N0f8k5gw+bVCbL3KhB+Zj8kpcz9vWAszDEympZw1NPKZ3BRx2ZrNaztzbGzcI9e+9mKF
         RE5gJSfWIf2hpFMBfRismiqbNMZs5JXkBW5ap2X94iyLE1GZ4MimZELvk1xP3vHXh8JQ
         K4AJp3XufwDNukRe1fNq5paqfbHKoDUG5bzLI3CX8zsuNuU0T4Pfhcwt8zOXqfDggo9w
         uusw==
X-Forwarded-Encrypted: i=1; AJvYcCXWXvqNSDfOC5vJAkaScEGHCGgSHTKGacTEThbYGF4LBleWf84ASBT0Aif2rO+0IdwJpbtqQJiR@lists.linux.dev
X-Gm-Message-State: AOJu0YwPTCE7Y6wVznKjJ4lDZpNyOmLQCHPMwBrjLmROdW0cV8VQxjHF
	ztMkzobcz2pLE5LrNGigj9jiTTm3gzePG1JX7SvWOohhuLTcb3jSg4euzPx7/0oIKWqCEE6Kvdm
	MelZKDQk8Wsp+D54Gwi9hQa2w7Qt+O34=
X-Gm-Gg: AeBDietmy7dGN9jZGcYGSFcgMbdrzyjMgCAcgnnkysKdTCUIjOBhsA942fK1A/zsfsw
	fIAG2tH3+Z9OvaBNAMKLevgcxHS0PU8cF8H3pDgBKsZzL1nO+n7GiARYpkE45s5pRDocI5f1egZ
	6ygrMhZT5/3FFiT9tQjXmNHx82ZFs78F3AXVo0/7b6DsRNxCX8azwj7T89rrTrOfROe3oGErHEv
	avf+e+Ub2Pg1ugpEGLPqqOwi8FAokkzBAe836mwo0t7jh8D3W+Rma7CJzSkWuMVs1T4EK7JWhZU
	3w6KEV75JjU2yCOAweDwXq7dDxE/H8qlqxjY5gZ784NqTm1snB9hH3U7flZozGe70V/0KuFRjZM
	P8JNMANFMVrSH0xAbDvARYB+DfGqFAevy3NyYr/O/GIsIad2cmUlYBvvuYilGhZl/Of9XB09Zqp
	MYUGJUNBCWs6A8lcTM2G4=
X-Received: by 2002:a05:7301:6743:b0:2be:2f62:8bb6 with SMTP id
 5a478bee46e88-2d40f0ed9d2mr1303235eec.30.1775719237398; Thu, 09 Apr 2026
 00:20:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260408175939.393281918@linuxfoundation.org> <7we3hoy35kjuwbrzarr4266ylu4x4zcurpuhuhkuzhijbhq2fx@o3zp2r6kgvoh>
In-Reply-To: <7we3hoy35kjuwbrzarr4266ylu4x4zcurpuhuhkuzhijbhq2fx@o3zp2r6kgvoh>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 9 Apr 2026 09:20:24 +0200
X-Gm-Features: AQROBzA1UGLLpF8P0JYFCm58OfHykChiAozB7mmP-BBUUlEFhoIgyrA19mOH8R8
Message-ID: <CADo9pHgtqbPt4Ji39unrZYz-yg3jj3TB+xM+L9LmJceoSpC6Ng@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc1 review
To: Shung-Hsi Yu <shung-hsi.yu@suse.com>, Sasha Levin <sashal@kernel.org>, 
	Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
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

while listening to Sasha: https://youtu.be/V4p-BlBd8pU

Den tors 9 apr. 2026 kl 08:15 skrev Shung-Hsi Yu <shung-hsi.yu@suse.com>:
>
> On Wed, Apr 08, 2026 at 08:00:00PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.19.12 release.
> > There are 311 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> > Anything received after that time might be too late.
>
> test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
> test_verifier in BPF selftests all passes[1] on x86_64.
>
> Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
>
> 1: https://github.com/shunghsiyu/libbpf/actions/runs/24153838933/job/70487760072
>
> [...]
>
