Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C6A1A267
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 19:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770666553; cv=none; b=If+J/iIAGErb+9AFovgYyl9ImjA+u7n9gFie/Q3LNCmRVV8zgQ5oHB5qZSBI0j6oPDenF2HfuUZMTrNlBi0dXmS6ckOqfxYmzJ6p6S6cczDOKRp/zgEWFd84BTLDAiEQzYde8Ox5GU9anwjMuC5fOu+SFpnrxncXUC/Nser13Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770666553; c=relaxed/simple;
	bh=CfvzO5xOG+hSOcnRJhf3SUQ/ZykvonJqJIogFnVT9I4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EMP8biLrOulu/22gLOqSvI2d/Qy4y1qn3NcuhIH9GANRRq9bkcmq5ancOLfobj7MC9BxjqmXV1c6TnhMBAdBeg+icYkvN0fp7ZCEMpxX/5u1u+w8WsvDQGisa8plBncptoBMXJhzqBedS6s29znx13hIRYaJhGRRT5lGn9TTb2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XtubVONN; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtubVONN"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b8675d4f93so1924691eec.0
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 11:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770666553; x=1771271353; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IMKxnn5tOlY3tJr0Nk+9Moa7pvSxgAQLlAon4I+K0f4=;
        b=XtubVONNTptaPuyVx9+pcTdLtte+ORPHfmC2L0Ue9l+IbpdTKR5oNQJILmEzR7KUSM
         7IuoxfnA53kiiQ9aiGy0jWtVWD6gkbwzUa+cIglo7lwjhW21DlpXDNMUQUL2Qli45W1g
         P/CE8+IIQnvppLa5n6F/Oy2mn2z5KD1V4uZ+Z8JIrYZZyv5u2PDHmGJmiFt3iqjPiOHw
         MQSHMlNcYezsKi1Arurq/+T3Bs61mYGwOQnMFigEvPNCO4Wum90mbjdJQH1kkulF4jDy
         XY+blHTM0ZP60en5oq43DN7h68szSPW03TulEYdT55jAu7B9H7R8PX9E+rNCcazLJi2n
         +VXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770666553; x=1771271353;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IMKxnn5tOlY3tJr0Nk+9Moa7pvSxgAQLlAon4I+K0f4=;
        b=j5z5BjPUNlSyMe6QlYURAuhhu1yCz2yP38BLhPhsWlo8sYz71TFfRQ/spxk//MucGc
         S370ePMXLf5hdk0um/Qp7NC5+dvBaY1RNF00uHp4eSshoe4tksa/45Cu9xNE/mdb05l0
         8B89HMd0CahH2UQua7K9Oz2b5Y20wYTp7ouS/i8Lpr6yp4AswEcgDGIUn4mvKC5IDwRe
         BiHTF0teKjv6egWzVSsbN3q2EG28e5gyKmvgj+mdaM/FPH1AGGOgEF3rq7H9cI2j1ETN
         Ue8Y3G5grfTMl0WIec9FjqnAkwBpDolhhQZo9waaubOmDTLCT28xguPITgDo+9b54oYl
         TS2Q==
X-Gm-Message-State: AOJu0Yyy/uOEJuMAjgZUuaPBM1s6cAAhtJ2d1Mitqd+lQSMPB/bbi4ae
	Jwn2GeQ2ekKVCL0pRhrE/AIp2YMGtPHpu4EDKmbR4Rn/ZapmQBih7edz
X-Gm-Gg: AZuq6aKuNktCPBMfkoA2sPAAaY+reNaPjMuKqS5jH7kFn58dv0By74vMeh+2a5hC5x4
	lq/ywnnpsE7nVVPSe2jM1EMrUJgYlFgioeXRBhPzFZxDSbnQn+MfQZHo1H23F0Im29IcILue9bi
	SMDq3MSXNgjXgIVRY8JHhY6vO2QLYvw+jYEYRYcK5xFQJw1eukBxdAhoA/Eo5+6VvefMxSSHXrd
	W9orAWZdbWEXvKfFIMZc7WAtd376oogq3Vm5QUGnTWw+B4TV5/T6ws7rQHldvHVerJZ5loH0+9S
	PRy2rvwF3Dra7lWd1g2WKaj2I/BcvQ3aI5CbKiz1g5VcI49i5e67lpgQDtWJSsYEsCXvCfwUdD6
	ufpDFesl+qSm50AXgUG2Gzk+8v3cJdROzrsRvDXP5VGOxntXHfJ8YsK2Rb9tOxbHJm+aX2vryRw
	6BdYPzR6Q2SFEO96WGt1vPgxZFdEcEjBUdaT3RdZe9w94/SUNTIVin
X-Received: by 2002:a05:7300:dc13:b0:2b7:d7b:61d7 with SMTP id 5a478bee46e88-2b85672bec2mr5936562eec.24.1770666552666;
        Mon, 09 Feb 2026 11:49:12 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b855c8a8f6sm8054245eec.32.2026.02.09.11.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 11:49:12 -0800 (PST)
Message-ID: <4d830483-fee5-497c-b4ef-c79a27d245fd@gmail.com>
Date: Mon, 9 Feb 2026 11:49:11 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260209142301.913348974@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/9/2026 6:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.163 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

