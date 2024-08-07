Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8E77F1B
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 21:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723067295; cv=none; b=dqKKb1Y+jdiLS2B4Hh157JWU0rD8QKLyIQRROj/zk0ezb9t01M7VnhKBj9G+4b45sZQ1FRd+nD8UTjRLanreFI2eyJi+wy5bOaUAPSkLDQqqbPYsgevC0yqtPUwixSXyYKRLI+rc/dR4rPl7Hi97zqr0qbqJL3e4jG91InkNVb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723067295; c=relaxed/simple;
	bh=ikHrDHxrIlxO7Av4gQzjNSiQgY/ZMnBK+K+bWKNpGEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z5I1KaSVFWACnHlvUIP4l/TbFkUge/JbmneGnzm4zqYVd92/HEYTx/hwpq9I7eMkNOnlOI/guz1VqqQiQyq8ZCkW8elXM7j92nHgm9wwP/Nj7n8XksAIB1/2re9Uc7wfdrtB2hCNDT5pnHIj8YzTfppiKDzublyrrl8btopngoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXr6XPHW; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXr6XPHW"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-6e7e23b42c3so271865a12.1
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 14:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723067292; x=1723672092; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zwnAvupY4s0tGUxoV29OC1pw14aRUUNlkJE3yq1W4l4=;
        b=SXr6XPHWdYye6PNiBVsmbeX+QnDzZHFSEXzI0eNJsGSfL87XoycXArZdA3W0WyLwoi
         Cb4IMUe9kHIdiaBvMh3OW0cxgwhNejnLCwfIMezyhbm0WjQTd9VTxKzo0pJ73VS1ljn3
         djH1rMg44PDXpVvezMxBfiFydsMrD47A88NExcIUxC9u2Hb2VEly/JUCge2QAR+LFLAy
         3hdLH+nR7tXzhwBIn8/61aJRSJicUwOwRZiyuVbwc5n8T4hyf4h7l2IRW5VKpb8klWRi
         cbgfz6N3QVMYTqRdl/yTbxaqJXh4splhNchIY3PoWxkpk5DZvMUKACC/mwrVk3iFh4dl
         0v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723067292; x=1723672092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwnAvupY4s0tGUxoV29OC1pw14aRUUNlkJE3yq1W4l4=;
        b=GOlov7+Sb/W/ehEo7STDYr6GncHHjmUdX08pCUMKMe4IFqfM7KRavWE0QP3rNn5lSy
         DEeesfbltvPF2v79wGDuWsEAbzEUVUPLFdRbmLeqQDZyr3XBDlvyYH8aJQRAmattYEz2
         O3YNEi9Ko0hxn3EZ6bKrtzAPhIdMMb2r34nSCxqIBfvH4M3V1nR9cBY/gPU6fusqByBY
         28ML07Cq5l2mzk6vxXQGEFsAM3UIptxg34Tn9dUPp1onn143bYW8tg4Z4QnMAqnzLVTq
         mUv+q8IyFPEy4KWBNACuXB8nkBykY1OsHWEcUXFIwiPeiGLe59JTIOLJ6CdIxSXKAy4+
         P+aQ==
X-Gm-Message-State: AOJu0YwU6hgXJhWfbe9XnWoxIvHjrfskd0JBRRQzKB9u1a4EC5+nmOjX
	FQnuOLLGvyACr16Q2NfDgWiFjd2kYUbAU6FhuvtipTSIlel0ra66
X-Google-Smtp-Source: AGHT+IGw6duZP0Dlz2YBvISY62DQJZX6EzKf/9DR6v+6hasCmSzLdLX1MaagaF6MVIhiK1G/LlhQYQ==
X-Received: by 2002:a17:90a:16c2:b0:2c9:67f5:3fae with SMTP id 98e67ed59e1d1-2cff952cffemr18586049a91.28.1723067291659;
        Wed, 07 Aug 2024 14:48:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2d1b3ab3baesm2096565a91.15.2024.08.07.14.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Aug 2024 14:48:11 -0700 (PDT)
Message-ID: <fd6a7f02-7ef7-4b91-bacb-1129049b0343@gmail.com>
Date: Wed, 7 Aug 2024 14:48:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240807150020.790615758@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 07:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

