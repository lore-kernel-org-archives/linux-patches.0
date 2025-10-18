Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5654199FAC
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 00:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760747941; cv=none; b=NHGKiSRQInOtRYxLRqXNxS4nbt5xJqCTvPC+0GLzbhZIPHAYBqVBMUrdgyVNwVuHNynQuAKVbuTxbfHryToIrELponLEjNxCzzewu+JMww7PbwERhoz5+LAoaUOWyO3fCtDRRB5VyfKhAf0XFZcXrX8Z6YLxqCmRrGT+Uc9XaHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760747941; c=relaxed/simple;
	bh=TfkrOdViFaSEovMzB0nSzeBVuPcuZ5Q4h4pTegO9HiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EiPMNrYhrGh0T3RJA+D87vMHL+v8OX/2HQ5oLbtjzUJYSULdvBA1BOSbvWwx4xq5cJzIFwEegzrUKJ92SZ42X4z2MCYcrBvybOC8QmWs7OosRdrc4vdqhkJen4O3Slb8I0zWaX3sMc5XpnUvE/HBos+WnEql8/PSSXO7/Fm8eys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GISOKvbF; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GISOKvbF"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-430d06546d3so4060305ab.3
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 17:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760747937; x=1761352737; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f6Kl7ZV/gVS/yfGRDqrKMc7VJq5dimqOMeIoI+yFLws=;
        b=GISOKvbFTwxixmMahVPhtUG1OqTBE6wxgGLKN+52X1pLlu5iEuwroI9GRDXmDOhaUx
         sRqb5VB+Y4GARp4QdmLLbqLVcII+15RG1J8NA7zDEEQqlVDrkkMmQySkUWSy+5nMaqMM
         jKILsNNji8RNTIq7ymi/E+v4TWjNvNECcSV9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760747937; x=1761352737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f6Kl7ZV/gVS/yfGRDqrKMc7VJq5dimqOMeIoI+yFLws=;
        b=utOaDbD84Rz3GnBHyZc4gMfbhKlqvb48M+YmDrmkUw+W5a3NEEkVfU3NzLhdlOXnD3
         0VqVhz2batSUQKge7i5tG35t05g1FO211AHcc/UsDcBq0Zf48dlXWg7F0aH36s4sYxON
         U5LcW042rxmrBcMaJYEiONJ2dwCO6oKn9MmsYOv/hWm0vsxOOu1VKeT3/mt5+L1J+dsA
         2YTLvpVwz3xByIa3TS7FJCqtSEVFGzb5wZYRDmgbjgDeCsVHr57fE3TZ4fVvSi2BajwT
         9i35a23MmnEZwo7KGWG09tci1yuNUfKwf404eZYOvQwRa2gKwH7qxKf1yMy/9jQChJQk
         DZtA==
X-Gm-Message-State: AOJu0Yx8KKjopMj1QcNYYGNKX2OENcbjgoagw4/hHQe8MIWVZQAK39ZU
	7sioxPfUJX00LG/fIE+Jy9nT21IQfwe8TO6LDafy5ovxgWAf9a5Ay3Brvn5JkEyx2Q+Ysc3ZPJB
	2T6q6
X-Gm-Gg: ASbGncspP81aeUJK8DOCFB3oN01hJPhhjQvXxVcPAdgmvdfGCGmm6jQLLLg2ujkVdf1
	OY8gT/znyK27IyBWoUWHL003JaMDlHIdvA48w42b92+cvuCa25F9GdGFYKkJe9WGrNA0Z44NuyA
	rt6NqZZYJrDKhMK+q85xq7rji5mD7AflwvIxbsYBUw5XkBUSAcNAXQNjmT0LD7AyOLcejZuZaQF
	E5Q0SdDQDU6KQDG2cWQAwnA1O7DpaUO8uMVCEn8X5XzQDuD/qL3Xlpw0Y2nGdLi29jyA7W1UVRU
	nmmUDTVAkrYyl40506GwBvc64WiasVjeuv0fgXNOFBE9FPStARF8YCmUpOiSj5moHS3OYQXgBLD
	+Hc7iPXbqzHEYlIZ/FcWefR0o9jbFjs19BfzO5Pflah4bJkkpetD4gsTadkkBzSdLTMSOmG0OSd
	F88BQFUkoJe3eLNnpK14F/6Xg=
X-Google-Smtp-Source: AGHT+IFQ1arpM4XiIHOzegBMIippzM4fh8WNlEEgxxDEdrMw5sQl3E/rQ4YiBNkwMyu4gNlwkvHgmw==
X-Received: by 2002:a05:6e02:3e06:b0:430:9f96:23c7 with SMTP id e9e14a558f8ab-430c524fcd9mr83643375ab.4.1760747937361;
        Fri, 17 Oct 2025 17:38:57 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d07b3eccsm5151775ab.28.2025.10.17.17.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 17:38:56 -0700 (PDT)
Message-ID: <95598231-ae6a-4a0a-8697-7ff273b6124e@linuxfoundation.org>
Date: Fri, 17 Oct 2025 18:38:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/168] 6.1.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 08:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.157 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.157-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
