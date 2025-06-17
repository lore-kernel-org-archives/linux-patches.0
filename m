Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D472EA16C
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177908; cv=none; b=UebebIs8bK80zBLJ/V/A/IGQZZLB2NlTAEsnrOBa2uK+llYlytEketRwPQOCUscSCwoefLo7yfVrL1f7H5XB4CiAfQmUbI11JxEIYZdOF9nVSV3ZI8KfEfwD4E/QUFasyJ3dtUkSxdgQuFeX/nk9mBI88GFRzh87J6rQA7xoM0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177908; c=relaxed/simple;
	bh=dkKZ72afcw6YlMGevnUXEdoK4heTyOjoh5qic9k/T+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e0kABNubHw3nK91UdfwUV029ocknIlJbRTsPnljK1ct3FnclJCKUarBrtEEvJy+xtN0r5wSkPdtGx1ERGeFb1BXMrRdGl0PkC8MTb/GmgU9GI9G3/MnN7B8F/T+LX7jZDf5qhSKZ0tW+oMIH5eAeMC1MYAsnKmXZvHYXO+PSfqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLzzp+ql; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLzzp+ql"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b2fd091f826so4382240a12.1
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 09:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750177906; x=1750782706; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qEy8ITm8kZbY094KyaBllE3KCXj9q9J+tbpb00m7Skw=;
        b=KLzzp+qlHP2CHUbvCx0L0bLC7HbrSfcJyq3GH4aIeJnlJmzl9pH1SKIjWkp8iPMKz7
         0v/XgPbE/cCFbe1CLx/gKHYVS/B9AJx9eUsDBLDmi0AXD6ikWqAyMQFwQircnkSbCaJo
         7atvOYzjO/YD2TB6Llsm4TlHQGf8yolNEe+zn27rv/8MpY46zr1Vq5um5E9jM8TEk28C
         bO9N9Lbei1OWDK0k+nveU/S/DBLM1RLL4X8s4nX+UqPhDhPcjXjZCCbI2+6777KValY8
         j+w4VoEaPckO75UEFwnVsGMXtNW3Vn0RaNrylWgQiwouKxQCaeCx5BO27ICQOkO710Jp
         AEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750177906; x=1750782706;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEy8ITm8kZbY094KyaBllE3KCXj9q9J+tbpb00m7Skw=;
        b=iasnLiCMPoXl8a4li8PT3dEVIJwDE6Zx4kLLiMCDeEZmlRrGGuTCxRMczwVa7av8az
         G8cnVJgyZpN9MB/ImI/p5ANRTC5L4sSuwMCpN2FHyne3O9km1JOJSpT+uJLYE1VsKdIf
         2jvlfFXMB87Bg2R1yYCzKLmNLobTiYhzFtwBfpXVwpc0h9pKX/mw70mlpShCIhZBKq74
         Jj5yt/HIYTHYGMBEKkfvvEfRIuEoCaMntf6v4tHMC16g4Na0BkONwMPyf7CdbAy4oV/3
         PRWIpkqSs4Da530GiSYBHL1lfjgfvQ5fdjXKDbzFHZ8ZuVXx3IP9trmY2LYxdzkJ812C
         z2sQ==
X-Gm-Message-State: AOJu0YwIQ4H7lWwLcK5MnLZd4DPDLhcASZp3TRyunR+IudaiXaomx0EH
	Npy48spHMqbwB4X0569s5wqbJzOJaAonbfLFbliY1b3/tE9mTH9rdVjS
X-Gm-Gg: ASbGnctB/D2VP6o8Y2izP4PPhMVJIm5evLK8nWtbetXHULrcV904QD6FRghtLw++Gin
	V3U79lO5E4Lba77YKtwhC8iWrU7ZH6x0aMCwhZ7pHMGRJBlELdWsVUf9xWYLuq6VnJIWSbbwI5B
	cvDS+Qt2j+hQ+oosHZzvB1gKqnNoo1ybP4bJL66woDWNEMk/ODzNFiuU9Zuf7Zd16Ao//ZWNje6
	wScRkdnyDp3xKpfBmAobDInagqlA2Hn1AtuxGrpthDkNOpO8g/N6j6OMJiZ8i7biDCJT8iSt1QH
	7TK7rr9yYmYmeyjVpHcJarfi8crUNrbTDrKAUMEK/kUAE84TW56zlrhFKw7zFhPvowxUHBmf8YH
	aNs3+imm+zjI34Q==
X-Google-Smtp-Source: AGHT+IGBHXbhNJJLqivrzogQpY/UsXMQJIVKz0r40L6q9ynE4qBtKdw94Wxz249Ku8WVDPxw8YqbHQ==
X-Received: by 2002:a05:6a21:e8a:b0:21f:53e4:1919 with SMTP id adf61e73a8af0-21fbc62b6a1mr27074051637.3.1750177906251;
        Tue, 17 Jun 2025 09:31:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1639dffsm7709506a12.3.2025.06.17.09.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 09:31:44 -0700 (PDT)
Message-ID: <c6c2c573-de9d-41c8-b686-a98a737c2d48@gmail.com>
Date: Tue, 17 Jun 2025 09:31:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250617152338.212798615@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 08:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMTB using 32-bit and 64-bit kernels, build on BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
