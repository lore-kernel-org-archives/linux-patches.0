Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6975813B590
	for <patches@lists.linux.dev>; Mon, 16 Sep 2024 17:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726507702; cv=none; b=VkAS13heWGNEsqksna13EehkJvKzVobx/VrgSsm2RBu78o9eFcTJXF4Z482FE4WBu1rj9XgcRPa10W1aECEcxFit9Sw2IWR19w0YOSwAZOUANVeR/PztukQk5Ddw3UlAObwKIvHsCKZ+3rL+XGZV99uQboZpr778931qSkzSJOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726507702; c=relaxed/simple;
	bh=2HAfSjZ0rksb6UX+rVql7xe64h/WufpvrJQUuwP8Ei0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T9UGECNvVL4wTAiKjyeh+dpWObISCpSD/HglW4p5HVxgrqe8Z5PpaTOh1/FztDM4fwZMS3fmFMWa5fYFBWcOCbTc1nfYyXzNH6PYCNf9xGnz55QitUUAULk3r/D0O/q+aLhQVLnOPPBW4TLESnk64txm2uOctgp6CF9w+W20Lz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RpwPGHFu; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RpwPGHFu"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-378f90ad32dso692244f8f.0
        for <patches@lists.linux.dev>; Mon, 16 Sep 2024 10:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1726507699; x=1727112499; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SqLo/dEBUfpp1Lh4uLJBd7I7zW9+divCoFNdtfvd0Io=;
        b=RpwPGHFuBPBgWwJyk2/N2TnJ1e29iGTdxoiy8zDLPMr2Ebg9aCA1yku+/mBddGdEWG
         ZTyCMGfpG/KOyhGAjfU28gMH6Ofa3ZXy5s0yxFhBjw+jrCiz6gzhJ4F6Ud6zShWaUbOC
         0DzWDXtHEjskHOEjAJ2ZYsn8sNGFxnZa++oAZ1XmJll9l5ORuCbJHF1DQePPygn6/HnM
         IRsjWCP1FGH/JOgtMg3v9c9vvw+mkgg4LePirA0MoypkWL1z5RcxE73sTA9ZzntUbOV6
         pYTZ9udAxloC09YsY36Uv82Elm3SL68pe8C1t3XmGMxb5xa/yhwhNhFnYmto8xw2pHdO
         wedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726507699; x=1727112499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SqLo/dEBUfpp1Lh4uLJBd7I7zW9+divCoFNdtfvd0Io=;
        b=pWwTFTd0enIUAcjqqSFuLehu3umF8lnfClbnNyRgtRyBAEWPbQD9r/UNr7HfqsqvP3
         8NOur5QWtnABegpp88KMEoTRBrKVLb7AMg5g36a42focboDsvytUtNTVEnHQj8CC8jpf
         9e+lBiXDM9CEjzSWuYdInOW05D7qGNWbCzPzmSjr5lg9mGX91LHzgJ1LCPCv7Ewblhv+
         a+juIB+R9AA4RjRXO/FB42Dnu4l9xcDrapBQyF1NpPFHWq4adNwUhg2HO3bS9cfPlvXF
         1dF0RfNDZlO0AkDD3uQ+fDYC8ttXSWVMRcNBTU8yUoEIlCJAyb/tzqGOrD9VZm3s1LHE
         TCPA==
X-Gm-Message-State: AOJu0Ywou3vhDQ0QEWgqwBpGl/dOZv2NDS54Cm4CB44N1BtCcSGHxrrz
	Q+i629vFC1XOB0fskLi5FVwP45nwnLoQxdSplqXCy8BVnJZRxQM=
X-Google-Smtp-Source: AGHT+IGPWSlU7J4r4K/9tm5G3UvJ73+6azKqU0ph7RCHLSGhOJB741tGiPQbKbvdefwpIoquatygBA==
X-Received: by 2002:adf:ec07:0:b0:374:c07c:a49 with SMTP id ffacd0b85a97d-378c2d04c73mr9324752f8f.28.1726507698263;
        Mon, 16 Sep 2024 10:28:18 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acc3a.dip0.t-ipconnect.de. [91.42.204.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42d9b1948fasm115960175e9.43.2024.09.16.10.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 10:28:17 -0700 (PDT)
Message-ID: <f3a5272d-2105-4e11-bfe9-d04b0626a7ef@googlemail.com>
Date: Mon, 16 Sep 2024 19:28:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/63] 6.1.111-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240916114221.021192667@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.09.2024 um 13:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.111 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
