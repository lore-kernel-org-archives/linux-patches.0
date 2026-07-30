Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21243AB29D
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 20:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442485; cv=none; b=B2IcegwGNmknVk7/xIcCtiLs+qKBu2B84hptERzqZn5rw7wt66tc/EyTD7Y+HELyS0Rm94ZdYrLw8+7DTVRR6JIn+exjiscF0UjheD0WDWvhLUikohKiKKih9YmutRsUP31TRQ52bVWnCkDS1R2Ec+Nj5uGyztrMCF6YmlKaELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442485; c=relaxed/simple;
	bh=WRhaPGbZ8uKf9RtnzlLml2+viY6SidF1GRHdMJeiG0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NQqTS6+cwGlFqFrBtDnUF8Z4wDELJSSm+fb0NXkQzOQY8cd6Yk9XGIRA+qfxt5g9QoTXnfpohwcWWa2uyB6Od8C8sCYBP0IJU/uYWeo4CQDxfEx6NneoYtoChk5+BgCNyMw7oTwB/mNtFbggH8EEfRdRHJM5wtimu6knIMVDATU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BB4+25I9; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BB4+25I9"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so1507865e9.2
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 13:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785442474; x=1786047274; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SdxFevHxl3sOyQXhH0oN7UW70ptjCIsSCK1K7cuk/88=;
        b=BB4+25I9qrrEOk7Pgbj+m/WKw2h9m2QzHGCNW2blvcH35gZg0XmT30ycx3uNEDkXjP
         63gbqFzsTgdT5dSs4aGfg2u3E2Pg9Jkn4RkMiWJwebTU0eZmx9uwWIPQT6sH9cfROx5o
         ATFmWncrGLFfWeC/DjKFHF7sygYw2ELifEzW8pgJhwVvyl2PR+pfZS2VvrqUtOhjm5+e
         xlXXTf3vRLToyaRUTT48iF/KPrWwLdnAY6XMj5EAZgGgQp9lNBNAX3W8hejgJk9CZHpA
         A/3zmL4C4e/7yzf+wntD/LgOIRu3M2Oqvg4q4/24PfI/QLuhC5HdE6mR7on2boijUkYy
         AR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785442474; x=1786047274;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SdxFevHxl3sOyQXhH0oN7UW70ptjCIsSCK1K7cuk/88=;
        b=R5pqWwhaFsAUDkCWoJYsnFzLE0DYE36Uta780Vy1HLLwxqqnL/QMbzMTsoeRGKiZbA
         nZPyGRZM2+uJiT/F5moWAaCpq24Dz7ODLXbboxdYN2fUgfGeIeu8A1d1AY764RDkS+9Q
         fIUn3eu7dgSPWfMIM9+dsYdghakScTUf0PQvInEwLay+Ph8TfHa3YQEJkiwGDZ+cgAux
         e3MQmZcfgQp7H9ia/yN6+ES8FxX6glj6ZyVon0d8Ovplp/k+8d50whRxqEq725F1YZ9L
         o/MPQdfxdmNyPz+ZxIH+/627CWFC0+aM/YKgdGT1MMzgl9wryupn8UwLLwvVK7igrM44
         //gw==
X-Gm-Message-State: AOJu0Yxig64Bt775PFSxYX2o2QSMMNHqYqO57GhZ3opHJhxdN5kwcweY
	AR9dpijzNtJK3SNVYTuMoWA44+O+WNI2cMqslaKzWVIVtQORcMTSLnQ=
X-Gm-Gg: AR+sD13TYqrP/PkCexro4eRbyKjEZ+x0dQvF0BcDwMWmZqWMj/egbbHvZa4Budgb0qh
	yiqeEORO068JXN241cV4cV+k9EzgLoJp7L1wWFDkKB/ztXfthAvcC3V7pEnFzfSuiSbquBAxZ03
	9xfrq6gX6Pzih/UJcsvu430duVuHkZ0NRseyH+q8zYiFDBfQ71mlMukF3oJYlMF/Hsx7Y1PjTRd
	q1PzLBBCKC0I++5/RkOaPosWKwDVO6lBuQCSEULlwn+T1HxLUWWbAuOnvFWSbsnMm2Wydrrvvzx
	+sM8SYWcItCvuHdMW46TzxQl7LUD4aQdaAWLvw2YXMu2e09sVg+hdLIBet9D9Rz8TOfM693wIyk
	pPx96gdiHGwSLcEEqIAQH4jJ8/iCDRpnQCM3Bobi/I2jZ6VHklgbjxmLlhnloelTkuCN9zp7GQZ
	By7DH9uCJCFZsIRpfyPxWpqHrlwsY12kLq/rZhIqTLWnYZyvPFI52dLrn7gJlbGSPV2OUYPaTaG
	IrJHTcfdUk5xA1hhfYH917iMCX3Uos43Wrt3HNuYzFl5s95ZbJw
X-Received: by 2002:a05:600c:55d8:b0:492:4a50:41fe with SMTP id 5b1f17b1804b1-49800ebf6c6mr40512225e9.22.1785442474199;
        Thu, 30 Jul 2026 13:14:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca7f.dip0.t-ipconnect.de. [91.42.202.127])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49805d76bddsm5117405e9.2.2026.07.30.13.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 13:14:33 -0700 (PDT)
Message-ID: <6b5cf099-63c1-4dfa-9095-cac2d11f3eea@googlemail.com>
Date: Thu, 30 Jul 2026 22:14:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260730141445.110192266@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2026 um 16:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.42 release.
> There are 675 patches in this series, all will be posted as a response
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
