Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7FA1BF33
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 04:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784694500; cv=none; b=PIM9EK2FRvVM7ERuRh7ZGft/gFxTh+/XnRntmEJfDl/XqUAAPh4w1R6fdjD1+pmqGl95dfZ+Kj8g6c1iV4UzhZaR7sV/rpTenYAeOZ5ll+cFVtyOPr1AKU7ezopp16PY5REZSxc5lopubgsMFIJ5+YitjkNcHXtJ8+U/RC6ntlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784694500; c=relaxed/simple;
	bh=Y4IKPmOrIgUJdzKXKjkJrU/HRrm4Se84EbvgRhy9FYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ceq4drn0tPjxaxtQJEbfZOXocCSqKkRMBPllrEULE4RQXqPfj+5G8KBRoQc6sqvG6MMG3NuAxqJ0wUqeD2ybz1Q21E8iIK6e+jgoPZk8+w3mLfbKSipKPIuVXO/utAAmcCUxZPoTnikMVAfcNOqHP2WNtuCKBQURRelYpjGs010=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=pwN2RHpb; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="pwN2RHpb"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493f6de72faso38591565e9.0
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 21:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784694497; x=1785299297; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ldbVD4qe6K2K3r+Kf7qw7vwzDn8tmHZoCss8MgT+CW8=;
        b=pwN2RHpbUtdPSsR0RwB+sFXth2w9nCYq/08PAXkHo17l9bCL3gL/WjiQng4pIRqeFe
         WFdTCclLvJYyyqJunhdqWzeXzXur7gnxw3lizjKAPS5lBzMHf3nHJ9BJ75xB7CJe69iN
         zEsjJiB84I6hSOjO3HcQV91h0AD7hqF68b0ooWlIYoC+VBYUFVpbj0Cjda0sbKh4dG38
         C9O5XYBTV0DMUeMXtzboV9cTN2XvtHls5HlyIGBeyIrChr/fEFnQ738Ye2jrlpjOO2Cz
         1UVIDF/MmxZnonbfbTwiRcp2F7WHuzAuWzywDfpPq2tefRVeSRgiUIJIL0ZbNdpU9BlW
         xyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784694497; x=1785299297;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ldbVD4qe6K2K3r+Kf7qw7vwzDn8tmHZoCss8MgT+CW8=;
        b=MjdpFt/hxKCPp1r3qrPEnvlivwuCLsNo/G+P5rcvYfVCHxolMXmxR3ZUww6aKrYyVu
         3cdO/yw7+7ISjGbQnuH4ZZAtOdQJZ4bzgZnC5Rk1MszI3EcYBCXyq00QvIsv+A8LCJwL
         sRkU7/lJ3JvizSGFHBdCC/FdgYqycddkAhhf+0s9VFVIwNpL9ko7z43dJPOL29Z24ByR
         qv15HoN3KV0Lb73gJuuwE2CmZKPyhJILDl0xdK7xUiGGVgffuv4zTYn1LHwESLv7MpiB
         3MZVgzAmE3VspA+UxcpjMdk1bYF/guNijLnXNkKLuKRsdsY4vy7woTXPZMhfx7PC0HWf
         ancA==
X-Gm-Message-State: AOJu0YyTt6sFEZGnBATB6Zxh9gdr3F5X5r3F/FfODAf+RpxDwynii82O
	Arlr+SGZsKyZv7JhxbrY/yukxQIgPEu4VSGHEDCMaGJQfqFW3G8UDNs=
X-Gm-Gg: AR+sD12h6BB0SHC8WZbQeGm4djGAIHPFTWYVzc0bAf27ocahaokwOv4uyUbTT4z82fC
	W5zB98Ik5Bj5hbkJhCbn8kqM8n6hWaLdVfkgHL9dfc9OYSWmIQVoIUueI5k5ajSLfE5w8JTo0FO
	erDyFSkKjkcmriQ7/UvvJgOQKdnXzUx8GLOJoa11Ffe//qXErbPwNuVTJW9yMxGRfgspkgDLZDf
	y7j22+1fmI+WE8zBjGObiFueL87j4sf2W1RQxy56a6vWj3lOC1gtAkofQeD7zZE7tI0JPoERHaT
	wckieUXeiXp92MHQeUWA0SovzD9MA/J1rer5d89/GcpBKuoHwl/ZZSoEvs4AdLNGbONhiXxi/c0
	LUEI9TgbvSXwpHShGQCsXid7qpeDwO50yQ1JIaw+9ZKCHJQ7q5hHKTkVvP9zlwqxjeymiYHJ0zo
	sjXmzXoZXgl2UgghTSFHAWuzZdPpqMrxxwtaC3A28nKh5RS5vZdQKzrMXY4zFbopTo
X-Received: by 2002:a05:600d:8449:b0:495:6022:5a23 with SMTP id 5b1f17b1804b1-4956a51d5c4mr27454805e9.19.1784694497026;
        Tue, 21 Jul 2026 21:28:17 -0700 (PDT)
Received: from [192.168.1.3] (p5b0575c3.dip0.t-ipconnect.de. [91.5.117.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956a509901sm72181655e9.8.2026.07.21.21.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 21:28:16 -0700 (PDT)
Message-ID: <ccc8ecba-4f79-4fbc-88e4-3da6857a3827@googlemail.com>
Date: Wed, 22 Jul 2026 06:28:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 0000/1611] 6.18.40-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152514.750365251@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.07.2026 um 17:01 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1611 patches in this series, all will be posted as a response
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
