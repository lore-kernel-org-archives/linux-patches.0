Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50E47B
	for <patches@lists.linux.dev>; Wed, 24 Aug 2022 12:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07EAC433D6
	for <patches@lists.linux.dev>; Wed, 24 Aug 2022 12:51:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yam95mWy"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 24 Aug 2022 13:51:48 +0100
Resent-Message-ID: <YwYe5By8yuv2fIxG@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 24 Aug 2022 13:50:44 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=UxaF=Y4=linaro.org=krzysztof.kozlowski@kernel.org>)
	id 1oQpqE-00A9Vj-3U
	for broonie@sirena.co.uk; Wed, 24 Aug 2022 13:50:44 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 041926010D
	for <broonie@sirena.co.uk>; Wed, 24 Aug 2022 12:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7E40BC433B5; Wed, 24 Aug 2022 12:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B725C433C1
	for <broonie@kernel.org>; Wed, 24 Aug 2022 12:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 6B725C433C1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f170.google.com with SMTP id bx38so16312020ljb.10
        for <broonie@kernel.org>; Wed, 24 Aug 2022 05:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=0O7Y3wJVPgnkwy4P2rEemJaId32uZhPl7XRxR+A9aIE=;
        b=Yam95mWyIq0L0MGw6weU1DlJz4RMqiQEoSPqdYdcFy81HXgQk97ePlQVxKanlngc+K
         HPCgJ6gROEYSRn95DexG04ODFwjr+N7Vov8Vr2319AMy3HTwssnYvlvI8S8ckOSaR9kp
         uFRFJX9mvjDuNMkDBCYKiXmY316JHSzxe4vmilL/mRC+n5oIkUkCEVVF0vAT5OGhMcvh
         RORPoEGTw2uHQV/6Xr8/cWXvH5txQJ/4+SdXqP5BuQb+Gip2Euj4geU9z56JJcTPko2k
         txxzU7CB4NUVazI7dVgVoyYBcWNFP82sY6KhI7URrk0ZIkj/EvEMdoGFuXERGWMD6GR5
         2LgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=0O7Y3wJVPgnkwy4P2rEemJaId32uZhPl7XRxR+A9aIE=;
        b=1NxS9wvjSXBEoOyW/W6MBPhpS03S41IwQ6+AFBX8V03BZGjWAhtrz5ZhXVbPmYjOhz
         /ySyCxa9uccgbcAiU2d6DE4ovuXNu9sh6ufbEebEOpEmhVDrKbol5S43uHqyre/OvrTZ
         w9q8z2diyYaGDfQt6CmAf8VivLUvI41FQ75JCkXP04eB6ZYuLBomeJhgGF4+eOqwLK2a
         aUS1c+RrTqJwuTlwQTd3+ps97LnzzLBd8F8vK0UKt3LyZCiI8U4Jcj5zVi4oZB6ycS0N
         mBQ/b9vBgfOafTcWPEP0OmFPaXrvFVzOJOSf0wsFgf6QGHcg9PvFGN/DOFOu+yByLr4m
         hlJA==
X-Gm-Message-State: ACgBeo0nkfVL9VFXLJeUewUapgGyOLkyxUcr+N3NBVkjkCqt6RZ3xJP/
	ebZLgP5S2Gr2RVFciQmkflg6iA==
X-Google-Smtp-Source: AA6agR65hBbDRBSJCxuxnnZFSQvwtE6BrqpyaIPRWhBHpgpzD629PE3LDaZFuYdEe3dkvWfNHYdAyg==
X-Received: by 2002:a2e:9cd0:0:b0:261:e257:dfe9 with SMTP id g16-20020a2e9cd0000000b00261e257dfe9mr898830ljj.209.1661345437595;
        Wed, 24 Aug 2022 05:50:37 -0700 (PDT)
Received: from [10.243.4.185] ([194.157.23.230])
        by smtp.gmail.com with ESMTPSA id n8-20020a05651203e800b0048b13d0b896sm1312261lfq.141.2022.08.24.05.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 05:50:37 -0700 (PDT)
Message-ID: <fa3aae29-3445-328c-e400-5b91cb2da4c4@linaro.org>
Date: Wed, 24 Aug 2022 15:50:34 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To: Chunxu Li <chunxu.li@mediatek.com>, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, nfraprado@collabora.com,
 broonie@kernel.org
Cc: lgirdwood@gmail.com, matthias.bgg@gmail.com, jiaxin.yu@mediatek.com,
 devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 project_global_chrome_upstream_group@mediatek.com
References: <20220824122319.23918-1-chunxu.li@mediatek.com>
 <20220824122319.23918-2-chunxu.li@mediatek.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220824122319.23918-2-chunxu.li@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=UxaF=Y4=linaro.org=krzysztof.kozlowski@kernel.org
Subject: Re: [PATCH v2 1/2] ASoC: mediatek: dt-bindings: modify machine
 bindings for SOF
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: guAT1g5+YoDg

On 24/08/2022 15:23, Chunxu Li wrote:
> From: "chunxu.li" <chunxu.li@mediatek.com>
> 
> Add SOF related field.
> 1. Add a property "mediatek,adsp", Only when adsp phandle could be
> retrieved, from DTS, the SOF related part of machine driver is executed.
> 2. Add a property "mediatek,dai-link" to support dai-links could be
> specified from DTS
> 
> Signed-off-by: chunxu.li <chunxu.li@mediatek.com>

Usually first name(s) is separated from family name(s) with a space, not
dot. Looks like you need to configure your system.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
