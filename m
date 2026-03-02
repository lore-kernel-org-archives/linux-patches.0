Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516562EA468
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 19:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481351; cv=none; b=oPHL5Psytt7i+e//mDXZXzuKAAtotSc7Xi0zaiY4MXtM4y3CslGFGGq1XYJRKP7F+u0ScDCfE9zoYARf12FaJV9wnn1P6sBQsFxSI8NaLtahxif7ngbKaOJY8OdC7ZC9b7aCKQ45Td6ASfaev/k4hThvxnZgKZTb2fwxkhMDEh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481351; c=relaxed/simple;
	bh=Hvd59+usVcaZ8ifj9tKS5IiJ4a8ZMD0RS9aEr11xeNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=temkAkgs+XCMBwlu+U06Uj0apt8TsTudH7gSXQTTvcXYdfRMiihN/86/zTJwrVjsM3a/CjD5VysR84P3ks0keHw0fWBpmlllkHkBfZxrr+DK/hA+ob6U5oFQJhPisX6YxRr6kga/nehdEKESu+KgYdK69aOmpsXbOXho9j0ejoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=aATxRHyl; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="aATxRHyl"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-483a2338616so30767095e9.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 11:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772481349; x=1773086149; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q7RGg+lZsEVvDvA8CfA6jT3knN/NNfFfEMkttW3wrEI=;
        b=aATxRHylY53itwSS6UpZneGKmLDC7RxeKPSSn2GKDBwR4mVf7DQeKAd0pmX8MSPuL1
         2mRG7eC7Ij/A5wH/SzZfUXjc5BLmHAxrlEQhKjh9TbSuJZqIjyntn2gPA1AMPKgE/72M
         W228mb3QMYIRlAyuqR9/qhGvDD3azR0D3Ov+LqeQX1ceaLbA/RRQk4mAOBvJWDhrRjUh
         kVpIek5pSyrrP8jK2s8B4J/g4M8/vhieGkGXsL404CFi00DCZfMIuC7UIBfFWC1fWHOK
         xEcM28oMqgSB9XZPd3Fn03eVMKH+N7Q+XG/FUdbyDwbkYsdlZv+oxAQ2iqkTf6ypNmy1
         vuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481349; x=1773086149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q7RGg+lZsEVvDvA8CfA6jT3knN/NNfFfEMkttW3wrEI=;
        b=acf6g7fDFMOlPaSZU2JMOT/i2oCQofU4sgxTrXAORXXMHjeKNfsnVg5xij3MTqC8TL
         pVg+v6usBVU2ZQhi/HzScui5UpdNWRgY8hTOzXwXDTo3ACy9+/aHVDYrjyStQUV71lqp
         +YkuhF4xCO+5Qr7+zRwJ3T5SEtzb/0NMGpn7YieM+N72pa4WPCVNGZEN4M2BSwSUPh4X
         /IziVXpikHRBEfrGdMS9o+u+34KMrvdss+1sMv8YCRQnX5BEnuNVzBAOvPPLv1o+82DC
         CYVPWyjE2JYLRG06mlfg0eTkhQGjOkVib3UVfJZG7cmvv+2sMrsrW5TMSq3XlVvI9nGW
         uXVw==
X-Forwarded-Encrypted: i=1; AJvYcCUaIdCcp3vu07grA6LsRt880kiwor1Isry6YyehvXrFlcf5r+qwiFfVyus7SBFcuOD/T23BzeZH@lists.linux.dev
X-Gm-Message-State: AOJu0YzUfar6a8gbKNCWWTJSBAmcCMvYM/GSy+ivMSWiD++CrtHo/iSp
	92DSRSMxgZp19yHGIedzEDOOTKi60eR2sj/YvGFjxYGXM11Y0uyJ+wc=
X-Gm-Gg: ATEYQzyJPdTR55B5hqGejchItqOYaXFaQQ1L6b/xzycLEBNa1fDZaLWD2Bm6/vYRQsy
	Pd/H1Xq/DEb6JKNmdg/q6TqvfnWks5h6+xLNi0uXMSXYbD3MffTD9qNjFrTKIXOIU9xyaDDPfFn
	EuH96wre7YHr+fwT6NPZVs00Wmetd4qqEtUMA9bap1IVLfr4vQl4FmMjde1uUCfWe9c3FNwd8EA
	3s8rQ0nyFpdxag8TVv9iB9NVejrrO4JjOOwMVNY4ksqRgtNuehqKI0FOETUQ8aEjh2QSfpn2FZ/
	yM9qOdL13OPUATiFY49Lw+1OF6+0I1wr1Cm1c05yPGX0fq8UqSMPVJ8eEdZcPp94maw+GUsSgOI
	jEoCZGK0BzW/4kIcKLJw9AqHUElJlDBxEcFfYE6amSAXBOwEqmIVtoDY3SZ3B4Xu0JhkrUrViNo
	vyDxIB/7RNZT50zCfnRPhCOpP/1O2J5AOzfuK8BIrbeqTn1yPXogQBNICS0+EKOvljo3U6pUh9d
	w==
X-Received: by 2002:a05:600d:6447:20b0:477:98f7:2aec with SMTP id 5b1f17b1804b1-483c9ba7e34mr162489315e9.3.1772481348284;
        Mon, 02 Mar 2026 11:55:48 -0800 (PST)
Received: from [192.168.1.3] (p5b2b433d.dip0.t-ipconnect.de. [91.43.67.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b3d24dsm259967155e9.5.2026.03.02.11.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 11:55:47 -0800 (PST)
Message-ID: <a04b1aa6-ba46-4368-9dfe-6320a2dafa79@googlemail.com>
Date: Mon, 2 Mar 2026 20:55:47 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160943.2522184-1-sashal@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.03.2026 um 17:09 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

So this 2nd incarnation of -rc2 (57e92ee8bab0fe5c2396925771b394f13d531cc7) now builds, boots and works fine on my 
2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
