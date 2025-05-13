Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8617724E01D
	for <patches@lists.linux.dev>; Tue, 13 May 2025 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747155572; cv=none; b=f12dAetE8Sjh4tNcAKjt2iiiTiZaMbyIq0GifWnv5CmBTQLWtDwvI7x8fqA8vOsfnjD5mKidr3edclcWEotj2HRBbj3NXMFGdBev1p+zkcDoWYgG1jFtjELpM44f8aTUVYlFjmW46b3WIclJW0hPT85/HwKRNShTHq4g4C9uFLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747155572; c=relaxed/simple;
	bh=JKn5JUNSPQnoUID7X6py4mf39Q8/q4+b7LFzorRC/YA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oJ9lQsNnzkOd1pdrOzTw7esW/05jwGMoBPx1Mw57Bmi8RmpGPrD2YX4WREzM/vRmuw0zZHoO0m6Vd2ecDCy8gaoewk3lSkd3wLCW2R6TOpqY+aXSVunssa0iy0+DebEd23Y7k0q96iwswWrPLMREc5gfXRVjHteQwrcZRYjgImo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CElTa12A; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CElTa12A"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a1f8c85562so2979980f8f.1
        for <patches@lists.linux.dev>; Tue, 13 May 2025 09:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747155569; x=1747760369; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RZjOMb5om57dmJRgoIxDIvEHKMEbYGpwwXOt5lNMlrw=;
        b=CElTa12AvLPVBzyiasv+2WFoLkQi4/kst5FFqncAIdMzED1j5L5R4EBlulKCLwDCQt
         xREOvWSntWhQWgyvpXnbg+Cx2bbfqbvpeqVpq9lJ1MOWaZL12QTxFS2NyyvYLwniMXOF
         Gm12FL7mLQsSkBRmWodpqggGhnqGAfQ1g2YlcE6insqewXH7b4kdfgR703hyaONMpK+Z
         oQ8a0OlIUzxwDvud9bH94OYVLZeBBe+ZRwZndHdYcJzRQzONWFzmS+CGFTnt+biL5Unm
         bEmylVG00o+NifCu8aBoMhziqYi+YkebapzV/wvo14rYxzUf/TLn3L4D3imUMrwuHNEu
         tmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747155569; x=1747760369;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RZjOMb5om57dmJRgoIxDIvEHKMEbYGpwwXOt5lNMlrw=;
        b=uOk9j9trpSA2fwVpV5dRzSG7/xTB/KSRbwwglJW8ipQW6rQDXixUKNJVYDLw2e5pXH
         2AxIgwToD4I8fuvCDRXVAbGiesl5C/+06zMLAllIoT2aA9zJI8at1Az1lhbCEDhZT6xC
         PskLKI04Jkjy7bXXhYSweWjx/vrR0Fr6kg6biz16Z0M4odA13R/4boPQxkG279OUVe0L
         ZGlX7gVR158cZaw0BVBFx7wCkP+dyaRnQFw9TrdtxRtK9fCQ+mP4I5AIhb44tBcgHwhm
         m9UwDhJMnXNRxyNPXkwZvnAFfRD0QBAFl7Vj2EGgRtxl+kS2t9kLeVAYic30IWmL2xXB
         msug==
X-Gm-Message-State: AOJu0YwjwwHYpCl6WIg0VECm+Nu+TjEj8fPEFXMwfU9OS+fBE9Ly9cxJ
	VGskeBeBRu0g9+cR6cwnorNRznu9acadfLMgEnCt1bw7fxasZXc=
X-Gm-Gg: ASbGncvWmKEz3KU0Xq0Laz83//RLboJV/dBv1BD2vnTcl0JuW30L/4voKQAtkQjFsg+
	ZNG+Ux1HJYhejI/lu+T+afxLGAdaPkqsztaYeU6Hp0CPSG+BsijQ9XZl4zVgsUy8jdMMx7PKHZt
	RKs+25IwpWSnktYOoZIa1oBaDFfL40dhHKffE0dCFh85CynFLeXI9xOiFz7oU73PWIZ2YNbs1Jl
	b1XTMzfDSGRRSU0WUGmX1BwxWjOqL9bWe/ylQ6h5ag4yriBnQY7JC+LB9xJNCQ2ZdzUSt41vQ9Y
	0jz1FeVVI9OB2D0tAN5CRgkx2oqngmw7+hsswMbWj1PJfRtYR0sZgtVI+eMKR8jXwhkt94HpOa3
	yjW8I6QKcqRYU442vXCv9sjVBUHE=
X-Google-Smtp-Source: AGHT+IFhwISbP27MyrHpLdvwM3SbZp+KgRuLNu2E6DunVvbQvlOIlBVqXXd3IdXUeECrOpl7XSpB9w==
X-Received: by 2002:a05:6000:1445:b0:3a2:ffbe:89d5 with SMTP id ffacd0b85a97d-3a34991e01bmr14060f8f.43.1747155568548;
        Tue, 13 May 2025 09:59:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac006.dip0.t-ipconnect.de. [91.42.192.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2cf1bsm17013992f8f.72.2025.05.13.09.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 09:59:27 -0700 (PDT)
Message-ID: <17062792-a294-4eaf-b827-22785940957b@googlemail.com>
Date: Tue, 13 May 2025 18:59:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172041.624042835@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.05.2025 um 19:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
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
