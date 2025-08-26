Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2A42E54B2
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756228810; cv=none; b=ZhEjv3CWKk+ij1nCLNpeE5RopF8oG23e3Ir0mey3gIHPmXUGuC/bZ3fbOvMDpPd52P9v7R1sWs3V9Z4DEUtCZODViMwFxtR0Lmwf5gReT9Q+gTnJKcKW/EWG5Rm/RyLzwoOBYQzkNAwmx3GI8BEyeIMHVxwHKO1Tw5UrcT59pxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756228810; c=relaxed/simple;
	bh=OneTPVvGf5CtKTfVmDcbn/EPX4wa9VHKlSdVCjaigTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tvn8J4mqmfKAzIfct0cpgPh0iUeE0VNxelPFlDzfJf81f136yZx0oP+r2lDb/NWs/r92CbxcXNSA0Fbbk7V0AtWOjxUvRKlkdFxkpsx+nBoghUgB0prviD/KTKw2hgHi4hjsTo7fqGw1Xf5zgxh4XqaQZipV1LXlz6GNoldWDck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y3eQMp4u; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3eQMp4u"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e87031ce70so398551685a.0
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 10:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756228808; x=1756833608; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JSKLhsuTTKWaNe2Iz7phwf88flDafRwaCX2Joa67Vn8=;
        b=Y3eQMp4usmvIv56lSrqRjwXRX/b9xPhsMJMNYm35uIRnK2UvjgUY1QDgolFCxAcK4B
         StwLhxFELLrGbJ02I/AJtwgS/I4BTMaYHGDQ0kcwVy1DBExDUsIiggNNjYm+wPoEskg7
         XZ+Eqp/SaReqFhwbt6mqA1L2Fh8zxUqJM/+W7VV43Ll/EJ7Fx5yd6M78eaxHgMZChOka
         JaKUnmajXMA2rnS0zVeks6si14IxbaGVjSwkMAS71xEvH9PesNEmTynZV6Mfmk9Af5pi
         wumapUcVrxiHdBuG6qOC1TTsG/AQrgYBws8A6/VaHthHhGegGghCHHYQZJepvU1wtmA0
         fUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756228808; x=1756833608;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSKLhsuTTKWaNe2Iz7phwf88flDafRwaCX2Joa67Vn8=;
        b=jJ5iOiwhsYnU+tcyqzYvc0D5JHG4UJLn2rH6+CTPqZaxADGjyF5u/q2kpe+c8Evthy
         /PXHkKcKrBUsCcbtlAnhf1LBH+S7B3YXLYA58vGBgmDlUUkG6xY35pbTY5G4gP5Ajf1a
         Dkj2kmfQmfsJilIwZ5p5+lpWX6a82C9oRA27EynRkvSxFW3PZPQ9vMCPk+Pjcgs6Ie5p
         IML90LWuE0bVbxMLTZLLu9LC3ZoipQ59Q9JFwsVSCJllsU/46kH99cE6NK1kF+NOUWUj
         vDgtFSPurL2rJNrCzy75GMT7MdM7ZANrLqauT0RuKxs3bLuShjk9UpxfdG15vo0xaSxs
         xKqQ==
X-Gm-Message-State: AOJu0YzXDgvjUx1LD2ghMA8rq8nWo6jladcUpgHWnuBMIqhAE7oQCnw2
	0MtX/O/bUSwSj/VfsX+YBRS48bZzwbPmQrwOg1N7jWcxkYaA3qodujmlZa3Dzg==
X-Gm-Gg: ASbGncuSM9xcg94UJuncWYjdS2EzifdWx68Dp9ynk1UrD9q0kZKKZwVBdWAyJt3G7Na
	fJ6AUjNWFSiqJJnUxf2r2al1LuJhkC7olPPJeacX+iWKEMjcbSYJ3H6Bc1PPPL43Rjga6VtgW7+
	sVbPCdQSXdshCW3SrVN9J23AdwOOL+1H3SuQpyyZwlUknEymilp3L4V9mJ/qEKvnHn0U+471vV1
	wnCxJHqER/a7BOdp/btTh/l086NQRbJvNJemWQadn3T4piVyNCraeIS6dpes/ivUsuLE/HFJxUj
	zXCvN9HEeYMQltKZrn2vfZvuufCi4n6LB4akPlaQpxAtDB/420loZwDQPop/i86tDPoY3he22ax
	Pao1TGvqXQ4frebn7cnwUl/FK5cAf9MjfOSWSeX9HBy8RIXKb/AehL69fHnBB
X-Google-Smtp-Source: AGHT+IExeNvwjRjJf0kFxGHZgI4IqJ8wYKpZjQFsHmzmUaPm5gzD5mD7E/3CGXYv/RyZ24Sn9V36HQ==
X-Received: by 2002:a05:620a:4305:b0:7e9:f81f:ceb4 with SMTP id af79cd13be357-7ea1108e2bfmr1670461685a.78.1756228807932;
        Tue, 26 Aug 2025 10:20:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da7283decsm68502276d6.41.2025.08.26.10.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 10:20:07 -0700 (PDT)
Message-ID: <fece2c26-4434-48db-9be8-42bd882c51e0@gmail.com>
Date: Tue, 26 Aug 2025 10:20:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/644] 5.15.190-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250826110946.507083938@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/25 04:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.190 release.
> There are 644 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.190-rc1.gz
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
