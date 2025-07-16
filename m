Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1342F5499
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685160; cv=none; b=Q67QBx4fzBupcEB6orCdv8Ef99gYLrzPRMuI0/AxHSn6YgUnv2xSA9qXkM4w1LbNdyDTg3iuSSKJ3vLu5sI3m2rXv4BuxSGDXN46dL1lN4LavzrGzF5vSWYkUFAMX3o0M9bRS9yH30ZnwpD22R6EI/s6jeYqdZk1FefOWuo6ne0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685160; c=relaxed/simple;
	bh=bgGIt5uwKo+8SRhGnRNrziln2a/zjnugSuIhacb/y3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b4OSVrTwBvMD2bTkeTZP+wuRlXzHGh1feXQuq3nNqkcNz0Ziungbeh3duqrXh2ltnxtMAH4alOoWB0RSzgZWL7xyhYvLgzpCbS6Y7Cwt326g6d2Stwa/p8jyTErmNf0iCgEBY0hYV5VBbOVQ0orziykCinUfgvzVlviENRNNp70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=W1n8/2Ph; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="W1n8/2Ph"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45629703011so576715e9.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1752685153; x=1753289953; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bCi+0zlUCZ4Yn1DhG0pTHwDWnxFzOiBeKQ3YUvqQbIo=;
        b=W1n8/2PhouJZcFIbC+mOWuBz8bP0Rhw+Ec3ON75M9PPOPwESBM8eAjn429yyIUOXHd
         yotOGIMEA6IY2lJbNITLVM9hYfkryq5Rm5u8q2F0IfiA3xE10UgJlpF5P0N9gK7qO5nD
         rK/vfhBH+QLesoSHI0jjoUY5vL8WBvWtKP9Mj5OCfDd2/I7zamFyk7P/iEVKFOMCvhSo
         trF1RC/Y9SqaMdVBC+fBNNaEQL7VtTLoa+RT/YlXnEFbRA2HQc04q2C4fGYii9wFBHCQ
         qVKn5wXPRUbKTZzQdrU7SW07yiKspxGwjuytyP2HfZXJE9Gcwahc/Hg3EA2vgOat1cE7
         8g1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752685153; x=1753289953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bCi+0zlUCZ4Yn1DhG0pTHwDWnxFzOiBeKQ3YUvqQbIo=;
        b=FuN+C+MrDc5UmAsnIVIV+TJqJs8t64qT/zp+bC+5kjrfD/HJEIJL8DWP8nJnOtz3Qr
         HDiKqLCWPVeEe8ixOmutkON5PMJnaUHoiYASRKlnnv0LoPUWRwUo8woPDUpgfC+3h4gV
         2gPCGXpN47pCCWgmlwQEKaI5chmckDKu3RUGxkFhAUMjsbD3CLKThfWOF6WrkAnwTrqL
         3HCxDQAqO0073yeuu6O1GWY80u9H+mjn3CZe2fZl4pLJK5SuqzJMnRdeJHraCBR/gfkn
         wXslqiQaq78arWEOPFA7QGAUG9TDCYbN3b28ut/JtaoEjif1jChOF9xK+eiWwC51uHxD
         3fzw==
X-Gm-Message-State: AOJu0YymgHQ4WANu77AFCpdeppYNo5Loy4Dt6gX1x3vjyWLaVKtFleWO
	28P/IsJAAv1HLSlA66Lz6XzmnxKa1o7w3S+BmVAkJoS9QOS1MP/YWRQ=
X-Gm-Gg: ASbGnct0wLMjiNd37Up24N38hb75/T9eFkGvP+PdHKVW9VgxsBvoMqXSbEpqvrhIy6k
	wd+RwPr0Ivy8Pb0HQrl0kVqgowudKlMYXfoikqRF0YduZa72/49oKrXtrunUCyMe9OxT58+p/03
	hYTXudAJcFV2MZANn5AwPfeosQZH0J2/Z+0ge5Mu5MhKlzYRWye8MKyxJIgG1KCrAfF8FVdRQvY
	RFjRk0803Ikw7pMsshP1w9pmCDXhje/E/52zx5YTda57cNYNqudolC//LeXZjP9VRMql1Ssep7u
	Ix/DIYS/QEQ/LkuOK60z5ODCzvwf8JB5s8UzHG964WG169onBaUNFeb1LII58/RA+7JN1ze75M8
	ytNajKswWX0Dk/JoUK1r8IjLNBap3FuxG5hwP81MzL7JoeRPcP7hIN6abd81x7wCI3+yq0LIY/j
	pr
X-Google-Smtp-Source: AGHT+IH2fN99teaziIOWHGK7VxDqMgJou22bqD2enEg/CDdFsFnuRU01K01zYdPKcgsMarOaEboTeg==
X-Received: by 2002:a05:6000:4805:b0:3a5:2182:bd17 with SMTP id ffacd0b85a97d-3b60dd6dc38mr2826716f8f.19.1752685153173;
        Wed, 16 Jul 2025 09:59:13 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac571.dip0.t-ipconnect.de. [91.42.197.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e0d872sm18577119f8f.60.2025.07.16.09.59.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:59:12 -0700 (PDT)
Message-ID: <04620255-73f0-4bf8-b7fe-4419e01b4022@googlemail.com>
Date: Wed, 16 Jul 2025 18:59:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715130814.854109770@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.07.2025 um 15:11 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
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
