Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5230ACFF
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 23:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519959; cv=none; b=X8p5EJidShZg5xQlGyGMBHiY6xvIhn939Ha4T6Wm3ME2cV11MfQvpBD3Cr17GyAlkdHjUK6f4+xVHcAoDsb8OLuLaMP/eWI6m0+QHqaMH85YaVJRgPtMXpVF4KK6UG1Pnf1EOoMwB+bnJnmGaEkVKSGQD9De9h7+VNeJJkHd+Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519959; c=relaxed/simple;
	bh=Rh4+Y6I5pI3J/iLpB/fv9hVazc5LVudqjRdfh0ZEMiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uYXKK8tD7bjCxZrYZpS3iZCKkM7o5/KueBQbBpm3ojMSHo3K9gbSDuPSXQ8QEPVolPAeuRNb8NyFnJmEy/Ffaum2kteaBe95l5A39BRimnpW0RmfrG+qiGh0tmJAVjBFf963JMd2YpXyyEJ2Z+JX8lThpB5yIFRsPxsDNHOeuTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IsMupcky; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IsMupcky"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b04fcfc0daso1759742eec.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 15:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768519957; x=1769124757; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RbhFmf+s9AJ+hr5baQrnrCRHAGqVTHtYjCq9UgpdDaQ=;
        b=IsMupckyx/4sf2enJGc78Tltev9xPJPz0n9no7/UnhG0kLHEI5GmwGMJ1FQ7v3KmYR
         GbQsAL2KUMMd1znJBkBWlBiWTbMrwXaE3YeSs1TneFwTF8P7Zf8px4bgwe7Z0wlva0fD
         exIKGWt4zPl+YKuI7Ea0hYD7KaXukNt7RR/2fZEoYGuYB98gdc0CyYrmxT9t87ANfL60
         +ze9Dn69rogt8pqqjgqWirTCRjX9WambU+WwKghj4VY/Rmwg/sevgsgLdUj1FaeFyxbu
         kPz73uyhUyqqxG74ZUsGoBvEy1xevgnZzxl9HsSg85SDTpMO30ato4MTdRN8nPim8OOm
         USDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768519957; x=1769124757;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RbhFmf+s9AJ+hr5baQrnrCRHAGqVTHtYjCq9UgpdDaQ=;
        b=HUC/5R6FzvTS0IroGj/FY9QMHInAPBXLb0zUZF93YCyjI3T49fqhs/JWlx2+qCSgNf
         i4/1cvzEFiYnPJZO+J/FN2suSwHuwq0eYoj8/xAGaAdBXiHnNons5nFEmcXWFcsgHa6V
         87LWd58QD7Bm+ZzoQ8QTpV4JwkadidgAKSE2ogQc4GL6CknRaESrxkDV324Z1hSBCEKI
         pWR4KEpQMLny/HCpwljUKbBWw/RmABwl1sOjNpxPbGDNdfFd1lSFfRfM6AAjmHOLN8bM
         a3iNiREEnVo2Eor1rfOjWCQA6ad6bfdzev1gy1JlWOvtHVlT5ceuVoUIvBdJgtQkpl4u
         PfLQ==
X-Gm-Message-State: AOJu0Yw6+aRrl/QZWgNd7aKTJs129xsw7/LoSqc3jVrce2sJN6CwVkmE
	AcsWo6wGSoGZqO3aONweOFkHN+9bHsq4+GxBt073eLyD+LtdT2Uaau5Z
X-Gm-Gg: AY/fxX6ROIeZy11s78u59strwxIHKfoONe6GOV849V0BJKuiPI8m/l2lfbsPUE4BMaL
	/vEQFLlHW9xrSS/+VeeD401eoQ4+VScZZHgjsCrvOA6gxo92ZqUGLVCJEDKgjoP0Z1UVKMV0f+p
	yh/UnK9ODUg6iCsxiDZHbrWy+RIyuAy1DSXhrQoO20RIAyhVqqVKalDy0dlINmX9guvgIFIgoMK
	nTJ7o0mKhbkb4cYoVQ5Lq/Nj5Jaak5Zi05kFstqrd4pycjDnzXvdtmnPBc4ctPagljKiraK4iKh
	lmXo/VkM42dUKJ/CkVnCaC2g+Can9/UtGlZhZAvTTbaW+LIObaW4QCOj3AluNyJsGokeMDILC1h
	tG5QQS2N1esUuf1Oiz8HU1Q+uZlZQK6jDetb+R0z4YTuzJ29uBmLvuYu4JVyuO43CJXM0gOXxs7
	MLPuIgxmVtUPVfjW2qhoOsILKG95rOmTK1SN+fpg==
X-Received: by 2002:a05:7300:7494:b0:2a4:3594:72e3 with SMTP id 5a478bee46e88-2b6b3f2a8d7mr1242978eec.18.1768519956756;
        Thu, 15 Jan 2026 15:32:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b365564csm704078eec.27.2026.01.15.15.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 15:32:36 -0800 (PST)
Message-ID: <ae8d6ec3-8331-49dd-9880-2f8427994e6b@gmail.com>
Date: Thu, 15 Jan 2026 15:32:34 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260115164202.305475649@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 08:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
