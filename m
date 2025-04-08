Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E79254867
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 20:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744144312; cv=none; b=tjhvV3PBFVP/2NOwxal6mi3Tn9kOJA5NPlLc8CjqXE6CZ9pHOG5utmz78vbCPSR1L2uXq3Vkwv74yAZAUqkaoAH7gU+5PUL2/XvKrJ9Cx8sCram/vcnaHnYk60VR2f3Af9wGHMjdnw/W4/WdNHgeTRlXOBl04hLmGRa+FUVI09g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744144312; c=relaxed/simple;
	bh=jcHHwYl04ttVXHaM95E/0bdlpnT2qWzZKbErWQGgHQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T23JtvmcAeuO2jcBkaLKHBI2vh4jbVkmDeWFuMQ7kj3VLj++9PeI2QHqwj/tGzlBoVbrTZNy0fLVjHjmvfpXssjzs3ux+M43WGCt9VYJv7Sbt6wvu3dqpNkqxf4jxtNE8dDRrKzbqQC5c/TQ0qSi4sdRU3IM6GI34E+2pSMu384=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBtZaZ4u; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBtZaZ4u"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-72c7336ed99so1811621a34.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 13:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744144309; x=1744749109; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ej+ETfMxy13xBpn6+4kyy/pRZQVyQrYQb0cU7d/VY0=;
        b=jBtZaZ4unJmzuQezw9xO8dodf7lhfSMT5GvFihw57Yz8lGLzH0SboO3BnwidSA5mqA
         oaNDTnkStqOh1CbaSQ8mfiKR5o74kRNqwzcJg09bB7kdYpSCJmOskz4SGoiB328M3bK+
         qJnPKLqxqhx37qqzpSBL4SW2snYB/0UFM2IqW2nlMcjr+bOmFmDtZYSsviGzEDttfE3R
         r+F2dBrpxJRkIXTeO3YcItgVejEtJx2ZucTL03/tkeu3EwmHCcoTHdpkTLsp21Abo0qO
         CM/XzCwRhc/6giu5xolbUsLRFoH6humn54AdCpZKrTDEvB+8blNFNunA1DTN3xAN7rGQ
         nAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744144309; x=1744749109;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Ej+ETfMxy13xBpn6+4kyy/pRZQVyQrYQb0cU7d/VY0=;
        b=u1jkW0Gn8GtGHFH0G+BA1olx7+0hhVfypplIwXRYjj1g+yjsHNOXMvQ1bs5jQ8JLeI
         SxLrSIODRV79r8cKiMf9NfUBKLdaU6e9c4TFjeKaXruGeYCUjskLutPmSgotCPuVspIP
         G/IElnTWev1htLd4SKdAjyRPpH+yPLzYy5CUMDU6+H/kDvcCVR41Xt6nYnpQtqs8Xt/8
         omwVlb/BmksnEYQLEwXhPXkiJdqN46I0MuOKxes7Ng2ePaJk2/IbwiVYr2EU/BwnP2P5
         hvXLDBIgz0UITZfpzAG6XFSGHwP54hl3weEZzB7kRUANfGBYxCbiYVQJEjeRVLN56x16
         ijPA==
X-Gm-Message-State: AOJu0YxWaQ8dxvChBvotIXMOnpPZ4tMQNweeTuc3Cq8zVb8yVQIjdwM0
	r5bLEi1X5UTducScflMrWCvOYTQPmJSmlNUUxM8fCRtvSzGleCX5
X-Gm-Gg: ASbGncslIwbLaiL2taBKj/VyPWnS9mVFVrQbmvoQUnnDaImha8zEWOWGKiihaI0rXzT
	qbkE9p2plozcq+QKXWM4bXiWT2ePdRuyrBNxFjakUYX2BQHsZf0O1uftrynxZ4/Aob13FlLz3kL
	9HMWDD4XX6lHMCxZCfQEVLVRaeq9Tzrni9ort8VFjIwYv0amMqvOkLJIkpGEDaSVBPmr0RQn3hE
	G/vZXfcqJW50R1zuwFzmLTRD6gbCSpfxTkDMhw1sOG1lRqz33x995G+vQa2/k8J0hibYudvaFji
	EyXp2zVmK4kY7C5t8WG1eU+sJjesGckrWNb+o4t50zEZHT6jcv7lOF3qzsiV52PfgxqZq6wF
X-Google-Smtp-Source: AGHT+IFfjcTZ+1ercJo5eWnRjDs56g87ASnazbppsCCX43zOu5mk0vhvzWBkxYl6OAOgIPlsZgiuhw==
X-Received: by 2002:a05:6830:3c81:b0:72b:8c4b:8ef2 with SMTP id 46e09a7af769-72e71bbcd28mr9208a34.24.1744144309258;
        Tue, 08 Apr 2025 13:31:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72e6515bf9fsm581546a34.6.2025.04.08.13.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 13:31:48 -0700 (PDT)
Message-ID: <ef68af5f-65ec-4fb1-9029-2eb12b4b23f3@gmail.com>
Date: Tue, 8 Apr 2025 13:31:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/154] 5.4.292-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408104815.295196624@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 03:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.292 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.292-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
