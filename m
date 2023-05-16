Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC78E621
	for <patches@lists.linux.dev>; Tue, 16 May 2023 02:59:51 +0000 (UTC)
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-3f4e7ce15c4so28089781cf.0
        for <patches@lists.linux.dev>; Mon, 15 May 2023 19:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684205991; x=1686797991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z2/CcS1dDO7WfV4NALb8qhhxWtiUQDoacwREUk6cWew=;
        b=d8uWc8JMUuTEzZ7Lqwg8dTJcrk6rQTB8pc0AYIPgRs1ORkU+CNzpyLY1A+Ksd2wLnh
         D5Z5JwSwJZYanPy83JBOahNLVGGUT5hqnQZUBlVQ4aeyfneHKOQqoHxt8ZGGybwxUN21
         zkLDLuNH6wfxibqrdCjWeCnBplhfwFL9WtH3ENoeuWsMdoX/qDCKG68CjiotFovSKp6d
         bitGN3YEYMMOEDew2RkL/XVEITFkUpgHaZgttJrFFA8HLx6WJ7cqFzN43yyiOboj77tF
         kVmVpNkdFZ1wkNYxEWwgw7qPDlGsaU8tkIj0LOCQLKuPYaGPx9i4oZ1/CYxpam1n5Bpr
         R2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684205991; x=1686797991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2/CcS1dDO7WfV4NALb8qhhxWtiUQDoacwREUk6cWew=;
        b=F4vQiVWdf0WlVV+NZUHefEB00EReU1P84hhQOyoRkNsCFSn3au/NKqKamWInMNg78C
         cXm+YygFZGSchTPtkylZxz+CPIMSavzg1wheEB/0OmSuEtFcGgExe0LPsDYZDo82/kxG
         lO+tur9PhbmyvBI2dgta4tZume6IzyTWw5y/uRmC3ND4WsB23G2Q6NkIhoSrHdhKDh2a
         xPVXrtB1obAGB3oY7Q/S22c4pa9qO2Lx6zX++DltXideHdigmrOV6u8wc2fqDt9nsHRS
         zat5WE/0OhnNvLj5DFDXW7lXIZhvFbUIs5fSwGwyciOkQePDjGrDQfK9CDPK+hp5CY/c
         CeFw==
X-Gm-Message-State: AC+VfDzZI0uBLNerKbgMb1TLtvPGw5y/Tse4J/iOAIKD6JJQF1HufmA6
	YQ2EjPEvMZYygAuFpq/dQYU=
X-Google-Smtp-Source: ACHHUZ4KkzqGcYXEDTqp9CcGfAsnDvZdU6Lef0A8iS1eRs8Tp/0BG3OSZ4T2r/6AqxY4beYp9WmSWA==
X-Received: by 2002:a05:622a:1828:b0:3ef:4efa:7042 with SMTP id t40-20020a05622a182800b003ef4efa7042mr58421143qtc.62.1684205990710;
        Mon, 15 May 2023 19:59:50 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a5-20020a05620a124500b00755951e48desm268917qkl.135.2023.05.15.19.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 19:59:49 -0700 (PDT)
Message-ID: <7b830074-a08b-4dd8-a9b7-9fe11cbc0d79@gmail.com>
Date: Mon, 15 May 2023 19:59:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 4.19 163/191] net: bcmgenet: Remove phy_stop() from
 bcmgenet_netif_stop()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Sasha Levin <sashal@kernel.org>
References: <20230515161707.203549282@linuxfoundation.org>
 <20230515161713.356981889@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230515161713.356981889@linuxfoundation.org>
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

Please drop this patch from all the stable queue for now until this one 
gets accepted:

https://lore.kernel.org/lkml/20230515025608.2587012-1-f.fainelli@gmail.com/

thanks a lot!
-- 
Florian
