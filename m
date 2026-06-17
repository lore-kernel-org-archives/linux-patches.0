Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F2F3BC669
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781715951; cv=none; b=BRFkfd6ETpfzdwJkjpyoMxmNaYmXoddhfxIhQPttCSfLAKmdIPg2bECTOPR6HREwrbc74st2wIQ0YZ0AJBmiHyNuH9Tn7dN3Smu1LEi1tF7TeB81jtMJsr83+Txpi7O5jPimPaCDL9uENBS65BlxU1NVGxLiZoOAS7lL9rGq684=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781715951; c=relaxed/simple;
	bh=QWiUt4W65Yol1oqJQVCdl+On8yL1ocMTAIdDcP5QrmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mC9teQM8hBh+y6tGgq8UUmW1HZvLsg/J1MRStinLdhu+qWuosUB7R5hrKOuWbR0rrHWk+O0W3juyz7XT0lZZ+QxD4noPKyWU4fRaQ0v4HfesO449riLW8EIaLYwpq2ZiFfvyIU2kKz2CiRnwlC1894xoFQPQD0O0uF30+xteQZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TRtqExE6; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TRtqExE6"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45eea68dd6fso24627f8f.2
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1781715948; x=1782320748; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u+aduyT6+K3d0mjQ176gNz47/6BLqnF1YE2F3LafYgU=;
        b=TRtqExE69BoqzDr1AS5Ol0DSsfJi2EBZKmtgDXcFNf7JllUCNu0b+GeKfoJ5sFEMmk
         QI1rJNqPioMHBeHuiumka/1Pfj7ZUeenjihOvVh8IABFq3wodfUl7F+aooAsDqKoDy8u
         SjXNgLQpv0yvpGIyLpMYUWlypZlErQuLH1iLSCoKSnO+4fB3ZFDzViXrG5B9NgTrWL8f
         5nwjb/ZMFK7KKHkZogWummSO08TlLnoD1hg3APbXJ27cTfYkygTe+kgAtbBPhdgTb+Lw
         sZvDl0D26IABNqYjARoRdU7VWeVSC5AOieeaH8IxbU5i+mVWgrDUFTugfHMw6VMZXIB4
         vJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781715948; x=1782320748;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u+aduyT6+K3d0mjQ176gNz47/6BLqnF1YE2F3LafYgU=;
        b=re+FFTHkEEo7SchG3spGm8sxFkZEWcTKbz9gUyuWv1akez3Gt7kaKUeSKsb1Pxw+i6
         FvqPfSJHprJ3dbALkFmW/GBQREfcgSK1wjv7ADq3Bhv6NGpIKHGPpCrB9wAhadzlWbZo
         leF5jhq2wqarPJLdQPcreOinRDGJvU/q3/a5sI7eTZqzB0cygUvWac5BC465K3b9598I
         /o0XZU1+qMTGUb+pxCiDK9oamjgDfjbFcZ/soYhJ0Wf2HIKqh3D8IBiRetuSC+sFYf87
         SoRJ57LhFxr2s9d1QDi1dsEkCQnO+kyNmT1wQl/cMWHdQIKl8O9Wuvqmn60MIyH9kha/
         ADMw==
X-Gm-Message-State: AOJu0Yxp/koSUNLPT+Ce3iU3X62pXrpQIGpu1+On+ucA3WRktzxhGY16
	rn6nf5NQoh4TgnQ4f1gLT6HEI5YxOL+icPLhh8d245JIAa+V5a+G0PdBVggkrBM=
X-Gm-Gg: AfdE7ckoKe9i8PsA5DzBR5JcZXdp79wLpJQCOH2VK1z7P2RxcuZ0pvUYVDkFRO+rZVh
	QCT21bBjM+QHmCO+nOTbAiJpVCk4bsZdH1uFZAasquReZvRu1cnHXnS7FUzjYPrU1iNbnicTzLH
	okn6SNIrfDi0NqFKr409X2Gn84GpnTXeRz66XJqa3PhrHYj83wJt7Njuu8AK3hPIhwLu0AP5bWr
	iAm/DCvCTyB6dgmsNRgTQ2bUZeNRt12/BafNBGjSltcDIa+/+cFsQth5Di+MSdBnCdAxbO1nhSs
	oMlEQSjDhIvrR5sfCDwx5HbbQfGWD4MKjk2EkNRhQSkGMBsatSiNGk1btJDZ0SUmlFwgkj9Kj2Z
	QxaWrxJozOAym6tjYzwk7s3bYY0/UlOnCmSwNnEB31v1WxRJfQoOXR6JHWhRR90rJjcn/eonKYn
	44g62eNNXhwHVMT0UFIMKp3e71EKBWD6MIjtj4+tmxo8skzemZr2LxwG8IIH6OVZMd
X-Received: by 2002:a05:6000:470d:b0:463:a7e3:9f71 with SMTP id ffacd0b85a97d-463a7e3a5e4mr178035f8f.15.1781715948528;
        Wed, 17 Jun 2026 10:05:48 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4777.dip0.t-ipconnect.de. [91.43.71.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2dbfb1sm58842472f8f.35.2026.06.17.10.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:05:48 -0700 (PDT)
Message-ID: <951a5d24-f36b-4ccf-939c-b741fb1b3a20@googlemail.com>
Date: Wed, 17 Jun 2026 19:05:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145044.869532709@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.06.2026 um 16:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
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
