Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800483D34A8
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 18:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773859441; cv=none; b=o2qEU4Lya3ZozS/TNR6gcDZ5gloWhP5E4XXctLKop04LQNdcwirLrI+Bf5gwhFTJxqmkwIbCzlVd4peNGQDIXNeRoDjJlgbJgQ/HiP4uylea19Ov3k8JvvzBz5PO9OKVCF2KppUW9b0M3szrefZCi1lKXGmjjM24sZJy9eefx3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773859441; c=relaxed/simple;
	bh=8Vcm/N9roL1EiGoUQJrKpZXwbsvsdhmITMoWN0rleZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QgP2eMm36ewsaAz96lylakTd4Um0S9JEqPVgGc3nnNt33KUzpIkGn06R+Z0R5rJacvA1Ra1wfb6XLUG3NBPEjUVrPrYYEe9xS8BnQbKBK2YcDC6uJ33sMamAZqu7U11V50ZrqZozRdNziwn9Cq4nq966PI/YqYjzDnYK2E8hmJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=aKJbwlky; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="aKJbwlky"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so1678825e9.0
        for <patches@lists.linux.dev>; Wed, 18 Mar 2026 11:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1773859439; x=1774464239; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q5gQcxECEznuueIY7HzNm9vgGiTnm3cM7BA/R5amhsw=;
        b=aKJbwlkyQoUE6qOUtkd7hUNkMkx68tX9gUCy8XesX53pFYQ6B4dXrAEli1Xpy3TAtr
         fj0+3HA3wgUnJsIVrvd2meTG//ytjlCRb7t42uoReX4g9NDvgqtSGc/+ksHDHCZTnXiy
         KpzqBfhetvPgSvopgiQMnJrZ9KcDLroCzoWJVRys045W2pviIrSnLLiKh6ai1rqfgDuH
         mIM69CxW7TAiFFhVyXdyndmOVAYP/mrdryaOVHNpuhbUpOAnTGPOAw/nRLG8mRXTxLAb
         ZXEhV9ivH7toGziF2Yl5P9B25VrdgJlYdxi8ZKsepH7YJb1OUBiT6jT9tuamI9DRnaHF
         MhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773859439; x=1774464239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q5gQcxECEznuueIY7HzNm9vgGiTnm3cM7BA/R5amhsw=;
        b=CcgoXzTWiUh/UCxdWFwZgWSj1EduC0FlVeM0ZaovH9GqbmuX68corwCsGB5ijrUOZg
         r7IZ5if45yyWtjqGhtoaQfrz+6HOOITAbB3XYMV65rSpvKxr6J+NUSgWvKUxsheH9XOy
         KbJZ6z5q+O4fN8nHbvug3RiMBL9fS/G2JU7kvC7UxxpLxfniQ1FAosGsXhHm30JnIt+V
         DVcDqj0DvEhttHlNx+DQuCqB7MmwNZtiA9ceVmOIVYC/t/ERkZtHKZGx1HMvCZrEO6bN
         HKiyBbjtjWjBSgxUsy3SF7cAF0Y3THwZbzpL1WgAZ0BY6nSCd0ZOr7ZrWQvqAYF3S+cV
         pwCg==
X-Gm-Message-State: AOJu0YxkCt5lLNC/Sem1Wku3ezw1i4IThqWhmL4i/COMQQ+mD7UjOFhQ
	ialJbjE+gfoaBvkuoMG/dh1mxePKtl4k7+/oot1DFgarC1Bb4yy5FH4=
X-Gm-Gg: ATEYQzyeZtXptYafCBcL72wTUCjW7m6nW1nzpHAqcWUCerCur65MY8UEsU5EfnGYVpq
	ntlphW8gQHQmgBCxOOu44bTL9A+bXOPLQje2wh7EIFUevsGK0HhI8uytg7qt2pqC8NC1pCmOWUa
	qngSx9MiFJPiC1nkXb96HBaK0wgoQdK2z6KTw5RU27adyy7NpJZkHlt0lGSVIWP5O607MsvDrJi
	iTaXz2wIr22nhKiwByihgQR+0LWZgtApZyRX60WpvTt9/68+Ep5fZY9DfEjsgbw9eYxQFRXKU0i
	hirMK50ux8wfaD4qmHwW8nXIa+MESVd/nc1tcb2HxBfAy1BNx90cwn798j2AvEs55uwYPUfQpJB
	vX9Yosy1KhC3sEtyPDryH10dRPkW3YhMx4hujq6ikaO/HkchYCnOHFr8Sl4F+ktSXdINpaLYbXF
	Pe2Mhb+qkg12/sZQbZ+ptCAcQ7AvdRdYb/i/x62DnY9oY2s1l1Xa5amBqbzogYspij1Qtm6M35u
	DY=
X-Received: by 2002:a05:600c:2d15:b0:485:5d25:81a9 with SMTP id 5b1f17b1804b1-486f4422231mr44915805e9.14.1773859438445;
        Wed, 18 Mar 2026 11:43:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace2a.dip0.t-ipconnect.de. [91.42.206.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8ba4baesm14540345e9.13.2026.03.18.11.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 11:43:58 -0700 (PDT)
Message-ID: <3b36d8bb-2450-405d-a23d-9feb7a755dea@googlemail.com>
Date: Wed, 18 Mar 2026 19:43:57 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260318122547.233850204@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.03.2026 um 13:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

RC2 now builds without error, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities 
or regressions found.

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
