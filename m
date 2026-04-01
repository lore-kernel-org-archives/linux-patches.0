Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F55637DE9F
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 05:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775021111; cv=none; b=iHyOJwXz318z/3CNpZqNk4oY4G9bCLcqUSjHss2lZApFNVsKUyHTDAW7nbiN5L+r7c0A5Cq5LXkLJNcsXzGWfs9Smnem3NEPGuiYFbbA0ggNxxmmPKQ273XbeW45/7nsQNiWBxy5rL//7/gAoOlBI/bulbW1eYa9YfYFK9+KqPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775021111; c=relaxed/simple;
	bh=mPOkvhBm+3qBPW5ESLd17mxXryn+8LaX+fwIs4v0bTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BVa4XY0VILbWMWrGsRiS8nqJhpQ+/+eU4fRoyouiOcc8CuVCUW8ODikZpZGoW3YwkUf/MxabQ9BnaucaxmBZf+S+KdFAkPzoqU59VcsfMRbS++SVjXIhmXaUwkORnliW2K0AAxIHTrfVvchfwMIbrI+RjLvfv9+zXs4BV+NvnRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=pnjkTXZU; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="pnjkTXZU"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43b8982c2f4so3213224f8f.2
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 22:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775021108; x=1775625908; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uq+oX1D4A8za2quMJgs8dN6OHnBRay6++qyZCC4PMCw=;
        b=pnjkTXZUFV/ucxM9ezD9CjwBihHZ+wT9vQNmqjFdw+S+nd4LMi0p/0G89xfPtaF0Ys
         YgDGeeQ3n6/QsaMCnWAuwMDhyC2zpidcQNBoMJ63y0vpT07znNV69SBYX44f6qk0vGbz
         LW8fgogpIksiNfq/r/ZHi99cd3DD8P+g7Ah1MTTzzlJtzhCROLUEU9Ma5HghiARkCBXV
         wG8pbCwCX0Ro0j3hnta1Fkiix8pObe2lcGqH+I6u58xcbHHePpvr3IKUbQJeNn3CjTZC
         2ZtVWZK4vWJ/IWQnRM/91aTSzCCd2gET9WvPPDTMmaLwCiPfZyO0775pZ319KEnY6njI
         TwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775021108; x=1775625908;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uq+oX1D4A8za2quMJgs8dN6OHnBRay6++qyZCC4PMCw=;
        b=nPybhs1EjCbR4x3Ij0dE8EqXiVOygGAwSw6lDFwkuVOQh6By9m3dIn5QFIeVx3IZf7
         RNKWQx2+GlUA4DwWYRPhVew8Y+ZEyc65i4Kag+43ZeeRwtgGoIs1Z9TPeJfsWaFpUjkF
         rGetn2EMF0nsPP9KxOdZqENMYCW1vEpvaU15nL+9WDD1zMVR5A3RQQ6kztzMhzH7/zam
         qUEt8cuXk23KpdUUV3+JytrzsCX0y2IctkJTrei3BOFOD0vMZgyqHFe2VoQ0adGt+Dt9
         9eN9XA3WWXLjCuoHLq+9Luvmz4AiggszvzfMQZfdT2tKU15EQQnaKZkqDYRKA2zYNRjk
         nZTA==
X-Gm-Message-State: AOJu0YxHjct+WS9wTRb5dsL6d1pDqGaN5U0zB9IRwSduQSydGBNdzA4e
	7dYKYXL3QtW35GTm6U0ETkPOjTX5kONII5Syksmo1W/Ud8Gno/5ju2A=
X-Gm-Gg: ATEYQzzhvrb6VE441C30tHpRFxahFFRgR+EBFSVfmMisYmOW3qjwwqtbUr5SWWVkTHu
	deQxP6qGG+sQSf4MPCGyjhR7cV6D+uKBu9/rRW1AhhgCo6euqbHiMnElU5kaivs684apTSKMhoO
	h5FXajGyAInIrx246rPKLsCsUXJOLoTqs8BJdDoTfg9NGQiH392+BKlJL91a7FKzMxZBPVluS0d
	zcfBrR7XGx16tHOizeUaUC1ofQnM7MfwBMNexFjJXvTApsjTzrexFt5f2Wwisry/QWBqg8HLojY
	70N/igOneYBLOWYToZlrcQQ8kEFCHPjqVAf5EItLVSV9in+skVwvJO07ENXbtwG/VvECeLYHWCs
	l3F6T50/BsvOH5hrRQOFaat3Fv9LD280EnBz0yzADseFxgjqptO12s6Mvhtea7jaQAUUfh7FFRW
	lJbkC6aKc/k7gzBcHp1lkbVz57whjlZ2zRqIwhsWYwcJgRgA/YxvTSD9imr+LEUyPuoIOgsffxW
	Q==
X-Received: by 2002:a05:6000:2307:b0:439:c299:4d8f with SMTP id ffacd0b85a97d-43d150ab9f6mr3833908f8f.17.1775021107783;
        Tue, 31 Mar 2026 22:25:07 -0700 (PDT)
Received: from [192.168.1.3] (p5b057048.dip0.t-ipconnect.de. [91.5.112.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf1db08e6sm46557659f8f.0.2026.03.31.22.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 22:25:07 -0700 (PDT)
Message-ID: <fc84377e-7cde-4260-8655-20009be4cb82@googlemail.com>
Date: Wed, 1 Apr 2026 07:25:06 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161753.468533260@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.03.2026 um 18:18 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
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
