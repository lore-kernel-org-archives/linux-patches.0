Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09062641C3
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759262197; cv=none; b=ThDYlSn7tNWkfk9SSaB5WlVQd5Pa+RPifFZIQWLLnWgpIB64whHZLJ7YD1o+gZxEcRa6QO+3JopE/nYyQJpiAa/ZRgpEkj7CGoQsReyLHT3DHZuTFRupQO/4nzgsCLhahwKoaFfn+1uTPv1B9MNg1F31K0CjfI6P996xCqpYMlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759262197; c=relaxed/simple;
	bh=pZsEy4BlzjnbApYdtY98hgFcJKx+/xKyksynw+ju+JU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQDtd1yKTui22RsuaFTFwkEtfEsJG5eb1rlYceJQ4Jt3ANRSdl7O4/1peYa97k4Oi2C81YOR0Wv9rGcgnhDlEgEQyM009/kd6GxP/CDkKnuyuEdcMD3Md0Kn6vdKd8p/4EF/78PdqOdFolvNpG1ilYEv6ht1DHESS4VqCaJdwfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=iYOhbaN9; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="iYOhbaN9"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e326e4e99so1278725e9.1
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 12:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1759262194; x=1759866994; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wr3gBhu+Jtq0RAUdwZRnS8EkF8mlUADBYcr5EwXyQJs=;
        b=iYOhbaN9UQNuBogkiAG9+34n+nP4z+tEQT8W+RsKBIb/0fy8s1dBSzPHK2PV1nDEEr
         pXG0nWnzcAWGSE1VycYNAJuvJf+K21AeGmEpuCd9mt8cXSvTBtw3Di1N92z9/IGoPloz
         Qk+0DSZxVW7QfcT/B4aRVTGjv3ES8JV+mqBiEEPo+mqgw5eTRVLb4T/xXg8UETIUZX7x
         9LpQDEDyxpbvFVEdPnvJF7867aCtwXsh2Rw2vGOfH2tueiEkotNj9ghPmEuMhei6FKzM
         nyKjMUXXhulh6Br36NEoRGWb/V5j52R8Tsywpey/rTkNlf/t4dndNB65CDocsEhKP7AX
         uOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759262194; x=1759866994;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wr3gBhu+Jtq0RAUdwZRnS8EkF8mlUADBYcr5EwXyQJs=;
        b=lMicqNCQ/bhsft7fBrJEWlVyq8SLfhBP2z7vaqMaDv9K7E+qmBPG7gBbtm+G838N+s
         g/9poH7H1YD3MuLwj+cIoBuorBJVNWzwRFZMMCLXfj/swhrMdP+7T2p+eMIOmsGEjWmV
         4Y+cqKZCkJeMZaXl3XAQVDlRZEp4F9xG1fQERlMvBuW4HnYoHX+VJ9SzAppppOz+ELdI
         EI9n6kyTGKu7ns3u/allnsV3dycejP0KYn4cTD5V8Aj9gs8RRF8zKy1PODhNtVoowtrg
         mbDSVHBzH2ppTUGblOzhxdd/nvOJkT6rD+/hIJeqg0ObYIJkfdLppELdX1YxUgKSg5PH
         P1iA==
X-Gm-Message-State: AOJu0Yw3ys5wg5zlh2+z0UKzdrI12oaSUzntTYY1uXJsNWscwk6kqlg7
	ggwsLIMH4MrQf6Mvu4YC9H4ZvwA68F7oSYiJ9P3lQ70cYveBnmgPnkM=
X-Gm-Gg: ASbGncsJ4OzLcHV82DH2EM/vX4FxQ/VMCa7de/DTmE9DkGIUrY2kxD7QsKTPuVOG2JX
	Cn40O7ZaPNA39tkknycyY5zI06Rw9dY97jle8iHtFCH0wlE0cH7+Zfoo80syUCcKEEt0R03NPLy
	D46d+JmttWqF1e42Ij1OXkfbb2Z3DW5KEOXkrbTIAU84qu1WvDLMBjdkq9nU1I1eG6U3lm8Gsxo
	WtuJAQrU7RCYTjgeeHW7YEDxmHD3DvKkUvO7naxa5xUy/nJsPe6FEU0ywBFm7ECrWRfJ2K6EdVn
	PY02qGYibbQDpFkvMyEe+m4CvfOs93M2Edav/x6HJO7J9/yGnzDiKv2DzszNK+6ZCgJEp8KFsMs
	2aDW396zrZ82FiHwkiPpLqeaVOZHwC4c+xjZuevIwUpzpp2BohS9M1B9G1wQY/JoZPcak2NS5F0
	TB4Ydud3UX5qkSHbT5sCvIkBeODEm/xOGwLQ==
X-Google-Smtp-Source: AGHT+IF0sFwvuRgPGE+exYeJzMFswBI4i3P7jw3i8w/j6W2Np5WRLVu1oilbh2amI4bAMDKJaEAy4g==
X-Received: by 2002:a05:6000:4387:b0:3e9:b208:f2f1 with SMTP id ffacd0b85a97d-425577b39fcmr862831f8f.29.1759262193723;
        Tue, 30 Sep 2025 12:56:33 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4965.dip0.t-ipconnect.de. [91.43.73.101])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb985e080sm23858507f8f.24.2025.09.30.12.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 12:56:33 -0700 (PDT)
Message-ID: <8947d35f-9e9d-42a3-9ed2-69c6f6a8bd97@googlemail.com>
Date: Tue, 30 Sep 2025 21:56:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143821.118938523@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2025 um 16:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
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
