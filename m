Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF12940D
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 17:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722447609; cv=none; b=cxPSMbVHKUnRL1StJtrcGeJsAzZpaLz/TsOZ15fT3zclUtsqrxvfSJLdKCnWWM8K22ZuPewKvslJjekFPzz4F6DYp19DrptUyG+zfJy9aYaoAdxtURjQEI2UtQQ8gSVRIXcB/60r9FyD/9YuR9QLFMimw5hQveH0Ksoxn3S7km0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722447609; c=relaxed/simple;
	bh=qSbr8OvtWym6DEXzgOAzgjMAQzTFcZiG6JjJfcid5+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZU4SHCLH1SYqDImw0dsEpvcrwNQVKD6IAq/rfZEMvx/YWsn4nmVMvo05Y2T/DJi6fm7meFsII76UPref3BQcn0HeZG5zXWeWmRbfLSR/DWrxLDON4jYn69Ggq+wENsmEcMThBVIYfQFVmFRG4Hb5cZwRCYRxQ1yPeC619njeNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FQcmXWop; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FQcmXWop"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4281abc64dfso33016555e9.3
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 10:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1722447606; x=1723052406; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tqdkQ35fC7p3H1I0RUbNW3ITakHFi6YBp9Jz0zA9POc=;
        b=FQcmXWopnHgJi4ZYDeQBBWTrIDwNDOy388ETOCalb9lAAEL8OaN4wj0v/tUS1tHWuE
         n2jqxBflVaxbmnac6GsRHj3w4drA/qgrRrlwykVCMOsjhTkVYBalv+KD4Qitcmbl8JUv
         2bikbT/cr/2+uNtTktv5IWJCBMW3HtzPbnuAhDlvUSMfw2v/VI4PxWoM5anqpJ+FOzY5
         DblNoZvAj4ChOR06jsABcQyPzkPg9rA2s/M1tStw4mf2+R9+EpeOdck5JZRdyoN8B3Bh
         5Q4fiGsYeKZtLhSt2YCj12ToEoFbYmx3Jg/fjbMF4pXJilQky/zTlCCjaXOaZ3+HECP7
         dn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722447606; x=1723052406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tqdkQ35fC7p3H1I0RUbNW3ITakHFi6YBp9Jz0zA9POc=;
        b=jVLQtdicLcmQ7MNMIQsWoW8n5B33aMGqxuTn1q8Q1BhNeT43oajxSu1aaD9+xgf5ZX
         fypBG5FHKhZZcT+jT06u0EE4BhKXyhLyAoaHm4yhZO6Yk8p2ngJfXBYgc0d7nVSZesoW
         VOqSV1hQ9PC4cRU8qQ8SybHoGRH+YQbXkT9xS4QRGZXlwYWFTqVcBhrg8PG+zidNhVxn
         6XiWaqkXtgrLvT+sKIHfGrfwRSHn62SGmtoiSoSAAX17+eLR75OaaE0ehNan8Nt388Uv
         UwIH4GRvkexMGHza1nMzRyUEQF0+vnUxozAGj7PyXL7cwp6dXIxNKNinrV8gZnBYQe2w
         K8aw==
X-Gm-Message-State: AOJu0YwFdNOJHJj0gV6U/TaYjK6VLdu6sHKMhxPYISjbXDrGkqxHxrqT
	w7akawbgOXhYurBZ93Fngp3RjD1uOffXLMfPitCQx5sSWw+LJ4c=
X-Google-Smtp-Source: AGHT+IGROOi3Jog7R7laQl63oVgL7DF1626ttLOvpuvHk1Fc6jzdWGkszuT+TKFYYdIs0lz92qpxQA==
X-Received: by 2002:a05:600c:4743:b0:428:18d9:9963 with SMTP id 5b1f17b1804b1-428b01fa085mr1295965e9.22.1722447606151;
        Wed, 31 Jul 2024 10:40:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b057724.dip0.t-ipconnect.de. [91.5.119.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282bb9d464sm29181655e9.42.2024.07.31.10.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 10:40:05 -0700 (PDT)
Message-ID: <b04044e0-d62c-494e-903a-331793163eb2@googlemail.com>
Date: Wed, 31 Jul 2024 19:40:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240730151639.792277039@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2024 um 17:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
