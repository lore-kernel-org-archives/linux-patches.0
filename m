Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5432D2DECBF
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 18:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291558; cv=none; b=n7P2VxqFUo02mO7pugRtb4dvFseE1tdQJa1MlFZF8NMWBo3ed5QD1gl5yvQKUR7nZ6/icvM82Vz8UExeRtypb9485yC6kvJTrU06FORSPqFl7Zptt90JNFUztPARok0Rdv3rNRFvhJd3cKfkcN8MtL8QYMEM38SadlRXyP7pvHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291558; c=relaxed/simple;
	bh=xKWqh2Mq3To1C8FNyFOCYh6IisBe2esHhyb63lXCN4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C67zWpVlmf/OPK4KhXPqbx1/cmBm/pXGJJz2/LAiZL8TIaTMqkCZzotp9sgFj06iiKHhK23J6Odtf0A5kcaLPBjBvlydBin6HHZrtp1PUdtk1UypUke9wit2NBeyixYwwMu/pMU4CVQX8SB5SW7SWuV99pOSGuQPtoVMxeYojYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=O8hikLaV; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="O8hikLaV"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38ad12fb595so42527121fa.0
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 11:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1774291555; x=1774896355; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p5I9WcMIMbWgGzcbuEa00kzIbh/DzG5Pp6MMimlIG30=;
        b=O8hikLaVbIOWJDUwM3cdgFzy77E/nZubYp0r3XKIxj2jcobu2BXXuTRJSyxExzZdJj
         pvMAwEdEd+S0ZfStLCDjrqKCXeGqnvR5URM+KmFc0YnHbDQIj9VdXmonTmlZmo0DUfvm
         0/MIjp0I6WTD15XaFSzKoGlZIetO01cnDdNjMiyOcBxOlLcdpttuqb3uizj32p503sJk
         IqDo1meKM0SGCdADboWngAjawU9sgKoNu13tDNrYiXqg6BsLyzxQsQtjhjVFabCAzzDC
         zZbiqbPiSRk8suzF48C6MmwYxt6gjcugh4dWjkB/yhVoLedY1qqWNfE/hAHBefNhZh5U
         5ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291555; x=1774896355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5I9WcMIMbWgGzcbuEa00kzIbh/DzG5Pp6MMimlIG30=;
        b=qkVTFI30WHvJXDtACGqehk3qrN5trEvZ8wft37kqT1QzqYedwCvhDai0B+946YOVNk
         Fplyw8Qmvc4YdxIGpiZYz6V/kYsSBmUXHsM9l0bZQNFVnjPeMoAOIgPU0t/mAwHirk7M
         kormC6+GhVIWKaUeuk4bEQ7jYvS+gv/hMhqtrj4z1szueZUUUSDBZiAwqHn3AtleyI50
         yAKRlHoO0am3R2ABp9Vwt1ctX2EyPC2W5MjCYsi0486Cv7yqZlNz/g/r2R5z9pLwyeqF
         irBZw8LRVvgG2y9Q3WfdnfU6M9tAvM+7q36zXkie/acBeXsYajc5/RqBmvdwN8GXIATW
         ttNw==
X-Gm-Message-State: AOJu0YxQ/FT/JIHoE+BQS/LqdFSK67OMclPDHPuGnHSuTdvraofDkq3Y
	T2tSJ0QMoQ6lUCNVIfoitPHAM6foO/Z8bNEYezxUFn8dfV2qVqlyZsI=
X-Gm-Gg: ATEYQzwexViDUdk/eIxuJ+eWiB+SiO5tn4cjtHNkws3irvcyzrIZ00EhvvPz4OIgjlc
	31x+EA1X7JOg57Y8ltUGE5W2gq/htHFM+PuAcbDvvhWhiuO9Ocew5ZdvHSil1NCmIEEu8Sl4bLx
	jFvdsW0KCeIxMyWju8AfGkU/Ab4UKgneZbxtHhm6gUvw+rWF6yC4zvj7vxtMlwQLJCXyOY1h8E2
	CvHHX3XLVu1pWd16wvZqlJlgbTcVj0aQjfFbWjArI5SlGaD+V4LhauGIKELpPxJpqq+pGll60/c
	rWY1JoaLVN5tgKPsd1CqT/3lWclVvb0Dvdate481zkteArJFAe5NBPQGEAXEvY45E2OL7EnmpHS
	5RfP1eh86MaF8VALAUQMtgCR42bLyQ6kqBNG+QHDFQWOdHBPGgttZjHzx2aiFQ4YB76H171FNkO
	GyfCNzwuDMahGtokl79ceoyj2dG7DU6jg7w47XAwn4PBgXQIfPSlBXCsiA8zXPt9vPrMG91G5SG
	g==
X-Received: by 2002:a2e:a30e:0:b0:38b:f1c3:cfb6 with SMTP id 38308e7fff4ca-38c327e9c52mr1248601fa.4.1774291555190;
        Mon, 23 Mar 2026 11:45:55 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b444d.dip0.t-ipconnect.de. [91.43.68.77])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38bf9aa200dsm30082831fa.28.2026.03.23.11.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 11:45:54 -0700 (PDT)
Message-ID: <941eaeda-94b3-4726-ba64-3223ea0cc3d2@googlemail.com>
Date: Mon, 23 Mar 2026 19:45:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134503.770111826@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.03.2026 um 14:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.20 release.
> There are 212 patches in this series, all will be posted as a response
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
