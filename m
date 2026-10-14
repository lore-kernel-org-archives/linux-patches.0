Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D4356510A
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792001312; cv=none; b=b5CGZ8xakHHdY8Xm3Dh37RWo6jQwOkf6lSWKJdI0QgbEegc0yDwQRInSSRckv6Wyf5aMDkEjQ3dEKbrGIudIeihr8IyFSPC9mjf1EvkGD0XZFTwo99mOiMc1mzqgy5tDbqHY2/R0jkc9EOfWIQaUhNi4VINNpP2NGNuNQ63f9Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792001312; c=relaxed/simple;
	bh=Gcu7FaYDYZMs45yhEm9GtD4DhGMsdtRnsP9YlV49BzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OhaySFuNp2Q9+LKOIn3k8tz2nbuiVEZ6qC2E/H07EiUUVMjFf7mBYVV/aKdnC+MVSGMGqs5V9dGauHv0lfI0NLKrhVP/k8WFmW+DS7W70LF4cdWaGw945ka2Wq/tMFiSEL0201LGHennZUtug+CW9Xba+liIJUsyYRKh0CxLzA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Nf6iM+KO; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Nf6iM+KO"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48de6a62a4cso1592715f8f.2
        for <patches@lists.linux.dev>; Wed, 14 Oct 2026 11:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792001308; x=1792606108; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fRWk/DlPq9AfJCvR0utFh2sqtNC4ckjvM5ysikrAaPE=;
        b=Nf6iM+KO5IgMkF7dRX92aIa1rGIbz+a8VlLLjEqgsKuqh7kLJFa57hqxkXIh80iC6n
         v6HznmatYaa3pUs3sUb2JO2uqEmpT/tDDxgvTPSLPWOOA19IGDEB2TVXrlaJLHcXjLz8
         FVYzw+LFQ+5dkHv4HD6zzFRhbC/zsDZrh5qckrvdw11EPb3pgmk5iAFDWhDikDfETgR5
         9OIJ11MDlbF0pBJWpLvRWF5jyeJoevLd6c3NFv8Xii4v05FVvkN2ntwxIad6Rh+47+t4
         QBtTzIHyza4Q101WP4p5yNWlZn6yQn2/D+XSuT1VWHNMB9/bPFyKMtg+ozkH+cvCCZGO
         iODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792001308; x=1792606108;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fRWk/DlPq9AfJCvR0utFh2sqtNC4ckjvM5ysikrAaPE=;
        b=WtyA7nGmKbjHdQ8JOaDQ+39xx/VulscXceruJs+5sTO1Q5RCx6kyp+DZspFJapn3eN
         k8vCZbH+7DV5rUv03G94W6G8ICxqkGEoaoydlEfRFSjZUszrOmV6iyVtDFnjoTuL8AFL
         SIO1h4oZIqLQRRB529Mgr3gA6/TLg79cEHk5qQ+Hf/ERPE8YUp+N0OOFlA2EwxRJMbjR
         wit6BxH6owi22wuOIVd4/cCkuqr9HT3TpAYVRZpEtFzoUd3SG2cM4x4zqwOX4g40iqBg
         tIxn2J0ne5n8H93BqgnZ1Dvs8h2KhZ5a+i4gCSHcEXHJkXUW/d2YE6UTJx4mOPM1o45q
         Zp6A==
X-Gm-Message-State: AFq9FYJ3WUeeZYH9lL+3TeShnke7cs2MPJmTbTjxPfXtEnTcmViCo8Xm
	J/iRS4GLYD3ftfJGW/T9/fXpZ51V2tIF5Nmekp+Go3I+iKD3mUi9LOI=
X-Gm-Gg: AYBFou20DHJJmtIw8Qfk/VdpG1RQNONLFRg8tFUca9+SL3bHmS7+GBFK8BbauTZGZQe
	/oFkl7A+2ud32VluO4rbmys8y/a/29dy/NFMWGiCTG0A07U8s/oLu+rlrKdp7udio1eD7cIaago
	oXF0iXWfvUNiWWVyz9nqqjgkr3TD2f3PNxB31hfMkKz6Jc0laXp3FkyW8wA2P4rT6lYv+AzXYvu
	CaoAr7GbkpgdrfbpmiCAsTeGOIt5LRar//TBLYNYLqo2jZ7YB43ch/r4DYzDuewjGKAafHksuPK
	jK4dA2pq4VGD4/7MSpXQnIx39KB3ilLrGguhJEXaocM687iqFMSbB6BMaG5d/x+AJdnNuF3rNXS
	F9mQa8f9vQUJ81kYIHLJ8TJLzkrXAlVZkBRLGy+F2B/GCJIOwHe6n2QNm6JtpWIi2KlMWLTHkoO
	RQSfJAjITTJrX/beMEY9+fMropBDf27Jfez5J+BMmSX9LWKHyWrnfvV2UHQ0Zrmcydn/ICHreCw
	pjuc6/h
X-Received: by 2002:a05:6000:4208:b0:48a:eeef:b4a7 with SMTP id ffacd0b85a97d-48dbace643emr31763461f8f.48.1792001306120;
        Wed, 14 Oct 2026 11:08:26 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acf7e.dip0.t-ipconnect.de. [91.42.207.126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc506asm13879718f8f.47.2026.10.14.11.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 11:08:25 -0700 (PDT)
Message-ID: <819c955f-5ebc-4c9e-a7a3-5da698721493@googlemail.com>
Date: Wed, 14 Oct 2026 20:08:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/505] 6.12.113-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261014123803.944920639@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261014123803.944920639@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 14.10.2026 um 14:50 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 505 patches in this series, all will be posted as a response
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
