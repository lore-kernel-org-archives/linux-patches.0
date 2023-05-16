Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8EA2568
	for <patches@lists.linux.dev>; Tue, 16 May 2023 03:12:13 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6439b410679so9022740b3a.0
        for <patches@lists.linux.dev>; Mon, 15 May 2023 20:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684206733; x=1686798733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yDxT5zCKX+OlRexh0/v7BOOIwkGWHS6pFpbkoRXsF0s=;
        b=dg5JgI4iRrgVHMoaLSH9XjLMxrJPcpicON+3WSjERjZJZ3ddRoUTh0nM3C+AgMi+Jz
         PNCsFEaH20Qsuys+Bih1MCdwku5d8daxd2Cz4McgpCKo+qCQjH2Swv3c9nZDGgAW+fqD
         o6OxePpJKuqzWTsJCuoIh/hVmAppqEj1qOLTsO7Kg6cOavCnNwwKM2uHsHZZWMvckRBR
         sfuHbKXVgESMPhbYDp4IWl5zzb7aXBBMFgO5Kw9xKjLpOqa247zlQwKhBby1zJh0d2un
         XJ5Z3dFQ74slmhhToJm1F3dipJgPFqt4mfY7Jeok8loVMPYR4jDm2QfGVuWJSvp/IJ6D
         TyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684206733; x=1686798733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yDxT5zCKX+OlRexh0/v7BOOIwkGWHS6pFpbkoRXsF0s=;
        b=WzT4tSMO9CaGCx7io4/n0yp7a+cBvC2Y9wTOPl+SpgnmHTByzYOvEGYjTg1qTx35zK
         idVGHbnId+AJOtkP04xL1wdLQtuFnigONUO0Fd1FlxvEsEysuda8L4PJzL0emOvj23H0
         pCurA9/cxw65ZX0Tol8A0kDAUlD1RzG7sgmu68ybuzwRhsHz8sM48xAvKoad971gnDEM
         arpkqv749uRKEzWR4m+gcyDiN1AsV3a9W97na1DN2oFOg8WlGjdL3tM+fpd3/NsTn08Z
         Losa90DcYcpHFGGhum8NlbdxB99yUqsDJllbWeUt04s/Qj5EE+pPBIfIP40wUMZtib8+
         Qfxg==
X-Gm-Message-State: AC+VfDzMePJH2FRZ6Wf0ps511hcpKTLu9ycRQegW3EhG60vA1LXyUZeP
	sC544LB9Ln8xfwyMgba8dcM=
X-Google-Smtp-Source: ACHHUZ5UAzeebD2P7wGy/eAUwRF6dMlbRrD2wF97aTl0OtGsDTbUpZfSy6Sd01yVn+82y76M2/H94w==
X-Received: by 2002:a05:6a00:1a06:b0:63b:8423:9e31 with SMTP id g6-20020a056a001a0600b0063b84239e31mr43622631pfv.11.1684206732768;
        Mon, 15 May 2023 20:12:12 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y20-20020a62b514000000b0062e12f945adsm12380777pfe.135.2023.05.15.20.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 20:12:12 -0700 (PDT)
Message-ID: <74ac1b5c-fbf2-873c-4ced-dc0ea5b28838@gmail.com>
Date: Mon, 15 May 2023 20:12:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 5.4 235/282] net: bcmgenet: Remove phy_stop() from
 bcmgenet_netif_stop()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Sasha Levin <sashal@kernel.org>
References: <20230515161722.146344674@linuxfoundation.org>
 <20230515161729.266459648@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230515161729.266459648@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/15/2023 9:30 AM, Greg Kroah-Hartman wrote:
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

Please drop this patch from the queue until 
https://lore.kernel.org/lkml/20230515025608.2587012-1-f.fainelli@gmail.com/ 
is merged into the 'net' tree, thanks!
-- 
Florian
