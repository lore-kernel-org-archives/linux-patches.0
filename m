Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEB813AA2F
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 05:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761627906; cv=none; b=hKDoulD3GBjXr39Ulv9+MXROGjVHgsu/s/UIDSgqcidIFCjoacx2oljTfQIgOCw8IHV958Eyl10RloQuSt6Ll8L4RSyP+0R7wwK1yFi7R/nFsq8+L0Hz1rkpAuByLDaHH5+VQBr/YQ9V1NPIdr8/0FADGBWmDO9F6gfBKyU37Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761627906; c=relaxed/simple;
	bh=tPEtRdgT5AFqfrjmOByK1BhhX0vqZEFiVdNegX8W91c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eOWO6DHhCagDunfpv9lTmZ/RElN1HLae3ai4qNuOEb+TncAtzIu2L+ct6b5p5K4Pt+6EmC6/gpGO3VzxSTEvXKNaV7c7BhM5SAa7uTwenDrL4paP2J23kNjy/B3fAIrLtaoolRb/xK6Ouih9yafBvFn22I/g7fO7WWcyq7zs/B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=d9yoxhMX; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="d9yoxhMX"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c4b41b38cso11853233a12.3
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 22:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761627903; x=1762232703; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AerQ8anahxAVq796epN6eN0GZqxQd097rK/3M9J0Tyc=;
        b=d9yoxhMXrvht+ff1MnleqP4vNpzmQKnW9t0ZFBupy0k33PZHrU12Mzg3U+RXTqC1qi
         SUYbDPHpWbB3QPdy+aoj7dSpTOV8Kw7hnFrlWgM6bh8HBwMh6pt/cJoVXG3xsTesyTQN
         4KgspF0UvI7UOmud0Yjl9hfw+R6+kzSB/6nj1RWcSI3RcxlafKlB1uyWEWBwKzb76Ufo
         REMdzSINikMzhy0j0PKU+tbcPEYAV6TfHKp8D/VHMeprVUcfWuZDpsPa9d4DQHC9C0AI
         uoNSftVbB1hoWBXaCdTKbwnLO9Tuhml4Wyww5BhJpDjVWzaT/aAVTxzrspqsmenEK98L
         zX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761627903; x=1762232703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AerQ8anahxAVq796epN6eN0GZqxQd097rK/3M9J0Tyc=;
        b=v6AcxX+rf/MBVDexesxAH7tguLs6Yjvv5szBtT92ZUQe3nAd+Sjg7csmDPVu/L9y48
         Bl2tWZqA4nGPR2JY6840RagFjiiYXLszJKvTJxW4cny5y9OgeUpPMl5EvmTaA0XQhyH/
         Ym0Hxr10mM3O1evYT9DXOc/06ZjO7C9wtx6DT5UmXJOLKacBmPJWQq+C7UAoaxFF1vw7
         YicfE4TM/PXIBTIpgB/T+WK8/P5Zb4JEJXq4kS1Xl8qRvQcSKYeNo6oWqHJF3Kcvd1jV
         kXSidg3oMtCO/LroO9JsR0x170GL+7r9oQfhVyUfAk4VEx6NaLjJnihTLV/LgFwo9aAv
         Z54A==
X-Gm-Message-State: AOJu0YwgCP7MwQNfntkofRuFSy/krAGBKA4XCYTm5IO0MB/9LJmQpxcZ
	yWB1lZkZF4ZaepPwszqd2glpS/NN9EQyVfjriV1LB/l5d54X+VOc6SA=
X-Gm-Gg: ASbGncv52PSncSetNzlUnuM24ZlkNH5KM22ti6dPrz3B0ZADOB21EznV018vSrdtp4n
	jj08rb2Dp4Qvb4Gim+EYRjVSu8TK4uXzrqL/JigeIE9yqjdGsmHxGtx5MJRk7Pyg2hN8pl7z2tb
	uXOpxTn2v2GhuMtWMpqgACWxCQc4RI6GcNd/Xk2ow3hCOLbmmNG34tKpLNcGlNUaiW66LB7LG3N
	W8ZUvCWBQFfGjC6QoWDbRQi81uv6SSu3Jy7HESWjVRu9T2rLVzoLoLji62oMquMLcF1zI0P0QyN
	WXioBJE4KBa0dA77s3LtHNyb6qt7kFRQRPMritUwMQeHLKMr+ZU7/xzmmk+Zi0d+RxQEkZbgmSp
	R6Q8lbQCGiZ/tymYnL8UAVbxj7vFtfsX3m3VGIFKqumxJcxlJUF51se7TVNu1sz1eLZUaBZ6Tkq
	fcLF73PD2kqr9w0YCHi0bsce2gH2+20NMKlKbZ6ylTOuTmHc3pZeI=
X-Google-Smtp-Source: AGHT+IG98gaKXDDq10+P2yRvMTbMWPbW2KU883vT9OMUrK2f2QHIOlAdmmMdyx3BlHiKzEtfl9tNlA==
X-Received: by 2002:a17:907:1c94:b0:b6d:505e:3d99 with SMTP id a640c23a62f3a-b6dba462958mr271070766b.12.1761627902710;
        Mon, 27 Oct 2025 22:05:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b057a53.dip0.t-ipconnect.de. [91.5.122.83])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6dad195456sm424001266b.72.2025.10.27.22.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 22:05:02 -0700 (PDT)
Message-ID: <bd62fdc3-03a1-4125-808a-4b4ce839e0e9@googlemail.com>
Date: Tue, 28 Oct 2025 06:05:01 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251027183514.934710872@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.10.2025 um 19:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
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
