Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1685E2F547F
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685136; cv=none; b=IjJge/x2rF27Uw+MsQuIIFiMZ7JTAZIYwF9WNnmahhkecyrnFfgCqNaNjdrEvYvdpWkvYEhlhTGUEVLIB9Hg7yaYXjAWERXN/5OQTxhJU78EIHjK89yfqH8cyaXoEF10yDftkF069JTMdYsnwcEs2Nao2lMULifIQDEwY2lZMaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685136; c=relaxed/simple;
	bh=iP6JTEZBLF+70HcemQ1GufE3WwClNLEat4r+78V/zjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=plkrbKrLbaBtnjDuITNUg1lKdEejljppmkeZxfkiVULyFkDO5/kXOuMu7OcV+5hwbu+k6HLW+2b3cFAn/JDBZM+w0W1bizfDInEX+MARfkl9Ezk8DeMYCFB7QJI8kjVnnChCIerZuy5ra+kp42UXAnQgW1u2OUILOr0gQA+M4T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GCEr9p0X; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCEr9p0X"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab58720d04so1392671cf.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752685130; x=1753289930; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kNK3kjQTEgT+WTYqCLEzmN18nhM0bQJWt1l3l5/y6bw=;
        b=GCEr9p0XQ40I5W5gy10yrarVN7n9EuNIOEAiwIU8rifqoLZJIl5Q9z+w43ml2l5irf
         4taovpOtzVD6goqKKJ3QzFQBC4E4fpHjqXNtqF3u+ncDixM6H4lSNYmvLT4bSW7g3dXP
         xI7+yjD8r7oWwUmYN9WgDPOYXIEPGr7776LQroDcIibCElPQX00T67leE6gvAEECypCE
         FP7JUoH6JPfSZ/2IuMVfV55GAUzeQTfcUvZAZUhespxGrQz4mp3g4qEldv/Bqg+3/bEZ
         +YKerE4xVIr+I79KgBL3MNg/3+p8/zKnbFKepxUgJNSBuz2NUnSWGjFjLkxhNQFXgMjj
         NNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752685130; x=1753289930;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNK3kjQTEgT+WTYqCLEzmN18nhM0bQJWt1l3l5/y6bw=;
        b=sVOxCY4Bx1VTMTTShD23zPj8yw+iS07MnYXOEsrdRmQw1NCdmfjladt24C2S83ot70
         vqBayFzY/DOHtTC6MuLX0g15db2/ktXrjI+sF03G1yDhINFW94jMOjidUPs3RdhTYCPD
         x0sIE99ULx1IX8lZBZ47QgHgmPdHpDnYg452wen67byBLkj9JdvL1hcNzibT4Z7Kpe9H
         mqWcw1r1+FofOo/OlyD97nmhtdyYEgMKDFdKFufabLpRDTjLnbUyFVIVZko31CbO1FYA
         b0jGeIqHBFncxdnqKy5s1L/W6yfzz8ptccd/Jy4+P1DgYiuVY+bT+58yYbo37oBlLZcQ
         2Ckg==
X-Gm-Message-State: AOJu0Yw5LvW9fFHLCQS9wH+vLvwN25iI3xGcKHhPTXP64EvqcOQ3wLg3
	As3QdoH9EEXrAFd5TWjKMWZ0DWmze1L1ZH7yhl/+AM6rQfposIxPLw5p
X-Gm-Gg: ASbGncshL2cIJDyN+32GX4gsj+vYqFzeRIGalRJjYjUkNTLNOP7yZDOXL/MUEcQmc1G
	VHb5IhjtNi8IUaPdkfUmgr9WW/nLNFkMTKYG82eLgwJ4wVI2XBhpgOwcmsy19SXIK/id6xddGiB
	A/CzWM6naCGia/7RArbKiRFYUPgDUDweT4sLVXprKr3HlSCDESwy2dhISxK6CJQ2GTAoTQd5zEe
	MomW00sqc6YONrYQQCBlNWnLdN1WubZSDR57kzT+5x4O0DGmS0R9iJYAOhY0wlZua9WX8v3yPiB
	aoGsHpnSq0D4TR64zz+0Zs2bSfm7bMHcDetiCzSxfeQ066lRVnqIy6+fRUEgJ0cCvzdhUjcEfVn
	QSfB2lEsaxuQY3e3svBTsfcM7x3dYooenkfF93zhybY7oZkEY4A==
X-Google-Smtp-Source: AGHT+IEwkI9+9yXOsyKNH0nezJp0ZgD3k5h6KOcI2B6jChy0Xl7/JmD697iNa5itSdPpBUh2baIYLg==
X-Received: by 2002:a05:622a:1997:b0:4a5:98c2:34b9 with SMTP id d75a77b69052e-4ab93d8dfdcmr48569031cf.34.1752685129732;
        Wed, 16 Jul 2025 09:58:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ab5da31391sm43620321cf.23.2025.07.16.09.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:58:49 -0700 (PDT)
Message-ID: <76e3ac74-eaf1-41e7-916c-d6127901eb0d@gmail.com>
Date: Wed, 16 Jul 2025 09:58:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715163541.635746149@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 09:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.146-rc2.gz
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
