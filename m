Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F460277816
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719371; cv=none; b=qwo78+FgJ9kAvf5dKYWFjj1Hcsb3irsfJTMpcfBJSZPSqIyy8Q4jB3U7juR9s4hIowjaUUG+APCjqKmn1Ydct/mN/CYaUOdAf7xrmm3UAYaUrYKMZBVhmZZRxHWgU2P2dhM+vDTr3ydiXlt9X5NVIOnMY+ZD/4ixbPL4ieIcUdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719371; c=relaxed/simple;
	bh=Y9vWFCVlw2g4DpNXUL4fhrgJKM0WgJemKT0SgUg2hNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZsyXZqkZRT5eMrk84iTHqqVK+vsbHHhkomezTGHNaotOyXipWd6CB20PeWKbV50wsmIuX7OABCnGcWWABTch1TJdO2Pl6yWIvVxOjnejAkGgtg8H2dkJefAr6XNINz927EpoXAgYXzmoMYTTfmf7/qVp5xk//O6S357mrggO8uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DwNDtqi1; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DwNDtqi1"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf06eabdaso11835835e9.2
        for <patches@lists.linux.dev>; Thu, 08 May 2025 08:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1746719368; x=1747324168; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eOY1fBOilgG1yZWy9IkYeCeO3dhjP7Lg4rWy8ix1o0M=;
        b=DwNDtqi1YghUexOonSIIppV6gs+DTzNXCwEF2TnGrOl4IG7TU/tVwUhIbZgalHZRUN
         oNu09dbQwPWssD5a8Vw5sWB0H4y+JET7CZ3DcCphDke0Wg2ik1rx+d8W3TuEogsKxdaT
         oQ+1/vToAdi+T84TJJ25XQb+ug33mYFBmSYTerSdu3MQayA8Nv86MRkDe4T+h271SOp/
         GdFxfXIWdVBlPRbXXq6SoVvESq72h4tlPmj2yuxwoFaUVedYrClvAjtP4WFyNjCurOJg
         Jqg2CZoYjK2K3G/v/3PkdxQO7rjTqdvEwAfm6hCdo+GLZEUTMp+nCWlAJliIXxlEnV6b
         qXgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746719368; x=1747324168;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eOY1fBOilgG1yZWy9IkYeCeO3dhjP7Lg4rWy8ix1o0M=;
        b=PD8rE47nSAkV2bHPs5dhuQOSHnq7VrH9A6Diogh4WL+xP7PAsHXVjYa2M9HTH/K+Z1
         F7DpxN+ru5KPFDfiCyYmOa5DpYBV8K3SqeBpembX6DHtasL/tOAK0Dmi6y8583PUdIbI
         J3ZYlIk3NL9NEg8OpiuMebt4kWucw3TbzaP+KZZNlf5W9FitvBUm3MgiYpcvlbN33dH6
         sd91ChmfVtP1Fp7TanLe+fXd2spSjmPcCmA2fmw5N4P3V5Ymj+FlMLIS7gPytjsCz8yW
         W0rhJiUf2IdK3q9G1y0KFYsEmWJpzfYpYZWY6MWW3ADTD+maaI7j9+nbsjdzjjqr6lGV
         yozw==
X-Gm-Message-State: AOJu0YwbU8TdHWwlv4NfObFQ1jmKtDmC7FGElafDueCS7AhndXov9xAO
	9/7VpWdfb5mgn0ZquivsXNhy6P/atEJXmhp/VqrovRUa5UQkl0A=
X-Gm-Gg: ASbGncswpsz4H6ZKUjGh13lwo/ukfbh4nKUSpWugT3c1dc2DCmnDtHlOqw33WGlYWp8
	vDWNyg2Sv6sAhqG6R+50QyE4XNQkx2FMo3qdMqCComg9xTNStV6wSCh2FMIIgx8lBflIyTYA49G
	tZ3GBqzTk2Ltk/gfl7n+QyO9IlbtjuIUaRKoyP11VyvwNxUEGA6Rs/Grs/EYGkfdckHj4wQnuf2
	Qy5VegDAuiQVPNZw1Zb0/SOY/nIksLq2FfI2LE6GuwhOEj+mMBWIvP0YNPdwy4boiecSfLituoh
	74EUvO6I7VMjlrBT5vFcMJat0nW3PEIKT2Ie0+7jx99kFIvlWIuHIz11Udpd2SVQmFryYl94iFc
	JU28gYA8TP4rsOTghwA==
X-Google-Smtp-Source: AGHT+IHO1DhAK3LRIJ8mCQPQrQm2PUR4aTQxh06gBQlCA4oEfIzCTN7RksSJNtOQ/XUQJQDZ1GqkOQ==
X-Received: by 2002:a05:600c:1d08:b0:43c:fffc:7855 with SMTP id 5b1f17b1804b1-441d44c7d8cmr75789755e9.15.1746719367357;
        Thu, 08 May 2025 08:49:27 -0700 (PDT)
Received: from [192.168.1.3] (p5b05727d.dip0.t-ipconnect.de. [91.5.114.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd328f0fsm42637535e9.7.2025.05.08.08.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 08:49:26 -0700 (PDT)
Message-ID: <bd2a17cf-a8ff-4e6e-9872-0bd28c2ef507@googlemail.com>
Date: Thu, 8 May 2025 17:49:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250507183824.682671926@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.05.2025 um 20:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
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
