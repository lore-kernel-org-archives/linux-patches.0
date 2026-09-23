Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99654248D6
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 18:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790187665; cv=none; b=BZ7XnqRP60jvIYHZhixKUlspBXhVJAEooO2k9OZXH9PJSZhldzVdrXJG0hFDpjW9v9AfzxzfcrcGRb505WrtR/gjq8Z3y6I2MII74gnv4qrc7C7BQtV+VhX0afmLLXGE+SSKXdXElsmi4ARI202/lz2gm5vbWSRSmGYj2xZWQtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790187665; c=relaxed/simple;
	bh=v/4/l6++ZGNHEEzPofsFGmPRWxoaWfhxiTez96lpTYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lKhcUwHRkY68+fGDXeAYdx6uLnSNWV/+6MSiI975Qoj2CtmVLHfFzUTRBvxY5rcDDkAXgcxs2tkCvkFFLwRPP7zEGThs7EcpUTH1M4+lEvOSOdR+sarkk6y2LQuk+r0+MpaFNyEwrlBwyNGG0mO5R9k0Y9x1SNQdGUzbOxx4e2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=YQK9zYiJ; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="YQK9zYiJ"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6b885ef8so6974155e9.1
        for <patches@lists.linux.dev>; Wed, 23 Sep 2026 11:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1790187659; x=1790792459; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YWjiKP/XBNIAbPzze1+HuDh+T/9ARwHn/3w9sXqhD7o=;
        b=YQK9zYiJDXx0ZBgLXhBKIPJED2F9tHmuAxjSACGnAYbkXQSLI+Oc4rbkNfuc/ZWwbR
         KwK+Sq8/Cin05Xel8+Fzz/3QWniw1JTTn4H4GCJ7txbqJwsBwS0f8O9mCGpompP2mnYz
         m7EExkYnJkQDRCxrtlnePs7CZJH9KkQb5pzF6L0CCBOEthw29H3cff3xGPWoYM8dkE89
         kvvcbPa2Cp+M2iaYiij2j1TaIdYCS9gqVkeD2AOc0fP9qJGq03gnmOzaWCwSIom030GQ
         tBEhH0NlV5TR9YFv0S4LInZdNbXo/ksd2Ud8a4p0kUc5hA3NWC9Fx1W+C8XQ+VjKHqk6
         i2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790187659; x=1790792459;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YWjiKP/XBNIAbPzze1+HuDh+T/9ARwHn/3w9sXqhD7o=;
        b=T3iQMfcuH5/Fr5vpU66edEShT1jW38WFLMUjoUBYo3xQ9kR6XKXUqT7LD0vbHk9A6k
         KP2jaw91zQVtKAXR/2EVTOUgADRDznBQfbzYGlZ+DAZop3MekVH/32e+L6+uvVvo39xA
         BL8QhQLtlA6pmx30OIyaGKGqwX3Z2IXMb9isFn0oEMrrFmGmcFjD7E/rBjF9VUaZ+QmD
         qZe/9RONKAWTgs7Stqg+OPL4SPiDROqVS24FjYambk7d4N3JoeIAnDNKC3JR3ov7UVgg
         Y4J9sMDrqWUqCQp3qBgxSRV5WU16EaK8RKar80eKhybiSBm1PT52sWXwLlDGF51DZFkU
         mZMg==
X-Gm-Message-State: AFuF++k5Yijf8XcLwph3HoGBk9yXyILqB7WUZm/t6wBcjNJync1pjfsy
	Bveqh13g3d0pt0jIzXbMOa3GbVozPtuRS163mp2poAu9FHn9Qj2xEaI=
X-Gm-Gg: AYBFou1EkWKEz2zJtDzyAzN/oHUrUTf9uDjaAktOGxKSSXSW/sMzG0/gFq3ZzXUkHMy
	XZia+WR9mHUiubLO2R/mx2MPUyGBqtD5DRCl0Qh2xnFMUb18fppILjAMDdsDL9L1SeC2avTsDWc
	IK71FMPQmXBBfFcMZThNyuF1SeSxCgsP87P/ZvPwwDhIQLSScmuOvg1lYXjEZ/vGf5cRqAtuO6+
	+Tx+8o5y14UJtofy2FzgHU5qrW1L9dRYndLvOgGD8rn9IWZ1gK6lPftlKs7HAMKgh/SQS+xewE3
	IGnUvQnyhPFkhCrNa110JnBSxJhyBKJ2uYfEyH2TrVMqcP3BPyNZ4tnzWnm5UwknUJpKcZe5a46
	SI8WO1Q/v1bmjcKXZ5ITKZx1wj/Obdw7lVaRKmN2ZcCPFG9SidEP2GBBj9AbigOXMn+Ct5/qc7S
	ki4jpeVb0dc68Vsp7PgohasVBN7Ul3S81f/iBznlvh+zeUpBBj93//AyzFexa1RWE1lQlJv4o7h
	ejnMbgZfImEXHfviPyX3wWY6LM9AcyUwFCHwyfF6dd2r0K9
X-Received: by 2002:a05:600c:4e93:b0:49d:243a:e4f9 with SMTP id 5b1f17b1804b1-49fe66d0727mr1180475e9.10.1790187658768;
        Wed, 23 Sep 2026 11:20:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b415d.dip0.t-ipconnect.de. [91.43.65.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5dfa6a7sm5734535e9.12.2026.09.23.11.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 11:20:58 -0700 (PDT)
Message-ID: <cfc18ad7-dffc-4386-a7b7-a152ce1d8a8d@googlemail.com>
Date: Wed, 23 Sep 2026 20:20:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260923140644.756254324@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.09.2026 um 16:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
