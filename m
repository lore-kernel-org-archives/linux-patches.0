Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E0935DA42
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 19:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786995969; cv=none; b=ffWtl/SQz6hd3BijuSZ2LpgkbHGRycms7ITUjkVCvlm8+WKyGml6M+LssWH3dHTMIgvgOFfRDiotNUakkt1E4tyX4bThVqGwo6+dYfJVjn0MeX1Fn5AnoPjGYsY1h6jZsH7HLuLqZ9jySm0jaXrBgMViEsx/8sOVkjz5LOvt/hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786995969; c=relaxed/simple;
	bh=qjzcOuDGva/am/+FX9AvrloKZpU/QphmrMZnh3UGOWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jBFRwBMEN4AEp3tB3zZTITT4Q1JwC7jANKEutu6OIk3AAUrZxonZRtUwO8b3R5Mz6y1IypI24sr6lnJ9l9KHUX2n2LpFvYKvq82KwQzL6ACR7+ZHf6+LBgLuCWhqQFKhLUYWzC3PWyTrbrTwvmFcycBi/eu7ujjW0Q0sycksEFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kLufckyr; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kLufckyr"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47de008b020so154565f8f.1
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 12:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786995966; x=1787600766; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OMw/DsLwlR9gsQHD2JeUWofjFd5mKs46PIgIVFOV7FA=;
        b=kLufckyrY54DjjVT0CoU8aO6X4u0sTtcKBZAKw5KnVxcz4chkyQh8m28xRxDE2ZKnc
         2qV2iyh33vrY/eWhQaF4jYv117EGdPSQBALufsK9/g4HlL5h2/+DmmU/dLfFZRGfsHsl
         O6W8fRw6GvsjznXWznm4oVxUi21g7Eexa6sh8uiNTtYtn5ivuatfvnf8Ex8X1JexpMf0
         SDulxJaUs2DLMCzXczzmna7tC42CZiWeVy0V5HRI/HpzZ2gM/ag0VUQwI4fBrjkBGQvj
         d6gnmYG+bEDvGDpwJV966EFWeCCDqBPNUqxPPwAsY8h8YInreuZFgL/5x2kcaJT5LgCl
         bLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786995966; x=1787600766;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OMw/DsLwlR9gsQHD2JeUWofjFd5mKs46PIgIVFOV7FA=;
        b=jIBV50LC+d3+KSbAoB67gq71o29FSljTzw2oQ6BT0eekmvNNkC8t/YyUYGpcjKaims
         nPVE1Z8TPdESQhmdd7emWebsPUFbReJ466lTI+XEaV2GtMDEhZ0jCQ1hKHDpHlzVFRtL
         Aab+8AJvQCuibTvOyjahAzj/SJYpti7JDpbAqRqewQuHCd9q4oGvqr1rE48Qe99KkOK1
         CjMZUgiAptIUilnTRrX9mqutClIfOFo+vEP/EKciVZgQbrauN1JlrJUXnG81x3T690sX
         jE+siXjALQr1pGYy/YCFd3qm3WYaRvBgF8k2/yVKJvalEpfN9ahO/W0EYX5epGPgLTTW
         dLSw==
X-Gm-Message-State: AOJu0Yx2wA6Rl2XSO0AuZ8/KHST3ImT6qmuXJJG9NUVoH3jZLZotTsT7
	14TbhG/0xvGyqII2ckZeLyVWPRoldzoPuRe9bvpoBZgAoLnVTr25q4o=
X-Gm-Gg: AR+sD13kbGEZ6iJvEUW2wMzKAn8+jsY5rmyrMKO49QIjKaNSv6rMWO7ydNfqGJpcfcZ
	+tmSRWNHbXCC8Zwauua8JTyiL9BzPVSwa+//Yqe61zSt4EQW2cQnfeHtKAANns5Sx1NelxIFnj1
	siWWak3YQChYL+bQZi5f4Y2MywJu4IoHZ5yVsOcDCaQo+m5CO9oIpmTT7t2ekUQ+LLFB1z2im+b
	gehSe6bFaCpQ1kNgJxjOXNLPOAn0zQ8y5LTdfGXS8wxzZ6hxJHrFTCcTHxrZUizyhTG7BJfH2en
	11SERS2NjrnYscahCVJ4yaN/SJ5dCNYEmV0Ab6ovXcbiJQQxRZp+Ee4yd8r51l5Pi5u97y8Y7FG
	HR9+Tykct8wpgcx1vW9e94GJDzPebwj7qcyhfgN2KgET5vGdzMdYvKPVwE0XsxiCmK7jj/1bQ9e
	3pjAb+Owtf+o1M7JWbq1rspCSLIT1aQgZOXc6uKQUzsvPpWRIu+avQYunZE3d1FYVLsffKdnOcp
	cfHTGb6XssxZlc0gZ2MbY2rLY932ZD3lxyqv9E4
X-Received: by 2002:a05:6000:2087:b0:47f:6e8b:699c with SMTP id ffacd0b85a97d-482aac7e9a7mr369373f8f.14.1786995966109;
        Mon, 17 Aug 2026 12:46:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b466b.dip0.t-ipconnect.de. [91.43.70.107])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a7bc7bsm5844067f8f.23.2026.08.17.12.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 12:46:05 -0700 (PDT)
Message-ID: <c4922cb1-3430-4d9b-be7a-06871c92c182@googlemail.com>
Date: Mon, 17 Aug 2026 21:46:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132536.466235697@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.08.2026 um 15:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
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
