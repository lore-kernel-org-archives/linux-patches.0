Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8A3396588
	for <patches@lists.linux.dev>; Tue, 12 May 2026 22:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778624187; cv=none; b=g2ziR3jUmejfzIjbixHCdpbBTxHW1sbVC30jBHVLfsGXHkIjl8y5npkORUoB/PuB6rZFsc/+Xv60kqgxIIYGIQADMmVe++iEawnVgRaaG4zXa5APEZpOTVoVoXVBiGx6QvYjCNnY5kTVwEWqAtoLzcrNuAB8+uhpIch2Cm6jhEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778624187; c=relaxed/simple;
	bh=zj1XaluJ+aZYRYZxrxeDXCpkk36+AI7qFz8oCqGIYUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnz652uYt9Q9KLWxPvlWPGFUKq9HcplxtkSBqVCRhYkWxIfTFziEVFmyfbmHj9yoBIt6ZH04ov2OXAjtAWO5nFnR7dNwqOfbH91zaGHhYyXqEFyYxNuoocaNkbgDKpWPAoKN2/tv+NcDnVk2hc+TeJA33jchv2lqySeLfiHieGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=aC3C8r83; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="aC3C8r83"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so54789095e9.0
        for <patches@lists.linux.dev>; Tue, 12 May 2026 15:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778624184; x=1779228984; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bO3QGpH6Gc8wfGrS65yzQutx1IbWc5h3f9czWRt70WQ=;
        b=aC3C8r83WMykjOx9f1nHP99Xw9hxOj2swgesQH+EbUB3TcVNELjxtQsLhtcSkvZ7qn
         8/TYFkz5PZV6gqjm4bG52qSQFYoIGC3RnV+nXN19Kq7tJ5DEXUf2S3FkhDM5ofn6VwlW
         JQ6TE9RCGPoe2Fn/OliULDb7rKMyIldwHs3DuT/poUfDVARieq1hpBR5VNlK1/22OQ7Y
         JBFvMd2wEmqqHS2j52YA+pskFnT4IHNnK9N6Mp7LgUKPamf53zQT6h5h0W3SgVRw2K4G
         q2o/o5M9DmZJ5+t5BdfuHCi/kRAx7mHHYypu0YP5p/0HSKjtaOETh+dkeVRxSrjRcWRn
         bBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778624184; x=1779228984;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bO3QGpH6Gc8wfGrS65yzQutx1IbWc5h3f9czWRt70WQ=;
        b=UZ1fHiKFlb5+TWlwgSC+AOSmiCmVxMM5pXmesNCyx2IBcKSgn84bYX9gTZ+yCNSDaQ
         PeI2LthETv8sYNxDmiUjJ+W+rUq47LAbpzE5Mp3woMUF32U2j1YqFh/lENFXB21Heg4O
         1/nwnymLVD8prgGb3poaORFjPDBqNZxZMtAKpT83SPSY8hHDfTNLcfDwMXI4mgiFscGR
         jajpma3SS5rACnlZUAjIQipqbJqe4fhTEe3azZLwiKy9IJkJdQlhaYYtTIzUI/HfInL1
         jN0yi/jseTb7HSqpZxoZECN8g7SfFSd6NNx6dY6UvpHCAAigXbsUyGSlQkd9QzmYNRdE
         6kfg==
X-Gm-Message-State: AOJu0YwiXJB94kl5RCrzd9LUOLF0ZBesqpQxYePU2t5iKS/Wrv6OfQ2c
	g1kKkkVOxSUGwRbi1gYaJ6yEcor3sTADeEXmNigSBnvCDBHOmZrpDZg=
X-Gm-Gg: Acq92OHnNe+LCFMYvq+xEOLm02tct1k1H7iiOwnzY1TTknztDEnh4QqDPDkVEco3pQU
	wJImtWtCuOMPB9A+zs2K3qibw0CBmzBfBZYysXNKHt7SknECV+YPeocdu/cPH+Cw+LTTsLp0OBY
	Ixh1oJdULDkPQ5k+wJ2148xfw4nnjesiwLIY6dFrtClTVmUtxemmMEskVBg53PsINc1HjO9s6nt
	SsYRJdNV6CGwJvqDkOoPBRuKFvWo4wSOadlPA7Lo7wFSGNBBaFbxMjfGwzcCjrE5QkjQUIJfq6e
	5g+fkAGdbKebcp05JG42SWlKjxIxvIlmp7QNcnYZOxInPmvFOwWpXV4YC326tiMVbCmMo6dbpv7
	UfxgjlH3X/g7Bhkfylws/q+2NHyzNTkWkuaFwZfLVLHrU21ei8dVSCRZm6pBAbo5qNyQMv0wpNM
	LA/iVhqv+3vT9cVYUZCJaWxqI/N8ypMuaEUep7gwwdIwa1uEAGGoVTzB8plQbPvI0dAt7cGVs9A
	xs=
X-Received: by 2002:a05:600c:3e16:b0:48e:8741:fd4d with SMTP id 5b1f17b1804b1-48fc9a3bac6mr8208475e9.18.1778624184063;
        Tue, 12 May 2026 15:16:24 -0700 (PDT)
Received: from [192.168.1.3] (p5b05786a.dip0.t-ipconnect.de. [91.5.120.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6b071sm35549822f8f.14.2026.05.12.15.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 15:16:23 -0700 (PDT)
Message-ID: <e6310202-f90d-4da5-b7da-9baeb6d8bc1e@googlemail.com>
Date: Wed, 13 May 2026 00:16:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260512173932.810559588@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.05.2026 um 19:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 206 patches in this series, all will be posted as a response
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
