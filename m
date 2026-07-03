Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262073EBF20
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 13:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783086544; cv=none; b=a24aqcnW+X8WIdQjKFFmipGeTQbpidbrHuNeNc0T02sDO9UpcEUI/ejGW6qFAwdDJumiR4RHSwUzU2A4Mymd9jNyUfHUbucXXD/gtZq8kNihK9oCfFOSknL9JKj8wIw65sEa8SAE7GJkHioWe8Ss2zsA4Si3zYM2oCqaFhoXNOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783086544; c=relaxed/simple;
	bh=DGx4vEaPXlRsV0Jufda/RTMpdGu8s+ujTJH63UEZenU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r936IXRZvP+qXPX+GDkLuqlNNszwVeLX+eT1jSwQfu7JHyn6KdK8lveMMFcxakplPDKkZIf27kDDSBzZiN9h1kGYDr8Y5YJj2HKx6mlzY4j1/C+foTuzbAMPBtYiVpp1+tM8jqVHqaaZIcZXFjjS9ckPmEfcb1SGZTeLku9pFRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JyWgRaNk; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JyWgRaNk"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493bc8fda98so6040925e9.0
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 06:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783086541; x=1783691341; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EHqQvNTeoc/2FSNLhGlqtEhHUBfU/vNEgSrulvmASEE=;
        b=JyWgRaNkLpM/UVQylu03YzY2nSdRt0uz1F+VmoT3BYF0Or9TqDFy8VydwgKJ+MCkme
         DLxmWSKSEUE0Km+TkNF/BImTddnBVTVU0BM/uPeWI3j7MIRrrabeTqQ3oo8LE39uiSd+
         iwmBBiXqqBOAw7rrJENbo4u5HF2KhNr0qVVvxfHUQEDkB93Z3NT+Vhj0XhTxCOuIXoId
         CtK36f8lcPpve9K+IyNMAjiQGKui+9E+ZOPz1b6K32N/8xq2GaNfid+Q95raLBQW9uf4
         JDTt3XxI/bFVXDD4a/4mOLrUvZvI4puWXYnhDsxxNmZzs3bOAYl0GsGRoIW6iAgJXYk9
         A0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783086541; x=1783691341;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EHqQvNTeoc/2FSNLhGlqtEhHUBfU/vNEgSrulvmASEE=;
        b=R8+vPtZ0JQ51BBP9+iv8JcExRJhyXUT47FZA5fOlCXNmsEI6I3cVfzfqSsNDmvquvU
         io1khX/HSLWyJ8jPFvvdHY6t59kZhFon8Bs+U2ZsXK+LU3M2QJprgRmXS2Y0M9zgTpnM
         qnvyXQZ2AKAiKokbu/b1XaOV94TYaeK6bP6880ACYfIntkXx5IbtLmJ82aUv7Bp/8CTN
         wxGCyeLXBqxs5lOba+MbXbcVgrERrKMJZLFR4iFIFr2NAGrbI5VFcIIdabrLXiHd+NOU
         l8xx0fN4CopbXEYR2Fbs8pAqAv6a8NUf9N/jKaGHWztyRDlKYKHwJYNecSvWjnygRJoQ
         tbXg==
X-Gm-Message-State: AOJu0YwktjzGxMbF8bdMSNwqLbc/6YsSb5nzqHY/J0NLRFk4qLqtbWco
	aORuDbCpmeCgWazUfCTP+dh+oPcAr+Tv0RaYv6hOcsr+2PdIS1TixRc=
X-Gm-Gg: AfdE7cnzdoSPqi7Ws8wmb2BJY9WeC45wGm8GR2OmkjD69kRlMmo87M+cW2l/DU1dTz4
	YmbkxhddFqGFOZqpTOLIF/45wBIgnMiOPXsG8NEMNbcLCwFbSLjYLoO5eBZ7EWeYPR7MDloHF1y
	02Wdq7SrNn5z9n+1CvhxPP42MrZDddUt98/uPGdTqY/nmPpHPYW5V7PZb5+FhF8T/XYNX0E0BHw
	hE7d0wdQQ+J5D/GCg/eP6g9jciMcYkJ80LgdcP8FzQf3jJXQAxxvO+/rldvvVUWQc+7MkGSzsFj
	SObnFv0zjQ9937NA0d9LalK56Ai36oGFP5NIV4v8WPJTXC0G6LqoV16UG5xJf3HIGFltSmI5B1M
	b6bgBpXm6/wG6Xi36phZXwfCnOEBm2OQfHoII4h+hR2mzLzIxVWqllhAchFGgkdOMvd4XmbLbu7
	XISaIwHYZlw64EuACX5LDQ0PuQ77IN461wVZMAu+QuhSc+Q+6q4YPmkm0shApWu/o=
X-Received: by 2002:a05:600d:15a:10b0:493:b92d:9166 with SMTP id 5b1f17b1804b1-493c3cdb264mr104350135e9.12.1783086541264;
        Fri, 03 Jul 2026 06:49:01 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b474a.dip0.t-ipconnect.de. [91.43.71.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493ccdb62d3sm58976105e9.8.2026.07.03.06.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 06:49:00 -0700 (PDT)
Message-ID: <5e332084-340e-4450-b416-ba9be05da503@googlemail.com>
Date: Fri, 3 Jul 2026 15:49:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260703072825.068705122@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260703072825.068705122@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.07.2026 um 09:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
