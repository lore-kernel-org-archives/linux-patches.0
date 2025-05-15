Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EADB664
	for <patches@lists.linux.dev>; Thu, 15 May 2025 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747345035; cv=none; b=atx9owvy/fTUMnjZ6PDwWsn8mUfNi6ZhBZqNCuFVQFWtSdeK0AzpaVDt2b+x0wk2BcUoNi7NsbjpVjMZSiY9VVKs5nlPFCsoHnw/DtGJmOBIWCGzxmT4i2cv0pRpmcUWa+9jBck6KrgtTj9P/xes59ZdLarppIaAgc/GbZiL/rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747345035; c=relaxed/simple;
	bh=6uepYIsSs6iVLsyaTwSMa1emoHWojyYAxnIzLLnYpno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GyKFZQgp5p51xz4GKGUvJCrc5LV8v9cEd8gGnSIyWbTsvWgVBomaWfX4ltFA3Yd1BM/v7WywHQDaILZSMGoCBOqKidSxGUURFrvf+31rdVjjxHyMc+JM8Yeu/D9QwRzSIWwgCO3ZG6QZgazglmLbc7rGVcYVucQIA65F9g3cYms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=O7alAdka; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="O7alAdka"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-442f4a3a4d6so9465155e9.0
        for <patches@lists.linux.dev>; Thu, 15 May 2025 14:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747345032; x=1747949832; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cmT5q5U5QpFLoxGl0O1NThy+g8rCMO4busNalB/ZFBI=;
        b=O7alAdkaIdiMzNGx/LU5ARSgqXsijPWGM8F+ivEudtPakhkDFlcowD0sdCToLcM99Y
         DxtqggZ19T/whF6Bbf9zhsa632cWGGTSpGDGTshVmoodKGk+uk9bXRoZHc7xuO2ngcvm
         /OIvIa+iQtlYmnz9cjaNOc8GG+HeTfA9cPF1+3dBkGcdvQAx9qKGuOppVhgXtYKkrraf
         wU35vkSev68cVDu/H7Qy5dKNdMdD3QiJugkTIAQUtp9oOZMA9IuMZ+e4aJaj29EWQ37K
         0gtFctz0OPYRTcyAMGzO64YHS8wd3aPEZKNkxcxAPQfovWYwWLyCzLiYQdfj8G5cVlGt
         Ms8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747345032; x=1747949832;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmT5q5U5QpFLoxGl0O1NThy+g8rCMO4busNalB/ZFBI=;
        b=NERxm64q3m6OM4H5eIeyfkX7neqPPwObT7YHuGuUHMbL6XADqybyezkWq1Q3f0yeVx
         NPLv4aBZqUS9Q107CS7TycjOCf/Vk4RbxkVeyH4X8+ir1e1D5nx775rWRFa7vvm9Mb+u
         bLDtmg7l1vH7JL90q6uRoEpLC59TnP+sj11vKeLQtJJjliGHGfJCZoMDqyPd9b1p2vFw
         6sY7+4mUCpX3fb0k1NYzIB9F/3aMUhzyw4M/EGHxOz2AXs3qrMnTUUmgE+rvLzzraE4k
         arPtC9Jd6MyGdKI3Dhri85yAZQu4F9nNmRg81I08vvOZSnYjm+kyeTwtbIgVweKZY32J
         jVmA==
X-Gm-Message-State: AOJu0YxFnmj3CbcIrkYWV7O7b+CQnopJwJnnwZE8HRXKFMJYYGNckjw8
	PVlME6HbK17nxZz+is+RCAA0dgm4nBlUk6JbIiiMJdaiugeLB9C/9hE=
X-Gm-Gg: ASbGnctqJ49I1PM4d1B53PX/ej/PRAqe87GD9tY4UA+mEQ85bRiiDByPG+4hytG1Q1y
	afG2p3EZ4le2QvwRIOeF4P2rmOW2wrE/F0wqdoNi1efTjuOEqlXFbS0kiMcMy8Zdc4pihUN8KCz
	uXLOU9aukOWgjo0NzJfcwrrCE9oz63S7c3yQfv7JuSaUCNPhtwd+YtJ7+qVTudl2vgOtwOZk87D
	uFzyosJu0kKyYvJaWm/P2ui1+zBLLKctsLsnpnPujEcyFa7+3vz9ptYgOKGuEiKHbRnRz0hadJ9
	ZxD6sukf9pxUPUlrXmoZ3dJNJFgrSjvNvZ8/2QOoXILTdRkZux299OY/k5RN7zXJxSsQJyAGOOJ
	QrUeZug2rK74JMGbLM9wzXVE69vfpxHQLtCFR
X-Google-Smtp-Source: AGHT+IGrVCsAbOfF2Z57AhIYHZhANi6KSxXgDZjVUW14yWJvdn190w6JMajAW56Qg1tsRmwVdCyqiQ==
X-Received: by 2002:a05:600c:4506:b0:43d:fa5f:7d30 with SMTP id 5b1f17b1804b1-442fd9a2be1mr6494175e9.16.1747345031811;
        Thu, 15 May 2025 14:37:11 -0700 (PDT)
Received: from [192.168.1.3] (p5b057603.dip0.t-ipconnect.de. [91.5.118.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442ebdc362fsm78870425e9.1.2025.05.15.14.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 14:37:10 -0700 (PDT)
Message-ID: <d77efcd5-4b38-46b9-977f-226c53a7aadf@googlemail.com>
Date: Thu, 15 May 2025 23:37:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250514125625.496402993@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250514125625.496402993@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 14.05.2025 um 15:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
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
