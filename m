Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672D820C483
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 11:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730979371; cv=none; b=SQNJBw9EHVO041vRA51KrtDE/Ivg8jJfFVGSuyV+B2WFSguiWdm4kJ1P29MXPlcpVsAfvhi5KJF7/zZ3xL3nHnNshoexo1/mWKrmsOsKQb9Ybvk+U9yF/aVMHeJQuXWO0VBLuUR1g10/oTBdllKp89Qg3lKQZ/EEYfE2FQQbxqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730979371; c=relaxed/simple;
	bh=qxWjifonqFKnhZ8gv89dEn2nASW03TwilfxkBsp7j5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IwDwqROKh1X1l3GbpSv0DdvKJqcrxDGGnmNZiQYhb8G48YJgvQeiRV1D8XN2dR/oO/0ec1VKpto86qP5eispxRHvg/0HUF7xUC8ZebDez0kZiwNFHv8MzQuslsT/k9PycNTZvXGeoQid7Dt7E+/wsXJZ5BpnL73EVcbn/gox5Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mRTUP6aq; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mRTUP6aq"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43155afca99so11260225e9.1
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 03:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1730979368; x=1731584168; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ty+qJBXg4bnlolQ5RZHsDuQ6RCsD7b6YT0DtPdQ5EVI=;
        b=mRTUP6aqJAUz2rXV79qweJCqvuv6JOMMLeBJnhiC1/OMkbbEFX9IKJiXqWVaTtbgib
         C1vMNmNpFVxIMAOyeI6ZBCLV6URleIPW0pZ5k8xbi83lsuCFxMjlUroh0kBFveU92hmn
         k+ajpCOsf8Lu/5G9spxxGLWsX1JgJpGQDulRJPTBv0JuotNrmQNgR7pYh/ArgM3EBLXK
         l+tx2FfiwqQl6L17llPfyuQDniZGno20endg4qBajBxxlLBk9JvsMaDj7IyqvYV9vKBQ
         SWg/WqheWcXGOHdJCxkH1Bu1shXQ1Efgz1JknRwYEZAARrAYJusf54C4jmA5PbTcJUJn
         1FfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730979368; x=1731584168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ty+qJBXg4bnlolQ5RZHsDuQ6RCsD7b6YT0DtPdQ5EVI=;
        b=BW3+sZgeIpIkjT/7hs9tnHDM4BaGdbk3qb5fH6fEh3aaTGvBGh+LVLuO8DpI8aq0FC
         0NcXQu3D9TEiFV6fR9ulor37Az1JvlYCgdwQaR8dIeBUi8fA4P0IEo/ZcrzTucPofs2K
         3IWHWSYzLueqF8FRwOmz3N+FvkgM1V1OgAfSE2pIxcvErKU04+ApRREICB83t1AUOxcV
         xf4xSxZOYYGaNbzh4168F6VxC9GX0CWhrwKLiBRNzccbQ8887fr0xFr8sqYoI/uspTIR
         G9kPigdVoIImvfL2cFNAfj1XMP4W8e2OSlK/HYRKsevqGcczuZX+b6tLHWXGzQ+fOm3Q
         oT+g==
X-Gm-Message-State: AOJu0YxCSFI0nSmWhbGb+o3vjrcVCBfulJ9VsbBCTu+rwDXra8ivWeGk
	8smf1iKy/MQIxlNYNf2wPji/VPMZmpYHsGhodDA8tTiVQ3tx6kE=
X-Google-Smtp-Source: AGHT+IGbrbjTVBvCyElsvoOE1ypSeiDOiFTAEQHkitYEQmG5JIs58kQwbh8kGECowUUtnuJYV+t9JA==
X-Received: by 2002:a05:600c:1c8a:b0:431:9340:77e0 with SMTP id 5b1f17b1804b1-432b382bdc8mr9191465e9.9.1730979367529;
        Thu, 07 Nov 2024 03:36:07 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac486.dip0.t-ipconnect.de. [91.42.196.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05319aesm20664355e9.8.2024.11.07.03.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 03:36:06 -0800 (PST)
Message-ID: <a14b2f06-fa71-40c3-a796-9193bbcc38ca@googlemail.com>
Date: Thu, 7 Nov 2024 12:36:05 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241106120306.038154857@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.11.2024 um 13:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
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
