Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B691E31ED70
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094557; cv=none; b=YhqnlAETHRtfFswNOSwoZ1OGDQMYXu2x+Vj8N62HvjEDenhUTQ785xA3/0vEXbVsssMhMXx5prEVu70u9t0IOoms7843llLG23PzSnLIIfbYPDeoQ458pqPWgr5guOqemwsUhH1ZAM+lUCtxXrkm78U+MgUZ0u2f8eq3NI+cxj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094557; c=relaxed/simple;
	bh=kyEswixmvM/2R47ee1U1Zr18TYgwgtQzWQ+AwQwssus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aZU0myjd5DU6QtjLoynjaL8iJwMzL+cxqaaQi6LLkJ/XngSaxNtluJjirrjZ8xBuNLvsJxa5dmUtb+z/uZOFzOUhXpvtqxHq9vSFeVYA+0ZvQwrYC7kAQK95qdJ27KhCVEmmDNsreDq+9X537gPB3Mgmou8vdIdC1X2svQOSBs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kMUmEnwd; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kMUmEnwd"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-432d256c2e6so1019212f8f.3
        for <patches@lists.linux.dev>; Thu, 22 Jan 2026 07:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1769094554; x=1769699354; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7HEkV9VzWvAzp4mpcZik2rJYLi6Ex4JtD0e9P4ovCps=;
        b=kMUmEnwdc88fnRFUK3/SgL0vrvKqKPwfru63HGXuwwTqOCIBeuOqNurP/DCFt/qWhC
         sxijvZnSlTPvaqE6/nS5QmMZdl58A911q2H7ustfxnsIot/3sYGq2p6SMnheXb7tz4Gj
         R0oHD2OwLFhNePa6JaEi+2dIPh2KSmhg274+sKksButQyS7kvB1CZdgZvMn8hZhxSdJ5
         TOZCFJWxxCL0LZbYiDjCIVPbkfsEO6MybhaxxKk5xcn91TwIF25e0/DE90LL1P2m0o4k
         Lb8veeKSnMR4V9IA/Om9I6Dw+qFaQLAOYYOaLCBL4dGBf2K5NR9v6fjmGUX9bs3kwCdv
         nnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094554; x=1769699354;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7HEkV9VzWvAzp4mpcZik2rJYLi6Ex4JtD0e9P4ovCps=;
        b=C3THCwmEnE6EcuSRGG6MKt2qKkM/1vC8QrAeYwvC4xOoee1xSZQstka/x+tc/iaj+j
         oP8bPB3WiMX/81WiIBffDA7ccFlkeUIH7FnCrDl/Zrt4C3jgKWz3l3jX9CcP2FMsJlve
         tu95KnxowlHCgyJgF//VYg7joHyd7qcQ5wfRpxDqgf54EIMo1dVnFqA5bzdlHBJfUSHi
         f5LvOKf01DYiVXrBIXOg2gXtHQQkWdAmTPoafB/Swoo1KdD9P3qu7TFJTKU9W9IJz7pP
         Gbj0CiBavydGcqdyHRWJc2T+8IaLuBzGgJUaLh0V9RY1fdgs0O4eT4Hmn8lS5CU7yZDn
         eGSw==
X-Gm-Message-State: AOJu0Ywfz9sW6aPgOONKM+TrisDb4tR5Ly7O+wx+1UB8GAGaiB1s4MqX
	Oh83jUyC0ClchUReoeLwIdqqKZOMUE7XWBAB1dC0bPFuFuaTi07I+pk=
X-Gm-Gg: AZuq6aKfW6cHbtk/krVC1UM9ZuT79VE/PewAm2mBV2EHqQ7PTgxCHRCzU/mS6lKrkG6
	3xHnZ8ECJ+HqY00lYBkSka2CzwoVF13w9fub0q1pV0zkAPz/mKZ7OPWI19YNgLt9ZmocE1aACbS
	B28qxE8/wN/2fWYxH794D+wMnGrmRccxl4S8H86WlBd9DHd5VjSghREmH3Q5yDugRGZ22pavPgQ
	Q1NkOSO5WUpJyv2OyrnkgzUGrnH36AR2cP0P8JA4jknp3hlLeB7/Zwu12q8+xMR8Sjg2rBEq3FC
	yDlbrVNdm8m4bDAJFCLJ+LH3X5uA9rbB99KFx4tWvYlHt/HGYZW+bnU1wWYnaIwRGutW+qh1FDw
	u2bdFcxe4Fsl49n6lMiXGpxC+BCjqC3diTB6TvQi7xgHVzco12YxJxCxjJsdBY1JPOKQIfFJ1zF
	xtufWOiIWh2VzcT/okMmzBQTsmDD4ZELiLrsvl19FArThAXsfzO/s559tWIexX53M=
X-Received: by 2002:a05:6000:2f81:b0:430:feb3:f5ae with SMTP id ffacd0b85a97d-4358ff3988bmr14224782f8f.55.1769094553461;
        Thu, 22 Jan 2026 07:09:13 -0800 (PST)
Received: from [192.168.1.3] (p5b2b44b4.dip0.t-ipconnect.de. [91.43.68.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356992211dsm45679808f8f.7.2026.01.22.07.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 07:09:12 -0800 (PST)
Message-ID: <2385bc6a-6b2f-47fd-a376-fcaff53eb232@googlemail.com>
Date: Thu, 22 Jan 2026 16:09:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260121181411.452263583@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.01.2026 um 19:14 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
