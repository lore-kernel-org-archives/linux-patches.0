Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1913D2FE075
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 21:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773781425; cv=none; b=J3sxRyb6EABREXI1mWApK+ltaD7EQEJFheo8lo7zhl7rH29rwsBjIVpmFK0hdHZ1ZxP/iqKmomtjRSwnGaEPCjq4iFEoleEPY3iQXs4vHE/SkUrpRMUtXx7YJhah52FZnC5hvxWghCmJgr081g05gJftVOgL7P6W53V1tgRAh90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773781425; c=relaxed/simple;
	bh=bdXN4W8dbAx26hVc8+7B8poVIYSFp5tngJk7XmJmdPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u5yPfBldI3Qm4jx0GaH8JRThDlbiyMn9WxtypIALfXO/UPTArDssmRpkuLfI4fmJ4xT8OgsiME84qoO/uiJKlCrAmicxeb+alzOZwN3EQ5lqmee7dRoWgErq7zrkjWkTa+dTcuo25zyjXweLk14xBdeUiy3YThMJpxbBFFdpeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PYp8qyxW; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PYp8qyxW"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48538c5956bso2551215e9.0
        for <patches@lists.linux.dev>; Tue, 17 Mar 2026 14:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1773781422; x=1774386222; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wxBhZ7CdyArr27GxY+04wnB2mrYkUJhRWilAMxTkQI8=;
        b=PYp8qyxWVnq5Cp+DLLx0uXlZ8fe3f769NInrvT0gPP2T7a09BI+Lhj7AAnB43G75ws
         mypv6Odx4c3/yJJOqMRgwYFbMNdviNSBzMInN32po4MrVlO8MW32vtfbrVpuqHQQzaY0
         3iVVjKezopbic+b7MQetPjTy1DAsmMEWv1YWTa6JK8e0GsbiBNuSZ+/ir0fRzbLW4E7G
         X8EeDVD/FXGF3hgazLxzEwo1F3SvbXtQNjGU9JgGh61hk5AlNF6waR7PO4mW63pq2ny/
         +CXxArfzfoVXFGDrW9IEFzmkZjXndtrne02Ib/7FfBINjt8/6CFVDPQvRaST2DOqIGqE
         WxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773781422; x=1774386222;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wxBhZ7CdyArr27GxY+04wnB2mrYkUJhRWilAMxTkQI8=;
        b=FTdHBZg3/JvGK/6XPpf61fvZ6osdfudZFBniTo6nMw7thi9zfsUb4/mqHA/VJecAym
         d2le+4RILJ56V+rkl2YgKSJkagLoxgR7zQyw8vzjIMFU2/HmBDVfrvWriaeRiZ7FEIwJ
         fLMOrKJ673VJTUkClhkVZI9eqXPpbezdImNZdr/drYRweZQafHdQj+DdrnG4I1XZOCQc
         gYYleT/lLuA5OAfEzXja9YJ+I7AZruBc968QTbMKfwAZ5Lyo0aWkFGpNWtyqDlwZwM7j
         k3erH4/PK8T3f09ONGYqRFk/UONEGfATfZrDROVE+jG9c1u+1Rabx5k+7YKPTfdRq5sw
         2/vg==
X-Gm-Message-State: AOJu0Yx5ETC1xLbJPkAeD4BFoF1gD3YCG0CyFJoZmJnGc2TbJRW5ZOwG
	nkyOjedriWtlCm8gUqGgG4bkN064vbSlDFZuhaY1/OQIR0QpKloFzW8=
X-Gm-Gg: ATEYQzwiciE8qQvq0A0hmVmeo2+LdXR4Xrj7y3ZmE0nG6e5KpM3sgbyWuv2zCuinQDe
	vikeMfjSnGgF1udWg7wDp+qWANDsvRDIeTnM0sypswWe3DvVukOJVqlI7Yoe/XaTKNA38PNMqvM
	lSDdkUOwQ8GPYtcDGZKvhhEqRqlCXeuDCzOQX4JP2vycVnf/DW2STKGTLnj5CEwPxwli7istKxb
	QtVeJ+XkFbpYdJd22UWPrn3jDApQU++sTZmGflQZnIWJXkhMq15MTQtNYzfNtI/FhDpr9XC+xYq
	8dCF+sA3l0kFOWZUOMd8Py6zw4YXoCtEEy4KD5fhU2TvXN8K5b3zik+3+18OUEfkldZ4fAMFMzH
	cxg9NZ6YVndGmPuLk2j1M9+PC02WD/kJpIRhBEmgf1lzSYMBzRC5CrujFvtOZKGox5F/Bt6DBaS
	PRvjgVGm+bwj0KES4NiipskMp2+A7HUeEIj41oO8WcBscB1VTSprZcERJLkCTXYvDxMYVb0hdVq
	4kcja7BMeXl
X-Received: by 2002:a05:600c:a00e:b0:485:3428:774c with SMTP id 5b1f17b1804b1-486f40a604bmr21513105e9.4.1773781422216;
        Tue, 17 Mar 2026 14:03:42 -0700 (PDT)
Received: from [192.168.1.3] (p5b05714c.dip0.t-ipconnect.de. [91.5.113.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4856eaee04fsm91129815e9.13.2026.03.17.14.03.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 14:03:41 -0700 (PDT)
Message-ID: <731ff34b-3967-4a21-83e4-d85009c48f1c@googlemail.com>
Date: Tue, 17 Mar 2026 22:03:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/333] 6.18.19-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260317162959.345812316@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.03.2026 um 17:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 333 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


Same build failure as in 6.19.9-rc1 on my 2-socket Ivy Bridge Xeon E5-2697 v2 server:

   LD      vmlinux.unstripped
   BTFIDS  vmlinux.unstripped
WARN: resolve_btfids: unresolved symbol kthread_exit

and git revert 0507972c8244d6454cbfd242157e86bb01971bf2 (kthread: consolidate kthread exit paths to prevent 
use-after-free) makes the build error go away, but may keep the original bug the patch intended to fix?! Wentao Guan 
wrote in [1] that an additional backport is needed to make this patch work, but I didn't test this...

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


[1] https://lore.kernel.org/stable/20260317175812.707723-1-guanwentao@uniontech.com/


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
