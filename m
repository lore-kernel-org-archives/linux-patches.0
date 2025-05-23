Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E831A0731
	for <patches@lists.linux.dev>; Fri, 23 May 2025 09:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747992324; cv=none; b=lCIXmlcQ24O/dTOPmJzSCkgpfkgVzlZ/2e9RS0PIe/3QbxDEo8OS1hhxgYJk6buqSIVMK0ZZQST7DG7Rp0V6H8XkItYVivnZjaAGgNf3OZlnavNxY9x7+S2tXAAHeZN22dxl5JVwzllwNutT1ZxTEI6KPcXUTpfjFvv8TuWKPO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747992324; c=relaxed/simple;
	bh=PGA0Ad3C1HpTjHVROgn9fZ9oWXGJ/ly5wqU3G/dAykY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QHz0Mtlaa+Fcepkz6QMTt3gVKSon9fqgIbIzdNwlurmPGO+7DJjbH3WVeu6WLfvGmG5lqJV63GtwE6dj8s1YEqEeeWvGQSU5k1p4uQ6ga/Ct4cmVREapYc18tcSQQfKrvs6dT2XTnySZcIGcXMDI8b315lUgKI+ktWRN22zhheU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEDp2EdM; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEDp2EdM"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-736c277331eso565815b3a.1
        for <patches@lists.linux.dev>; Fri, 23 May 2025 02:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747992322; x=1748597122; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=4yPM5GHZurT6WiMDMIjRa6sRdT6oGbPUbwT9Dc0gQR0=;
        b=YEDp2EdMfvt5nbFsIMY/AcReLzBgl7r/5TwA1tA5IIyTOf8sUflevlgWf2fzlTSdWD
         KP7Qvh0E9zPuO5ELT1tHuYenCeE5nv1ZUReIaN4w6Qy/spdz0RTW/4J46kLWgYqldNXu
         fzGnfgG3zq6btM9/sIHaXzU8xEMIrsssiTIqsBBSMBn4dg/j92jnpqpG8ZN4LiD4ZZgE
         cw0pvBHRK3XTd4KK7b1L3EqwJukqYa95AcHUzfXMr+0g6YcSsggma7oZWk99MdRJSkfy
         WiZa9Q+rnFl2GNghxDrK1iAXG4Z9vH22yXipczcVMPWMhiLaUV2d7GSLEPBrTIKhFx2z
         6JZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747992322; x=1748597122;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yPM5GHZurT6WiMDMIjRa6sRdT6oGbPUbwT9Dc0gQR0=;
        b=hOC6w3fir4ING30ZbqGjp1gSEEuuktDo1pFxCVATJgQm0mcOLS8ZJSF3W0Yk7o/whM
         Kip5s5DV9NKkqaNHabaQkcN+YANHfxl0YdWOTFkWmuW83izKW4yGyGScbTvXPnndN8QK
         XAHFsZKbRP0oAzELBf+58S6n/rKA57XJEx+meQXPSwoH/OtseCVaDWnN9nFrQ/lJKn2B
         LWNNy/FOlfZYxs/AWQQ7lmGNaDqTe2Rvhdtj9maFM5hl/Ga1+02D/NiyLDokrj0Hcb4I
         OeJZyfS2oOKMPepTHeE1AbRwkKVr3JqksuXreoas4ogv93OIpx7prCPaWZ58s9h62rR0
         cy2A==
X-Gm-Message-State: AOJu0YyNneWbIkveOpsq4u7MG6xOFjsFk79QZutPmMtyn785ZM52vA4H
	n4pFqLJuZHTJQxtysebCD1stMemX7yxPQeeTKp8FwedByAHUrCVu6S7s
X-Gm-Gg: ASbGncvKR8+yzrpLg0RdVMpLlADgkk0csN3vspBj27Ddxi8tp9xcdTcO+ym+1FGIGlv
	rY1RwKUw0JiOoF41BgtMkwyjPxIsH/yfHjvUTsSbRiiM2JjxSVxEKT6aiH9hPyVxQw7ixhB2nfJ
	kC9qh53jGegb/hDUDaNI4aNfRhAHg5lvPvfrVh62+d+ONPnqy3Qudvyky1r1qwjgVzQ96cVT6V1
	4CmKKxyyQH1Ns0kPK1QrSfiSL7nBZNWYW4svF3cOT602RitwONhp7k3z+nqa4CG1OqCd99IvS/U
	imWfK4q3A12dKcLdagvMYEF3GRQnFlSIh4HhGluvWPOTPrzWqiyUorZbd7LmeMu3FE6W3eZbEnF
	6TwY9sch/IO6DJw5FDISodTxo
X-Google-Smtp-Source: AGHT+IEhjREyA9R1vAN2c4/XfdKgzwcSq1mlFAlayao0uKzK/2HNIFI6IHqVfNJCeEOSTbLaiN65VA==
X-Received: by 2002:a05:6a20:12d2:b0:1e1:9e9f:ae4 with SMTP id adf61e73a8af0-21877ab0e3dmr4125419637.13.1747992321797;
        Fri, 23 May 2025 02:25:21 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a98770eesm12335068b3a.154.2025.05.23.02.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 May 2025 02:25:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <0f597436-5da6-4319-b918-9f57bde5634a@roeck-us.net>
Date: Fri, 23 May 2025 02:25:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250520125753.836407405@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 

Build reference: v5.15.184
Compiler version: x86_64-linux-gcc (GCC) 12.4.0
Assembler version: GNU assembler (GNU Binutils) 2.40

Configuration file workarounds:
     "s/CONFIG_FRAME_WARN=.*/CONFIG_FRAME_WARN=0/"

Building i386:defconfig ... passed
Building i386:allyesconfig ... failed
--------------
Error log:
x86_64-linux-ld: arch/x86/kernel/static_call.o: in function `__static_call_transform':
static_call.c:(.ref.text+0x46): undefined reference to `cpu_wants_rethunk_at'
make[1]: [Makefile:1234: vmlinux] Error 1 (ignored)
--------------
Building i386:allmodconfig ... failed
--------------
Error log:
x86_64-linux-ld: arch/x86/kernel/static_call.o: in function `__static_call_transform':
static_call.c:(.ref.text+0x46): undefined reference to `cpu_wants_rethunk_at'
make[1]: [Makefile:1234: vmlinux] Error 1 (ignored)
--------------

In v5.15.y, cpu_wants_rethunk_at is only built if CONFIG_STACK_VALIDATION=y,
but that is not supported for i386 builds. The dummy function in
arch/x86/include/asm/alternative.h doesn't take that dependency into account.

Guenter

