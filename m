Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65574221540
	for <patches@lists.linux.dev>; Thu,  8 May 2025 12:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708958; cv=none; b=DGMT/reV2WctrcLtTd8g4Pnb7e0jdIqoXXuVqD+W1F40+5Z7qz/sQO7j91jHZvu0utw6nhI0G2w190Fgb0dCguqd98g8rrt2/xjPf/FdQS/y+gaNeM+BENJCgkObF9ewqhazN6rpQ5tY+4LCIR3pt8nPVpWcnqkZryMw2Et98dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708958; c=relaxed/simple;
	bh=P2hkK24gIBpekWVgzbZvUT9UAOj3974Lm4QOgZm4MU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F9+fXCi42XBTkWYor+Tx1hGkZ3P98pAH+Rc8AHPDflIrT8YJdxXiIr6dCgy2PFTWUTvgdA5MIwBR0C8YA7BSBaxn1KONijQuewdiwODVDK04KVD0Vt3c+b/eVYHqkMnny9YrVquobVCwPMAjpHdXQZ1ZT37J/3vb/MuZWBtARO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=L/LhXeLw; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="L/LhXeLw"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a0be50048eso384842f8f.0
        for <patches@lists.linux.dev>; Thu, 08 May 2025 05:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1746708955; x=1747313755; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p6AYNVAEWLWzZVYwdSbhFHON7qW08tK4r17ya22Q5uQ=;
        b=L/LhXeLw6XodZJaIctOaD3m5mXnsojSO6FIEey1BroZ9EznsJgz4U+9s5aUnUVc7Au
         k92CEExajvB4goWPk7XwxucZPkeobBjCSSxkHzfVV6j0JQ9xIRqMXNf262WtOEPYmonG
         rkRDrDzxfr6S7fKY5x0e3v4UooRO1DRmfssKxQC/ZZQkOMTi8FdKr+7m3UaOSuCmPXn3
         ZuJe1TmKf6RJVwvZcGZMvFFXPA8s+fktcdleYUpWejs0JowFMf/8OSQWP8lt3nSYJQba
         sDNkT0ErMBFLQoIzOarl3hLb+HrRJP7WgUAWQYofLCU4StNTi2YTi8Wq6K3+SV+CuAT3
         0E+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746708955; x=1747313755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p6AYNVAEWLWzZVYwdSbhFHON7qW08tK4r17ya22Q5uQ=;
        b=BVLvfmGVhjOTIJBZSxoKK9RUXcsJWMM3QBOPT6tgGwCCipWRI6BLKpAtsBg6NT3s3G
         PD7mlHN1oExMafYyW/kk3jMzCmlM4G7osF+7DKdtX0mTjQvJmLyt4e2VQ3L/QKqqrRsq
         BKyFFXhJMUZ1VwdSesQsKkCBfpwS4nitSfw8VY3VWpLoCq0ImA0/+PF4M4MCYZEMvhTZ
         s4rtrfdJLTZtNphWbVQFouHVboTD4D+s+C1hnAFdkyKybJlZOHifMPTYvVJzs+04mWRZ
         Y3vzI49ApT3XBMxPsQEw4rwwcDbLfV/Llq9lX8dORmyV2+OSEUC0R9kOt626DhfDFPS8
         xC6Q==
X-Gm-Message-State: AOJu0YwPZOQnGEog21NXm2HH01N4jP0HVOs5uPA2hs+aA2KG68GNh5XW
	7afQ3gHf6qlzFcDkuBR2EPmNKQqOAIKEnh19jIy4ZQ/3D9S6MwQ=
X-Gm-Gg: ASbGncva2xMuwh2A72+qdjQXRAen6q5hzslv8ibP+s/NXbid+A4saQXCnYGBphhH1sB
	q7lt67gBEnGTE5CcphC90I+jbTeAEKjI3QbmJDOVH2SaA01fqogfMBart98mt81v4xllbN+8HyD
	Xi/AOWNjM2bTxKrOZLDHztV6GO9rS4oPLQQ0rfquzm0xbhceIq/NC0r0pQbKYdSGij9UPlDJu6g
	BZ5j42HDkCNbkFsTb/nny6of1LpKLa5uLDUOlh6DIIzAMMgkX2dVLbbu33/t9LqpMI5vHZHFkqr
	tPLjRELZPOF/EbcRWaaqCQN+wNdduNBleU4vBW8fr32Mw1jNNqFHu6QBB1WsaqMuQ+72OHwu/3Y
	tcZ5f7RBcdhz9xtDqfA==
X-Google-Smtp-Source: AGHT+IGTa2WWD3VgWj+uKDTBuDUhX771kiVc7NX3oQrzYhOmASsrPcy1MfhL6cDIuvZ78Xz9Lvk9Tg==
X-Received: by 2002:a05:6000:184d:b0:39c:30d9:3b5c with SMTP id ffacd0b85a97d-3a0ba0efbf9mr2488623f8f.39.1746708954465;
        Thu, 08 May 2025 05:55:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b05727d.dip0.t-ipconnect.de. [91.5.114.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a0b9af4ba1sm2897233f8f.59.2025.05.08.05.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 05:55:53 -0700 (PDT)
Message-ID: <384739cf-4b2b-4c4c-81e6-19d4547dd395@googlemail.com>
Date: Thu, 8 May 2025 14:55:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250508112609.711621924@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250508112609.711621924@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.05.2025 um 13:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
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
