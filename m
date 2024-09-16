Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4516143C63
	for <patches@lists.linux.dev>; Mon, 16 Sep 2024 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726510349; cv=none; b=gNZ1+YfZVuJ8j+Q7W3NjtMFqSHPpf0U94Y84Hn0IX36nIbc94ENsIpUypsVYfieO1RgdRvdXdtgSNxXIZEabPCZUiua+Uo5X3AXNKtGED9MERlO2v3O1+MECbQyBF9E0oZvjDJmDMNjrsgGy9qLrUwEufhRDTZbshMITEhxobUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726510349; c=relaxed/simple;
	bh=/OfRyNqrb0rhZXvUasI7+TDBt2vnFU2uO2phanTYMSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uFwW1jxpUitvNkxbED4EQBtmzWYWVhOcegsLgLkaDidJ7RtR5zwouwbXtcocv3LlxnhzoBhCkWQTaB8JLA3ff/u+S9TXOhDcap6mIEHF+oZ0lERR23IquzxeJ6F5LCmO6sE2p2JKCNI25DHV8nrnotVyBizsQD9juVLvs3jifZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LdPqhChB; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LdPqhChB"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42cb57f8b41so47388355e9.0
        for <patches@lists.linux.dev>; Mon, 16 Sep 2024 11:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1726510345; x=1727115145; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ZW97+TG1bHC3qGZeiAaZOhq8lixoj+g1nC65K/8l3Q=;
        b=LdPqhChBRPH7A4CWeVtOC2B96ApcqvuK1kqmVKDUMJ7mSornq99USdj0h6DWpcdqX2
         QQN2W0F+ENyVsrfLR84NksDxBEkLAa0Xm7E9Y4Q43Jq01buC4RJkn/tCo5Ygnhs59sTB
         wL9zM/RK/4o2TnYuge9VOlBxmM17PP+bgfXiOZty6/F7lU6LjoLbgBfgYbB9Ek6vJzmk
         aPXoUK4r7yQ4vbLApWpj26A8e9pKQligEV1Oa1J2GVVf87RuIs956TtySg+OkmhBEbnZ
         T0FSgnVw6iB2llVwwAeD3eoog2vNfXa3XTWJkoFgPNHH8fvbUH+CRVaBsM37rWXJlbbG
         v3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726510345; x=1727115145;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZW97+TG1bHC3qGZeiAaZOhq8lixoj+g1nC65K/8l3Q=;
        b=R278Km6ancBGIwGGBe6e5NiT0ULRYQZJmwJ8wPvsLbPOcYmEhXfFS3dN2F1KpJ9tq3
         AxeKQ2ueHlJpKtf3P4KYDPx/wvoqSZ8YhiO7J8ewe9HbNloA/Ca2r1oWSCbeu32vgU7k
         BNz9bbRLf66azjy942BLL0Lsy58D5TtsV7i7THjpHPe4p9UpnueGVUNcBvMKcc+p29un
         /LV/jttisdpzsbb3+h67Vb/qgCzaEJp8uyAVzaa68JzTTXMd7PrzVuVbjuwBnUTzG1kZ
         KyLw6GTfQ0f+U5VEWRpjU23xyQGWtIXCzTCn22xa33MXizi4mDyhtauAabgHzXa+VvQo
         9LKw==
X-Gm-Message-State: AOJu0Ywdzf8P2ZExHqYvT28vXTm6CJMO1OwLIZTZnlS2dw+b1cp7RRrn
	KcaeoFcf9xOlESn84GIQXF6k7xfDoJHRnJf0kCZd/4ZuQ8xOWKhhaimxiJY=
X-Google-Smtp-Source: AGHT+IGQbKp0JgJMcbk//NhE7JFF/Sc+z/Un8HvbYJn5CqgdSrSP+LnKzeoQpzxpl4BwO3NAoE20Ww==
X-Received: by 2002:a05:600c:46c9:b0:42c:a8cb:6a5a with SMTP id 5b1f17b1804b1-42d908267d1mr131297855e9.15.1726510344858;
        Mon, 16 Sep 2024 11:12:24 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acc3a.dip0.t-ipconnect.de. [91.42.204.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e78051c1sm7864645f8f.99.2024.09.16.11.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 11:12:24 -0700 (PDT)
Message-ID: <0b3ad565-1d66-4dcb-9a6d-64c356d50e2f@googlemail.com>
Date: Mon, 16 Sep 2024 20:12:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/91] 6.6.52-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240916114224.509743970@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.09.2024 um 13:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.52 release.
> There are 91 patches in this series, all will be posted as a response
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
