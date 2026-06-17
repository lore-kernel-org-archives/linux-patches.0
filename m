Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC2A3C7E1D
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 20:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781728311; cv=none; b=tdpglVluKo29opvHdGUxktF2vDRSpamWP7u55h491djOurPF2cbrLFrjMtlN+ZRmzEjavzdhhV10eWwET8IR87xz7a339NQfO+wMQvYKplgr5nKdfPSOpetYLvkcFsmiiO1U+jBFNBBXekyrblfrYTrCSwMb7yiEEBG57lxmofA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781728311; c=relaxed/simple;
	bh=ilHa6mBWU2AoqymTSuxCecFC/tP1FzoccoWuRJlRG8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qwnpdbX/NxXJgbGzOP+5u3H4UZlvCe2TNiLbYlvIOkAZqg4USyIKNon9rTlj5MfuqzGo901in/uYsNmmM3c1sshxGl+KbGPtLiB2luiX6i6WsDmrVvwN7zwbuTiX05FHQc35R4XNV5UKRmAl25azZBphFRE32kNvg1vPFUBB/DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gU26Tvwx; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gU26Tvwx"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4629324e170so293395f8f.0
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 13:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1781728308; x=1782333108; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KJoFZAgDnFS7dzERXVYf3hL3VCTnc1Lf8VBBxmJqE2o=;
        b=gU26Tvwxrd0kRiCK6VIvYHF2GNOJ68Xz691WEH6GDTgP4CU/NaD6qwXuypBM/Y4JdA
         H7ejTTF4L0rBKpwEfQ7Z2lTw+Ac2GaGX69gsvaPLKG1X6VhMMNYXBjrL0tc7HclflY62
         cv/Ty7BOEIfn5fkqntoR8a0kvqhENe9KhgSmloIqP8fKzLgkjdZ+zITtfN0PDqSWrKtW
         WOlFxCRzOCJsaZYl4Um11m+IxSo8uH65XWQ3f0pQS+Rnz9BzEhhzs4kCrq404itqXlD6
         P5qmrAxUK3slhunjL9BnC4xGodmIpZRDiZdjEPrQEWnHmsYmItUcoGXlSn0uoU2+cuEl
         Fb4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781728308; x=1782333108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KJoFZAgDnFS7dzERXVYf3hL3VCTnc1Lf8VBBxmJqE2o=;
        b=otPC5p33Q0J6TRFwtWh+LdAgDFbhoCwAjDyTSQ46VVmzYvsZH985p1FJkVZ+uWgxOP
         vIEVHS0A/L8hCpfS2uk6Sjajk0/MdtGm9kdm2tkI7cnqvG5oPb33jzSMioLX4M44A2LW
         CsCZ1mOgXW7sE3XcI054CWCy/w/Htc7XsCV5nuywjbd6Hon7VUkzoKt7RDA7NYchtlFs
         nIQ1AlHk0pqa86tCXByIcmlL6p1SBEY8jEOiIALhhcyftXl378CkrO0YCZh3Be2P7w8d
         G6tnAWcpLHdkKp5rqcAIPE4gr6sYm1OEhoBtd3pQSUGE3mnQBXSsJdC6XuiOyt3oEwxa
         gAew==
X-Gm-Message-State: AOJu0YyVBMixInY+kCba66YaBPupNYIzhvTZ20swiGIzus39RyPseYi1
	hPxuIjCdxAQ8eJN+33CcemFS8ZdulVgNJzKG64v7FM/hA0IJGlJdFmY=
X-Gm-Gg: AfdE7ckOKBZ3Yg3v4/VrkZsV/7pZeGOAQ81pPyk4+OIKIdvzXMCScG+35ZVlzbbcaXA
	qlea7eh1APTKRxuJEtyDldCVbZzHgTCn20kDvL/EjxrOANCYmAjC63TChmky+sCG88w3Akm5Qb0
	71NJvL8HqEggRtliOVpI0zwfBJoE/c6yclwN8pasR6UWlrTNaQiN0tqsdCH6S7fOx7/ZPiYdrMg
	0DtIqFvHId+ac5NnSMnEW3nHpQyd1bhQZkgW+PEBgYCvRpqylZp+c8Z+b0G+lTU2kPfvquLSxSE
	zjpnDoabghIRsqmM8N+9tijbhAwyV3k1VJZpDsGD+C3Sf87gS+FilEmtwfR2aROhRDhFeKCLvqZ
	xsuX/852XMKfcyI3Z9dS+pj0cMKL6uCJZCE9B0ALwqMhC4xGaGg3MpONVcBZw76F4WIVhqoPF20
	cg65Q5zor39MRhEu7aksuruUv6URrCapZrg91uZ04gF7YsHLEpS9534AisHl0P7Epk
X-Received: by 2002:a05:6000:461e:b0:45e:f2bd:2b17 with SMTP id ffacd0b85a97d-46238acb523mr10028940f8f.21.1781728307522;
        Wed, 17 Jun 2026 13:31:47 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4777.dip0.t-ipconnect.de. [91.43.71.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-461eaa0d1c7sm13523403f8f.7.2026.06.17.13.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 13:31:47 -0700 (PDT)
Message-ID: <f93fa5d9-c2ed-4c83-a6f0-3d7b9c792051@googlemail.com>
Date: Wed, 17 Jun 2026 22:31:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/522] 6.1.176-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145125.307082728@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.06.2026 um 16:52 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.176 release.
> There are 522 patches in this series, all will be posted as a response
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
