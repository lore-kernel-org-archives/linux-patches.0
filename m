Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B2110F4
	for <patches@lists.linux.dev>; Sat,  8 Feb 2025 02:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982626; cv=none; b=akQpE5XKtck5gabVBm3FFGcOUPP5nAruR4o0PS1LUiJHpjq+ax15e3pWqktH/+MHd07QNMYS/0e61UDCIcXi4CAkbz+5SMMy9iVdtRcmkPQOarBrmLxunPR8/omfH2t45ramSh71EcB+PLpesZcms/ogyOXeAdU5UURRcHLvI4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982626; c=relaxed/simple;
	bh=1yRZEVogkK7XQDQbmp2eIIgRmMSs3XbAGXlfU20Jpt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I0FZrBf6fi7zRMNY2Zjjm801pv/MfbDtPbxOKH/7zL1eBoXPlVZ7ZPb16NggOSfrcTW3n7VXee90MirWVdb3SxN5YxmfPTA+hQvjKM+MSTjou2/OEzfS1yjlLQEeIexe44QTK1xo660iyZ54q13/bYfLVvDDnC2tl+v3qnqBgU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Os337oBx; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Os337oBx"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43621d27adeso18177395e9.2
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 18:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738982623; x=1739587423; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Q96w3VhI1OyM0iRg0iyUAghNaFOtqrMksaCmsOLmiE=;
        b=Os337oBxALJHEEH3jut3rhcYTYRNVZPvAeyfgRqlrwHkaAUU/k/IMeLVj83ORep5eP
         dLvk5ePZahRV5uopb2piq/I+JBUknBvXGF9y9SBoKj5YPy0yULuRcUPp8D0X2xt0Iahy
         mu7UH9RZaXVtf0vgdhE0fYWwAV3h9Ix+59CMWGBNscCZjgXZwXJZCVmESkgP/sO7odBA
         JI8YIZp3t/PSVVjOHaQAiHUeZYiJOdtxlXq/zsTN+Tuspxx4K3QWJxuSvXj1xwxOddrd
         GF6KoEbOOsCXbaw1BDxHIHkZJBpH+jBm/VfZLq4dnQvMDD3RZDhysWcTqcyNU1DUcU4/
         MMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738982623; x=1739587423;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Q96w3VhI1OyM0iRg0iyUAghNaFOtqrMksaCmsOLmiE=;
        b=CCpGNfINHIX8BWNq6tcKr6UcZiWqx+6aHtSWVnx1HOt12KLYKfrU1DxZsnY+W2YQMO
         hYCk7DzSaMBX4h0OA2YNSOFV0ZVaTfaOAyXw1GVK/tNOw1fPz14t0k+1jMmtsRIsPwWC
         +besAuc/xW4uwWBdFtvnuC9CDf2OcqQdo8aEkz6bTcZ76JKgD8evm1wChEyxM+gDyORO
         MwkGMBFS0aGWNh3B6FxskKSbtLH+ouRNnebjz7t0pNX6uUQqK5O7pI1wwYsxhCCwdvE/
         FlB/A2sn06AK1s7daN9u6+8iwHyNEOA9jApAlmo0L7elrGho3BOF/Ps9K6jJSntvkAXl
         Kv8Q==
X-Gm-Message-State: AOJu0YwucBSkcw+3EAT4wbNz/oZ8dMgIfwMs6ryz0TY4iYFTxuP46Xez
	wRFrh+jEFPVwW2xJrgz08HZSb0N+UQsiwjtBEUTENDGuU9Sylgg=
X-Gm-Gg: ASbGncuc81VVf1eE1o+JeqkrcbqciDEzNLQK0CpsF/YLdebFJpUpnfHia6bpNEtmOU7
	i2Exm62c3lLm3ftdI50U0198nb99lkoSEbwpSvC9vR5iKfXphmEdmkS+quHV7wn1lOzhWHFuHvs
	4bdQfvUEjD0snwWEY/czMLSQ++JgRVMxjoHlI55QWy8DVNrjGTPvjilmF/I9kic5mWazIw4Zz34
	de+a14mxkgaMWZq5NiyT163iM6wtgCEKOeIkRpnItUgSIymly4qzIFCBEPMZz7arQmVK9wjNCbC
	gH872ZscbdyY8ca+QTlxYD9n42cKU5LidyvBIapXvg3JnnwEWdzZ85ZuzjFCZdJPLUbd
X-Google-Smtp-Source: AGHT+IH2AAb7mKYtGgCklY/ZnYB6GdOFP0u3p7Xp7Xg+7rObcCTVDk9IjDCBVs8nQ0emmciHy27c0w==
X-Received: by 2002:a05:600c:5492:b0:438:a214:52f4 with SMTP id 5b1f17b1804b1-439249c3836mr36026495e9.25.1738982622819;
        Fri, 07 Feb 2025 18:43:42 -0800 (PST)
Received: from [192.168.1.3] (p5b0574a7.dip0.t-ipconnect.de. [91.5.116.167])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391dfc87desm70748545e9.25.2025.02.07.18.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 18:43:41 -0800 (PST)
Message-ID: <201f2658-68bf-44b1-9092-7b8119e91f9b@googlemail.com>
Date: Sat, 8 Feb 2025 03:43:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/583] 6.12.13-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250206160711.563887287@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250206160711.563887287@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.02.2025 um 17:11 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 583 patches in this series, all will be posted as a response
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
