Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278E219C560
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 20:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735592310; cv=none; b=qzyyONtNyeoXri9a3og6SYkoBZEk5lvLL/wZpiUNCTjlJEHJK3UlxhP2saF98OBb2vk7ldvl3aXEXIntYF60IiBlfGLyUyc2KI8R0bCHDHhnTL8vNR40jq8PMbE5RPPYK5u8SmxXFVo1t4kj7wKZ5ggA5dcqHZPMo3jNzIhnHgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735592310; c=relaxed/simple;
	bh=ex6QSwQEiZhlMX2qD0HPG9/IBK/NP6pU3E64l5rusB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hrLD3iICu0mnLeWtf5fJiGbeRm6buLvzevB8iBs+WwwOqPuqzUwordSwYnkN7i87tBHuzZ3OQTq24zPdP10sgfCYxKbSkeEZkZFannAVpoQzOgvTJjDfdPhRHcXqDlrcqJ1saxOX4rR9FWJBePL5RgXE9KFQZ3fp6X+CAwG1AJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtLJJ0Tm; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtLJJ0Tm"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844e9b83aaaso847119639f.3
        for <patches@lists.linux.dev>; Mon, 30 Dec 2024 12:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1735592306; x=1736197106; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tB+6W+IrBzBEAXEAXQiP1227h/crTkFPCfG7eT6ve+Y=;
        b=BtLJJ0Tmalm3CRikjkLzAfxpT755mp3OhKfMTT0TERkv7176PW0LZO8VXc+Wb1WpZh
         RBiDZ6pjOg63aIAu18Ro4pR2pI+zCv9TI7hZONmsaWgiy9wvd1a1DppIZt6HvFWZLCqM
         KJgr0dehlS+GuaEnRHmVt8kApWvHPv277YEgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735592306; x=1736197106;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tB+6W+IrBzBEAXEAXQiP1227h/crTkFPCfG7eT6ve+Y=;
        b=iVktEz3NnjxZpxvvDW6trnhSflvxVJZKZ/6f63VtvN8vfhmLD+hQesXJ5xWULT9pTN
         vYqOtAx7o7twU/wN5F7684EPlgdtoRoCBi10np1a/RWi/L9SftcXqFEIQSHNrO2pp3AW
         C6O1mdozXFYaJxWuAAYLpwBTwnQK21cqV52AUpuzcPRb71vJAclwOYjrSOZKhf7k1ooZ
         w2srBp5qaisz32TirCF3PeNDf5TaT7nhPkz0cl6btKg9XecbZhGAj2olqWLuOjEHElN/
         4JWqpXUcE882YMqcC9/CRCefunb8mIs1wdQTKIBsgFdqmdWk/HbpGnBTHjpMg9kMlAry
         s1VQ==
X-Gm-Message-State: AOJu0YzTTU7HbmWA61Ow+N3ziRelfE6qLP3R2or75VYE00H8so9mxmvN
	ZJP5sULPdQHFB/mIBEBCHVNkuAtEX4nztOqghOCquyelXpmteKRR7Fd73nkwOWg=
X-Gm-Gg: ASbGncvpbd9aChkgbglkJMNAkuLyVnbkudi0slNZvybKyuY9Ckep5RbVrlyp9Iz2YX7
	gR1uc0HIJm0SpBwyEvi6HDC6RF6ykRtIUcpkoUWK6WF5aVH9ObNMRG+l83pGFHrNLEAk/jnsIaF
	etV8WZlZl4JkMfQnvfkgWDT8dMugvhm9PgGiT5S6oZ06mRpkBjCrMELBlHJMpQvDA9Djl5dTyTU
	UuxAmb8q4njC4/7TVjIZboMjqXZEp2PYqZgiF9nx5122w9TjCuOhPYViNiY/duoTtBD
X-Google-Smtp-Source: AGHT+IGcdhrTKCB8H/gwZPtz0/Ahdr965oKRBKC5oj59c1LYlrh8O9OqYHusymm72e8baxgoyc5gNg==
X-Received: by 2002:a05:6602:3688:b0:849:a439:a276 with SMTP id ca18e2360f4ac-849a439aac6mr3654562139f.14.1735592306246;
        Mon, 30 Dec 2024 12:58:26 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf80630sm5519655173.76.2024.12.30.12.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 12:58:25 -0800 (PST)
Message-ID: <7889c1c1-e9c7-40af-8771-5bdc7636d455@linuxfoundation.org>
Date: Mon, 30 Dec 2024 13:58:24 -0700
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
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/24 08:42, Greg Kroah-Hartman wrote:
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
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
