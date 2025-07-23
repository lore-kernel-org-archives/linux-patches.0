Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986D7281366
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 08:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753260267; cv=none; b=VgKoYAj9ZxhmzpIAl42gteajknqBotEcOKmG3nJ/O0kzhP3wE1LIFpC4JcQpdxdXl83oOqKtqL8Q49k8aSJbazH1FGDV3BBGtCrDkWsFmWc5/bt4AmyBfUy0UWBjKz2YLpLHoPLaxU8kSnPjX0lXHBn2TOhyjyEP6t7iT0Rds+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753260267; c=relaxed/simple;
	bh=DgxWQJW5l4LePsfcKPDjk3i/+2FITa3Jht3/1E+WjsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TNypWE+IrzEmU65lL6LlXrEGsoVbxkfp6eQPAEvwcgqllIXptWcm62nzsjMBbw2Vi2UIjvjKHMYpSngVZaX6e+colB7jqEOG9Eax2OqyGFle9grkcebd0OKUCp0Trv00iWjkf7IDtjP3Amt8zo62k1XX+BLlhpHSMu8g18VAIIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fBArNI+C; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fBArNI+C"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-456108bf94bso45350465e9.0
        for <patches@lists.linux.dev>; Wed, 23 Jul 2025 01:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753260264; x=1753865064; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZHJOQcM1lG84uA4i35JDleDtG0EIf41km2GDbzT/6cA=;
        b=fBArNI+CKVAeQcxoVN85wbPF/nQRJ6nuDUsy36q9e235nsX1RGYlr1B7LlbZM/dR4J
         xZHh4+lQ3BcPX+ReLbpMPlbP4vv5Q8uEAdR0rloIKXfFOFbBjT2zJ2F6mE8rP1n9Vnnm
         Jv6i1vLdWUoHSPh/ySz06rckOieEDU+Fd0wvkYCI9vgosjSI9jOc0NxzBVMw3kBQMAHt
         cvgpcG1W9+YLwOC+bmT03M2LCyM2v0CPQ7DzXrRu5Rn//zOtdn68IgLT/xzxfzxAp/qb
         9r+qv71+c0ZV+tejDcVNg5QkpXUptMEQotM/UvhhboMy+J7ebg/Z8iinh8j2oqZZ3JDW
         yG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753260264; x=1753865064;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHJOQcM1lG84uA4i35JDleDtG0EIf41km2GDbzT/6cA=;
        b=vvr15Evi7z15O1YjFEDOLkCA9RYOtUjclgZ+iEFVgXd4kGeSD1TgbHEIGUuAsrzfef
         Nq2pJNq2erzDA97kO7GEkfBDUR0TZ5He/R0tI8rCdgXDYcrvvQA0Lq7O5/TrfMVxshBw
         ZEQDtN8NACV0XmtNfpkcwSKNEACXRhVgdJGoUEI4ZR/Zlz81QhqbH9nHNSA0NI95jriR
         xWvqJ08ImXM5Ndw0cqvrz2kTrdHXgxLCQZKmBa3CRCZv2AvGViDLR/AASRJSM1R+tMMk
         iG2L0MMfq1KskU32soJPbs6lrSu5XeiNOweYw0j9790Wvv9fVb2Cz3Jw3EcMqNh/8HKu
         RXvQ==
X-Gm-Message-State: AOJu0YzQP/6MuETxuxvZ6QJ2J0PVXiQy4/t3lNwyT2SetUCx1jpiet4w
	8VZgGUWDnqFB0lu+lBYAvAD8Y7hM5roOoUwS0mmmWzGuqF/dweBkb9s=
X-Gm-Gg: ASbGncsxoyuKiIkdhuYpGubu3xluiTHVXLRlRoWmT+boGBEu48YJP4HnkfbJyc90Jhq
	ysGM2waTCYXZXGNSWfyQsaDxm+aWoSbS/Jnr6k2V+/P5sd8CPm/bq2+pudWqLtiFp3cGAOEVNmk
	wwQpmO8mhgs9+iQKP9MMh33Y470mDL4ujRDowvm4K4yAsgJVWQDm8drvNJYjxt3lDtlkut9EQzC
	AKWtEtCCZZwQjzGjEcuk48rufv2HGbxXKT5ncU/8KFaPhvqFfss14JlzoVS/tV5j8EHI/s/IHuD
	goQ2nXYaSVguEL762VYYYrQfKywtf/5DuEEMRSDP+BaH7omTGalllw3zHiqtDPWsLoshaHOKJhi
	5Pce3uYuqLIbWYM0yauxANUvIKo7MTR5P9WmmgEXiIYzkTmgITZKNE4TGhAZvrIUalmQLz1gt1O
	8x
X-Google-Smtp-Source: AGHT+IFZfB8IgD+HLvld7HTIKQ+DyeqVqAVunEW+9LuQWRwpmq2NB0dRTMuV1a5xK4ZAPv1csjbddw==
X-Received: by 2002:a05:600c:450b:b0:456:1abd:fcfc with SMTP id 5b1f17b1804b1-45868d304cemr15087635e9.25.1753260263563;
        Wed, 23 Jul 2025 01:44:23 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac7d3.dip0.t-ipconnect.de. [91.42.199.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458691abc62sm15924465e9.26.2025.07.23.01.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 01:44:22 -0700 (PDT)
Message-ID: <14340824-5434-49d2-9d23-860cc3e28948@googlemail.com>
Date: Wed, 23 Jul 2025 10:44:21 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134345.761035548@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2025 um 15:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
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
