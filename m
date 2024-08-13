Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E7D189904
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 10:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543784; cv=none; b=PNsAHKpuY9UbWsPDL5GX0eFilzT8o9ZPWZ6yRDedAjJp5+F9k0TTSvRW+Z9Blk3T3mdG2zmkVRxgWFx1+T9AGVdR2LHnjTNPLnnLfHDvOv7U9g+R0jVaBChhk43LReLTTtH6l/N+dX03UX+3gnY3le0YTV1w80GgPL+IGoopOl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543784; c=relaxed/simple;
	bh=cmu6cP6fL/3husJRB14FqGnNMhdCIb/BhtgJUDPFZlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3EgNTnuHSiN5auAxNrcGdMk8w9nYewtYSGmR7bvZHkiA2Xzg+ShrOcoSgwcU5sTrAIkZ7U2GtlhiegcFwUwUZq74nDN99oOi6ZqGBEFJo+5PnDS69WRphpckGj2hPlAtAVR5cEr65YZo8tZs2WdOjuAGlDMKVd3zIr0ZnDsaMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=H0OO4kpG; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="H0OO4kpG"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4281ca54fd3so40066685e9.2
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 03:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723543781; x=1724148581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PquCqhSeNls1CSskkoL5zD2TuWsNdcMF+oenJmTY7EA=;
        b=H0OO4kpGZFsmzyIj7eH6zsXjNFGhpm8it4CHBqC9KK5VU1WGr9KjW7iNM/xMwWhzaR
         MtmwsTEW0iaQHFTiC1AI8UhZb5KoDFT3pVG0SOfXV/CPzI0ACSL67HzUHRBNPY0ijSPV
         ZvX8GgrFUGGrehaTV7majFRDdxmOKXgPV+1Z0ztLeFAAH+Q2P4fRE+x7sVAacH7zQQu7
         ENPUsw5bMt/TJvyxTrpUiD68ADQU9eBNWyn1xp3SfarlAL/jcmeNE82KpmpQGGVaVdID
         n7V14xNRDmGcv/nGvC41oV/HfRG010sv9fOMGAoa2n7CLc9AJlKby4Mbv4yABUx6+vVd
         5GkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723543781; x=1724148581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PquCqhSeNls1CSskkoL5zD2TuWsNdcMF+oenJmTY7EA=;
        b=kDyQEn1uiDo0Dem6PRBlsRvE1zc8hkIJYXWDlIIJixFBCNuuq/mIhOFgbqKD62oHwW
         C+Nv6xEILZB9mofw1m1l+zL7ZqizGWleLO31MW8xV1Ehv63dubYtnWznpHfYmDIvxE5G
         s8iuTgbfhNMFsvXN/jVbwPq1zJHPZTJtrBY+iO210SMszibFjPCYSmzGQ5975iZlmDYb
         RaBdn+XKej6CaJTOjdKF2xRpIzQQ+GT7pGYaq+8QE80UXVX40gSwHLF87osnK6mV8GKJ
         VMo5tudEWPY0SguBrmE92iUFuKisJXiHhxdwjDVQ+AVCneHCNDsLBdKoe4NrrHfz9oPw
         1PMQ==
X-Gm-Message-State: AOJu0YyZ+5SZE4capHq6qDr3Ui6zqRHh+0l6VK7v7ClEPzRWCu7Dl6vE
	1xxx/2N6odR06kk5f9J3XsaR2aRWfgI1n8nrpffK0/BkCRNfNMk=
X-Google-Smtp-Source: AGHT+IFpQAx5ayMlEwbx/OMjBFzh+DZbiGWwxkB5cXYBIgSDq0DF7hj0eOZeGCY03/PhkfcwYtKnTg==
X-Received: by 2002:a5d:664a:0:b0:367:9516:ffb4 with SMTP id ffacd0b85a97d-3716cceee06mr1846715f8f.19.1723543781097;
        Tue, 13 Aug 2024 03:09:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac34a.dip0.t-ipconnect.de. [91.42.195.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4c36bce0sm9817816f8f.3.2024.08.13.03.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 03:09:40 -0700 (PDT)
Message-ID: <c281acfa-9313-4b20-9fae-f418cc32cc48@googlemail.com>
Date: Tue, 13 Aug 2024 12:09:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/189] 6.6.46-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240812160132.135168257@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.08.2024 um 18:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.46 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
