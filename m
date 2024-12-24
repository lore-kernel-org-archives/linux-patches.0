Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F128E1B4F09
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 12:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735042706; cv=none; b=n3pU9vkwy0by73/o/iPHH1CQHDvypStyQwNoqhPJoVTevxPag+DPu+P9IY4WOzlJhq60aMFNi8ruUiRGPX3ZSO/imzzR6/NzpR5YLho2QRWrhyNMNHm0p/+oxl/cVoWCqdYl1u+LoIcH0mEazb0Tj4UygZVhyoXm1vQRCmcynxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735042706; c=relaxed/simple;
	bh=ErATO3wWw4JwUGbt9YDU3ibfUHfhqpA1AqRX9pV/pJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GDorzC0ge+0TQv+AMySBStBPulvyz+ovaUy+C7hQ/cOfLvPma5KeSsIZ7o1RDC4ywC5piBFhTiIkgcJB4IP+qJYOVUQh12LuBpxOxioBEm3t7W1RzaOBrivbPGU/vUnOjycQL0iR16xMD5muDYLeJun9UfsI7wZe7FTgFOqbqV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=k4r0sTRv; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="k4r0sTRv"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaec111762bso467071366b.2
        for <patches@lists.linux.dev>; Tue, 24 Dec 2024 04:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1735042703; x=1735647503; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mb+RiudxCgxsWyDcAHJGp6RqlPZh4GuS25YePvjI4LI=;
        b=k4r0sTRv4J3b+A1RGiv07jOD9VluU5KoUfzIBuVjGzhkMiRNSsJNuz3By6m0HF9wUT
         QyPE9f+xHJanXRatCOhlZ/JgSPaH1HLFfs8N4tcfPfCwR+ZBDyNcfkGOD1hXVQqCf7v3
         NwpHGTyPlEf/buB8+eATWJO3FPjSBShpFlNzDjNwiOvRv0L2WtBk1i2pJ5E6DMMTqtUp
         fxdPzQCmvngjN1IE+ECNgZF1zuMrgjob7Oqc5KmAn2Qbv7WD7bb8cG757L+NCEA9OsxH
         loGBCVyQKhb/VB3pz//vHzAZHJWhfBNHu25CjbX3gRWWH7mC4uYS/r6zcWR6ca+5oaRl
         jUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735042703; x=1735647503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mb+RiudxCgxsWyDcAHJGp6RqlPZh4GuS25YePvjI4LI=;
        b=naFey31SMo9MlIAxNHOAuAdHNQeX50+JSsLHzPBHus5zBLC6mJuQyJGMRevA7JC50b
         PZyruBuBrmQw7Jv+egtGpZHjXafYIKTHhXucQB4Gq1qJXHp/sPn5XsnOZJUqent+EVUq
         KSf0JKnT8F+zqYV0nfcAnujcbJS8HTRdIORxXvzFyTQajZ0UdMIT2PHDZYuCJTj9UQc3
         4HNyxMFbOWSG1Cu+p5Sa0qfd5cd3ka1/Nb77E6GhNEUV6PoIFyDnx2L8zwAjq4YjvRcY
         4i+Tny2ch8I4Bcf0BmHKabK03JuG8DQLEpKjRLc8ElRsSqhcCVINp3UipujPgJaioVAW
         8LIw==
X-Gm-Message-State: AOJu0YykuFjkF0zIQZGLJWqem7XsryRywh+UN3IdyVtrYBsbQ9N/L28A
	M7udydfMFGM8NzYpX75NFDRhSYJ/a+u45eGcA70/F3xKL46TzXQ=
X-Gm-Gg: ASbGncv6C33vOFiG+C1gLOqyu8ldfQYVq86Rs29OOUKswNgoQF87oy++/EH1nhcdNYw
	Zktek1KADfXTsAYZcauKRTOcqIjNN6to5zAzW9VwVBQCXxrHglHTeCJ+dLqAiGbDUGv+lI/pWah
	+ItPUwjqoHQcJzVAjnmhTppL5uhBzP2SU4VEY4c2phCZbSn0b13bAdwuhETmEWRyhowhzrTfAvi
	j1UhFKbY0UovjGmmvIbS2zRXKEen3rqQ/k9nBcndRMPfIJ/0ilOHc75jSqVo1z6REqum1xwkToR
	yss/hcK8GFZrzzioEytYpOLuGxLmJ/tvOg==
X-Google-Smtp-Source: AGHT+IFa8YNAs+CzLV3KLRaSyW954mnGATmOz/1e1JwC4yDSqc7YwnlN0ZYhiw4WZqVEHs0U53fYCg==
X-Received: by 2002:a17:907:d14:b0:aa6:a53a:f6c7 with SMTP id a640c23a62f3a-aac2d459679mr1648757766b.31.1735042703000;
        Tue, 24 Dec 2024 04:18:23 -0800 (PST)
Received: from [192.168.1.3] (p5b2aca5b.dip0.t-ipconnect.de. [91.42.202.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e830b3bsm655852366b.25.2024.12.24.04.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 04:18:22 -0800 (PST)
Message-ID: <dac29565-3d5e-4f31-96c9-9c98a2521590@googlemail.com>
Date: Tue, 24 Dec 2024 13:18:21 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241223155408.598780301@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 23.12.2024 um 16:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Happy holiday season!
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
