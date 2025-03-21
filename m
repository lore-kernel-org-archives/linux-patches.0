Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB1C200CB
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 00:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742517423; cv=none; b=XGtGMx0Tqal5ZsLy5+bc8+uqY2Jp4q3gLctOP7kRuVeZXVjx4wkFnJFIYrxcaI2UP0P+rsM344PyFtMNYTOUaLKTNKPOVPaHUPWkyKeHarGV70cunpyGIHrMBYETMmPCTAluy/jKEcnDutwsWf/hEDP7mpx/yNWR97Ss8q3XBzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742517423; c=relaxed/simple;
	bh=2z2RHDJm+LH1XHYv8vwtILZIc8Ji7eD8BNHKPWzg2vA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eduWkBzB7iP9kBFCjUOv6AlZ4B1Cf6YlLL7yUKzxkKPMAtpSrHT69yceLjCT4tvkVCKPQsh6zggmltOKfpVfLGtPj74TxXfa9pxLPF8ciyIZdRahcB8Bc1X7+/KXsHF+m++tYeLiz6l2WCYAOp9XbTm/G/RdwbfR8GFBydgRIwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=e1wrcqvb; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="e1wrcqvb"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43690d4605dso9625395e9.0
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 17:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1742517418; x=1743122218; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YqUcVj28ADCuEV5WcvgqcjEh/QhHQb8TbIe4WSOMGp8=;
        b=e1wrcqvb20G1pOpBCtu0JQiJeX0irgZ0l1V9XYPirGI4yMMdNZSQYHO5Thlt+t1CO4
         DXQWWFatDMyJnvjntQdDmhgzGMSJhQnNuIJQbiAw1Ph9O4l65v1w4IqBx9bZdtostgcc
         IPF5i50qoFu+lS3yiS9sDLXZ33aoNf7ObsOkW5kHkK0R5y31jzjYUkKkFoT7v5sLNuFj
         Tu/v3FnfZ6uxv7+0zVpz95w+jX/YhG4Axy+CQWW17wCN7Qv+jWpb56yYdqwwDLTOounR
         Y7yD6JCBIOiJp/gT7t2nfrE2vDrOa8KE2B/q8yVBLUFAoWMu9VQVc561QqU5UUA8HMNp
         oqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742517418; x=1743122218;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YqUcVj28ADCuEV5WcvgqcjEh/QhHQb8TbIe4WSOMGp8=;
        b=vPNODbpWneNDKgcWoSRUQnEdfHqoD7UVthVibE3O7TJ4SU/iCHTfJn2nnX19W6RKSQ
         2RS9G10K0lxI6CvTxxeGe6mN4Ur3Ni719r4b8JkaPjNpd5Fa1a5WfJ/IxdukAoFrpA6N
         BHCTk0XZ1dvqscJBUudL1j6Zhg7BW+55F9Ux7CW6p+EYIfhyozFnCMkjRsrr+e8PpAEu
         Kw64b8svIZ6GrIS1D75/k/0Y025wR7771rUxrqP9FjdrH9aOu4WrBzyekr50RZJufQB4
         e1Fm729Aw7GlInMcfFGRGyZWZROfMpiO1W0cBgG6LPyJtb8hU38pmlTLVPSPnynRx0pe
         CZLw==
X-Gm-Message-State: AOJu0YznqXAgj1cNzekbBVTYrKBGvZkdJtJFykAFAWkkRrjqcKCrOhyv
	CeDn+XXSpM1dl0/V/LpqjF1ty9f+TGWRwU1gu39c+3zkNC6/4fs=
X-Gm-Gg: ASbGncuFZdKaLathlNqH9sJFX/LnNbA6beiTzCCwdsN5NogpEFUHyXWwpCO+wE0d8Cb
	A55oh98CCeEcNbxns0Y/q6ysjX611gp13uba54UqJs/3nqkbbwCnQkr145urIICnxx4ihLHOZMc
	YGLY5XULDUwNohFzMdbiZDBW1BgcUBl5bG0yhb4g8wxP+5yaf84JYc4yTMosRK6n35uUepi4UFo
	B5K6GihwhLLJlA1IoBdoDXOqyvQn2roAKM45JqZEkSssylfhfdwUsfBp2u6BFrDz6SgCXROUE0I
	l3wZn5v0svi3SyuoRFG1BSh0PXgBlf5sXLCzRUYVrWoY0jkbd4WqS5hju5DMCIerFcNVefGSWZC
	mse6hp9RTGF0dHpiZQr4k9g==
X-Google-Smtp-Source: AGHT+IHvGLjMkOgQHJeFISgsZU+mKKIo64KH7v61/RWdA0q63XnnMd2pNMchgRNfh+u1zcQOFJefnw==
X-Received: by 2002:a05:600c:4503:b0:43c:fabf:9146 with SMTP id 5b1f17b1804b1-43d509f5a43mr11075975e9.17.1742517417855;
        Thu, 20 Mar 2025 17:36:57 -0700 (PDT)
Received: from [192.168.1.3] (p5b0579be.dip0.t-ipconnect.de. [91.5.121.190])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d3ae04a94sm45405785e9.0.2025.03.20.17.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 17:36:56 -0700 (PDT)
Message-ID: <d5f238f2-2ffd-4e85-9667-9a7398b42516@googlemail.com>
Date: Fri, 21 Mar 2025 01:36:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250319143019.983527953@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.03.2025 um 15:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
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
