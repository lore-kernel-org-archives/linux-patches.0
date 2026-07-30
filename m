Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2778D43078B
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 17:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785432265; cv=none; b=SUS1n3XQkjhFVdjNwqRJJMmwZn70XBtLoGJBK8HE/W67B/VJYc2WZy62qlf3yCK3YAocdJ6WLFjr8UoUZcqTH88ZaAj2BsgnbO9zafFPpZGG3zORcEp0SphOqJ+FIuakxtliPWcBEZ252VcOqXovw0e+Zy4xywGrTT4qGj9QHtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785432265; c=relaxed/simple;
	bh=Bt561/BYlsljphffl0GVHsslSbyVvsEBKuebmKyXk7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZ5vIeFhE43vg7NxYWflFP70v7su3T0SbZJhAwMYt4srbq7aSXMmIhrRGzQkPFr4xa4fisz/tLsliMbE/rAdcB1TfdD8WvsS/qFZFa0P7rwpxS582oynBDuW2SA1Rv/9m+yySiy3hd30GrtWhxbosErQqvfBwgUnne5VjAIwI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1CT2MwB; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1CT2MwB"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5bf9466412fso80745e0c.1
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 10:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785432263; x=1786037063; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oDHSPdU7eZliEnYDKkNe6n4EnFUD+dLgVWZ4qb7cmmg=;
        b=F1CT2MwB6fC8LUr/Ja3qqFtvBbj6U//ABmfZvyr/gNwZDwphMUfCsZXvomy2TeqVC2
         XBl8Vc3Pcep6bASmskYL9ZWyTrtH9nLhAJHrZXKVTcXtnn5GI9yFidY+rtIBVe5AIyRm
         7bp9oMlJiOlVFHdUqVB2G0NoccZXlxYBl5KYBJlKrrGk10dR55GLiWx8MMNW/LpASgdx
         0fTBoHQYf5NCzbEj4JjFFHU7vQFEfCfhJIYizdKnStQpMpinCLUNNq2O1mP2FBudhPET
         +C10+JMO0xkAJfvmb090uBOrOjgQBBeXGqAiq9OrqydxEAtjZLCVstWGgzUGePW/z8uT
         Ugaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785432263; x=1786037063;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oDHSPdU7eZliEnYDKkNe6n4EnFUD+dLgVWZ4qb7cmmg=;
        b=oZSbTxz5wu/WPeDSoVi1nwqUOAhVidjxI66FOwl1swB3C+WQ4YI17FuyzeQhP2OqhC
         r4/2V4ScRIvQmYnRJTesfh7W+BHoZ0xSfVia1/xG/ylDkSWH2R1uQVdUuTPAteTK+7PY
         70GqvgXtflTWiYZMyc6e53suBHeSo9o4PTX/9SELqjI3ruNu+O5fcrEBLquw+X6G+G1J
         AxipKd1Pj1JZyDK9i/JDW/gbO1f4FxYP5Uw8Pvs2BbTLMeDo02VT23vVvoPDXu8XHgy/
         OwUjNTY/RXsa25twaNO6xWS0ziDYbLf6aIwcz/Rg0zqyC8dbCSXt/DDS336S1MuAIl5N
         hhdQ==
X-Gm-Message-State: AOJu0YwbYJ9VEp+aptxFje/vta6HGvQIG+RPSQh7wDfdJEG0DOtmoiZ3
	KWM/z1ZIgl4ves5wGnmLyE5wvnBHLnmZRD0QBY4zBkzgDO09o56zNij/
X-Gm-Gg: AR+sD11oENsT1H7uNK8XOUymFtixxnPOnMmEepKRud+vz4seUEA4sphaBiZPp1LeETD
	uulqixM7WupLNEkB/ybn6pbn0SVuG70PDy/o8L/SUkmZRXZWTkpZt3zBwHimEaBuvl95M8jWz4t
	H6QYr5WpqlrwDpPSYOiUnFUAAAyFI1awhHvAYVpDwyjcbgCT9PAeeRr7n2Fj2XWDARQV9+/xcpx
	q9lem7jEPMCTEF5ppauvFdlPOICMRzIhp7b7WWHYKEDFHcfygwoHj3A205p/SniTgoylr4ImTFP
	RjaCKX31i/y2L0BgCF5HDHpqkvzapn8QwoPObLFtywioebbJhAPsh7dpu9j2JDtPQ+VQd7LvDZg
	KNLN9bsb08zzPpAgFBEl2yTAfYoHvmoohfYrWgNFo6b7WsAQCYAHpoAd0lSOA2atoRv5ubLXDBt
	eTHBb6+tQe1cIt67SOXkPfHybsZyi3ClxulDlnDxo3Ud7twVR3eiZ+s2E37GKKbcZVKPCWPzxf7
	ycYkc6UDXcGQls=
X-Received: by 2002:a05:6122:da1:b0:5bd:bcb1:453b with SMTP id 71dfb90a1353d-5c36614578cmr1208498e0c.10.1785432263066;
        Thu, 30 Jul 2026 10:24:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c36655f076sm1972973e0c.5.2026.07.30.10.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 10:24:21 -0700 (PDT)
Message-ID: <51d1d2fa-8064-436a-b0ca-7a65ccdeead9@gmail.com>
Date: Thu, 30 Jul 2026 10:24:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260730141423.392222816@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 07:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.148 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
