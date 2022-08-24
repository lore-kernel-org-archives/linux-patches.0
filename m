Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD8C7B
	for <patches@lists.linux.dev>; Wed, 24 Aug 2022 12:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BAEC433B5
	for <patches@lists.linux.dev>; Wed, 24 Aug 2022 12:51:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="myWHpRkE"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 24 Aug 2022 13:51:38 +0100
Resent-Message-ID: <YwYe2iUeWZOy00pR@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 24 Aug 2022 13:51:01 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=UxaF=Y4=linaro.org=krzysztof.kozlowski@kernel.org>)
	id 1oQpqV-00A9W5-IZ
	for broonie@sirena.co.uk; Wed, 24 Aug 2022 13:51:01 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 3D92C61418
	for <broonie@sirena.co.uk>; Wed, 24 Aug 2022 12:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id B3BA2C433B5; Wed, 24 Aug 2022 12:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87933C433D6
	for <broonie@kernel.org>; Wed, 24 Aug 2022 12:50:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 87933C433D6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f45.google.com with SMTP id bt10so10870937lfb.1
        for <broonie@kernel.org>; Wed, 24 Aug 2022 05:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=VIvn4cn38mqmq8WvF2X7y/SBiSVMfGMJeaVNH0qHe9o=;
        b=myWHpRkE0JHF+tTboHvgSdeq4hDDIDzW3o2/kG40uIP8wBe5Qtf8c4eWWvLeA3qGB+
         5+VAi70dRsuwNRjXlXFZRRi5152W7yHHCTd9A1cYQ07kRzRQCkkDDqdLcsSal9TXUimu
         WHNESwCDBoMe2T4PirwFphqC7jnVY6GXoosXkLj1Qhspt+curOhozmhJWQHIYWA49J0H
         j9ZakInDkVu8bPFMvSuVGx6I5kzlN789kKmwoGcwachUCYbC6KVA8KcaDUH/UksnAdj1
         mtX81dBWvW68wBRbsLgyobXiZ2di4NmNtBQkRko+eStRHi6/WYVFVLyJhlURXaOmSLrE
         IFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VIvn4cn38mqmq8WvF2X7y/SBiSVMfGMJeaVNH0qHe9o=;
        b=d2Y7utw6Qsw5TaemomssgzOM7jWo8s5yUsZgUYeXKfOsM+K/UQy68VpcgtIBPxaMOZ
         qmMcICAGDTnnQdOBdxW1Fetn9nQQXEIlRmKAXxcg+32Yr6i92EuOAd+jrB2Rsk2xbFqY
         hgMRsMfjmqBIvoR2TCUTETEn7iu8ThKHXwR4SGd4kZmLGPUNv0zAzxUdT8GjLJAZkuOa
         da8+KSHBrhb5ArKjm6DHIWsWBpVLGEI3vwp6nfVYbevl5zf1RV8i6IlHajHlZakmJhU+
         MvvLX+mO7S2FqaKJfA7bhqpXRQI1azdlDbkNqz4SfnQJlj8PjEjj2PM4px6bn3d5pmhN
         2MSQ==
X-Gm-Message-State: ACgBeo3RQUFEx6ppJuSBmB7RQu1pbEGN4WDxqrcO1iEsSdzLrxCZqWlg
	vLDB1aWjf7EfIIuWKZeBnKyt8A==
X-Google-Smtp-Source: AA6agR7Z/1jGW7Q8B9kfMwTIdCYPqqO+/2YBvt8cNU59/7t5/M6VcYqdYuJNjpfmZf8K+b4Uz38cuw==
X-Received: by 2002:a05:6512:3084:b0:492:f04c:8a3 with SMTP id z4-20020a056512308400b00492f04c08a3mr3618630lfd.199.1661345453600;
        Wed, 24 Aug 2022 05:50:53 -0700 (PDT)
Received: from [10.243.4.185] ([194.157.23.230])
        by smtp.gmail.com with ESMTPSA id v23-20020a05651203b700b00492f294f06bsm1028184lfp.110.2022.08.24.05.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 05:50:53 -0700 (PDT)
Message-ID: <58a694df-fb33-dac9-0dfd-eb2efb9abde9@linaro.org>
Date: Wed, 24 Aug 2022 15:50:46 +0300
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
 <20220824122319.23918-3-chunxu.li@mediatek.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220824122319.23918-3-chunxu.li@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=UxaF=Y4=linaro.org=krzysztof.kozlowski@kernel.org
Subject: Re: [PATCH v2 2/2] ASoC: mediatek: dt-bindings: modify machine
 bindings for SOF
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: b2ygY9Q4ejPa

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
