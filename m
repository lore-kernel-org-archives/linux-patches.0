Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B926F1CCEF5
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 13:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677808; cv=none; b=TrLjbB6qW1lAQGJvqJal0rqa525gQFzmAbX8OSt2Wlf6Mn2jtEDG4g8h4Zr/kSwKJvO2ck4CKK8DOPTwuraigSvLs40Nh5S9u6dsUMLrR3Jaft9j/dmokJGpkbUqu8MuxdjHxArs6XZAhFqFZsHLHzOJk8oYhjNE90THEEWEdoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677808; c=relaxed/simple;
	bh=gd+fZnjtIrzZH8uRFuesecl8rg3R3bbNBsC0AcNkI2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qCISEN4lx3XQs1obnGeVWE9dPcnU6LM56vg0RbeMrAmnjyDlJbDnFLZrVSWVu8FRTYhFYPUQNkh72DObMlLBnl/Qov25QFGTznmYunZV6Tz/TgwBMxWFJMdRbBdM3LLoy3WwsV5CR6h+WDszgeDrM9fkmLpJh12BzhAmJqxpaNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=UCuSsm/H; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="UCuSsm/H"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4315839a7c9so15674385e9.3
        for <patches@lists.linux.dev>; Fri, 15 Nov 2024 05:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1731677805; x=1732282605; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QFMEoy+VpYmS896YAj0P2dmeI7XvRACI2gkwVcDp1l0=;
        b=UCuSsm/H7jOyC0qjMRcE3Bygq7CFfIjQUqSq3zbj1hkQhv+SaaeeeZ89QFHva4lGuy
         yRTR5QqRk8Ly/PxVW0dmo+K0ECCU79Bsj9AJllytBwgcCPtepaZsFzdE75PnLDpTdcGk
         F6DyrQDvWvp7BNJuRQaa1zgIYj5hsAeyLKw4+d3zpD2VbOlae0+hke6nGJCzIcPEEOO4
         s86AiDcMlKyWFrm2tpvns39Ux1uq0s36PtuD41XWfbOenlJlKgSQk4Q5Xd3ho4jn21bo
         Y0pPNuDm1R3WfwdxJMb8v9XalgTRuaDZ20j2ysN9H8Rrim7kkmbnT0a8jLlWSPslkD2w
         z3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731677805; x=1732282605;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFMEoy+VpYmS896YAj0P2dmeI7XvRACI2gkwVcDp1l0=;
        b=vZlY+r3ygABA8RIyD0wgyEu3e0koenSo/9kU0B7zBmrbnpTHsv1zm1HI0BMMEsI5md
         ZYJ2fqH8kt2p3OiOFUscTr4rg7SwonRd0qbYjH7r66O+MysUO6Xt0h9W4XCrU4IL5wTs
         zTOvGzRDJkgkB5NQG3jhJE+sZ52f09eaIVOZxhrPqNjHe9J6LXu+ndIWVIFbUX+wzela
         j/lltlbXT6FUrFEunvZ7RgoE5nUWZAJU5DKllqPg5m/+EmWviP8jQod/hP1Kwhz+PtO0
         uu+zNW9tOybQeQLtqp98zw48hRSc+WkWQZa1dwtRncdbj/88aoX/68e26SuA/C+E5Uj7
         wxKg==
X-Gm-Message-State: AOJu0YxK0G2v33Ejj/s8mirZeQJGi5usKc/IQdMXEq4B1p0mFGsTXHdk
	uWA7D1Ynf9XUwrKxukU81oHzY7D+ItMsDDCapaWXSwp4xaGepPA=
X-Google-Smtp-Source: AGHT+IFCGOXPuKhEx3Wk5YE8y8nyvKH/XqNmBteJiALxBgwKZI2U4Vxx8yVSP4YuFlEM3MRere3Prg==
X-Received: by 2002:a05:600c:4f06:b0:426:6455:f124 with SMTP id 5b1f17b1804b1-432df67783emr23283655e9.0.1731677804979;
        Fri, 15 Nov 2024 05:36:44 -0800 (PST)
Received: from [192.168.1.3] (p5b05792c.dip0.t-ipconnect.de. [91.5.121.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da27fc8esm58933775e9.21.2024.11.15.05.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 05:36:44 -0800 (PST)
Message-ID: <c4cda9aa-bead-4ca3-8878-8f6d05953ba4@googlemail.com>
Date: Fri, 15 Nov 2024 14:36:42 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241115063722.962047137@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.11.2024 um 07:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
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
