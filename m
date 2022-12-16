Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E8B1378
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 09:13:51 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id bp15so2482105lfb.13
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 01:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c+C9KQuE+R0TNgeqhyRteMhPhVfgAuZdXYjuNY9w0Tg=;
        b=I+tdbpPxB/xvcyDKQWbXrSlBwJFiggn5RH93nh7LJC69E9VRg3TN79aUmK64w7HytB
         7DKddM8IOSyd+AvBcVNpV0fVZCMYAvNKjD8HDaJXeThGtQ/M/+f7zmgQW5tKg0ezOhen
         4FY7A2WsN+OfnsHPB4Dd6L/KgHIgezVbQC9Lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c+C9KQuE+R0TNgeqhyRteMhPhVfgAuZdXYjuNY9w0Tg=;
        b=idXGhtGuczD6yEC9a8m/u2mntQGpzuq2JNZ8x6SF66ukMrqBbY3EBJVKSXVRCklWyl
         VL3ilvOuSa/EWJjp/3SBUT3aLZKV2Z10i9ius/yq4J1ruh/89LpDdKtIwt73nolKJvIn
         yk3+7Tu2Y4GcLv35Vy3eu3Un0oc3CLOB8vilxynvaQ9jVXwUsZs/RSV3S6IQFRaMMg2L
         JT85koPpITWwfgmK+U+LHJneLueyuku1ZklvlW5L0DmfuT90lR1MjFgqeHUl+xZlKqVF
         52JmLanxCb7az/vmCyQOydzDpdNYuTmbJtUCvAE3G/K4NByZXsvYsZ3jWZS9rWenpd5d
         aUYQ==
X-Gm-Message-State: AFqh2krPUE01lClLcR8BNK8r5kbQ7URYFxXM6UJH25xvykrUHgXim/2P
	+jwk761J2ilKNWyh09I6OI+hkg==
X-Google-Smtp-Source: AMrXdXuRZZig3Xer3I8P5A83jMcDJtsPri5m5838O/2KQ/DItsAc0ECL1f5FuDXjzkqXh9VzhdWPGA==
X-Received: by 2002:a05:6512:3d2a:b0:4ba:555f:4795 with SMTP id d42-20020a0565123d2a00b004ba555f4795mr3668103lfv.25.1671182030017;
        Fri, 16 Dec 2022 01:13:50 -0800 (PST)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id a23-20020a056512201700b004b094730074sm164709lfb.267.2022.12.16.01.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 01:13:49 -0800 (PST)
Message-ID: <6314ea2f-61f7-2c5a-86d3-1158b80bd5d4@rasmusvillemoes.dk>
Date: Fri, 16 Dec 2022 10:13:48 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 11/14] net: fec: dont reset irq coalesce settings to
 defaults on "ip link up"
Content-Language: en-US, da
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Andrew Lunn <andrew@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>
References: <20221215172906.338769943@linuxfoundation.org>
 <20221215172907.210669704@linuxfoundation.org>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <20221215172907.210669704@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/12/2022 19.10, Greg Kroah-Hartman wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> [ Upstream commit df727d4547de568302b0ed15b0d4e8a469bdb456 ]

You should not take this unless you at the same time also take

commit 7e6303567ce3ca506e4a2704e4baa86f1d8bde02
Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date:   Mon Dec 5 21:46:04 2022 +0100

    net: fec: properly guard irq coalesce setup

which

    Fixes: df727d4547de (net: fec: don't reset irq coalesce settings to
defaults on "ip link up")

The same of course applies to the 6.0.y series.

I don't know if your scripts already do this and it just somehow failed
here, but it would probably be a good idea to always check if there is
already a Fixes for a commit that gets chosen for -stable.

Rasmus
