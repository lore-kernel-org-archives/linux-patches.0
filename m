Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F4017F509
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 11:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721216776; cv=none; b=CoExtcA1sfisH8FGQM4aY4pxfztRtnndjSQN5PX5HUBi9SJeHcDV4VMssM0kDyNF8J88+QekkKWaBHFvONjL+16LjjXcQ//PZUps+56jubbsFIGM1yAnwaxmnT6b/kzZq6zzS7nwcGh9ssL2tUgOLqwYg4QPQd8fv4xHWp15QOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721216776; c=relaxed/simple;
	bh=mPNNJXb9JtXOSrYhH09YI2E6ecROU8kEPA0TLFzJtFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XTGLJ+l2LdicpxZ0pv5+e0fyfYn09b5AkeTHnS02/Y3WjxKoH0bncCW9ud2tEoKk+pVWVEaJXfLwVHt0cyRmMRBtjhqeA++yaFD7RotfCswH08yyaamAKW2lEMQ+xkrHbH42pbecZ33eje4KKH/8kQSeXJ4jqKDT5FJZcLlISDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=P8PrePzM; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="P8PrePzM"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so1352512a12.0
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 04:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721216773; x=1721821573; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FH2P+UODR03FUkhmyN08iuWgXrF+03JkmoesFJR614Q=;
        b=P8PrePzMM0C5zP7XXhIPJniWc5DYjcx1Yrhl8WTe4QFUKQqNTjyHI6ciyK97QEoK4z
         EzJ2Z4CdVoVgseCppPZV9lj5sVwWo7fs10mela5RPZyZ6ahZdAjmyy22P+KLKYsZNDdL
         tW1ExeeCBDN3wwyJ6StIoVekjF0ce1E095ZjAMrsz/RQDvo3GZgoeTU7MWxnhv96uySQ
         QHoBlWEagBpIMq/lobWLyiCKIkva22OSbBN7PEHfH83aM/rM4tiCORh26L/m/pwbSzRC
         X2VRDoVHZlvfNZL5VasGTJfHhY7Wa0yDOHC+nQ8+a1fSbPDHDpz0tlSUX73w95qK/QsH
         ECtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721216773; x=1721821573;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FH2P+UODR03FUkhmyN08iuWgXrF+03JkmoesFJR614Q=;
        b=ZTaVH+qyDzOqsy3b6CnfJR1UPeMgjxA+qzbLLDKdKeTWZajp8k+KOpx1k+7zQWrDys
         tu9N4Ui9ugKjKcbKcXAhuAnRTGEFIr4KGkX/njdqmQo4KpPhr2LZXVauYq51gMGcDcd3
         f4Wtt8NcyafI3ARHBciVv0PpuZFN59EzbKlSX45htSE4hKCmmmMLHSO9ANZIO85K/GeQ
         dM0vumFME5eWeV3XEks9W9LzDDRW7H+CVjGESgBqtdn3cJQGk95PeKHGA3riwdRDSpki
         2vy9mC8zJkIsEOYREoJOw4e6vXormMtQQ3pvN//tY+uaW+EgqELr+yi6bQMAmWnxKaQa
         TfjA==
X-Gm-Message-State: AOJu0YzzUG3G5czo/BJ0pl8JZ4D/0sfdffCW30Ozz0XZ4nial2+ZpGBK
	8/L3kgLiRigUBvgZygYAMdx9ib2drEI5+8reQLbTo/k6Lo+3jS8=
X-Google-Smtp-Source: AGHT+IHY9UhZrcLqZUJEDjrrkScBQVarkTtANqFffDu6b0DNpiM/F0ukbPo2IDtdU96Z3B6jY5Z51w==
X-Received: by 2002:a17:906:5a93:b0:a77:dc58:d30b with SMTP id a640c23a62f3a-a7a00915bc0mr153976366b.31.1721216771808;
        Wed, 17 Jul 2024 04:46:11 -0700 (PDT)
Received: from [192.168.1.3] (p5b0576fa.dip0.t-ipconnect.de. [91.5.118.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5a359asm444939366b.19.2024.07.17.04.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 04:46:11 -0700 (PDT)
Message-ID: <56ba7dc3-bbcf-4d62-946e-a234c74dbd0a@googlemail.com>
Date: Wed, 17 Jul 2024 13:46:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.9 000/142] 6.9.10-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063806.741977243@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240717063806.741977243@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.07.2024 um 08:40 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.10 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
