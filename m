Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B262121930B
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757350705; cv=none; b=PKSpKwg9kt4sSwDg1j+s8NN5cfDZaRPm3wbN110H1P/dtu/DKu5Dck/djVLJqX37401iIgm6bZigsOPdSsl5V7gKodXCXV7HfhsUAt+czZFot1ryjZ9eTVStoPxv7E2vMvQ00lHB0cQk6o3Q0RG9ejIit5KIKXPbJPjTCSeGCII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757350705; c=relaxed/simple;
	bh=Y1rChX9DxLW70YkldiYMb4Lie70kMNo9Ol1isUhql9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQMPK9R7i1jBp+RpGl9LYANdtbFJvNFwhVTE6ag9ef4s6c0AGhLpY2TKAn8L13s1mF/inlT0ulHInS9x4klkfDfmneEEDou71ImWR1YUCNey9lC55VgIYbzRx/fa2LHZZzv+3XDyTT05yxth/IOglrZ6zhDEBHBVHnkbCaYbh54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gbi75hk3; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gbi75hk3"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-73f29c5a4abso21402936d6.2
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 09:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757350702; x=1757955502; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2mfVZ2OHIGggTmY0sxP5FH9aCSOjCFLQ5dvaKvSRES0=;
        b=Gbi75hk3P89fL5Q+vqBqQ5g5/+RG+0SPZfS/DmAONaSsMJuflg+RwCNA6uv27txx7F
         +HA/0Qg7gWuQdCyjWvzQSDMI//8GR4c61RdxcpsZc8FnVdLgVaXlqYcOXpOpuL4BJKBG
         /3goj8bI65VM0fn/gNrKJXwdYlXjCn3aTjS+K22g0BsyLgJcJORwBkezpLCMycWjfXrt
         kjdDA3Lzif2PIKaTsu8glsFdl9QED4SqDMvU32o/Hc5m9+w44AwOmMxKoTlqvFn+ro6i
         2fPM6hIj5+WLidhxi/+53WCy4oWUYSrRV+JJx97L/pagzTlsA2xhO6xE6STvnJCoKHWb
         TePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757350702; x=1757955502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mfVZ2OHIGggTmY0sxP5FH9aCSOjCFLQ5dvaKvSRES0=;
        b=QJUpHQLhIzC/Lk7hlvrvQ0LmRD1w0LNd5DuJ9Q+/xWx7a5gaP00ed1+bu18uuGyQll
         24kAfd5iddJGuoWhO0Nc+Y+y6JLT1TA0NyX0TbrKQX4SIUOJTC3vXZTnfHs2coISXm6W
         6f2w6r1ZdPSvl18N733YQ4wu3sckvmAwejRw7eXMTtY/WLnrnw1qMHfzCE4qrkJQEqNb
         d5gc0vMx7KOe9jJdJSCXuhHyOTmjtv4EVYvYQhe4nzT+0m224jyJ8/z7wfdmz28zk2ML
         HvfJhhBGd77sWPmppl17XG0cW0YZSOFuw7EQuQoM/i8tJFNQwlTTeDVcDIqGb4w+CufD
         hhcQ==
X-Gm-Message-State: AOJu0Yxs8YSHUhom/I14cLG2KusDgDBb6laeH330oxU/4KKMUy5oA1Tn
	vZ+kFWge7jslewgAkARUSzW0r+XyFLNRjchOOwMt7dP2CltSGSDMChfs
X-Gm-Gg: ASbGnct/g+oEdNWAuVt5xtTX1c9olaI0jGBiLpiJv+aoVKD11EgUS7OvxXvjOibkJf7
	0oYizVDmqZYYZu5AXsyS0UwWMIwcuE7UDBsT3N8P2L5cxJMgTP9ny8ShEI4HX2J5mJs1PjUgqtf
	HKpzedTJyeIQoO4JMQzMem/QX0Ev592rlYISndoeoW3wtotR9+5PEjOALvd+7BcL949N+ZcG934
	L/krm8PvjDJE1yv0+MrrETrfpQGqQSork3MZoY3PVlNMp4KmDTYfAHYpVV4LlkY+dt8PSgeNmQB
	9JNP0gBcU3o5D2VA8BHk8nShd54NrYd31twFh+NtP4rwBIeOKiEFrJalpSMu1IU08QVUbGPwDFA
	Ei5GaLcxowcEJww0dKB1hBW0eIL7DGl5sX0HBMS4Mt56zeXxoOHkzNWIp1Ew4
X-Google-Smtp-Source: AGHT+IHaWV5EzXjXAMApAFagSMo2wK+T2IfdiINcAZD168Q3w85cxtSZmzKBd4om+JspAP71S9DUYg==
X-Received: by 2002:a05:6214:f2d:b0:70d:b2cb:d015 with SMTP id 6a1803df08f44-739453b4d70mr99445986d6.67.1757350702354;
        Mon, 08 Sep 2025 09:58:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720ae045ef6sm124696636d6.31.2025.09.08.09.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 09:58:21 -0700 (PDT)
Message-ID: <7c162049-7dc3-4078-92ff-b5f409d7a7ed@gmail.com>
Date: Mon, 8 Sep 2025 09:58:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.1 000/101] 6.1.151-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250908151840.509077218@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250908151840.509077218@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 09:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Sep 2025 15:18:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc2.gz
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
