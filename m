Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5D6548EE
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 03:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755056941; cv=none; b=kmCD//LBgbfpWNoWN1x6Utk+RGdDrorixTYVfoliq8v3iL5p8N8Hx8P2aDP6814Knv3eKECCn7Yyeu565SiWe/oGCFXg+cNv2okTMcpgYjUpb95l8RgA0yh/+f/nkeIWaGyJImC7bp5aw1eah7Jb/OQS+6rtgluq/DFs/qjOTvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755056941; c=relaxed/simple;
	bh=Bg9avpoQxIbrFvqx8zsIIQZpntrHIw9bRtBm1TxgJOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riQQrK/PH8O/TDXd3igrWbHSdGh/yemgmbn1YwMjXkBfSIJ3lTdZsQ2gSrijQOi4bZlv808LR/zl9S03AasUmxERGhCV0V+FRJR03zTRmBgN5+77yJtR1g/ka8Bt2XeKPQOGtbc8B77PAiqrRKMihFDR6Xat4I/eZb3jDrGezS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Ld4XQGnT; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Ld4XQGnT"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-458bece40fcso30807905e9.3
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 20:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755056938; x=1755661738; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gxMNsL+4yACXSz5SuyJHQH2P16mnqVfCD9Cumtuwkks=;
        b=Ld4XQGnTs0ZGZvwcUX9kqDAknp4OUSAGdK6d+njmm9XhaUwJtIPsS2l37hQl5rTC5R
         LLJISFSxCP6HyoruC7c5NCM9ZjwkyW6M8K/faqFr4oIm+gcKd8u3cSYOIAqsN4G9qT43
         BXp/TcwqnraowdDXshBkkOp9HlWnzPyBjBkL7ytmn6xHkoM8TdHSNND02rs/Dm8k1SJi
         NhAQGF2UeX5j43lckegqudWM5AtA1wi1Kkb9Uukk8trw+zYPv+IieUShHNFx9E/S0XpW
         pbT/iv1ZMkhk3Mafk64+GOSA++dNnug4hb9v8ENH1B0TCN8S73oUwRmumIOlUQnqUGUM
         M8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755056938; x=1755661738;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gxMNsL+4yACXSz5SuyJHQH2P16mnqVfCD9Cumtuwkks=;
        b=FvXmT0omf9g/3jMSFxDbrC1rs975Xw9YmDdPCsCc+efAy8ehM+sw6keXjJiceHlEVr
         VcW9Selr3sqfro1NSiN0CRnQgm1unKZIEp3RZpFgfaetVbxpbhJDp14m7vxFGzjTXQB6
         iAYv6e1V3X39L3BYrTIjAokbpSHfdmUISJUsrkUMYzhJetKrmwHDLszrUxiwHMWOi/Wl
         UalECi3M87qTc+R2ufg3p5V/FMmFgrYxLLvG3/YSaRaSrASRXQDPR+nE+NsXoIbw8fyq
         3JLXk4wlY+cuMbVybQUINK0AHW265v54MpmssuXiL6qN99yMsbsNovJjA2Bw603vx6fQ
         MIuw==
X-Gm-Message-State: AOJu0YzlOUrOgh8WdmNyINp2toyGm6W2cnGPuHhv72YotAaBLopRYgnh
	LHKWs1X4jgzz2TaB29U8PVfJ64pG4+J8BicMA3uPXdTgF7AkUhtFaIU=
X-Gm-Gg: ASbGnctupLqTjEPRUqYV8pFCvFMMISfLP7HXQc6VNSkyK7McFNz8MFgOhYWB/LaODYj
	Hr/hORsXTxbozdEZJz2okcxKXV/ZIEC34PFViy0uFkvDff0gfdaRtqaSBIwPWN+5SnNvNP5I7Kl
	dcm6wAToGUllAS2SYBzLOLBI/hYNkbIO0MkhqqLe2Q6H9KIqODyVsz+wF77s4f5JNxbGr8kdsbD
	pNNsXT9OIzWGzJ16Oq5KVVSQwI2+yT59eQJ+gHTObk2RLXgKHd/tAdRtiL/H91kQ9BMWKM0nUi3
	RCbmBk+55U9skn3vNPdru+bQbBRydEel6P+kl/40JoJ7ePWoSEUukHd5jxgtjFG7nbDlgDZUfK8
	JTtsd11HU79+y46/bNvlqE7laGLWCPZg+TZnxlF6/cRPfvaMLtnisio2vsAkW8Gs3w0AeZJyv5a
	c=
X-Google-Smtp-Source: AGHT+IGMLnjEf9oNYKSS5e4bSrDnCy4R7EK9c5gk3ITwqZPReSbGC51U8AXCNFUeS6wUDL4GuW9YTQ==
X-Received: by 2002:a05:6000:4020:b0:3b6:17b5:413c with SMTP id ffacd0b85a97d-3b917eb3cbdmr598204f8f.39.1755056937812;
        Tue, 12 Aug 2025 20:48:57 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b48db.dip0.t-ipconnect.de. [91.43.72.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b95desm45481257f8f.20.2025.08.12.20.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 20:48:56 -0700 (PDT)
Message-ID: <c4abe49a-c65f-4a67-8280-8e616bbd4b2f@googlemail.com>
Date: Wed, 13 Aug 2025 05:48:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812174357.281828096@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.08.2025 um 19:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.10 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. Built with GCC 14.2 on Debian Trixie.
No dmesg oddities or regressions found. I did not see any of the Python warning messages here which I did see in the 
6.1.148-rc1 build.

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
