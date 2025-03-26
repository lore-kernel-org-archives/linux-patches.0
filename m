Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7BE1B4141
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 23:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743030291; cv=none; b=fp70ZY7qrgmZFmgBI/eJbADaYh9zQkPwwRauMBfVyGjFZyDP4eL4dX08f/DLyV/WRlhAi8+DG0pboH04zEU9R9LWJCY7lz8ye6M98Hr++ckwwu42p87twOfjEyCZtRmTI0xg4QRF1gj1MRoFtGaXdFkvDB9gccg1QRKriCixBUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743030291; c=relaxed/simple;
	bh=lu0985pnAiWIeLqiiXNJyyeE3/4K9/7b88UOr7N8zC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PkZKgg/Sphtjl9G0pHEJWwK+WJNJfPjTHi4Jl/+cpRgNEvH6cnBbDzYRodwoWIjxbBAHbmN/xNC9uo4lEnTItclN7vrBAVzS4Mw12VqIG80IsDwQ9nnC+M293XEvZ4h59e+yjaMhhNo+X9PPn13bOUsAvhY85HTmTsC7vyIgx6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VBwwnfb/; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VBwwnfb/"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3913fdd003bso203085f8f.1
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 16:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743030287; x=1743635087; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G1Db4+giVOhxRRsgeVFOY4J55f6l7WCs95jCreUUDT4=;
        b=VBwwnfb/dCdgyjWJRKNKBPzdh7trXWFrzaB52YNmuUS++zX3YdeDYY2bXc+eeQ3eFU
         XbeE6ZAJjJRnpDLN8Lxuqb36POChiCJ69qntY/wfoRjSb9Y38A2a2AyU78dTgBdK/n6A
         6jdfoyvpdxjEMENpNQ2eyhrK3bHJISvXk4OL1SE99lZb2BnShqUi4HA/XbohOIQo/O9E
         PMsajCtEU+m6WsDIUDqGdsI6VPJE6WiPvrdWrHJ71EVEoPhsof4y0U1ToUnFptGH5tBP
         EqcG6uzxDd8sr4SW+EdHuhAoe9Ml6nbPzU1e8JSwpNpL74VkrUMY4LiJ8v7bArZ4tzlo
         f7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743030287; x=1743635087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1Db4+giVOhxRRsgeVFOY4J55f6l7WCs95jCreUUDT4=;
        b=isAx17/yZMHB7o0isn7tGaQqkMvdPjlYJyEK+5gH1hRjK8PzmIdTSX3vV2bF/4jMJ9
         d90q8qdON/LxtKNnb8NzpIu0MKDsDMpp9jP2iK1VtLM/Sa78CJa7Vt1Hz+46iyUwIQW8
         RNw60tRbJoqu2VYe9mZejKg6Tqv8rZyzQMKAA4LniZe4Y+y3Sfe2hp9MY4XZwnhGQAba
         oEa1u6BEtnZnk1eeLEM73hXu/xVNeukkPxqgd8frJQelc2/sM1NmZxfei21M+hHT7gdf
         U/6BQdlyHYKsXnRgcnT5CwGE21lZrubQZxhJXTtadXanOKiGDPVo2SOqdFsmdpApFjlW
         ZB7A==
X-Gm-Message-State: AOJu0Yw4erMEv7uz0fjnDtTKBPkQW7DKQczrUEilsvhurq+WqFXxnGnd
	ZV8NNgGdFYEazwRUFGc6qI9xS8RtDj//jLAIegsFbc11ZqMDlcU=
X-Gm-Gg: ASbGnctypEC/rXTlmaq+td3b28HLJZ5P8f01Zad0m7ZxZCzFrXSyn2UU81sLB2tHHk2
	ilkafQhtsvP837np2DNP07VlbQTAFHCyLJewwNEMl96kib5FIhRsukbx7z/RDTnLnlai/BXJe/9
	Oj2pImIeQde6j/72f+dDjRQPdQepRRW9PweCG/aBSABPWFP7k2DkNySWLs6i4Wgl088dwhMufr5
	HCj+hJnhSN7FloMjwkyyAJs2FGLxNbqTqUn8c8wWQD04uP6g1anMzfXevoyO2UY4HyIS8UXAIIo
	ev7UfkjWIMD/OShki2UhxDjbDzupFpYZnXTTzowZmw5iKb1JL3kz4JtM+SeHp2LlJGtzwQ3qdFj
	T026+O4sJEgkpquNupO5g
X-Google-Smtp-Source: AGHT+IEYCg6JrwvA9ri9z4o/+GNt/2rRyXIUH7v3Awan8sMK7hJCRKxqpK5ZlWFLSeEigUNOVXrQJg==
X-Received: by 2002:a5d:6d01:0:b0:390:f9d0:5e7 with SMTP id ffacd0b85a97d-39ad14f7f07mr1284508f8f.13.1743030287279;
        Wed, 26 Mar 2025 16:04:47 -0700 (PDT)
Received: from [192.168.1.3] (p5b057a21.dip0.t-ipconnect.de. [91.5.122.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39ad0c6bae8sm1940263f8f.68.2025.03.26.16.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 16:04:44 -0700 (PDT)
Message-ID: <d3ca01f7-08a1-4725-9007-b6d127de0b1d@googlemail.com>
Date: Thu, 27 Mar 2025 00:04:42 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250325122149.058346343@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.03.2025 um 13:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
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
