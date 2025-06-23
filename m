Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F0E1EB5F8
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 20:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750711798; cv=none; b=PEp8MOmh59Sdee+nHLT9aKrcDAK7E22jInhWsTBhKTl1QIkvxSOvImzaf0uFxXuuMsa+ci2wRw4wJBS/7rFur+YianMpW4Tw5gdjEsmU8/0E2cUwCeQ+KGJUelYCHZZrmaqrpBLNgVQ75af1SfLdZWAnWdPdFtf2p8vFEHVgYL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750711798; c=relaxed/simple;
	bh=hiRiP1mEeVcp0//Bh7jTxxu+orSUMoHruu9X+qCE/fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ssD4B8NTeqKXTqDcJviCmtCk2fLDBZht/Cq2g7Prk5QYokS3w4LTmXQCcsftojqR+qKfCRu5/RdfadE/6EVhgNoiDn3lqpZ9L+uvQ7lc/3XKr4UHMF/jCR24HrvgXJLQ9EoRvekhsSRFQWaLe3EuL3w5c8+8APxi7XahScCAVfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pt+NimNc; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pt+NimNc"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2353a2bc210so40498685ad.2
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 13:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750711796; x=1751316596; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=weXHogG41g/cWGKJLnZuTZtl70yy4s5IwHwPHS5+yNE=;
        b=Pt+NimNc1Zzz5NCsQT4LsgGNfHXpU+BxwB/cvmlMy/rv3LyrYPZrj/NMWJzB7OpIwP
         K8JdbmQKH5K028sF0l85W6MPAhrmwVmRkrHW8uMkeQxOkltNWY5UfzEx1t+d787/nPao
         KKYXA0aeMjhj2Tb2U+Uy7O9pz4y1AqnrPeIr10Pw/1Chnk13u9fLsuJwg5NahdFwxDpU
         urnf7fV8mYFPq2YQ9FQ4Za2AEuZsWH51Z9Mzco4nA0arcfIQG6AQ7O6AtIk1/T2tSMLY
         wZ4XYweAWPiXo8Sz5PKCT/8OSQ4ogoQ30IPEK6xDv+EDA/CiOZMrGCd73yyOEUvhGu7j
         V/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750711796; x=1751316596;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weXHogG41g/cWGKJLnZuTZtl70yy4s5IwHwPHS5+yNE=;
        b=pE1OSeEoU19CDwmLcxx6FCmr+3q8UHg0iacnh7PngpL55y2EoU5JqdcnDXz6lp40NP
         utPsbbh60t4fNVjNQTb6hzKF8lMLblZ9SejimlKkhiEB7QYzDj3uoKTb94jm095QCbO1
         gF7IVtmySX5aaNVr6qYVcYbMYkBCoR+17LSHaajhvDPXlqEctxGzM0tzS3JLqzyRFdvB
         ziESGMMIEyiHIfuIEoLkh0phOhjjybdd2Gw2LUTP7kLVRwCiXiHjo1zFLBs7uAv0o44C
         ZJIfs6m7wDNmdKrqQ9S9wz2Vd6YBsJeDUwmQHQRwdbmjp1SQo6FuUWxPzS7KsYqKCXrc
         WbEw==
X-Gm-Message-State: AOJu0YwEbm9MqnLCOGIgMcmZh44B0BoI+NZnXglHswjwtiMmdIc70tiG
	63mnXFQNNfBAqDS3THumRa/NwFL/IGnd+9rIDODLWRBZ5DPgEwENEVe9
X-Gm-Gg: ASbGncuvyvOJ8k95ku+OMObDXcbUvM9aXktgujILSg2JNyWIVum1TJpFhAVAJptfbxO
	xfWuLJrUoHmJMbhNTzgN+rYMDsKg93C6a5nG6HFGUusTRKL5X08zS22YgVMsqn0GhBurXA6e9pi
	6XlHa/PhAzgvIk9nO8bhaJw6tlArCFT2Ki7elIXU9/WNqhU5HOiF2xAX+AhgSsg1ny4pIgZ7+uX
	YUEWq9tZyp62wrgzoR+szLVdx2652ggJZhRyfvdCXK9fQtiaVQM9LOLtohqGy2H52kUmlMdFOkV
	Esoa/oX3cfHbbbullPV3dpVs5HywHNUBeQlW+4TfRKK5cpSIWfd8fOTHFGo7YScbpNH8JY9MtSD
	K8jDiiXsEYjxhAg==
X-Google-Smtp-Source: AGHT+IGgSkiqCgu3Tlo68vWVQORrqfMWSdM0S0CmW4fT8T2aHvF9owwjkeUL1/HhaX9k6yylZohtRA==
X-Received: by 2002:a17:902:ea0c:b0:234:a139:120d with SMTP id d9443c01a7336-237d9779b69mr206885575ad.7.1750711796573;
        Mon, 23 Jun 2025 13:49:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8673d1asm91970485ad.172.2025.06.23.13.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 13:49:56 -0700 (PDT)
Message-ID: <0413c7f8-d5fb-4b6d-a97b-cbabb61b87c3@gmail.com>
Date: Mon, 23 Jun 2025 13:49:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130632.993849527@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/25 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.186 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
