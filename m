Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29911367F31
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 19:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786995127; cv=none; b=MMPC0o/4RbXpLERadDoXbw9bQ1F+aIKrrJXq8n/GtfKukPYaUE/xJocYWnpWAyNMzd+hPiHOtmI6oyFrmPxq7UZINzR4V7IVfESgTdS69s3chrbdqhAqDEKsq6W0rFSc/fOwfp3hvS6irT0RJl/nsi3Li9AKzeflsAL6k/zBWW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786995127; c=relaxed/simple;
	bh=oy8Pf03Xb3bKzV+tVAHn1SinHESgGLHQl0i4z6bB+PA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sD25ZN9ncctk9l/0nP36C9Xijidq/crBYmt+NIKDxn2ZjbuBZseEVzMJ2LqGgkUTLfPHJZbTntdzcSRefjHuAVJPlGviSmqhqPDfGyeyBpCfUJq8O7Zcn6VQ4akHISQ8vp6M6SxOvmwL2C09ecXIrorEbYV7bdXyJ+H6Hxq+tWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=etmxzBpL; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="etmxzBpL"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2caed617615so50745695ad.3
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 12:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786995125; x=1787599925; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1wBt9xLi/VKDutjFxVI3PLjtL7dpb/PtctWy5h6/1Kw=;
        b=etmxzBpLK5EiBcB+8GbzwBLO83F1TI5Tt/gH+XEZGZyLe/LUye2VLqiRgIaFiGVwFa
         1i704v4oPJFZ6N/rSqUzig+D2qfxe+L2oTPUMJQ7ofLU8tMXl0NfOXJnetN9e8B3EiUb
         PU5dsAsOvLdmzOE/a9G3H73557MjyOof7KSXBSI73F0jNIFocr8F3CwZ0rX1DZa1Oj8w
         YAz2LmfWuM8MoCa2bktn4Z2Q5AjMwTW0VEuMXZSDB244Dr3CBpN08wBx5RIQCXkiuX6i
         VSwRLxYFE4cctcagvUXie3fVqypYdCAw61Yxwn49Ux+8eRn6IXUCgyiwWukHWq/L72Mv
         k4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786995125; x=1787599925;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1wBt9xLi/VKDutjFxVI3PLjtL7dpb/PtctWy5h6/1Kw=;
        b=IIGmqir/byzFhxpeVvpe9J1SBS/BfoeP+bednfqanLoGi9YQeT2w+p3oTmOvGY6QzE
         ML7liv43gkOonqhzcOHHNwg6q98Dy5SZgLVcTuQZffxIGZS4hr1UxXgZvZbvieWoIJ06
         7fxYqd+1h3yvxitx4hy0q7J82YJ11Sn8WH5ctNoAETtX5ck4EUgQ2vG5Ek78r4pG7xDZ
         D/r33U6K5mLtf+JlFoXChGG6+2AZjMLwhY84wcii1jmgGxcDYB9L0pFKbeatHjyQAcbK
         P4AJlpbmRQfpMSPYbRxfa8fHENogmcGI+Ts8QkrNvutXoL2cCrrxMvYg/aL0WDpXiHB8
         3sfA==
X-Gm-Message-State: AOJu0YwD1RkkgOnM25MiP7r8++ga9KgxsqRMekXG6Gcs63Sock7rqnDx
	94j16NYpkj1rxQjrzR7UFywXrgpU+2nGT0l0ag+op3bN8EPd+EdZRBsl
X-Gm-Gg: AR+sD11Kx023MPaO6VPypX4+J+fEwyP08BcnXoVJgTzlTDORQPo1JgCjW/pos9fgS0Y
	rvZBXXsw6deA+ybEI8I6jbFnhtBLOZKFzbm2cNoRCBF4Z0/EAYFX1SvudZtQ+V1u4r+cLt1gXLJ
	OWJn1qGPU+xQ6O5NdbS5IpcO1UpVtzRN+U4fWE39irjWwbTm5rY7clTOfdW9yx175C/YVzggQ5Z
	brN4L4uHEbM0YnlvOl419l5VFYmSK0ZSCbQEYR35LSUyJLF08p+tMsUvTg9EoNiuG5oDG+Y5oYM
	ILllQaaOy6n9sfuCfNFIMKlRcOT9sVDTzCsvFSfZUfCabeFgt25GuO8mTynX4wZDktNr/VmAMlo
	JUGm+1c7R6WAXdBpWuG3g05teOvaOhoIxq9sfLTz024ru6ouBF6JT6LM4llE07uyLUxsQAkGVak
	CnbOR+Ahqe+W41Qotln2iTvWOM7+EYjZaUNfs4FxZz4mJFb8n+cmq0110ea1Da603HcaLQPsP6a
	Z8Di0Drni5MhPo=
X-Received: by 2002:a05:6a20:6f8a:b0:3bf:9b3d:61bb with SMTP id adf61e73a8af0-3cc71e5c82amr33662410637.16.1786995125386;
        Mon, 17 Aug 2026 12:32:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267c8972d2sm7469283eec.29.2026.08.17.12.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 12:32:04 -0700 (PDT)
Message-ID: <2e6b9933-0cd3-4eaa-ad0d-f1a71875e7bc@gmail.com>
Date: Mon, 17 Aug 2026 12:32:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/609] 6.1.183-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132543.039278408@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.183 release.
> There are 609 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.183-rc1.gz
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
