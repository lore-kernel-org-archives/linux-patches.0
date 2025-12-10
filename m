Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F95A1DFF7
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 12:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765370002; cv=none; b=YDr/Tef0rqLi2g2tDc9yR1Rdk/qQhbmVoTmyhFlMRu5AEG9GL1lemYy0xxw68Hfy2pzSSTf5tUXf6seHxPCadb39xkz/xJ7+TbVU4ICitCJilgP0gcDfhW3FAfKd6QW8IMLGyBGFyPEgF1CSODWaP6pqV4xmMLGBYXt5r72U+6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765370002; c=relaxed/simple;
	bh=JfxDjyamM9WaYpVnHOT3P1cNbeTdg3sojWRxERSzR+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AajiMMBASeRLwblCW36incqDjCX1JVruLGw5x5uREXL3TEYuM71BcKYcjGOCTm5VuOh3BEqPNJXLXgSyjGDQDmbIxMJVrSnMtEW3q/Ihuhr5IGHJIFsoaIUUqC4UtddSt8N3Qw+PfQcPM1fLt9JmU5qPSLPcPYUWXw858GKMH94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PvBO06Fb; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PvBO06Fb"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47a80d4a065so11003685e9.2
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 04:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1765369999; x=1765974799; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oVUoIaFOxcBrziHPtBUq4vWBign2WgxiWVbaopM5Zo8=;
        b=PvBO06Fb90+6TNyG6X82Vj7CXmUOfufBsJPQobAuF5T7EqvdpqqySzihwvqVcqEBel
         tFqXbXWfXHNeoUoiR5r4BOMusPhz/8RgGNzYuAYNW5DEdr84qWNLXvXuhgE9KWyFJlpS
         h5/RtARXiOoYy5kNf4kX0DsWwRH7awt4F2fKqqnHPp1vCimwfEaLl8S0DjwavDSiZDWN
         Al5LNH5iGts9HKhogy7BI5FXvI3znCfXIYY9DaAZEGfZxBv9ccko3mYWP3SCEU4Ov4aW
         aBtLh4xVBLlAtg4Ef0A5omBY3C8DbF1j3nr+x2+ENX7CbA1fqlHQNmEQSRStJks3CQnO
         NopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765369999; x=1765974799;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oVUoIaFOxcBrziHPtBUq4vWBign2WgxiWVbaopM5Zo8=;
        b=R/xuYh7kbaYcaZifSot1zqWF/PiUPmFMF1klQu0TsrRkJXvFlE/5qJJC3EGMtk5A6b
         PCgsrxp1bokMc59iU+zWfhaFQQRGTtRHG+ry3T0pAedAAqAapnDS7Q8SQii6DwxgGALm
         kPqz6/GAHhd6aUMJYiieyqytAilBMmkiUbvs4/ZWGcg0ipqnirNyKUWA190ab+3bgcyH
         pvmUASSBef2bnkEW5yCJcUOAaZpdmKQ76HSVk5YEjSY5jU+hDIjhQbZ2sZRUx0KyMF4b
         0P3nfuXG/PClhLVg7Kimj5NYsGI4lnOeRSbtVyKAp3L+2WraODygzqp7hAjdqZr2l+Ud
         N/FQ==
X-Gm-Message-State: AOJu0YyOzefYbuPE5gUCJXIONCYHKg7u5kMnkVeduUpnZuxyfSFhc9Ii
	y4HF5PjjVcYKld2Q55U7Ynluqlgsl9dguE+c9LxvvBsR9MbhERlcTKQ=
X-Gm-Gg: ASbGncsKyetzRsJNQ6e7S2lV5KIjtIV9cjZKBcTolCqic28xYSOa38SznGAd5yZTuL0
	2xk6dM/iKak/C/jPUeSx6OwYjTMNe4ZBK5w5UeY0y3HMofphltgjNK7R71GwpGAlsqbH9p+VNzq
	rsALPeL0H5Tr3TodEPIFduAgX0+RKJQQ+n7ltAB/WKqc2Ojh62nM3Me0RqRUJovJ9IxYNqETDkK
	n0VYoc4O731wDvunO9BMxru3BRw070JVtgm1wwdF0ODCfbYtLzUQnKif2OZeejdIw8lGpjwTWHW
	7Mv/jt4EF9+SC58+41ZLw7/1QWYw539LqkXxtHedArADrWKprsRnVJlej1MD1OA6G8mjaOPDkN6
	bvgtySayWloazc3l6fk2Bpavn9XYR818aLKrZr5+q/2iY4D1lfGeWDGoEN62QrJgu6Z7eihcEiv
	SpHCd4RfHrNviykUmOrTstuU8WHTiseyhD8aG+JNdJk2+xrFgh+4VxMdPeEqLEdV3WDQSxTLj7
X-Google-Smtp-Source: AGHT+IHOPYRlGLqkl9OBrneNq5hSr/5akjNj3KqTKVjghTmRCEdijqyuELLJzzcB99oktVjOSqjggQ==
X-Received: by 2002:a05:600c:3b13:b0:477:8a2a:123e with SMTP id 5b1f17b1804b1-47a83853344mr24532115e9.33.1765369999254;
        Wed, 10 Dec 2025 04:33:19 -0800 (PST)
Received: from [192.168.1.3] (p5b2b444c.dip0.t-ipconnect.de. [91.43.68.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d930dffsm49772075e9.2.2025.12.10.04.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 04:33:18 -0800 (PST)
Message-ID: <1dd77802-cd1f-485a-9658-0515440ea2fe@googlemail.com>
Date: Wed, 10 Dec 2025 13:33:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251210072948.125620687@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.12.2025 um 08:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
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
