Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD8B3C15
	for <patches@lists.linux.dev>; Tue, 16 May 2023 03:42:10 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1a516fb6523so127336365ad.3
        for <patches@lists.linux.dev>; Mon, 15 May 2023 20:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684208530; x=1686800530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DFTJu2wWhYQ+AebqISrsV3BzsJGQ1gjBy5fDqwWThPU=;
        b=FuXYm+fiZHMEo5guN7d++FfpXJN6u5oxhpvcxFVGg6PbJ4wBSOjv66aUOwKpyA3U0V
         HOCTSZCLAkr6K37D1L4m/ckwVX+LLSS3BPmTQKz9SfTSUoM/tnY/zM32iKCr/W0o857P
         iAp7AZenciZf2rkHHjuEJYhpKblMQcs8+VYQeZsdNRw6b1CG7XsZo+e/pIa/XRY1GT55
         iB7SKD7Z8mKvc2nazIbLeFF0+Dq0VGNmdRg3o6Qs8WyfCTUwPWNnmX7N3dYNH/4MTIU7
         216o+NhZoIhQMNSxSLw3WFDr2Grcj8k4erTCunquP/XXoubPGTXNWpf7m4F4Ok0jnRpu
         T3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684208530; x=1686800530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFTJu2wWhYQ+AebqISrsV3BzsJGQ1gjBy5fDqwWThPU=;
        b=CNd/9F8Ugj3TPlP5EeT08TdyGGICwSBTQ3Rpp/YNwQ/TkF3i1t74SN+A9B98nCtt6g
         Uf9/AL1EuY/rLXRzxqyua36wBWamcJamL7jWmIqsX43UqYokVNhWwVWcetF20MbNixax
         zo2w1sN3VzGNgRowQR+Ahgt9ku22MJ9tMc5+POD+92YnQ6cpSYm3o0pQhL4Bd+fAWPu/
         9IfoEk1WP1Onfd21tdtSVYMBTzWQK6B6vi2dwUEtj+Znwtwzvvrlox0wKQT0JPk6zLgi
         0u+FivYnLyf1lSCbyxreLJfvhH7ow8vx2JYNIdP4kLsgAAB0Pve0jeKI3rImeZ3el0C/
         sY1Q==
X-Gm-Message-State: AC+VfDy1FKCHIwe6tooSta87XxzurZ1XUabuE/cthSPJAltVwJhBe3p4
	1B3UlYqgccoBgEFkfu4XKpc=
X-Google-Smtp-Source: ACHHUZ5QHROk1+S9ZSJaGrSriCpQumHU09tIOc6zj87tmZ1bH4SeFfrxAMeNhjT+uiG/t6T/YFEtgQ==
X-Received: by 2002:a17:903:22c6:b0:1ac:3739:9969 with SMTP id y6-20020a17090322c600b001ac37399969mr47047977plg.48.1684208530023;
        Mon, 15 May 2023 20:42:10 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id iy3-20020a170903130300b001ab1cdb4295sm14266252plb.130.2023.05.15.20.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 20:42:09 -0700 (PDT)
Message-ID: <9574bc6c-ad0d-9847-4925-4cff7e4514a1@gmail.com>
Date: Mon, 15 May 2023 20:42:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 6.1 089/239] net: bcmgenet: Remove phy_stop() from
 bcmgenet_netif_stop()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Sasha Levin <sashal@kernel.org>
References: <20230515161721.545370111@linuxfoundation.org>
 <20230515161724.344429171@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230515161724.344429171@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/15/2023 9:25 AM, Greg Kroah-Hartman wrote:
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
