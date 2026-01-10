Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5880735965
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768038843; cv=none; b=bZw/qgetHP+J+pbEQFY7rVCwsHKsap254eb6e8n/oSU8ad9GvHzxWEfxrhwDoY1vFqB6H3Ynjd57m97xWSDYISiJm2cvPjBd5goLYfib+TD0L4Yuk7WZzb5TzSrp3Kzv7wF/4JYRPDiHax9RJFPz+mueyfAzRspk30l7KI9ci+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768038843; c=relaxed/simple;
	bh=yL+5nDlRuP0DDKJR6kMiVZMt2mnQsVcin+5neQ6LxoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CfRf1P4QVKgNyClvrP7CJ3RGYGK9TtUGEEIB5nVcXh/AEaCBScrsJZK3llqKEfy/16q7DOFazfikPfVSErg4PTpg+ckw4BgCaq2Hbhj53/gj45RkEV7OuR11Oio4anajl07AfEnjZogew3ZKvWLe30PX2lwy1CuEyD14g8sKRq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=jKO1Dc3W; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="jKO1Dc3W"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so812278966b.2
        for <patches@lists.linux.dev>; Sat, 10 Jan 2026 01:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768038841; x=1768643641; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vpheX/ey9FdByEahZt7dUCBS3OYWKh+3lgetnYEvmao=;
        b=jKO1Dc3Wvf5XWVAVvMRhdLKb6rcd1yUtsqwd0/ndg+nrMCB+ZIfBD1zcxZOWvl0fc3
         +kQq/BckeOphn8zZ5267T3faW+YhXr4fSWfQKfnvPI5dwR52EH10j0bNMmDo/9dzHz2z
         TPAQbQ6Z5oc1bnFlcGY2R4STFZDO4D+zxPlp02BHTrfR6IGGeBGy/HI9oLjo9XCdk23W
         xcfcj58XjaDOx6QsYafjTH6G1t/8VuXl4SblvsvLJ+0Aokqslu++L74GzDwyWUiiqhyQ
         FNBMYxX/Gj2amzfM/EjZ4C3hMbEwCAM4/eroz84r5hVIPIq4erzR8gdkCmukshvDmlXw
         S6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768038841; x=1768643641;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vpheX/ey9FdByEahZt7dUCBS3OYWKh+3lgetnYEvmao=;
        b=PcYP20G09deU4sk+9k4/01vgtKVCA2d3eCTHhzN85sZUHzZKLOdj/3ph5ZBGetJEoo
         emM/YFwjZCOaQgZfuaD+tnuMeyoqxfPMUvc4yktBnC0/bSAXob+KQFFyp2OBDw/ExbRj
         JV3bZj2haTx9vyBNsltIWjeQHwiRANsjxQpCp+sT9y5UnSu/Mym8BkdKc8NnNGVl8DnV
         Yl35eUVvE+9xeC52GU84ASyxAzgKNiJKs7e/LHv29awhboSSA0bZjr8IQ2zhJechj74N
         8tQ0OW6mFIo8x1yypX1FhgoIrwgXECgOCFaLQ7EMBiQ/M4h0bFN2wAmcXU7Qwob8kQ/T
         nE0g==
X-Forwarded-Encrypted: i=1; AJvYcCV7+mX+H59dW6jVcRafxvKHPW3hxNbPlZWd3zkE8OxLqYQDgmEdtm5QILWtXnVJy69owwAmrYQt@lists.linux.dev
X-Gm-Message-State: AOJu0Yzqygf+gqu1XImI5yVyf1ZBpbLA/asP9nRqImFrJCmQ0THz5+UZ
	p1CUbEX1fp9Ox7eFZzSelxtBOv9KckMGtbPSmMo4sU/coPRvFGbWVmvep2eoFIOREsvEmRozucw
	jM+ctBUVexUqUR12qbbBqJSUZul1faFqSP+RDqzcdwg==
X-Gm-Gg: AY/fxX4lgLu98/igOpZoefqZCb0VJm/VPH0g7m5zv820N2UsFk8GL7yCHBVdOsM5tt5
	6D5vWMStsuHnQjsustFAfkHjB8vb8BDijfn5RIE2FU154NVUEYruvL1XjB0tlaBLS8r/e05IizD
	R4Ix5mYYgFBHDhoxBDT4xB+xfLKqv7uJ2rJdQm4Nt54QxTTRwlS7APhW8Ku/hIYLODY9NXiUqVu
	XT2lQ5Cxo4xyNopc0+/Oi8mYZQCO8E5L3O8hQuNnczaFkz8xnr21Az36jxX+5VDLHUVJk/w
X-Google-Smtp-Source: AGHT+IGURXNNrj3WuTa9P2rOK93sGBZtBFjkgl0j2ENrDSP0o8OmoRnsi+DfVENA1fiY6l84H5lQQwXnfRapuUaFCQ0=
X-Received: by 2002:a17:907:7fa5:b0:b73:8639:cd96 with SMTP id
 a640c23a62f3a-b8444ccea89mr1181718666b.24.1768038840793; Sat, 10 Jan 2026
 01:54:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109111950.344681501@linuxfoundation.org>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 10 Jan 2026 15:23:24 +0530
X-Gm-Features: AQt7F2q3IZTmlvbj4-K7nkwEjAM9xMP_OSy0LpooJtrgBLok0IruzPdn15OyjPU
Message-ID: <CAG=yYw=UXQHH4j2vaPcMu7XsKRLm6HVuTHZW_aS5d23bLpSE1A@mail.gmail.com>
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

hello

Compiled and booted  6.18.5-rc1+

No  typical new regressions   from dmesg.

As per dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
