Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D683C15
	for <patches@lists.linux.dev>; Tue, 16 May 2023 03:41:54 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-24dfc3c662eso9129423a91.3
        for <patches@lists.linux.dev>; Mon, 15 May 2023 20:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684208514; x=1686800514;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sGleJXuJTGhHLqLpDeHS3KsfT+7mitpqtqJB51lXU1o=;
        b=B9qbdwBln8PheB+T9VzI8GA2rOX1TXPwb42YzDQnP4qhW++T7Qq6w/iXNtGf5OLOl2
         Q+AT/Vq6G5q5M12BFxpwZ7RkD3hJHIJIm3pl5KcYyVbNobdYfpbXdETD3jXfF5SkA9lL
         mNaAF7uDWl/6ygu0W9HehQX91gLNp+MynUXnHfQvD/+jmtaMFhIYAQkjNptdiioPb5Fh
         kAFbSs8JrNw7pBQ9x84YCBG3QP6MuuEgql5w6Naz8MD35Qx60jF7imufrtX9KimwKVNH
         pE3V75MYhmKh4Ylag7y+OYMOISHFbPF/6vN+aKBrTpVN4Dy2S3N+l3X7WrCW4RG9+q1w
         zfEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684208514; x=1686800514;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sGleJXuJTGhHLqLpDeHS3KsfT+7mitpqtqJB51lXU1o=;
        b=eLMjWH/TnsRwgGNxd4cUFpUC32By/w6lV2JTT1ZX23D+tbS6TPkZzGZ3yDe3LqJUpK
         YkmR+j/S5dRGCuEqjzEHW30R674dY8wD2le3PkwBGsGAhUVQGNSySBRcylM+o6TiZ3oe
         rYHeIrhoBrzpHo/KVJj5E8BanO3HuqvAUHMCKGS/xwhuv3zUXyqja2u6e+D4QUbGczJb
         En5rI/4ThMm1AK24Y8y3xsf7bMB4MRp8l6x9WQsDKtvQjKkT/i222e78WO843vZOL1On
         YvBR8keD3zpHgTTTVRBb1Y+NMgzVu3Ou1/t1oCEN/Uhb4arGr3tkrjT/3KZBvdSwtdBM
         4fWw==
X-Gm-Message-State: AC+VfDy+QExArnSZJWckGm72GdATeyrzBNyKfZ2ZOSiuU7JtMWQIKHE0
	Dl/SpZev6575q6/8l5gBAOM=
X-Google-Smtp-Source: ACHHUZ7OzSgTDJSG55FyqVg28T/ZSUHXu7cbbC8EGzGfHRQHrvJtfq2h0PXBjdo3kz8TJmo5UKFJnA==
X-Received: by 2002:a17:90a:6e44:b0:24d:ee34:57b6 with SMTP id s4-20020a17090a6e4400b0024dee3457b6mr35225929pjm.41.1684208513857;
        Mon, 15 May 2023 20:41:53 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b001ac7794a7eesm14299952plg.288.2023.05.15.20.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 20:41:53 -0700 (PDT)
Message-ID: <413f8553-cb46-a073-b94e-63adc3954ee7@gmail.com>
Date: Mon, 15 May 2023 20:41:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 5.15 048/134] net: bcmgenet: Remove phy_stop() from
 bcmgenet_netif_stop()
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Sasha Levin <sashal@kernel.org>
References: <20230515161702.887638251@linuxfoundation.org>
 <20230515161704.750701051@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230515161704.750701051@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/15/2023 9:28 AM, Greg Kroah-Hartman wrote:
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
