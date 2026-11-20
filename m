Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795164311;
	b=aLopcGRdPKpb5pGOwoMf0JP5ukXuz9Ly8ARuSImvJQUcX2Q4gJo8BkFyWLUVYpQz30ix
	 ZWSojuLedJf4FGbuuc9UPYX6CcuIfyi4HAFg6ZnlaFigka0kQuXMmkYKNdFRXsbcvIUWl
	 SxjNoVPcFxODT3CPQYK6UY/XcsSlnqRXDtQGexhciXwadZjCeNGtlbGI9dtPJVNW6Zssy
	 aF9PBJriqsWrT2MxfYKtQzgqX/4uPQn1ul9Gd+ii1psXLhxlscPRCti+zwC5mjNAdZMBi
	 Oh/4lJb29DVkxkiL70VfG0mwCpDoheCyxMycs9hDtXspRdyUp29pilxauMHcTx8WAFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795164311;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=sCqnY8v5CI6MdsdAysAACdNLL0d1psytcPbpLVmifrw=;
	b=KXtfYZErL2JRmF0tECB42t90OV5trIg7b8R4j43K5Wfg08N5O/mdI+QPShOFPSGmJdyP
	 RHcBI0p4FQpeXuQcgURyCH+Q8sJcZMooAwfTW+a6FpjMfU88sbNJ4YOvuCh2JPkBzbbbt
	 ePYFtih3BGeIhF8EkCIZiiuvJkd+fYnM9aWSkLlHOszpyb9Ov8kRvmswMQs5j5Btii1CS
	 NWb6wLUvNCSVzUocIrbnYa/IkMqEEFw0AKfRJy5rZK95wiGcnWUKm4A8jb5ggt53j5oFL
	 9ftuystLJIDJ59O+UBeg5PIQO0T24l3cNNqxALFryvkZnDFkhFh7My4oLzrH37zRasg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Aq7iMJd/";
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F151D606A885
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 08:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F151D606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Aq7iMJd/
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b08cf16decso454816a91.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 00:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795164310; x=1795769110; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sCqnY8v5CI6MdsdAysAACdNLL0d1psytcPbpLVmifrw=;
        b=Aq7iMJd/PV797lnxQvEpim4db7/bXEjcRmDK9Zw+N8WjG30clBtXhLp3iFo2K0avyk
         LcXe97beq1UDRCu0GlFoCmwsKROwpSwLqDUd1y60KyOsHxt038BhzyjOBdqqqv1Yk7HP
         C77BUlpoJkzLRYkxqmyegpdS9BMw4PgnOA1PS5YwyP+5fqfUNq8N9wYq55ScC+Z42xcz
         +6TIxyDp8lZDyrBajYvrnz2LDhyd/x5Zup/M5CDud7mIWxgDENQyOdU1E9NQGY4I9tzT
         SXrp5FygESIWhHwLBeV4EYpKEbKfBaV1z3TKggk4S6mzsJX/1Zeu2Jxgpdoue4pYKXN6
         5pSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795164310; x=1795769110;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sCqnY8v5CI6MdsdAysAACdNLL0d1psytcPbpLVmifrw=;
        b=rlXLllXQZ47QDf9dJtathLq0ppjfJnE/1ptjZ9LgfNbBU7TgAnTFHn66or7fhIr0eC
         3/MIIXJK1LZEZmJGwGGzyN/wifp/qiWrvoGX0CHY8XbE+rmOsoUQBDaoPZPS3EwUsQh8
         NmaC4K/wvUgE7+Tv4NSaXnTumyp/EC/NYZxAMFhCJOOsOv1/+RGI8jCkSyv9QxnPzkw4
         CP2/dNpntUeb3cFcmPRm2C9jKavWFlKKVOIv6lUcL/FTGYImIee8Q3g5lF1KPfTYNYC6
         JrrTWexZVgbqqmpYz6lmVu5SIE+GJC/iOm3lszcXuw7SoZM/YYWSq7zzZDqxy4Z6Tecw
         3QEA==
X-Gm-Message-State: APuU4Z+QT5Eje1hYeUaz1jA07Vr5mmiGlanQdxXaZbUQclzc5qcQTbaN
	pUCykY5l+so/R5rMgNCZXu9OFnxNyGDK26tXwcd/UvE84mXp1pKw2J+e
X-Gm-Gg: AZFdTZeTkqK8Kch/jDbevysScN47LTIj/CgiNVapt0CixZo9HSISxJZDhwRgXraZCS4
	q0DmOUr7gadlw5xVRYo/bZtdTmHj79pWHy4khiXccqx0VY5KlgJ3s3MpD8HbsRsCeZvcT0G5+I9
	ye3ljuJG5b2iWw/SMnFuXkLK5PMKL3Y8Nyp4Mv3kvuBZ1inuCOTo/unvvJZFTPJ5e17WBCHdR1w
	OwejApb0D8eVOluLJMVFSLE/cFw4Z7pvUkCH3PAG3ErEuA/USje3rZb79Iy88+8bv+qn97NizzH
	HDyYGtdM3i+DkElQXQWsgS8/xBvEyQyB17IsW8ZZf7vpWlJHWz+3mUfmQXM3nvc/uHz93IY4qyN
	wn3QuH/Q9omRTLiv/lfyz3ZecvcoD6IAYLM9Q8oCS2kYObkGV5rlOPQT1/UB3OEkbQe0EyP1lgT
	mMIPMzehQLTz/zu9kJz/7jxOe9OjAUvYZdFNzLMpAEgnZYK/68330MTvpgN6FQq2QBbhWtsr4i2
	ZUnAGF3OBrCDWbUrVeScJWFDCKoXi6R0VttA3Xh8QJ4cvDSWxiBHeeXeTSY0N3AODhosBuj2cN5
	zK0ytG6IhYlp+2st7eyAWH4kyD/9yw==
X-Received: by 2002:a17:90a:e705:b0:3ab:1b1c:8a70 with SMTP id 98e67ed59e1d1-3b41c938d83mr1968763a91.38.1795164310099;
        Fri, 20 Nov 2026 00:45:10 -0800 (PST)
Received: from [10.222.1.82] ([59.20.222.202])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad92c07sm3376049a91.13.2026.11.20.00.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 00:45:09 -0800 (PST)
Message-ID: <e0df1ec0-d6cc-4c5c-868f-cd490d252e9a@gmail.com>
Date: Fri, 20 Nov 2026 17:45:05 +0900
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120055248.913352689@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/26 2:58 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Hi, Greg:

7.3.6-rc2 successfully built and booted in my system without any notable
regressions.

Distribution: Gentoo Linux
Architecture: x86_64 (ASUS Zenbook UM3504DA)
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M

[    0.000000] Linux version 7.3.6-rc2-myllvm (user1@gentoo-zenbook)
(clang version 23.1.6, LLD 23.1.6) #1 SMP PREEMPT_DYNAMIC Fri Nov 20
17:29:11 KST 2026

Tested-by: Joungmin Lee <leejm516@gmail.com>

Best,
Joungmin
