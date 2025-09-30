Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0273E14D283
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 18:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759257220; cv=none; b=Gq42T8HZyrB607xA+IYEufH2IsL1mpHWNB7ujxMkDkv7Dllt7PMC89L9xARbmdrDduP2Y5TQdBA+kydtSPXvFRT1Y4vm+v9e59UKN6udtcvAjIXLdi9umTKAY2Yy7vFY/a9Umf7mT5++7od5TVaMXcq/hk9XivDIuC5rHWxYnOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759257220; c=relaxed/simple;
	bh=zVlyMZxxHo0RNdeW4XnKVTsVN5ixAUC0opYVbEaXHnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qsm4hXzWXh2TWIv9V60RWUPKlThwzzBAsMpZYSJpHpTqVX7TQLOAgNREWUYmxaT7IA5YY3/M7UmTDKfNiJYPmKSmIM/h80B1VVT2DjP9HnPKu0eAHKFUAMvDl3mp6xxilJDxotDuckILTSnvfcN3JkwTXaogj3LRPNBGCVbJrZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=K/0wW65h; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="K/0wW65h"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-414f48bd5a7so4138087f8f.2
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 11:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1759257217; x=1759862017; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zZ0HvTGWGNVVCxU1HIxgw6BFLuWYpp+QnQXrw9yVN8M=;
        b=K/0wW65hqLk4I6Ofl1KkXy29zL5RiP4Q1UIzYeMsuzGGutgN6h/szQkpRdmqEvUeee
         7+ug9DRsvU0yL+91bJ55/qWB2kWDip5qmI8GqkNhBRxz6wTjN3Ala/JFWe+1joT/4LoE
         YEqTpEiHb8Kgt3qTLgzDmDaiaxzEG0mztbHyWtGspIHPlELLmQklbNoS6hP/df2H6gXZ
         1K49/43GN5k6LgnFQxsde1pAs5PmkF1NGw4EaWQqD+3pUEX4OI5RzvhjgKr8rdRZwWVs
         w43sqkhPeaURIt4n5bKhz9OL+t7u1G7R8n0/j/oOXVvD9fiuM16AXxni6OzZTVA6/ARX
         FUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759257217; x=1759862017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZ0HvTGWGNVVCxU1HIxgw6BFLuWYpp+QnQXrw9yVN8M=;
        b=n2AfTQFC3pOATdFPmLR+CswJeM8kiSTNgOCsb9RbFG6Wp3sVzwroGpjASYgqHysGth
         4g5GSZlX0rEnLCOAl0nf3t45jAJuzhcPnIzOmGvNU2u323+48c8ARuSUPNGTwOQgkMbe
         5xEVvWRqeLkLDuT1dgUv2fhRkZdxgm8oasz5ge/1UuGhigY93Lnek7c3vUSv/ioOtFEg
         YnHIQokBUwF/6Y8O1qOy4re8hrnCRVXmkIv3Xil4kHY/f+fS7gAaNBnyKTnKrUzHS8Ko
         0v/FSSLvV8q87XzM3P0mzV8fAPKa/SWIEV2L1oeQIV1gDMNSdpNP1USoru4ijr6jufiv
         vz7w==
X-Gm-Message-State: AOJu0YxlDwzinnwmj4LIsEOPrwJMzxI8w+Scf5w3ZBw/g+YFKODQM3oX
	sq/hBR/hdHcEaQZwyoXHkhv34lTjXBLr6+MUPl8gBJnKsCBuX37YSlg=
X-Gm-Gg: ASbGncu4fMybHllekK29YL3cwut2rNaS7Akv0wlH2FPGOSCf/wx5vO7zFZ8Q73XXTJy
	XpNJLuS/Bddw6veHTrntjwJS2xAo0Rk/iGwY9PIeXzWkQlZwQK6GLzHbKGj+3Apr8rVHFBlJYDR
	3lHIxJVecJoFqpcRSCYW6UwScmH1upor0sX590Je37J4KwI4osUc20du4Kde3PuQG0/Kswer95p
	06fNCfrCleO5DsK9JwCZdAecEyDN7/hGCV8N3BHY337xu2I10sOekzuI8mUBM6W8oFymyIsfd0c
	adexD9eSGU2iBgZvuT9s97iw1TBM6w0UzhcuYgu0lUYJ/M6O9ditGM3Z8nfjsm2BQMaUwOd4lue
	i9QEp/FNX7iWo0okutMcL+ultD0VOEz7WtgRuDp2nD3i7WHqrP46mr16nOccGXPDzfGT+/XtITn
	C7uGfBLlf9vMlwtrmmRgl+g68=
X-Google-Smtp-Source: AGHT+IHVmRLkFZm9HoDiRSglZ+jRCxRWITUyBjqs9WQREg0IFVK2ZE+PbWpA+KG/kULEundNbrrJDA==
X-Received: by 2002:a05:6000:2388:b0:3ea:a496:9ba8 with SMTP id ffacd0b85a97d-4255780bc4dmr538317f8f.29.1759257216984;
        Tue, 30 Sep 2025 11:33:36 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4965.dip0.t-ipconnect.de. [91.43.73.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b8507sm4930375e9.3.2025.09.30.11.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 11:33:36 -0700 (PDT)
Message-ID: <babd43a7-6c7d-4368-b769-8d9456121d43@googlemail.com>
Date: Tue, 30 Sep 2025 20:33:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/73] 6.1.155-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143820.537407601@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2025 um 16:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.155 release.
> There are 73 patches in this series, all will be posted as a response
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
