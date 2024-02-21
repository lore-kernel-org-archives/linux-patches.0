Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276FC12AAE0
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 23:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559171; cv=none; b=GjTa4o9iXeabhmfyRjtdSLpXgiVI6421VKHZCStQM0pBwfflmEsZARJuHrofahd7YcRR0U0atJW+faD9PTHalkgEC92+L+VjC9ToHoej3LnKtnNyG8dZSP7+QR/9hg4k1Zb86Be6w2haSMJUl65cgR2tzNv1s6WmDYw3YYI0/GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559171; c=relaxed/simple;
	bh=gt2zbHp09sQ4E0IXRMe5CLcXg4e6+9enng0YONTvvo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mf6s8dlTNZx4PuACyezYbjrzVd8GbWEJEoY8tkDqJPh5UFndR61nsRAhXIqIDOgT8GMFtMxriJf0BljrDH7Lah/I8Zjp6S37icR83HwerS0jJEBV7/k/v0mBxVL6k+hlyf1gCkGvsUTQDdX+oAewCJLV01JrqoCUFaQT4pxmO/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJZWxTOe; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJZWxTOe"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7c3d923f7cbso71278839f.0
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1708559167; x=1709163967; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SAKcgOx4dnAtWUXFdt+Zxs9fPqeZZy1uNdBw2DnFh8U=;
        b=GJZWxTOe8gz9kQaHKVlNzMSmqNYlQuvd8GQBVaxzWazwiNNG2E3wRyd7IaP4/KIRdZ
         duEaskey4VzwDgmthWoCK6MR0/BDZHFT4nq35MoeZkGhncUXWGdI6gNgdGpRVss8+mHP
         30Ki/mQEcfA2RrhdzMv19DwS1J99xKACCjJ9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708559167; x=1709163967;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAKcgOx4dnAtWUXFdt+Zxs9fPqeZZy1uNdBw2DnFh8U=;
        b=bkvdcYemY3vHqS/WMiahb/X5oHvHa3PYtmOWC0EsNHzIVSeftCuqA4oA+v5b0PxZNe
         4EXBavSxUaI2S8gw5W99oKemr2EBtYmJjyXC56+xoKcqCR82+IokrxiXE7NOYKEZrU2q
         /xJhOnyGuvWqddOXarOfLKHtbHK63UemZhImqOTKvEO5T7wD/IZ6kAgo9lXPx6GGLBSE
         OMjBKT33VdeSXgl57toePGUShpIyYDZZzvuqGax4TpQ8oWxrW//LUgzGPwJp2p8ICVzz
         7Z1NOuOLg/zacsLOB4OVzPwsecc2RTy1IRMFNaEvYbJAmj0C54LRorUvLjm9f7SqYGeS
         3OPw==
X-Gm-Message-State: AOJu0YyYQV3VNhXFqm92MAFb1mlBWkof3jiH/dFgJikt1YwYXWY33Rcb
	eKVUpysO97IrSaB1EbUVNCdiSGMiDSwOPoTw7XgCNaidV4DFx5ntDHEbqJ2dMQs=
X-Google-Smtp-Source: AGHT+IHUxQhgcp++EYtIQCs8Ay614fr69uXwCM/LhRP+kEK0r1PasMk0Q7ScDHW9tdbD2SQB9Lxj5g==
X-Received: by 2002:a05:6602:2545:b0:7c4:c985:145a with SMTP id cg5-20020a056602254500b007c4c985145amr835299iob.2.1708559167143;
        Wed, 21 Feb 2024 15:46:07 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id b14-20020a05663801ae00b00473fbb3eb4asm2936835jaq.105.2024.02.21.15.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 15:46:06 -0800 (PST)
Message-ID: <46cb9bb2-2af1-441e-9a99-44600c1ca33e@linuxfoundation.org>
Date: Wed, 21 Feb 2024 16:46:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/267] 5.4.269-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 06:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.269 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.269-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

