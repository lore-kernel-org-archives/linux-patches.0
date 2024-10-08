Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788381DF745
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728401225; cv=none; b=WtTkzg9n2SEnf325ZUOpxr6kTd4FFtx7/Q8PlXrElUpViJwb8zZzoWqjZh7a4ev7kgCtJbhYw5LjEoKE1rCzsWvAL8KBQYz/GdMYPwSdURqxzuUUO1cqgS1qKWz8svaFWe5ZeNzMdHkYc6sUNXJWDvS2Ys8g7QC3JgP+wDFdbZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728401225; c=relaxed/simple;
	bh=7zIVHXrGUFUQeGA3JsB1jGUISzgxJSyZ2/hsJJ6T0s0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gU4I9Icra/W6DVcarb1MoZBaJhqi1cDy9RvIjKL2BaL0Q4aWY2Jgfyc9B3+WymlgR2Evj0LT72lVAQlCzLVVJ+ukLqrBclfVQvz3zNPX6M7OstPlhF0Kx5ubgEWharMuYqxJAowz/A3xqG03gkpxUlqjCjgHtLb+zPOCs10SNEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kVtyDp4X; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kVtyDp4X"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37cc60c9838so3335439f8f.1
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 08:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1728401222; x=1729006022; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fx33b0Vst6rr/13H3aLmQkWWcQZszdz1hSN+fgduKMQ=;
        b=kVtyDp4XfhOG+03KBF2sfEtzoHJ4hcl3A2j/gU+B9N9x+6DQdq18XEDzogDlYbD0PF
         qctjRP/DusFlQEkOzd7fY3XbhEKp3+bdssqLBQHDn5//hY3URX34zrG9fsz/ShNAKPcg
         jOvVAgWe76KTOzeryB2rqiwHlRsekBWl3Nn5d93/Ec7rusG+gCWi5pFsVauZc/CV8HW0
         zYBK+O/po/NOqCu+PVhNYbmXH8D/5Nd08q2brzKhoBY70UXHr6GA0QXZWHTVG7tQz4A+
         3hMaLLbkTKjJNOzeZy4pxzRuwCrKQksenBU130f5AqGaRZUkvIC9o8aDMMEywxxKVQl1
         kDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728401222; x=1729006022;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fx33b0Vst6rr/13H3aLmQkWWcQZszdz1hSN+fgduKMQ=;
        b=AWAoU/0Cg/YzHdG3McmAbaKobYHigknxzM3BPJi3MJRO2a7q9V5+xcmJMnscnw8p5W
         l0IG30Seu3ewUjce9FJaVTtCeJwYceOG5Bt2wIvxsdgnNXp+ZkMLiSZSmTKU8SElyRBh
         FmTuzow5t75e1Klz85REXM2H6NYGqX9aptUUPECFFK8bjnmMrDTtE2Z392q7csyn6L+B
         239yvs740CPl12MKy++xK+CL53NbbrPtQJxUjkm8MSpMN06H1ymuBtz7r1m6UJBpChJF
         l9LUJgWmHxmihDlwMv7qnC9fUPAGt/6VDAf4bHfKZqI2M+C/7uvsZSXYUPa3Cumu6zha
         guiw==
X-Gm-Message-State: AOJu0YyebtBj6/apzep8DQzXOkc2FGKsDJLqOuVgoY8nMXH3nhxU2d9o
	DVMwU+Tq5llx6ushXI2Ii7ggHaIfQW7yPmn3IMZ9TvuTpqSuQWc=
X-Google-Smtp-Source: AGHT+IH7j0waETH9wpacj2LEJiLemxRMnh5ZTXtQiF8a7MTObAsoTJwfxQhdiBU/g+FLlm0ThCd//Q==
X-Received: by 2002:a5d:4150:0:b0:36b:5d86:d885 with SMTP id ffacd0b85a97d-37d29350cdemr2497525f8f.24.1728401221524;
        Tue, 08 Oct 2024 08:27:01 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4723.dip0.t-ipconnect.de. [91.43.71.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d1695e8aasm8338609f8f.78.2024.10.08.08.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 08:27:00 -0700 (PDT)
Message-ID: <7f46f38d-c1e4-4a07-8694-cc7a2ff0f992@googlemail.com>
Date: Tue, 8 Oct 2024 17:26:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241008115702.214071228@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.10.2024 um 14:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
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
