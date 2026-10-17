Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E90A3C73EC
	for <patches@lists.linux.dev>; Sat, 17 Oct 2026 23:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792280310; cv=none; b=TpunoTvj8BixPTwcjJM3N00VKwC3naYOOXdEwIDfPKA9wGkwO52N+afT1Ew9spV+v+h0nCSkthm3XVVVK2ft5gkeFNl2EBtfztfZzEP/oZ+g75AjXtntcApYZix0YLq26cv20Ty4Muyiu/INL0lNzA8Cawhd4hUm9GHqEKaegns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792280310; c=relaxed/simple;
	bh=JVTsBkfayrBjFco43pfXEbz4LFu5+JkfJk9QW5Tz/vA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KExnQDilUXnW0wZ/we+uG1rXmbB0RudMGuQs2qOxPj+pqne/FpaqXdpy/WoVC9hwzjK3dJn6jR5E1x7Famg++ErgOS5IMn8dLZktGm4CkIg5PfRt2OG2LBglo8JqFOmzSFmAAxga0BPN5VlnYzJmBBEurINjxb+EWOISDJe+1lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hiMMzT5y; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hiMMzT5y"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1e3b87ac5so28245e9.1
        for <patches@lists.linux.dev>; Sat, 17 Oct 2026 16:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792280307; x=1792885107; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wiwPMxdwxY4yPc3TWeM+k3SIkOD63HQmDE61mV/SD6Q=;
        b=hiMMzT5y4jQMYpuK2k7P9ZrhOTLCZrRAN/HQfaXFidqW7jrqHHCP90qqoB9JmFee1b
         xGCBJnkzI3M9yqxORfh5lZxafllSk/RBZlxezrEHMvtn/sq7nRoy/x+vvX81hMluWf9W
         OzxsgKeeqpTUwwwz/bXag8cZjnprz8yoUfWsa7Xd/o+s6YNZy2I0zAQ6OL92vf4T8hLF
         zK9CnRP6f4Qd5TeKeirM1pbl+LcM8zNqroKX3gEim/6wgXQhD4WBb15O4E04l5hZXAkz
         xnZsJYybIfyU/MMqnVcn+y5UzLfieR9k4aoC5IYtc9aCga/7DFPwmDSNBEiSaaoMfob2
         Gn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792280307; x=1792885107;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wiwPMxdwxY4yPc3TWeM+k3SIkOD63HQmDE61mV/SD6Q=;
        b=sHVp88tLZXID4r3mX0IIzyAC+6q1GTh3PCsmR3zigrsgOT4p2lddFdXK9nLU7ano+m
         mbZJsTNxsSYa6Ro01aK+ooK1cK2O2MeLYY8jykrEn7HcB8ah0szl+FHeUipkrNA0lTDx
         0QmZ1ygN9EwWx2MflsqLeGW7l3JxJ8bXydwKlGOsrcw5dLra3OpIvee2oXYXmi+MKMHk
         QcJ599VAv4mBGY3ZfHTjE5cDf+N2wIYfbu4vidUK47MIJIM5q8ql5igDN4F3+IMs+XoC
         T5E1AwJK+Sk2gBEOriJHnvHtzEVBHXQNH+KKfcKuA0tD17b5pTfYiWt00qvdipGGe6j0
         vvxg==
X-Gm-Message-State: AFq9FYLhhDFpA/yrC9OYdo3qXhfYYa9D5N1prfuQUZyK7uS2Wn9IOwlm
	yTCTXjz2X+IMm8Sih5udQBqVcghFg/vkFGRLWOwgfcvhbo+1ljLP/XA=
X-Gm-Gg: AYBFou3usNE/4IqM7Dbj0elZ8dTGkdxCkVOPoj4CqoOgg0JJV8D2Cg9NMbhgh8/+HOv
	xgHhb80q7ahdQiSUBUHeJg6ysFqEf+EcrDSAJtCD5/jSMPo5mUr/lJ6MS2lP649tBdFTNeYvX7v
	4tNGsXEdxt/25VlNBMwuo4oaEEXPWeShZ/DMPvEkN7rTwWz3gf83qpCi2sd+smnKDzD+N1bQZky
	WqSisvFBAQzI5M4IZX8ASMCLv70ngoKuGrPEMVoypOM5gULbU1JxXUO3fhtZRWFVf3UjNkh29aI
	p4FY6AwE8LcZ737wV15jXldWAEZJn3XwV5bdaUrUZV/c1/iq4dIzog4Ex8zNaS+hKhTkvU7BLwB
	lXYkTfQwtJRpQfMbxvPIS3NSSx7FNiTaGKU/97SNy3HS1eNKbHfT9fK6Ttr+Rvn6o1liwOSh6Yi
	Rc7nNUIhDaFF3hO60U8hhQ+xjw0/iEXPl+iLsBvsEHp5ohM3wa0hqmc53G0QwOW6R5SpNXwK8wR
	fjp+8Ih55ulUJYZk1cOxl0LGvq/wevW2KoKDhPul7/ndZag
X-Received: by 2002:a05:600c:3488:b0:4a1:dbb7:bb44 with SMTP id 5b1f17b1804b1-4a1dbb7bc9emr40963825e9.5.1792280307200;
        Sat, 17 Oct 2026 16:38:27 -0700 (PDT)
Received: from [192.168.1.3] (p5b057d26.dip0.t-ipconnect.de. [91.5.125.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1ce02d619sm106283035e9.3.2026.10.17.16.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 16:38:26 -0700 (PDT)
Message-ID: <b6a433cc-b00c-4ecd-8549-c382b790ac15@googlemail.com>
Date: Sun, 18 Oct 2026 01:38:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017160036.979869304@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.2026 um 17:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
