Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD8A281375
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 11:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757332738; cv=none; b=fQUV5+W97J4xW6MyabOYOob0T6riKwI5Vc0rIVpHJd5fUGUfdUp4FR/vwzbxN+gFqiFIcweiD+LpVrvqGclbBo9epH92FIDMpnWAm8Bm3Fno+rej3WUm8IjHJOKmtVyrFzU5rXqEQZzTGHFgipziaoEG/ajEdSS+0UvO5HjRAbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757332738; c=relaxed/simple;
	bh=6QOPQOr+MMPkIBn3rM6zrLTI8GvkuF3KweTHN1ROwhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KYXv9pqOFazD/JNkyjh2JbCGYpQlqOlt0S1hVGMyojz0GT8HQShPCOJ1/8CzJ3tjmL5WkqZxDE4HThlswN2IRMEErSbP/QP7rnLpLunslYXc/rHuQVTyctb1criSOcMoYkY0fama2gGOlIY63fcvfg/spyjeDZgOU24WzXRpLmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=faAM99tz; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="faAM99tz"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45de60d39b7so6400895e9.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 04:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1757332735; x=1757937535; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eRM+uyebU2Rj5lbvmGYz/DfavkBeN9Z38pQmhJrF7OY=;
        b=faAM99tzeT9c8+Tw/o10RwTd3dhJLaWit3SW8bw/xflTNBXDkOx8AOkEBiPXVf36xE
         51vWY61xfVhcMmqkJwWaem/6dqdoezzDnsg10FPrNjkkQD+dZRKj/JD7au1r6BlOBquc
         Ica07Davhq/Wr1+o2xQ8lNL5bHfyT21uHWa71zPaeSIUiJuka4f2RVyZ8J4c/AtNAfRc
         +OTnGsn2KzJzRZ8lxnOWw2uVsf5pJ9W49oNVIMI9EFxYH26qNJN7VDB5kRhSrrQKU2zt
         /MvjJbTu95633DWJuEwLslZqQDfJ9EV73fD95mBvVA5xpFm1Om+E+vQsZqIeBmUUnCuv
         Vt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757332735; x=1757937535;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eRM+uyebU2Rj5lbvmGYz/DfavkBeN9Z38pQmhJrF7OY=;
        b=MHY+2s9DesFsWteHG+CWXzzElFe0LV07eNCjOhNfU1uKe9uQy8MYodq98DHoTEQySt
         UoxnbS4uHHvYrHtmm+IM/tlQ6ZHuQeH4sk/3Qi351vKNWNsG1+W/z566LBgvR2aEnRlf
         K9ztKIX6L7/auH1RsBpMwS7JOk1KUXHp6U2SeglVjtjIKbfvIH/p8sFqdX8whHUSvel5
         cCHG77ovxWckAQOFPk+s7cyRWlQxxRQzVWXVxH6yxUsd7DPggQwgB3N4UMljAB20Y5Le
         KgkJO14kGdfiGBRfEmMg/3raPE7niSxgBVXcu8EhCGvb7D9m/8qzTHMqgtwcvs9zCHWc
         N2oQ==
X-Gm-Message-State: AOJu0Ywia2C4pj8Swvrd9nm8sRuTM4SsMH/ANU6g8ddk6ufwbIT7jWlb
	j5tSb0yNUz824bwfktTkTI9pvHvtBTDd4rgl4h2MDdEO59tpMu0LjXs=
X-Gm-Gg: ASbGncuTk3DUhEIWUsz+tGxDvd+U8IfMsHkxlAQt679YdoEBIjGQXTFVA3V259qid+h
	2VMusfCUvD6wv1AWE3U7OD4qre/RHMUl1XOdDGOeKtYmmfUKeOKO77HJWtvB9MU34WaEVwV/sxH
	hWNIvsTaMzVncY816BzDCIeNj3Fz6RL0QXREkirAfaFRezlt+ItHxdQGIn4fEPo7TuZwVUMzZFP
	HertmoxXpa6uRCFGh23wsnalrA3VuANy20+10M2X0P+KIPUPeTb1t3KPXPhvl/TfQr4EPJrUNXb
	EgFGBIDVdSKY5utp9nwIdtiuSZgiYplDhm1P8d74VauVeZ/QbnfNZLM8esnfhUPqVLENyKoTdIX
	dtWEAg+FlMxJ7g5gn4ceTpMJEWiyGYJ2IHhBKf7t5V0kSKAkITICsBNAlP4PuKu8YOyveceO5/S
	C/NJVQR2OD8g==
X-Google-Smtp-Source: AGHT+IFZgWcpxr6NhhjmxZvbiZnvCl/sZZdpHsCBeK240GnMFcxyIzd1XotzPDvdvGrx0kcUWiMGQw==
X-Received: by 2002:a05:600c:1f90:b0:45b:8f11:8e00 with SMTP id 5b1f17b1804b1-45dddee8f49mr54141185e9.37.1757332734483;
        Mon, 08 Sep 2025 04:58:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac262.dip0.t-ipconnect.de. [91.42.194.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e12444de96sm16556416f8f.19.2025.09.08.04.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 04:58:54 -0700 (PDT)
Message-ID: <09016717-6ae6-43d8-8985-54562dbbf956@googlemail.com>
Date: Mon, 8 Sep 2025 13:58:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250907195615.802693401@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.09.2025 um 21:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
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
