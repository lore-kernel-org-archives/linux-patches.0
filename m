Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6407A7262D
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661826; cv=none; b=D8XvS+o4XqpbhofwttS4l5TNFaBgMZH5ArcJOiVcsZAAwQY74P20WkEptrXzkKGGFd9oywqZzB/Cr8VLIUKMT9VFGrSOxvTm+36L7ADMsom28giXMHDIKjqnHHZK5klmCx5mBm8aDGeRCrsP2joYs+20f6sLWRxjMyEmx/lGOkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661826; c=relaxed/simple;
	bh=tZSHvE7TdwzlP1qobY35x/N6TFretv4ZlFe9i0nhrMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CxbCSWF73tCJh8MGEkgFqKngAzOaGQXUj7/VwqVqf11BtSXKNM2xqzlXw3xq55a1u/ORQWgHi22IjANDf8z7sKHvBr7AZDwkEt7rs62us/I29TJV8m5VWBEhQD0ZpBx6oQ3E50B/46SR/7LpU0NPZWpSlpkLCs14ZGRi7HqdtG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C8+DwSFj; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C8+DwSFj"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b60565d5f4so301279f8f.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 03:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752661823; x=1753266623; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6XnqCTUVDxXqLw605VpQiOmmAr4VEm5DLMnQo1CAZWc=;
        b=C8+DwSFjcBQkfUWO996i0IXJjRq30glm9zZ3eDDMeSGY/9ZWjXHesjyRePXmX+kEcT
         +ri4AKK0a+GMqciEGKfrzfhAiySvaIrUxDDpXTCosUBOTU1jdoc0wBaaGd4Qavs54F5x
         HFmnVOGcSF5JSkW4ncLa9cMzaJqE9a25EsXs1Uz5qcS5skopWrt+vfxBCMNi0qVXunS7
         a8y2zd1V53g5QuAeDCcsPM5ZNU+Df8DhI1FGmyIrIEoDGcKcaJzXBo2DoNSz5p0hQBC1
         oFfEfhgLINM63goFF3YrLuYY1Axn394yGpjDAh2uS9cuMvupVQR4oSNIX0pDr/aEp+Zf
         syIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752661823; x=1753266623;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6XnqCTUVDxXqLw605VpQiOmmAr4VEm5DLMnQo1CAZWc=;
        b=PJmyzoP1S5iI240t/+kbg8xxnGPTsTS0AAJaMUcI2PIKjT2HcBnv1VrY6bd8zZdRBm
         9uppBRlKDi2mVAch94SCnIeWTse+DbiM4ibiwpMiiyIMbBrXnfG/NW8bVnZcb0I4Mwms
         1H3K5PZwwR5qcZ5QokNs3d9C2qt3z71OIr8EilWOx20B2bxkR/eMN/ZxhdEy5NqSmlu1
         XIbugrSDL2qofN9F9vf5m9+6mL0Qvvt7c9MV20R1uvQ/Fr58otosG+vhm34cslsnVykY
         EDLY0ix4ZMRLptyg4CMU6UKETGaSGwx/HJsHiMyrijfKYMz52XnNxq2qX2saRdTHCbMC
         6tdw==
X-Forwarded-Encrypted: i=1; AJvYcCXZN3KA2pX/fuCuV9KqPc1UHwEF8q3HN/wPkk5bDKX/OBctiKuh5plwEwoHNFXjlhpFyf/D2na7@lists.linux.dev
X-Gm-Message-State: AOJu0YzVvO3RmVUrHAUjLaMiYAhT/2LOfJr9CdpeIghbt/npBi68eQqh
	tAsddjYKkpfYcpLItydIpS7n3BEZ/JrAw9kaepZJmbIH7u4qw6AkdDXyOqGw92AHHjA=
X-Gm-Gg: ASbGncvu56gzqdadyIeeph66yR1wugu9DbX8ybelc/B3q89sYk155aEcJvTMXJHqAX0
	8L67WCvCtWSZLiQ4CNC7Brslq3j4rUjcq1nRPLg5iIED2CWZ1zFTt26VcweAL2I0SKpJOMFmQip
	6E2jvg8PQcEJ3txFj/goLsSD5TsHiOepJgD9qy959baEkCotHXCTKHFUXW5XTUyK5v8n2oUDKKR
	K6z8HxtFj+Iawx4HprzykywpjCp7L5Q7FrPOIY1nRqIvIQXWJ7YgqMx4Bphjmfbu0CERty5cflJ
	tDuvzd5ItWo02TN+MqBiGd6FH3EGDHI0NNh8lICy8vSHcDwB4gDlko0HsbiE2cm+6w8WATiXSWF
	znbArLEfl40OdkuK7D6xD6kTgwcL6oi83qEyR9pStow==
X-Google-Smtp-Source: AGHT+IEWEOxnRmsY7CW6qzxqOxUEAfhDQBThVtGYsxYdHnrMvbBgNTYPuxWQrQr9DcPA8NVplhCfqg==
X-Received: by 2002:a05:6000:40dc:b0:3a5:3369:52f3 with SMTP id ffacd0b85a97d-3b60dd4a834mr810416f8f.3.1752661822704;
        Wed, 16 Jul 2025 03:30:22 -0700 (PDT)
Received: from [192.168.1.110] ([178.197.222.89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8bd15bfsm17790152f8f.19.2025.07.16.03.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 03:30:22 -0700 (PDT)
Message-ID: <8698f842-a464-47b8-8c47-97cda016e227@linaro.org>
Date: Wed, 16 Jul 2025 12:30:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 2/2] arm64: defconfig: enable Maxim TCPCI driver
To: Macpaul Lin <macpaul.lin@mediatek.com>,
 openembedded-core@lists.openembedded.org, patches@lists.linux.dev,
 stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Sasha Levin <sashal@kernel.org>,
 =?UTF-8?Q?N=C3=ADcolas_F_=2E_R_=2E_A_=2E_Prado?= <nfraprado@collabora.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org
Cc: Bear Wang <bear.wang@mediatek.com>, Pablo Sun <pablo.sun@mediatek.com>,
 Macpaul Lin <macpaul@gmail.com>,
 MediaTek Chromebook Upstream
 <Project_Global_Chrome_Upstream_Group@mediatek.com>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 Peter Griffin <peter.griffin@linaro.org>,
 Conor Dooley <conor.dooley@microchip.com>, Arnd Bergmann <arnd@arndb.de>
References: <20250716102854.4012956-1-macpaul.lin@mediatek.com>
 <20250716102854.4012956-2-macpaul.lin@mediatek.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 2+47PN9NZAOyb771QoVr8A==
In-Reply-To: <20250716102854.4012956-2-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 16/07/2025 12:28, Macpaul Lin wrote:
> From: André Draszik <andre.draszik@linaro.org>
> 
> [ Upstream commit d2ca319822e071423ab883bc8493053320b8e52c ]
> 
> Enable the Maxim max33359 as this is used by the gs101-oriole (Google
> Pixel 6) board.
> 
> Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: André Draszik <andre.draszik@linaro.org>
> Link: https://lore.kernel.org/r/20241203-gs101-phy-lanes-orientation-dts-v2-1-1412783a6b01@linaro.org
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://lore.kernel.org/r/20241231131742.134329-1-krzysztof.kozlowski@linaro.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>

No, that's not a fix.

Best regards,
Krzysztof
