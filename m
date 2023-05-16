Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E16C3C15
	for <patches@lists.linux.dev>; Tue, 16 May 2023 03:42:34 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-24e015fcf3dso10029375a91.3
        for <patches@lists.linux.dev>; Mon, 15 May 2023 20:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684208553; x=1686800553;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IWEDbA0e08o53RdV5T/MGMWQcP1SW07qkBJKSLgM8nI=;
        b=h80UC7Ki97MZ46YYh1nY9kuKHzsLOFKTnlpXGemW/gRc9Gnrr4AMdiGeszYgZb1+nY
         tHxXS2G/pM1HnbAgHs3EFRFTnZpT3D89PRQnzeunJNJ3Tyj467jY7+lUQ5yjeCOk2j1f
         ngz159R+oxID5ksOq83NNowOGBJaAZVKeHeYrvG+G+I359a0S2FY5sRp/qKx+gDFiC6G
         mHvCr2Cp70B5huhQnt3Gj7vGZU9aCanbNHuKbu5b6eIs0GU8Sw32UjqBn8sGGX7AYhMx
         /W3LQS1QU/HvUZl2pAqV08WTyxE7F79tR7RFlcJVj0Kc2xu7wseXC4qEq8QX+fBlbGpI
         L0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684208553; x=1686800553;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IWEDbA0e08o53RdV5T/MGMWQcP1SW07qkBJKSLgM8nI=;
        b=Zw4Eujz6mptp/dSOjRh8L5Oqlhy4PhjUIcAJnMwxmE6z462ZO4ExSNQbRVNMtR2t6Y
         Judux7I7DGmSAxYpg6pJAtXjThzI2z0W7Oqv94ytIX2xPa2ebzqXZ5cFTvAZ+LDEM7lf
         qvhdtSOk+t7wb+f8AWNMx/fkMabV2ZnjsN4vza4qypw2j8RWZ24mxjS9qahJMrxLDhl9
         kbN53C2LOmlte9dECOa3nQTpFa51WkxMYxmFeu9h1Djz5q7N4+hICYxY9VsZ9f3LkwbG
         80YgzaSYi5FjYSsVuWkTzYkdeeS6HBgoUC41gVF9so9gI03ofVfzUenOxHWqJW3JpPLj
         0a+g==
X-Gm-Message-State: AC+VfDybkXZ2A8WTNomRva0MpLjG18kLaOLtYJAzGgFuwY4qnfMUdFP1
	BHIVPpQToVwvH1No2GZP7WIGegZ+1Rc=
X-Google-Smtp-Source: ACHHUZ7UvyyRZgqWaf2Op3DDkAzg3ZLkzTaA+ZfXZMwDEnbtBULVfCxaMPEjD6V+B+gluMnzbVEsWw==
X-Received: by 2002:a17:90b:160e:b0:24e:37c6:9681 with SMTP id la14-20020a17090b160e00b0024e37c69681mr36241498pjb.38.1684208553605;
        Mon, 15 May 2023 20:42:33 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id nl17-20020a17090b385100b0024e49b53c24sm402972pjb.10.2023.05.15.20.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 20:42:32 -0700 (PDT)
Message-ID: <a7843640-7fc9-379f-8a21-a2e599f742d8@gmail.com>
Date: Mon, 15 May 2023 20:42:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 6.2 092/242] net: bcmgenet: Remove phy_stop() from
 bcmgenet_netif_stop()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Sasha Levin <sashal@kernel.org>
References: <20230515161721.802179972@linuxfoundation.org>
 <20230515161724.671015328@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230515161724.671015328@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/15/2023 9:26 AM, Greg Kroah-Hartman wrote:
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
