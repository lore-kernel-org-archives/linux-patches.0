Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8829C2AD02
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 02:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734057068; cv=none; b=mpMNlCYleaQPtcb998KgQRE6hwZVRMpGRJM7GWmMG45q8MPOqs/w5Nq9wrsb2jugfhJUxpTqOhQ0pX3q5Pq6MraoAzbpVhXaTbJl8Hi7b8IYxuNZv75gzH8F2GUHTb4E06g7eAn0l/XOVLZfO5ve1wB4y5a5E1WSKhZp2nheGjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734057068; c=relaxed/simple;
	bh=hPzhQWhJg34Kpqf4MVZHYhzs+MIEPTPQBi5m5xnYDiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=abEigr5XwtJ+En2g6e6oA4juJzVc/quo68mxoYRBy9oF2dPmr8ykzi6/q85GLfjkk+QzPUAorZpJxBPzq5H8QrJuCtl3+PJcjKjsRyYL2dxho5TfshfbhH4cAtEHs89QlYBWl8Q3rso1UivQWp0BD7udRXSvzLmUkuHoDSXgc+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TCx9qz0N; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TCx9qz0N"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-385d7b4da2bso1180741f8f.1
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 18:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1734057063; x=1734661863; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j/NT9jBFNeWij/Bo2czeFzLUqSgyf1VNBFVJ4b6esT8=;
        b=TCx9qz0N3v8KoRH8YYLPQKHB5wc8HwQ5rwdUicOhNyaX/xDqvdulrioHCIp9vUnRI2
         5Biz2s9Ft7X+edMoadZxjyVDrP5Ce97ejwSk6aKDImv1JeZQT8aGnmR4yXOkfUeYQY3w
         PxbCsXyKNYIR8V3PfKVDbQwgp5cRpXu9Rkf8SkL6HrHqCZpmHFaO+Vq0B/N4NYEIFOsj
         bTXaGrsJBH71/HOKqX7ZEm3EeSsOwW6wof28gzEIt2uwUHJ1eVi9a8jaCD/2fy5sCv2x
         nMBezydwsXRWA3b8fepfsQsHEdHr9Mtif9yDuyQRK1YwrqyRQJybYSjMV/F9siaIKjc1
         Nqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734057063; x=1734661863;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/NT9jBFNeWij/Bo2czeFzLUqSgyf1VNBFVJ4b6esT8=;
        b=Mhkeb7cpOdpfp0W9MWSXVkoTv3eu7pE4+YUhk9z7cxeG78VP+gLqEzfvLTEgRuwZx8
         b9Z9axkP7eBz0DLLZp4oHBZVKCPRPcFlGRti+r1PDgTQNS2WyD7xm5JFz9Di7ink3cM6
         NitOC/N1hBY9XNaKpFp38RHcRgQtTS8A7TBbs17lLsmNkdYLzremwaYmd6pfa/cUUVsb
         wUdkoh1d55amIEcwjZcuDUYrQwd+U85k7zC/3YaQCsEvAxA0387sG92HxSwq/Hl1sS39
         J+Exx2PuoB8aSW6wdgv8tITXHTkbKMQ62oj4tLfoWYje3N22IfEqvyPzboUzvBXqwjwv
         mU7w==
X-Gm-Message-State: AOJu0YzoBxmauxgmPQEnPd/8gYVmqpuoljvSVuS9NXrJilGrctNK+6rA
	jUOG3mzHEVb2Tf10CLZpst338ALlRnH/8X7zyYmoLURT54O+Z+k=
X-Gm-Gg: ASbGncsWx+vmk0njJ6CICLYHYfKBMqljgOlNyFbSW64C17LiKA16Fl2jEZ9ywtNgAHq
	/nS3ZM+ugRz3V9SNZKaAGPCDwrpD3seDzHOaQeGzDvMsP5te3pqlFfsHBBoxUX+4MlZCbCtPXGT
	g/IRl5cygn4GE6tVMcQ/QTAY5kRRRSDMIKBQwBHrofR3q9Fill680l5oJeS+9bm/OW3xg/lIMU9
	fYcp2DaGpQ0OBJ6iUxMucAZyXkOnul6bnEK9lYOD1FHOzqHLrke1lDISHIBs23Mala1tyxmJuLv
	Z6zkyj3iqVhgZkDAcMuhODXrKtz7xUKL
X-Google-Smtp-Source: AGHT+IEUL/uIQsLe/pbBTa962sqyzAgZ2ypA106g6+52xux6R80PwyBsPhVia81M0tXDqB7JjEqU2w==
X-Received: by 2002:a5d:5f50:0:b0:382:3959:f429 with SMTP id ffacd0b85a97d-38880ac5f31mr532370f8f.5.1734057062555;
        Thu, 12 Dec 2024 18:31:02 -0800 (PST)
Received: from [192.168.1.3] (p5b057a27.dip0.t-ipconnect.de. [91.5.122.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-387825296desm5580998f8f.111.2024.12.12.18.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 18:31:01 -0800 (PST)
Message-ID: <b2913864-50b1-4f6a-b20b-3a93aeec204a@googlemail.com>
Date: Fri, 13 Dec 2024 03:30:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144349.797589255@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.12.2024 um 15:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
