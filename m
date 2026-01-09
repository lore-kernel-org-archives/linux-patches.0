Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC4C338931
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 23:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768003095; cv=none; b=PXZmb0Y2Wmpkso5lXQiklEcfnYfJeldXEkvywdZPzTzMLbpLq99wTQjGHQXarGRrtqOUZIVTkjyWbZYt/x0Pr5QAKMWyQxW29grimUhfmsXvdhKB3j1ZWKUX1m3gnl21qUz9rgqkIdkzZz4S3e6dE6/9dldBmMQidwEouq1Qqro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768003095; c=relaxed/simple;
	bh=I9Cfsfg3RLUq/nIMfIDqMEPRiGfTmJ+W0kuYh+PJOr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HOI1GWlC8hDaQ9urqBn0dmOLNj5XI2cKCIFyeeYppV5OaeRiayFxqRJr0rbi0xqAH49G9u+DlbwZT11ZKhlYiUOoiRPDJNoLf3PT6SQ0HhwFQePih7hXEruDZicebaa8dKW1uRcH1KcvFawvjWBeH6BiGflkCxIWqQrLPD4tJrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8FyXmKJ; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8FyXmKJ"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c6da42fbd4so2699895a34.1
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 15:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768003093; x=1768607893; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bFEQYRI/1yCnUCm31pPkGuWos0aM2JS2hDmoF0o+HQU=;
        b=K8FyXmKJ5seM8AHAdbyB/XVhTI4xejefnV1xrhzmLYYoafdgVql6C1EtG173zNN/6w
         3UytKjrgIe2SH/ax89Sd70YBDmw5SfphMnUChAySttbL1aq+7JwCo9B9JVGuyJIH6GGc
         Si/DJJc3XJVBgMekJxlTRPLMuvG9yAIB3hJAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768003093; x=1768607893;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bFEQYRI/1yCnUCm31pPkGuWos0aM2JS2hDmoF0o+HQU=;
        b=E0MbVUVv6N3wY7USFV/U25lO229EokjdHEva16lZIdsPrllzZDsMNQlCvJCOyor1h5
         6C8nkY75uFEvmmeX0xuvbOfqW76nWcJ5B+VO/cJUTRXQtxgg+6XtD9KRrzYJ8n9J+Aod
         +ftvOVGIvlCKniQxZBvbCKC41FWJJXabmh8e5jjoFWmmt8S84OuUgSzl9aRSc2ffA4Dg
         iFzrEIzc4c9+vjO71H1T1GgQxmGuBZXPxyJnyVK2FoSWkAx5ikoLY/Q5kizfcavV3kyL
         UUplrdr8zLUbF3k0k6eAYcV0gkqLuOlXa4oBipkrGwY/eeF5NGc/nbvmFEpEOQTbbDZR
         QZDQ==
X-Gm-Message-State: AOJu0YzzR2Ible/Z6tz9CV3reXLq6LeR7PejaOWmsdX1fcM0mmTKFo0y
	ay8Tg1v3cC3LQEltW/YoR9W7zMTD7aYZmqwmIJfUVRFZjc0RUoTor4IX1SBnIKaLO50ZGUxoFf/
	983b6
X-Gm-Gg: AY/fxX5F3TC5Ptj7H/Omb7D85V4a4YeWZ6OD0H+3i4MlPosJayek5pin7Na+Yf5NR7a
	jueNq5hrG7nAST6SFBOjMRz2SSjyCsw57KBkTUAUQt1h+LEWUve7+WLQQPrnvZYIXqYz8qXMZDv
	xyU5VONHvZO7esRHp8zgLFX2JbCzXfkBVWSQVRgD4SaPDxKjvCFdOptKEkEckmJkTL77swWlxvX
	owEbw7ldtStKGe8L7TRK767XVhB8AVpCHxWlx0v/rhFTYkxXoQxdgza/Sm4k5b+5LvWg3DXLzi5
	NTgsLgJsbY26jIQdVGFtoN0rjbm+JWyYM4Vq3Rknsx2V4WvmSkh9MRCjF//B+R9Aauo+6EiVtV8
	huOngHdFlRavysHUJHU/R/DXi2WMXj5esmGoJngtPzoUCgKd/i8rZO2T+2JMwv2wbQkSBHa8Dcq
	Y0xSoSmlxezilspILe2usTkfDCrPtzKL+I8g==
X-Google-Smtp-Source: AGHT+IFuhsAMsjRaaRlSKB12kpUhOh4j/WkmMN2jjP7L5PC1K6YEaZKs3kdjw7+AeCobZACBX/x3jA==
X-Received: by 2002:a05:6830:2e07:b0:7cb:1288:329 with SMTP id 46e09a7af769-7ce50ab21cdmr9144795a34.37.1768003093250;
        Fri, 09 Jan 2026 15:58:13 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ee883sm8538140a34.28.2026.01.09.15.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 15:58:12 -0800 (PST)
Message-ID: <b6fbd379-4307-46b1-be96-2fd13bbd1a79@linuxfoundation.org>
Date: Fri, 9 Jan 2026 16:58:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 04:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
