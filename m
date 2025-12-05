Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875E2DAFAA
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 05:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764911338; cv=none; b=obUSq0VwTDQAfvisyIGCk4ryGItTxSibGU5Mp9yDsOevaN1NfMd+AdcSrg4+XWJcX1/o6UQbtqf1bA1ipN1m9K08Vj/ZAoN6H5Y1yg4trloSqkT/zyzOZ2RGyDmPEqJj6QQae61qOcoX9J6Xd6+05hCjIxqKlUUjA9ygap6yE9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764911338; c=relaxed/simple;
	bh=0mosFK9wUrWmPpbImUrx67eiKJ87H4+FqqaRIiZgNIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGhvL7EAsUgY41/n966xwLGCw6pPc6fJNcJDyvnf6nFgcTzIGm1MUDFk1FfhMr+1nzqlj3JkZh+w4TZESSBPIOlA3J0Agni+78XptI+rNPFa0PaRUVs5SM/T158JswrVM9oJbBSkvmU4K5G29lYeKYtx1+IzDCAZeT+HsAm8LlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZNoFu3ks; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZNoFu3ks"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47795f6f5c0so11301035e9.1
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 21:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1764911335; x=1765516135; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qQ/QcU+pdySkeU/ShhAyFWrRXwd2eVI/9oBv8X3jXNM=;
        b=ZNoFu3ksnvASBTHRGd0NoMthvRoZZCskYcX5ud+3Sngi+MLhUPv4qLLvGJVzECKR+N
         H5vV+8eQnMmZioDvqg4XU2mSw+hujz6RC6s32rf93JIkXbk2iLrpF2p4dG06dHHcqRyB
         kWbea7GQUY3Q2cYSh8KYM2vuI5WAD/k9IfHy+h5Z46sWTHJknptgp08z/40QS0OAMwdj
         hlnxvxrAEeHfEcZgVU3cPwcCSW8BOf/YHlclaaVWw7qFgRTWET32Z1MjP7qLCXgyJ2uJ
         mQIz5ntCdhsNetds4S2PkFNGhwd6voncOpAJ32RIPHCh4QcTNZm7E8Xbcr9P50GH6k47
         renw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764911335; x=1765516135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qQ/QcU+pdySkeU/ShhAyFWrRXwd2eVI/9oBv8X3jXNM=;
        b=KV1u6RNY7kFHGUqqeaz+NteCuuBir24xJMjBCt6PWp3OCtQUPk4Zpxf9ftdwn/iIpF
         72s1LD2sppet/zwbuxfQJOYEcyGml4Jg1hbhQPqo31T3sV8OFWmoS9xjQT4UZ+9quKuk
         Zd6mmKAObA9HTzQrj0n0ADMWNrBb4ZALqEcDLQEYRM1aNvAQqDafX6XE3W1O7pCAns30
         M77jYVqPA574C9r8WyuhWhHybeEUIy3CgmVCXQUMnwh8dYLNrHkmFQ5BeC6qKWN/tLjX
         oLQ8Cr41j9hpWTJwvZmlMx5KMs0fG0ddXmS69JAex9g3oyaFwv+KoT5gGZTzwUbFlk5K
         A4Ig==
X-Gm-Message-State: AOJu0YycxcTsGjL5Er5IYuZ+Efq5ucf9Sybw2l0x90XEIsomPsw5rlAS
	1TK+BXivvBKEt+WQgXbNK6T4UQSa+tm8W5ST5TM82TTGAtIdw/CzV0E=
X-Gm-Gg: ASbGncvPqQqvsSQDmM0f3scHF5yJ/fv2upyTwGGdwusCqVnhStZFFzq47IiKevLdBtE
	pmLjxQZfb6aNp3+qjXgWvbZhWCFh8yFaNErRH3+C3n7yw1C4mesKUDYKdMXX5Gp0RXu/5qJ7GCs
	+sdxIFcGwPZ1rRdFzTpHbnFpwDz9aATYcGRbHK0vCHf1tNXlFGUknTmqhlL8NaKN4YWf158bXOY
	r1PD13NtpFTFV1NW97CvC0Oxm77OWOcry74hw54VsanNOLuH1/PGMPS5HsPzUL7ySceTzYKsJqO
	HFwhh1RTi2NYkFk5Tzg+CvaebDWb/6tPef6vbtD0ZQwaLLbqOE2A43rxoyfvb1KcFtlf1l+Izu8
	bpJLsnb8BRj68Y2obWY5VAU9T21st+6JCZ8izYhIUcqta0fv9P08AFZ7nJAtEnkRvGNv6jO7wR1
	eFUcmHmwvLo9sFWks04j7CL5Qr/GpTrWzFdE7ncZVGBd7nsECckgs2yRcJGFryXWCOBCLUR2YP7
	A==
X-Google-Smtp-Source: AGHT+IFuy+KM+jSzlsBMxRWNLMk24D+Ii3BDvGvDvIPansVEZ/vl5jS5fISZUowndW7O7145yPP0Vw==
X-Received: by 2002:a05:600c:1ca4:b0:477:63dc:be00 with SMTP id 5b1f17b1804b1-4792af404d2mr91038825e9.25.1764911334883;
        Thu, 04 Dec 2025 21:08:54 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac20f.dip0.t-ipconnect.de. [91.42.194.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479311e7142sm64715515e9.11.2025.12.04.21.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 21:08:54 -0800 (PST)
Message-ID: <36a31d9d-cb38-43db-94d1-d40129ca4bc9@googlemail.com>
Date: Fri, 5 Dec 2025 06:08:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/567] 6.1.159-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251204163841.693429967@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251204163841.693429967@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.12.2025 um 17:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 567 patches in this series, all will be posted as a response
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
