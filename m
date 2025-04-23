Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCF9283CBE
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745427181; cv=none; b=aZSRPE7zpoAfymtpzlan9qqXHhIEwfdksDGfvo1dBmgW7/dZddmW8dIxxnzySsoX3MuRk0UPi1TUI0TRSI5qF4FGsN6R60/AD1JhoVet0upnybJa1kuU1nIjt9uFhUd2dIiDSNHlc5LuGKE1J5cYfPZH6zI5JClTUGO5xlnxPAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745427181; c=relaxed/simple;
	bh=m1JW6JCpT5K62iypPeyrD5Xxw8L3gfy6sXHK50Nf0JI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JB7L9a98K2mQZKb036JLKu9QX0MsdZOMlPussG7ymedN1INZB3asmcg5j3a+hhS+RtMlcEq8hna/je8heYXo2PvsZt6LeS/eRog25O0qJ7IOlMUfU6oPbu9AD1jsAPQMJsO+oNP0SNTiT3K8ChYFRO3yJVhBTxHLGrCPoSJblAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JYLD5BIs; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JYLD5BIs"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso21087f8f.2
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 09:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1745427178; x=1746031978; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mp1u/sIDVPqsXQLkzZlVGoz0PRI6pxyHbfKJBelf6DE=;
        b=JYLD5BIsw/tPML5lsqh6U+2ndvPCtQoAcEOv6pbiVoQHdSSDSVBN+4De1X0JVWHmKu
         wc3yIvLvCYEiXJiee2m/rHRgs8Mw/b6nSjJHHJjioXnRxY456BOBKoibODMxeWDovYzd
         O8hW3hT1yWWOP5+665/aWQj3hyN7xQ3K561SK8HkANQtPfdIdE7WqvKWUobul1g4/xV6
         14Qm67nKkQMRbSZFRcYaBKG6RiIrcEkkO6ePTCQtieyd1R5fQ8mRBckZ1ifwNzD+vbsa
         l5r+1X4g4jKYatGDXHgZ0dOstvSUcYr1Po4idzQAuWnaZvvlvV+wchD6T25XqkblJ0/Q
         3xhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745427178; x=1746031978;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mp1u/sIDVPqsXQLkzZlVGoz0PRI6pxyHbfKJBelf6DE=;
        b=Wl1Jf55OWRkfg/LHIXNl4ZfPVU+mki0GT952Td9mn6HC4twWqeMyc7ejZY7+84mh6T
         0aAbx91N60LIpGHdfjH61/rF7es5RH9U+E3VtM0IphFQesb+ya79zjYtEQW4n+33EoVE
         LTj5/ftSl3Wb+XdVdvBTAa4viZHVUrZ5JEyzm27cSEzK7aKCyHRx47wLO1Pv2Y9spgtb
         eN7IJUboGBff60zU0pwIFESCfH3AG/OOfFth6tMsW00V5eLIv/qBy+RvdycZTAdZP42X
         cP21ONyCmDWh2meEB0tQFxQwpb28khzDv8QprldXNWBk+K4EyZbK9cXCLxmreBPZa/8E
         gfwQ==
X-Gm-Message-State: AOJu0YxiU/kYxK9+GWMyYR+6V2oi4Wzdtqet9w5tCNOCQxoR/YbRnwTJ
	GHwUZVqHtpqkQp/krjtq+uHLVmDPh9E0EepfTY2NznybqVuuftk=
X-Gm-Gg: ASbGncv0mOK4YHNn7pV5fpyaNAI+e5QkVxng5t6uji22YQUamkySeSSdbQPAmAwckXS
	Up8xeUbQ2LP7KfCv/VGxDDUdH3jG4yPMXRO29XEr9pHVEPpZZZxkwKmJ4oWJmH7rhdHuUsrnycK
	Q33rLtBkJ+uH4QTBupHLfjVSlKLI8crkfbf0FAm27WupWaSaYOVU4Oe8feZNxkn1c+g5TfP653U
	Wh0R2GL6s8Vyanp5ZB4TSCL8LJAjO3njUV9L0AyjaQaFtGmVvtPt3r3E5H2J0v2Wm3DuiDlNAKj
	CTdGC3Y6BVO45oafH2Tc3VKq6bsusu7onm6xZMCpMJdMPAa5Yc2S1+/ERlGXaRWrBhNNHWd5OHY
	oV+23APGibLvCVQyrpA==
X-Google-Smtp-Source: AGHT+IHLHgQwjBt14DC1pTfqWWanbV25/yLubDo519FkOCkJkmpwKCc8feIRKpjRKMsqiMdEH3ytRg==
X-Received: by 2002:a5d:5f47:0:b0:391:22e2:cd21 with SMTP id ffacd0b85a97d-3a06c43fb78mr229330f8f.36.1745427177790;
        Wed, 23 Apr 2025 09:52:57 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac758.dip0.t-ipconnect.de. [91.42.199.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa420837sm19598917f8f.10.2025.04.23.09.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 09:52:57 -0700 (PDT)
Message-ID: <c799db97-19f7-426e-892e-7da3d36a98f5@googlemail.com>
Date: Wed, 23 Apr 2025 18:52:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250423142624.409452181@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.04.2025 um 16:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.135 release.
> There are 291 patches in this series, all will be posted as a response
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
