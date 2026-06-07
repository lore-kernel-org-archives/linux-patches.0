Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B918329396
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 19:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780861541; cv=none; b=f5/vFW/zcESpua3cuaVbVkOUVUikZl10innjGSAIb16tzjd3t4ZMjANFkinKZ+LVf2UJdIyUNucoGBJ5FqyVUTe4BpgEOvuyMKzLbRT7OMLjjnYA29bFNaNRF9sPvDFLLgUtvXUMbsZdGTBPJvXPLBY5gcmjADAi88BMreWlkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780861541; c=relaxed/simple;
	bh=tCCyScGg5zLktCv4/vu7dP7DFr0mxGEvVB09IMqHG0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SjMAVHzxsYQcmR1usrRsdSTmMjfhpt5nPLcE/lPT1BsWSbWTht+5S08daRJGqiapUc9EEDCU7VyXHRK4rIMyd7KFcfYH+9czOtzqEnA61rpch0GJ8bGP834vljHyk4ct7LXOdPJIQstaBPDR7L/UU5Ev5iyAOgpt02rFXDY/+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=l9cfr8f4; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="l9cfr8f4"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490ac357c55so41583205e9.1
        for <patches@lists.linux.dev>; Sun, 07 Jun 2026 12:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1780861538; x=1781466338; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JHoXjXG0dor552NQWwgbrAyEMhGxFl2juanAjE9YOn4=;
        b=l9cfr8f4wJnQS1vET5ngYwfk47tV1QB5g7phqmBKyHDF8r3mkzFjtNSZxZhHn37CQp
         V5zsvbmcI1glSfGyDmieTnBRBMrUKow8a0abzPWUrHyLYTRyKOY6zsiVymbGMN+LcQZ7
         Xg8Pt6BTY70mopnGNiwFckO1/Tyo1RvoFy/mopsJg2+h1gLr7+dvji1TF7ENdXsf+qiv
         EoRJCu3dLHw9S3fcO1QCeXYnpQHNFmZCwpqLx5MogvFlq234DDX8oGdIRRIMpMyiQ+3H
         yH7rm55F1oSOlAgCSYFleH/0agv/3KdxML5O384pJhnKw+tLVESctNHflQyIvDjKx4hx
         9PNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780861538; x=1781466338;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JHoXjXG0dor552NQWwgbrAyEMhGxFl2juanAjE9YOn4=;
        b=GaMCRBuvkWyqfc81s4bFAe8LGOTtVWWN11Go4QZwDDj7mAKmQYbGLPz3idtvQsoMYr
         32ZtW2kLReBBc+o0WTnnfMAN6lT9SmvI2hsycYz9hWH6w0MXzIvXn98GCtO23sqVqsgy
         rbtqDRg1t76TGwHLK0vxoHYkuDeQkVLO4u/MP63kb87+6We0IIpP7jOIxZdj5Jm65IIh
         Dpk+Jfeq5SpHh+l8+mkgGbQskUT3J8KMdl6h3nuL9LC8AG+DEbGv+itoVTqisryqAp9V
         J+u/VBUGc972WywKwZO2+B1DS/S53E/QSIXHnSGNhtZxy8HHLoN02ukaVLoKhrI6DL4G
         +TUQ==
X-Gm-Message-State: AOJu0YxP10vULWG4aNEZ7sfHa2BmDJju1AIuQqLsijMr6sKcKdErkagi
	e/A2kbc7oUfAokcz1gkRI7wE0RfTt1l8AnvTd1eGi2AJq//Xw3h+2WM=
X-Gm-Gg: Acq92OFOlRCENq8PqcjWss5zebKuYURKneiKknnJg4SrZcEgewOdhK9fjU53LSBTAYF
	nno4TfgJSwE51NGDupgPWrfU7InrgU4MUZqrGzI+5VXDqBd+BRtwuTJF7r6F2WDwZjRdoLvHjTe
	lCW3337kmUY/j/5PmlLLZt4QkAwh52dCvvA6CIpGUwOMX2TBP56zPm9pGSrOWcQSxaYBLEdpFaP
	UVuyGFyjgY3X1gkKTkX9nTGLz1LuCztqFAjZeMoQKS7MT0FAKGqcwKuTvlIWOBMSoIALCvupt1H
	CeFqCSiz/kNn1uw7o9m9yzcZLagSluo5ygG8xNYE19fpenSUG/qjZIyH59ElIlI4Fv6NNheBpii
	6im3qylDNiIuGkPT4BeI5+Rucs7pNr7X7VLJPQRmGKMMYRK5tBQTrsUgN7/Mi/gDvgxYhqmeEgI
	coUDr1hEMC8xydMYWnzZ+Fjje5AIKtSt+UsiAtdYRoO9nm4W/JG9+8xDEfkow1QWTBfyO4ppJcc
	4inR/dTU8cMYA==
X-Received: by 2002:a05:600c:3e83:b0:48f:f64c:c2fe with SMTP id 5b1f17b1804b1-490c25f1ac3mr206766775e9.22.1780861538381;
        Sun, 07 Jun 2026 12:45:38 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b48d7.dip0.t-ipconnect.de. [91.43.72.215])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc413adbsm333640585e9.15.2026.06.07.12.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 12:45:38 -0700 (PDT)
Message-ID: <60bd06c4-be38-43a1-9375-faa890402dfd@googlemail.com>
Date: Sun, 7 Jun 2026 21:45:37 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260607095727.647295505@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.06.2026 um 11:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.93 release.
> There are 307 patches in this series, all will be posted as a response
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
