Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772881DED5A
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 12:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982037; cv=none; b=jbtVkYVUjdAEetqY/PNCU1l5Cnc4dRvPw8P3rYBXQ+Xmh0Ac7ZL1ThqEPMOxxm9wmZMteriYR0NcAHNasEn1Dw7nXjI0EHpB7s0WTy0FIdALhB2yDeKqFBG7jf/WtuHyCJzwqCPZwlAyjIBE46UEGFublunpI3DSGJ8MV6sTwDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982037; c=relaxed/simple;
	bh=IQ+lzEzj0W8txnSHSblQ3pbXTuZYufAwYO3m204rwZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=URnJ5fUO0VyYAhPsBw0tYk9QUNFIxB0caQ14fw+tCPL36CQul7HyyDFgPndVHMVadxI0UTieMSPUEmeSX36xkGitZ7pGGOddmfce4XptIXvrE6rY0o2wfgAnrCqhae4RQi9l/PWTo6mwAUIoCaEzYgU7J/PvIvNjPaJQKkyl2+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Z7/L7L6P; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Z7/L7L6P"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4316cce103dso10347535e9.3
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 04:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1730982034; x=1731586834; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QlSRWSIV6LHGeIvracfP3+zpVN6xLyNM5gXTnwqtm5s=;
        b=Z7/L7L6Pea7Mvi29/mMI4WCeoGLEdwu3/pPTBz3kdNgKoDBdP4XNNSSmPnUudeljh/
         Ijkq0pMnWkRayyosuP/zuXFl1OSW6p91Lv09UX5/Tbir0QQxykWwUAzEf4ZpDFyMrGjT
         P5uEHTVp+KQ19n0eLyIkZzkhSe54G237kSyREKOpaP/nuJovwbMOCRA0Yul138ACRBw6
         K3zftqN44jhhXnE6bbTzSKmtX1kFXALapKx+KWOgKXUE0ccrat5NE26ZimJ7VeulDiVX
         o1GTDPQbqNYggwEwbBKyvNPbnnPNinZN9N4j6JiscnwCXG9m0B4453jJRxqIT71DScsy
         LdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730982034; x=1731586834;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QlSRWSIV6LHGeIvracfP3+zpVN6xLyNM5gXTnwqtm5s=;
        b=pwhWHHh8rM+DCV+A2WkiXKsE0kqpoFfv+v3kXKhk7X2BWGb2rZiOCL96B1gXXHC8FV
         t5RYuj9Umj0MmAPM0AXIPiPcUTBTuyoXiL2TMM+o/NxGOpS5GEbVxCvUkiU8zMMSWXE2
         QzSTQy/z3U56TgVvG5FLgx6hKOfLbBThkoCcRouXaT9eFY14QchC2GcDuPSJTzaH+YeH
         fWXAY+HmT9uHyOpXdKbN5kkfY7iWeyXvrimfO1XzyVJJCEeJb12JKDZtIHeNpNFI3vF2
         VGZX/n5wm0GhKaKlqZvv9wfrgwI7ljoZYXF+ONfvBTx2xpfgBwC+B+MnvdPhaznv8REb
         9FpA==
X-Gm-Message-State: AOJu0YwsXfFoYDo0peTYxyKUT503hz22oC3fKbr+7I27yRT5RPh/HvKE
	pmQhJ8XkDAcEC1D0N+aIKmTThV6sjHBpsh2bxSXCIgjyZBCtEQ0=
X-Google-Smtp-Source: AGHT+IGL2fX4z2U85qlfVASCEm/jrw+/7NqZCwCI+sqOVMta4//26kDAspck+hOFab7FaEXh44A24g==
X-Received: by 2002:a05:600c:4455:b0:42c:b508:750e with SMTP id 5b1f17b1804b1-4328324ae6cmr243347705e9.11.1730982033592;
        Thu, 07 Nov 2024 04:20:33 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac486.dip0.t-ipconnect.de. [91.42.196.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa5b5e3dsm58197545e9.9.2024.11.07.04.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 04:20:32 -0800 (PST)
Message-ID: <bff71a1a-9f8f-4f48-8207-b56ea57a92da@googlemail.com>
Date: Thu, 7 Nov 2024 13:20:31 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/151] 6.6.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241106120308.841299741@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.11.2024 um 13:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.60 release.
> There are 151 patches in this series, all will be posted as a response
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
