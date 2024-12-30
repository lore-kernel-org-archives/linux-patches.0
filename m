Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0593219DFAB
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 17:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735581124; cv=none; b=IS34MW10mCSKXknrL7uB6QCqoE2RcVERCflay18wvHEK8EtoQTPzihI6xw5ipn2f7+Sv8CBb3KIHXGxVPKoCblHlbinwtYYvAf/jPjTTqaIuO7RPc82SIqF+c2cTJbHvyKVOePPW41tJqGtmcSHnnYeCFikOw4E0MAQQ+rD38Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735581124; c=relaxed/simple;
	bh=HIhOlTdMGVlskCBikR4qRKesMCFZR98N2pPB+yB/2cM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hmibGpD2MwuSBCddb6fNXioJ4w21/sle1C4NOpSxTeNJiSDogWdkFqoUHUHGXBofvqlQFdBi/ZGYEY8fgHhVFkkTWnmpX0pB6gjeB513OzjmSxSh/HwnWfcsOv1q5NkVUiCoKUaaPZK7mZsKVAWNnM3P7IvsXZdJuo4VXTGXt78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=il+SYOQl; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="il+SYOQl"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-467838e75ffso113187191cf.3
        for <patches@lists.linux.dev>; Mon, 30 Dec 2024 09:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735581122; x=1736185922; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IYSd9A7AF3xQpqmlOyuSY8eMHWA0vaOmsSMGJUj6h/Q=;
        b=il+SYOQloI/T9sVND2Sefs0h4pxLHqcDdiIaUVKfthY7hM6yUJ8sG69H1QfraqWeaF
         PLcF/SXz0ZKd6FS4hD1ygQ8Y2/B0CIKg2WYQbC6fN8VWdcOasrJ1Zr3Vj8sq7BTKyetw
         sFyU/67AH9MjY4p+4mNAoBc0btFRLN8C18x2uNIPFhz6EGMi/m5WlUfj2q1q/XK8pJl+
         zlKtcOoNUn3WUUVugs9jgpYde0ji62ClyQcJ29aHdgCHJt4ASebfpcxRHWB3k8eVoGfc
         oj/AQmdQMi7omAaytrekv6uUuJR+fBUV/9+859fn4d9Si0GA1ZXo6a78NwUtRWIv9qLv
         uDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735581122; x=1736185922;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYSd9A7AF3xQpqmlOyuSY8eMHWA0vaOmsSMGJUj6h/Q=;
        b=BRdsPLlyMrDBFhugDczn8BBK2ZKXJnHSIsfebkoEAYfsDzDv9xWCATkR6lGGI4sz6I
         kqg+ky9bxAbNQRgtnPmenPfU8bUJsYR/DBD8rF2aeLdzKjxDMBvFe+jJ7rKhAijSTkA2
         DC21ZjJdl7WY4yj0x52EVD+7pF/eAqCuzU/v3kgAJCh+Awzma1frtg5uKXDH6eVVshDF
         zP+Ccp6V6O1H2U9P50+QMJRBk5QtPBWQ3YE7cg9ZlYFFJJIB9YQI2OL/FipqM1z2UKd3
         A2tgSsktrM9ey/XuXTALK/zO38OlOoopNkch/hw4JqRveiUzym4887+u9fLefi2/me78
         Dg9Q==
X-Gm-Message-State: AOJu0Yws9ge639aBaHzY5ceXi6znh+KBNPZnh7iAkke4HRboeYW9nwnT
	kF8qGZnMyH3AfVddGsuQfS8W7O6SbLbT/tkqPZhzo8O94xBbHF8f
X-Gm-Gg: ASbGncsUXWcUTX9MndZ2VNgAodgqBmPVjzEvyPbTdr8siko18F1bbGYB8eQMz/lc8XI
	ecIUwg0mBEP83luHR/spxJccYDsbo7vqoQMe0633id0F+xCJkZRpSZW9y1PdZ4UVmEKC73J1wza
	wdBe7bqY1EK6GtYm3rgBNCMhy0VQaY3GPEyK7W4LPPtz05KUQX2VSRYdIaAURmSoblfxuGysqP1
	F4ud71GH/XgEIRickiyi2oCLccxd5YTyHOc8MPuiLcDxKYYOMFsQ6uRefRDnA4GRD1IOmUbMQCW
	taHwkF+b
X-Google-Smtp-Source: AGHT+IFHCp+Gz629eJ4WSSf954j66vHSHiT7HV15E5avPD/rA/NBaRA0H5e4/BtJZjRKBCEXUboVYA==
X-Received: by 2002:ac8:59d3:0:b0:466:b122:5143 with SMTP id d75a77b69052e-46a4a8cc456mr554241721cf.16.1735581121844;
        Mon, 30 Dec 2024 09:52:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46a3e64cb04sm107513581cf.8.2024.12.30.09.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 09:52:01 -0800 (PST)
Message-ID: <7b5e04ea-9ccf-45bb-b3e1-51a0fae633c2@gmail.com>
Date: Mon, 30 Dec 2024 09:51:58 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/86] 6.6.69-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241230154211.711515682@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/24 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.69 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.69-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
