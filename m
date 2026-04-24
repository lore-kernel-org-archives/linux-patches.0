Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDD53D5668
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777046501; cv=none; b=e4IafBmlOeXahb5aP9KTWcaPASy6Ekb6k7BrrSWSoFqw0rvK9YWiThCknAHBbRVfwDEIecfloG2kGw1PIujlYwLcQLYrNMmiWoPBiX5l95h4gM3u90gjegz++EzJ0ABJhvyLNcUqHVcY2BXts2U/yduvPbiSpl/ATRIi/FI5j94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777046501; c=relaxed/simple;
	bh=XBrRIOss3UB8Fgcs6nvW4hOYB/mA2XcG3Gnu8tDN7JQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J6OAu6h7luJ9KRtLAHS1xeydPuagrRAlxg5neDQBx9poORXf9JknF/4JX4MwVXo3K+GOOO08GoSSnD68kUZlAeqkh7T+DXmWrtNd1vH4dilROdmKpcUJBUBLrX2ZldCs8Df88TPigHXc/ftUz1PFLsBPB+5oPW3bCfnl5iVkDwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IDL3OwX4; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IDL3OwX4"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d6fbd0954so6266587f8f.1
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 09:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1777046499; x=1777651299; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x5EePbwPULNZVcoCBgcrmEXYzSzuUctn0Jq6gjLWNAI=;
        b=IDL3OwX4D+PadeFRzhsIBlwEUw1C3JIAbKARPLkgh10wgRSMvZ9mYFnKb3ZQEhqAu9
         mBZfuDiyEZ8PnYIQLsNh21gR5DUEfeoF0LVaG5YltVEIm/JQnMP4Fkauc4Ih3Pql0nt5
         JsVQ72thEs2LuhBFHe5O1d9i5VLA5lWLawHDktRpNwKy9Aj8VWfGOTV9FNGvxarjKgf7
         hWUel1D/l8wzsm30Myp5TdfBEVQOqaQIWItLDrDwp0Oux6ti1VeN1vP2+HXhDAGKc7aP
         ZbDznLoVAClBLQSstKgtsgZQ3pr0+OVDue+GEveQoMoxWuRVPsN5CZ1azVkJ2+lfEpYo
         MaLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777046499; x=1777651299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5EePbwPULNZVcoCBgcrmEXYzSzuUctn0Jq6gjLWNAI=;
        b=ZpLm8jgf76FfNA5N6MrmKVUtctndrQtnCplsopmPEPH5ZbL5IK5VfmvSwFdzeHBdN8
         II4vb1vLUgDLh/ohiOl+NbrnXAkbWU7ld/nTKlQMGqRT+eKzQZYfR3cbc3P5lB8QCPbf
         N36sQ8ci6XONCje3Dvxb6dhG34Bh40wcFjIv77CsfyYa3HD6nj6fz5RFkP/7I02YG7n2
         LccPKGXtPzONCqaWMOoTs/yRsi8GdeIBnXXKiLrg6JjUA9ORnill2GfH0MFWdrl91+up
         q9VDwsEk9f7ANQSuZBnLwhuqLzfgq0yxnOdCbF8w4Bf9JRlShrVeq5RcvcI3pyWdUsss
         0YBw==
X-Gm-Message-State: AOJu0YxFzU5shDiEx8LYCpIwuJyQv26ZDaniep5BMR0qiUZDKoJxD8wm
	9hsAAewj6da5cMmiP7/PYVq4cmEQFLHJGVFL+nNoxLIqWamx4IxvADA=
X-Gm-Gg: AeBDieuxwSyAnFC+m0kDrbmYDUZ+85XrerXfgY2GmYjfog5fGPNy6uhvQJ/Ycq31n3z
	gWip+Y1f8vX3c/RsPOzuBn9vtXGQiTBT87gDO4QUttFIZfV+AwM26Z3ISb8NuK0n78j8r/ohA1X
	aD40L1dxmid3IRFXYqybp9KY5ayqsEjR2OTrBW4GHZ7QMoB5mnyotwUnuZLWso+CgziQ4Qk9mVv
	J3TOTHi4MBf1dX5jqQQ/jw5Ul+DQI+L/rGaGTgyeNEkyxdTBKIg+qg7yDi/pW4jZfMYxC2+4DTV
	LewT7aMBHK5CqhqKIkJgb+qFpMsS5o5YzOIFWPqoSLraKdYbYFq39AmqFcjoifXimxGUdFtxvY3
	R40nA1gIW8bz/UuxTU0hrSScm54wmK5MaDWAebNiUpIFyE0MqXFQ5RnLQ9uTwiV0MKdIdNTBruc
	WQfKEaHf6C+CRC3rmHMBvUcKJ7Wc1axfXF9HeRGzQU9pS1BOIpH4sktKhO+OAaTTKo9WpDgrmgM
	J/ebH9/tM24
X-Received: by 2002:a5d:64c3:0:b0:43f:e266:4c9c with SMTP id ffacd0b85a97d-43fe3db2e62mr50645337f8f.3.1777046498497;
        Fri, 24 Apr 2026 09:01:38 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4e21.dip0.t-ipconnect.de. [91.43.78.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a18csm69596790f8f.20.2026.04.24.09.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 09:01:37 -0700 (PDT)
Message-ID: <3649f35e-b190-4369-a90d-20eee8505e1c@googlemail.com>
Date: Fri, 24 Apr 2026 18:01:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/166] 6.6.136-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260424132532.812258529@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.04.2026 um 15:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.136 release.
> There are 166 patches in this series, all will be posted as a response
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
