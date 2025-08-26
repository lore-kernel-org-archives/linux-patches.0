Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D1623817F
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 22:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756245969; cv=none; b=X0Pns3EWf9N72bySCs5x1uV339CbKcC9/Lw2OcW0LAGhedeuHkSoTYFdZYwfFdUs1kos9vNgZh+FFvljbY+u0UobWPGtqdBZSDxLMt+DhnAk62qd+2r0TEiV2pb5T6rqYSgDRwmBjkHIwX3LpZxKT2SNNpati1uqsZOLMIH0HxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756245969; c=relaxed/simple;
	bh=u/TTX0STx4snkL3BTx2vIxvUR5cZT8dsiz7IKeIyq2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YKbTKyVptnp6U6/nP+jo0p3Q37/T5XsJUseiHcpcSY3xkXq1YKqw+htZFomi2hfIB4vCG4xjyomhQakutWz0eVbt8U5vYQqhEWHkdep8FHSxMYuBVC3cNz17kwkMAdYd8CKeLAHMILCOpA2tfyyZJxJsGQ2iNfZFlkMaTCFAhRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=HrPb6zZh; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="HrPb6zZh"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3c98b309804so2147845f8f.1
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 15:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1756245966; x=1756850766; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8e9dM5QsAQ9dzNMnHHlU+Y7vBsWhn8pMu81yfhmakKs=;
        b=HrPb6zZhK3qFGTUO6ZDWaNukRnPiksOTQzaSBmghSXbB7flBuyxmimTLjHlgobR7NY
         YrwB4KXc2NLJz65yeFEg8bLwZH6VrVs0meTMiyn61vLZ6Ug9FWt2eyh/l17raSxDcyaV
         61oCbSMzEOy+yXnV85vL1O5kYsJiZCbgM7GfOC5+LiLijG4eWvIzjiev8VmqzqCvFYeG
         pKsfe3wsXgr3UYEXJR+vcvZ9X/jH3xILEkaDgYPiWyOTyrs8K6L8MyMTUo7lbxANWErh
         nl5nW25Z0uLRT4iisc/6n9JXVrLvdPPKJ5KbFAGH2MblfnMEmACH9dKf+7VFIicL3gUP
         GyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756245966; x=1756850766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8e9dM5QsAQ9dzNMnHHlU+Y7vBsWhn8pMu81yfhmakKs=;
        b=dd8o+PYm2on0GbUNNxvEC+Gsc5eUjLA8JPlvaqPTQk2tx8w0Qd9q62cwRz/z5Rdats
         TcUClYtukxOK2TioHp8livQH1EqNxGFRUTJTsaeaCmH23L4i/Q5dmR32TE27egIQIvQk
         FfQJHKfRP8zkO3kHRLrxyxyptvOCeI4l+JVrXK1jm8gFp89ldPjpMCgtQlB0KnibEfq4
         X47Zavtxm3qAS5wdH+qu6l7158HGQdcc0sCTG8oYSw6HJEB2mPaJRf8rX2FcBxkuvbDJ
         tKRtLcHBIuq2JhGiEzZvjT3N1uEGUfRX0qhQw0slOGtNbyTPg03PGkOQcwGtG+KKt74u
         KGEg==
X-Gm-Message-State: AOJu0Yyy/ryO4iaNcknJe/4pNLUWvzgtZ67GFBySfhqyPU/poriL10DE
	GxvOaaXZs39mf0i0d3VIYSj8D6Ot+C+UTtSwYZED0c2U3sm5GAgz47w=
X-Gm-Gg: ASbGnctPpyVoSI8ZBUp9hNnRUaOlZEEKuMqBShaDpACrPdfKOp/ukyksbi9uDiUjK3O
	DCwO9BQVeZS8nfuPgrXkDhZ14HilO8a5HGCI/shRdr0Ps2+vkIxbCrN5DQUakL6cnPRkGcm3i9a
	lmm8Wh+/YDfuPluuZJXp+njaUC3yYKLZP68RmfE5mdhf0ofAwJwq0ello2CSUdJCZdeQwb3Syid
	cGF1NM0uh11Cqg2oDi1bDK3Mo1kR9LFMp2PbZ8Okx2ifwxEFuXQzC5XvZXXLWZvwZMDgOv6KDqP
	8qarcgcZqK4ts+5Vi0UOdXJ+CzkP9hjD7vF2V8L9ArEDdzTfHSsKlUXjn7fDyXbeTTsh4yZNGlN
	mCInnIFm3U605OeHze7M8hD/IvhQM70Jmd4wEi7WTbl1rYqieQz3wYaSXrJExKkp+kfD5xoUND8
	DKA60VTINCoGUpKGHCVug=
X-Google-Smtp-Source: AGHT+IHMTfuxDf1Htew8ys3jQRNDbyDBKRa9bTKr6dLtQleGws59MBJtQywxLD466SH2lWL9ySo9xA==
X-Received: by 2002:a05:6000:4205:b0:3c8:e436:a5b6 with SMTP id ffacd0b85a97d-3c8e436a7cemr8505302f8f.63.1756245966065;
        Tue, 26 Aug 2025 15:06:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b057219.dip0.t-ipconnect.de. [91.5.114.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc66a45c09sm1007087f8f.47.2025.08.26.15.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 15:06:05 -0700 (PDT)
Message-ID: <3269b6b2-d079-4e62-8948-95a53fc07e3d@googlemail.com>
Date: Wed, 27 Aug 2025 00:06:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250826110915.169062587@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.08.2025 um 13:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
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
