Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381DF3AC1C
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748883820; cv=none; b=g0U8OaxF5M2aOToklhASEfgOoEOl+nn2mFP617J13YphKBaOatQLWoqNPl5mKxbqIWWxV91Y5noS7QLEPRg69vXkxgF8TjJkyTxh1qKM06soBUbU5XOlUNgRzKdtqpjrqmlvDc/B3UVH0jwkdwBE+xBMUt/k7ROvZ76jDcp78M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748883820; c=relaxed/simple;
	bh=VMaer+x2LjRkIyNhCPgGhMCgkxjOf58plLCkqARWbt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U90tW7FjXllosUO5JhBWIyT5P8EjNa9SAKov0J2DPPSWg3V8K3rV9hcjvcttz2MTzroN1XnX9Nu/Ce74zKrWzWrqDBwk9sD0WCUl01+gxbHeP1UB8q9E4e7dLeCUL0MXINypm6IC/RzxtROHkyOfYdq1MnBqGKebXmRYou+ZZwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mGWokUwO; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mGWokUwO"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-742c9563fd9so3854111b3a.3
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 10:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748883818; x=1749488618; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fll3hWF4pol/LM2L7XdwKp07jcPy9V6QGOSoLodOnKA=;
        b=mGWokUwO74F5Imfi5JmrH4/6KsN00DKkW4YcQswfxbRn2gecaoCiVTeLnxt4CFXHkP
         9Kn2eL0FxkcdRD9S4SgWTPwUuEnWywcQ2f3sSFXcq7J9SlY3EcfDYzpg960oVJTx1GNJ
         zl/ggJzOCeq+NDvgQymwQJ5f1CydORDD0JYIZSVGwaSbsaDtsNO8jqLhVCE9oR6vY1i2
         2MqHqmF4hnDkNIV4vtL66zVVFhg792M0VoBjHNyddQs4YC8tFgXuyWtBuTT2/kBEQd9i
         +pG3sp6eHl19HIg2w0g+ualhgOY8LYUhsheVh/SDXcQcBRX883YAeY6OZ23c6H2pmAf9
         iddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748883818; x=1749488618;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fll3hWF4pol/LM2L7XdwKp07jcPy9V6QGOSoLodOnKA=;
        b=qbdAyuA12efeJ8XQK/3EslNv7fhJE1D4Z6TcihJYwfvmam0PfaxUrCANYpdLwYUbTk
         CFuF8D4HcpliVQfm0SFC9awYe5LPeU0in9qf6w8zoqYIYvgqJYerp2qk8QudV7fU5CX1
         4YvXEdhNw0OPCb+LyVJU7npPe5XWxTSry3nINNMpCesTr49GRqvJImTEpK053arjl0za
         GgAXMDDym3ShAjXQEAj6+ddARGLVVR9sfgmgfbeKEGx77DIQu1QmVoUGNyXzba0x6VAF
         u5a0IkMvhxXZyrYd/XwAKtoecZMOpOIcur4fRIsN9JbEhTvtYsGYzm7v0bCDdhtmQGNG
         KyuA==
X-Gm-Message-State: AOJu0YyEiFZjBiWMeBzfi1EROLBowpd8N6hVG4B2Cv9kQF4E2IFDkUee
	cQGHffl3bl+44koChNrRrNrjydqvfdRIYxNbGN7+4RVHohZTIu6kyy+B
X-Gm-Gg: ASbGncvdqlESdMYTajy1R091eeYEwGmC/aI5y68hZBcl8v0MNVFeT9ALDlmfFvx0Sqs
	qtjBCQ5jXGAHYCqhJ61nxRwXuQisX1t5Pu2Kq+iGBWBMqb9gTTk4xEuEWzrwKzsa3osPVf3UEQT
	9IafpOE1NsQs7xMfVGgA7qJNYzaNaIm3fAE5oEWhFQpAS4ZstiYYZCL9799Ny9b4nhuG6aZXEVF
	0kA2fZNhcu6vK5jJAF7x32PNafkSj+My0c3OQN/fZ1x//zGzRpe1lcwK6Hu35dtKVoCE7r31zgs
	jQdIS/tAMlmGckX+YI3cUFx34ZI+2B6scLeP0NbSdN90DYXrarGes21iPtQ5KHhhg7n9e1K0s1Z
	IYFw=
X-Google-Smtp-Source: AGHT+IHFSNHnyO+CDl/RuvZSWW0apRaWa2HraPjvF6RPXFQovk1bTYvNCry87zOPF++XkqEjDNbdxQ==
X-Received: by 2002:a05:6a21:9998:b0:215:e9aa:7fff with SMTP id adf61e73a8af0-21ae00b198cmr22928496637.31.1748883818354;
        Mon, 02 Jun 2025 10:03:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747afeb2bc1sm7874247b3a.47.2025.06.02.10.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 10:03:37 -0700 (PDT)
Message-ID: <50d6ee44-f7c7-4fe7-848d-dc31cddc19f9@gmail.com>
Date: Mon, 2 Jun 2025 10:03:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/207] 5.15.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134258.769974467@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 06:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.185 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.185-rc1.gz
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
