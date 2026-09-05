Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798A63769EC
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 18:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788631658; cv=none; b=eraVyrPSC1vdof076jnho4IPLI4O7TZ44DtTb9Xm6Dh2B2htqGZfrwXUnGfO25C7+dO+BRbIKoIQ4inN8KxfNPM3OnJZHOtH0a61XT50ZJXChnJ3IqWvjDVeNLdmYfqZCF7C1IQCsLSF+zZ21uJ7rMI1gamQqF8AzHJjBQVSHbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788631658; c=relaxed/simple;
	bh=nbv1eKJuOAUMEOdTIAnaLZ6xXeW+UqMsJKrxTU2H3vM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f+uA6bGmVFrsY5SF0rjcXCRekSqC3I6hLRygoeArFljpFD+OfNjghYJNvzE/kQQl4xv+urwP7guNKNTf87DMQteS9hPnFsowzZk2cZlphTmrW3SUrHpfCgaEnj7rmKELhO6VeQ4Me0P4CCiBVm0wPsJCZBerbrJ8dRhaj9MVhjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PlX+Pf7Z; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PlX+Pf7Z"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so2272757f8f.1
        for <patches@lists.linux.dev>; Sat, 05 Sep 2026 11:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788631656; x=1789236456; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l/Ho2DAvKn3GLqPGoIYnpqH3AGeUo66hN6WndlrjAOs=;
        b=PlX+Pf7ZBEb2Y3nKTI+GjoX/AqnEf4upAXXQ9qNecubBWCNQBS4oq2xW6I+PIIO/tM
         zMlWzDIF4Tvuu98q83YGLdDXHBuS3RRAWYWC9OBJQKmweVot4KtmBFD2Pe8rd83gNt8p
         lTSvzbcfWeEF+84QnDIewdgKjGoDAvo8N9Cd6KITya6trau0eK9Wt/ZYD0938lpAqGmV
         CvMR/hde7uF14LMAl7WQEUHG9kshz5p/WpXCUL6G7VzqUC0ZCWeqGRvkVxi9gIE+Ohdx
         yyWEmNo7cY06VA70uD3Z4ilUYHt9h+lAf/qF3izxemjIIHoopB/af7+sJ4FPhEyYR9UO
         3DBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788631656; x=1789236456;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l/Ho2DAvKn3GLqPGoIYnpqH3AGeUo66hN6WndlrjAOs=;
        b=CWaHwsf9oDpfVYHviuV067I3pfjFtEPAP/jGRetB+KPxEqek7nOmA/RfWCkcLFo+mP
         +jhzr34OgX+h5GURQ/KHwqdXZnQ/pJC0VQE6p88dH6g5uq8ncZ6fnYSOHgNWQ9Yry3Uy
         RTVkFFNBeUjrukMtcOpjA34nqOLeM7cxbDfYNidCpCoGA7rhqF3PREiWN5gNApTRdvY/
         KR8myYYzWhhnPckgONNXzlckmY3tGFQ7VoV2vUdNoCQ9xtiMrTA2O9KKS2xiHf0LC+lb
         xkTujyVxDl6bPnKMpK2RU/E2HNodby9kKuPihU5yQgiE4Kg6RzwpLqF7xIn/iyhXZJo7
         pQEg==
X-Gm-Message-State: AFuF++k4clrotwrdJJ/5IBwumfqVMQtNV3TGqmF1+CtjHRB8cihrx2In
	N/S1f+A/6hvprQcm5dB2TlTgGsVOiFuIz8+/h34+kJv10dp/ef8+o1w=
X-Gm-Gg: AYBFou08FUlHlomo8+wSyU0L9y1zN1DgevH2/jNOAnh1kdvwxEoeg9jUno6/ySPRW/c
	L8sDTLYGSz17Q0jDuoiAGlr/WljdxgDezli/pLSoiiECv8M1eWNDA/x72oBaxiAPOhnJ3Y7tzee
	ijZEHbipO4IsFiL0hAigwktcNqaQz+MVWp+gDwfKFPX+TrXv7t8IuorEJEitRukSs+k60fgG+OA
	/QfszjKsdB2AIYE0pAPu5PCmfm8UFZDJFA+wjU9H4zKzqJhDZCU9QcLb0d4wwXHajaVcr01l1Fk
	Zg24baq7EN1NNPnTTVITHdu8Vum6/eZBMJMRz63R+Mw/5Uyli+1QDbAJMMtHlOtpVuPiLRVMvHl
	67L9Fs9Ro90OFT+a9Dh11wsVa07rBiHGnDS9W3x5J1dr6W31YsgS9ALbr7fe3Trtvd7GiKrmLD0
	FUKTz2x8vYGxpih++27WsyHYPRv9PDW/wj5VxvE1PBJ7npTA/5HplUVEN0+Qrpqfq9/JY28KYsE
	HuOl1qJTYumoywLtMWGWvFqg+Y11yevynbeYA7Q
X-Received: by 2002:a05:6000:41ce:b0:485:8c16:a336 with SMTP id ffacd0b85a97d-4858c16a7b8mr11206275f8f.43.1788631655591;
        Sat, 05 Sep 2026 11:07:35 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acda4.dip0.t-ipconnect.de. [91.42.205.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883a9b49sm13044687f8f.17.2026.09.05.11.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 11:07:35 -0700 (PDT)
Message-ID: <2627e60e-7787-412b-bc45-ed5d831a6bec@googlemail.com>
Date: Sat, 5 Sep 2026 20:07:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/713] 7.2.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260904045803.810145556@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.09.2026 um 06:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.4 release.
> There are 713 patches in this series, all will be posted as a response
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
