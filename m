Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BA12E1751
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756227676; cv=none; b=YJDt85GUhFSE1FOhSCuuAsqsoK/UuYzayUvTpd15FN3JC6z9QrtobwTCDCGd2jC/TcedOgYlmxwbmo9xl+rgJXU/CUr/COikWKCC3zxU+8KvgCWYlMYRoLhS8NxbPa2jU4rNp5ZN9KUkdGgdieBUv58KgFj0xjPbcY4CCj+vybY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756227676; c=relaxed/simple;
	bh=HRifJIP/Z9yEEq8qLSuxjRS6ewHNIcIRi/KyeKw5kpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0F7IRw9xvh6PUihG5KCKa8ejhJt09+3kAhgQleMmDmgIZgbZ306gEW80DEWsJ1TZ3zmdtrRJ9ItFIIfNYMCTXXYa2iWB5fZrYuzgkZe2zHKpvMsURtanF7Ry0dc2WZs4nPFXycJsUOVAQ9dZqJs7UTD2FVx4+nb5mUo2fkIf7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TU6hM+4+; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TU6hM+4+"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7e864c4615aso8781485a.1
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 10:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756227669; x=1756832469; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bRKzh8DIPbKcCybC/7E+dyvw8PR5kUzlHb1wJjTVXtc=;
        b=TU6hM+4+3Lr1id68dcJrRE7CgQLDAz5KwKVyQboDkCdspToMV5Mps+CY6tqytCAZtz
         zA3j0XuKfjoGJED2M1fEES03+1XZtWPiqM09sdyDi5zRkU7zUhRjpWxhQuHsNz28vRl8
         7Qixe4lK7ztaNeL5aGqCuQK1MRuhscyoa7z+wxwjN9c/pZNPBUbMlusfGbFU/GnH+7qO
         xFyTkAkW3JZuA95VthgAaM+53iPDgyssVJDOimQDPawb1AxbUjG4iXzhT+bL1Da/ydbF
         k6HG/6CVzzPh0e8cxWO1RfrOPGqUEjz17WZDZcSJ5eMiHNAb5cp2rXtNMKmoVcpesHD1
         oLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756227669; x=1756832469;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRKzh8DIPbKcCybC/7E+dyvw8PR5kUzlHb1wJjTVXtc=;
        b=t/BV9u/8idkKFPOZ19KIsJZdFC4HNSktQaKPCRhstLMOO2v6OgGlikS6OyOKXYAWYM
         2N6ZpatUefyXXXPvRokOgLM6SmbwrQpMwzYE+qxec4wgkm0ykiR8k1BFO+2zBcSl9lxJ
         Pnmyfr8s80ysQujX+/HQotjB2sE1+JvNFXxTlCRFMo+VoTYyfvaka47m5oK3HsY3Dwsh
         Bs1dAp81OhqZpkp8BRGUlNGRn4cMPJ2iunw/HZMm47OyiR/MMmfnfUmqKk3Y77xFSbT9
         BNhZQBTSey3U5rklGB9Z+eI+/KDI00b8flNPwgInfCY6Lx/GuomrvADYOeghpwEBduYB
         MroA==
X-Gm-Message-State: AOJu0Yz3X4eFoaz8+83rUBop+2nL0CWrYbjXb9bdZatZvsG6KCbR6LST
	Q3zxKVZmtld2po9+zu4otzD2nDIgQZ8+A4ltNtAsAAwNmKHX0FSWtE3a
X-Gm-Gg: ASbGncu+y2W8i7f+fyBhb2MJndg2KlZo/7Q0lIcrl3gxvZz0UXbQZo91avQBnOCes1q
	zKxdOnF777C0NEpqMV70Kr/m+92vVzAmfT1XdTXe6hd3DiI3I7wW91fv59qkwuq95k5BB4OAWXG
	tMoQR4dDZjQ455Y97mCENOfk0R6AtkkcRdcv2bwlBfCDlQS8UfdGwcWJ44iKtlFFFjIYSL6woRR
	N4Sjr39KfvU0ov2Vw/5DfP8D6oskYf2PinmCHsI279QPkBsZttiiAkLjMbjyz0BvLaDBB0mJgLp
	JnE6+PA2gc2FG3RJMB+rSmbe9jgpNGDOi3/wO2ipW4GzaYUIB0eKoJUwuq1okPz+qwIK/VUZ1Ul
	Hc7PaHceIygKq3A+uLcWvwTKrkoBtGeAPBurQUJyroFQamM5tlg==
X-Google-Smtp-Source: AGHT+IGS31cqYP5qKxZxREBI9B65V6SJqeHAo2pQrB62oGzvSihthY+MMIVPs9uAGaBgVXdtGCuKbA==
X-Received: by 2002:a05:620a:7101:b0:7ed:92c8:7d16 with SMTP id af79cd13be357-7f58d941f59mr264859585a.31.1756227668309;
        Tue, 26 Aug 2025 10:01:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebee415f6dsm719225285a.27.2025.08.26.10.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 10:01:07 -0700 (PDT)
Message-ID: <7415b3ac-cff8-4dbc-a4a4-a483e1435564@gmail.com>
Date: Tue, 26 Aug 2025 10:01:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/403] 5.4.297-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250826110905.607690791@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/25 04:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.297 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.297-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
