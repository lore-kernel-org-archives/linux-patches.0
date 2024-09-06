Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C942DC13C
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 12:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725627152; cv=none; b=JAuAj/EYjzyx0NKtR9M/9O79qvAk9v6h0SB5n23T1amAvjOd4ioL/WU+4wM1J4p8Pb+AR1BKWIpK3F+2ZfkYaUya6AaTzfj/ceIzEAg68z0xLBJM5+htDTgM372mtD5jUFnJGxS/32WgDVpCOfA2svDRoypLLc3jFPQr8kHzbkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725627152; c=relaxed/simple;
	bh=LAe+SVFODFHG3JO85HxVC4wTLxHPy0xG1UGWXRGSfSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjRAxH2/lJ9d3BxN1SJzgNWrX6xhXP1FS7UWyp169oXs7ZxuY2uteKW5llUDGlnY1PQrUYT5/WzswK1z11ZpU8F10dbPpqJdVh+RtLadaGIryk0rFCL6eCKuFgY19/n+wBIeEtj16tlaTcm6qZn3aFzLSK9XAhfYXVdu5WYa7PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=AdZr7kSX; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="AdZr7kSX"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53345dcd377so2537034e87.2
        for <patches@lists.linux.dev>; Fri, 06 Sep 2024 05:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1725627149; x=1726231949; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a7xpYl6U/W2CVmGwpeWmwDvxtZgNF6LNCUTyVT4QRdE=;
        b=AdZr7kSXC2FktwvZfNoA6si/0oU1Ioc94gSOHka2XwkQ+C2voF0y1MqO4brb3HGnSe
         Y34xGNMMbU8r34jFMZ6XrPpstohiafRlwN/wB/roo12xOrOzcIfLNocWbjK1/HaAt91W
         P3S3I4XyUc7uw3mBsRIyhS+A3T9wcKqaBbEnm+J7Gn7YBHHnGpnidc9IKU4vsx2YxwIE
         H++4fDmNm2ic6DJy4BQ/DqYSg0KEM3xCHOBT5fJNiWHCG0cP1JdEVc/vh2TTRP6eHJQx
         lQ98CgwEcS/+IZVrkp/CKZTMXzBYJxM7qq+5QwRhdZn5BfTJ3934IPSB03wbsydPkkDu
         /Ojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725627149; x=1726231949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a7xpYl6U/W2CVmGwpeWmwDvxtZgNF6LNCUTyVT4QRdE=;
        b=EwPqJ8BYt2thTdnlLL3tCH33ziMsO+KlZk6Su5TWtp5opHGLuL9zrGGNqTjB3OPwsY
         eHWkqDowo50U8vjI3Vd8S2CXGRUXULCheB4O2gR2aCzfM9gxDy1K43BVgvojjuMfhwQH
         iQk+GNC8AUYyzAf1EfbDb38j2Kp8TnUmY81E60OZ9I00zvgy+X7MHzsSYUZyMNyzGx/y
         YGTkVG0J3rK6wVAi0mNPcoRJESmtcqNNeYqxDS79HEJPueoDl6bf8cYc004KG87ygxUX
         5RAl8m+5xaYV22yfrfM407VbWBCtLRk5xxUcjsttG5nNUWFUiQKA17Ewt0dvSfo1cmVJ
         nB2A==
X-Gm-Message-State: AOJu0YzS8QfboJ7efDQHciCFNX502IDuuOT/UN6lUC6W6Bum0OD2Nndp
	qMCMyxusyIr2CbA84BqMDzFsrjRLiltkAq29zyDZU1AX3YrpDEg=
X-Google-Smtp-Source: AGHT+IHWVUg6w0qXEXxCORO+fGAi77k1sUCAjc1o4hBTuyAu256CvscZNFz2PRcuSJLEh35/EphQNA==
X-Received: by 2002:a05:6512:3d89:b0:533:4676:c21c with SMTP id 2adb3069b0e04-536587fcdecmr1661821e87.44.1725627148397;
        Fri, 06 Sep 2024 05:52:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b40f2.dip0.t-ipconnect.de. [91.43.64.242])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623a45b0sm279211566b.143.2024.09.06.05.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 05:52:27 -0700 (PDT)
Message-ID: <7e973e08-456f-44bc-b769-fb600b49274d@googlemail.com>
Date: Fri, 6 Sep 2024 14:52:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/131] 6.6.50-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240905163540.863769972@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240905163540.863769972@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.09.2024 um 18:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.50 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
