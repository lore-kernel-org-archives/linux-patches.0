Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8223BD
	for <patches@lists.linux.dev>; Tue, 16 May 2023 03:41:31 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so12575694a12.1
        for <patches@lists.linux.dev>; Mon, 15 May 2023 20:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684208491; x=1686800491;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X8muklSSsKDOiWk41cVeLRdJ/loh4oIf+0IAwRbd4TM=;
        b=RMf5l9/CoZ4Nu29hQiIGT4ak60DASextMTgysLNalT4CyPvDKRGYed88XcoOv1IzRx
         W7RqxS3jm95tKsxp5Vb1y1zVgFv6h7sgzPZPIdqXg95nQ+HwNIztgjVnyNyZC9lehmbV
         vu7MTS9KRCQcs4Wj/SvNSGlMrruxnnWxzepqqbP0g/tJvSyGuxbGpN71Wd5IYRoCYhy5
         CVs5iwSadiCI5FajzHa2KPZBBmepDZ+NegYJUBbCxR+4TuuNIgyEdrq7Vkp/4b6664D4
         55L+MGaOg5wJxgqlDI3tqEjeOvvRhqiiMhm71ext3Qk0qsMSqYN4MhW+QyIToBqoL5M7
         Zdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684208491; x=1686800491;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X8muklSSsKDOiWk41cVeLRdJ/loh4oIf+0IAwRbd4TM=;
        b=S1EjFINi6+k8VlvOabOJ7MieGmH1hNiXqM1frKhDBCDofhfdLAdqHjjLdmivfpE4Th
         /UxdYC07xSJMyPI9frmfNbMqUPc9VhDhz1XRBOVtfZcgdNWyzWxXd2Xsd1QTouJaXqB3
         EgVF8hK2msK7ofWDxGn2W7ibrNWRCsAjnqivWR+9tdCA7wE7xNYq6obBrXeLmE0RHK9r
         LsyafMbmRzCJJNc5N64C86/JgGuKJuXJrVc4tPDHuBo3rS/v4fSUzpW++verOYy0rgba
         BXNy3ueMBEflph7RAo0FdEUgc5zbPhaaEvPq7oPJMgKhulCXKZZ7AMQQzCsH5Kfg+4lc
         BhGw==
X-Gm-Message-State: AC+VfDynfgC82MlFNIZ3nFpdiLVMA6m9TTu9lvkNUlEBo/i9Md/2KlsO
	L7BskZj4/J3hriBbBfs+l8YpOC3um40=
X-Google-Smtp-Source: ACHHUZ6+NhASnNpnanf8dAH7BChYWfuh+PBucbyu2rrW36wS7jQmJ3pRoD8KCbkSrRj6RwFbgzXzGw==
X-Received: by 2002:a05:6a20:9389:b0:106:bb67:d674 with SMTP id x9-20020a056a20938900b00106bb67d674mr2947934pzh.45.1684208490756;
        Mon, 15 May 2023 20:41:30 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id n21-20020a63e055000000b00530704f3a53sm9021796pgj.30.2023.05.15.20.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 20:41:30 -0700 (PDT)
Message-ID: <f9044b5b-a750-6f91-aa90-4d572e8dd142@gmail.com>
Date: Mon, 15 May 2023 20:41:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 5.10 328/381] net: bcmgenet: Remove phy_stop() from
 bcmgenet_netif_stop()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Sasha Levin <sashal@kernel.org>
References: <20230515161736.775969473@linuxfoundation.org>
 <20230515161751.623223787@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230515161751.623223787@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/15/2023 9:29 AM, Greg Kroah-Hartman wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> [ Upstream commit 93e0401e0fc0c54b0ac05b687cd135c2ac38187c ]
> 
> The call to phy_stop() races with the later call to phy_disconnect(),
> resulting in concurrent phy_suspend() calls being run from different
> CPUs. The final call to phy_disconnect() ensures that the PHY is
> stopped and suspended, too.
> 
> Fixes: c96e731c93ff ("net: bcmgenet: connect and disconnect from the PHY state machine")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this patch until 
https://lore.kernel.org/lkml/20230515025608.2587012-1-f.fainelli@gmail.com/ 
is merged, thanks!
-- 
Florian
