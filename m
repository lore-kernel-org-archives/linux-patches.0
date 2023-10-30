Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EC2EED4
	for <patches@lists.linux.dev>; Mon, 30 Oct 2023 13:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="nDDXn14e";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="qzZs3y+4"
ARC-Seal: i=1; a=rsa-sha256; t=1698673262; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=imh4HaiCmJaGb1y89GvoF6nV2rrqm+zrkI1kZ7iu1kAvoRjHfqA2+xR/L3j1S/4Er7
    DfsnATDnMzw8BPT5bpmyvDMCSBp8PaOJRIyMBftQDQVMcDdKjlbB65nfeCNSQdX/LCzx
    LOuAsNa1jtuV2KWU2/bjFqp2SNhVZ+2l7qdWs+dtEkun1o/wvYwRJQc2HeejtcCVmyxm
    I0ciM1K8eI0C/CFCFGszkHLXItwFwuSHr1q+Z5bwWWPIy78r/FO0LDIHNF9X+r/hw3hm
    3igVIJgWTkcOvjFIxpHUznlbfeauKIMGrmupVeddCuN6cXid/klxgRFF2mSuKC9n5ZXK
    iAgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698673262;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=0kUSB11fDKSCCQnsLAQkRqLL84Gbj9QLRVuk4vhIrKc=;
    b=Apccs41+u6eHcmWRqTeFwu49vHkxrrhD3VIBJ+ML514R/N330Yx1+gPxs59X2nQA55
    onF1k3xFgkbvArpgOfigUStiPSCYDsYUNONbeIw79G3jBEgKtDZfEtoD2zLQNzoqXL5s
    02XR/AbVuwI3wn7jY5WrGni6rbKlOTPe5IEX8+f9lKFL3KsWg2IxOoGBusNsXlCDLBRW
    e8TDq80hmgmyZolxlF2mu34Dl+HpQLL/s/TrF/HoD4qgrwOTuI3IZprpxZSwnmUUMmm3
    St9HyfKdVT9nX4reEbTrfzimfm6U6suagmozUsty4leoS2DZfcVpkW9Wgl3qC28DLdWJ
    cfNA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698673262;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=0kUSB11fDKSCCQnsLAQkRqLL84Gbj9QLRVuk4vhIrKc=;
    b=nDDXn14ea8gygMxS77u1h4vEIscFc/43fs52AEMLZvLBQfWIjWeLX7KBaS70fTtrvj
    GY+q1GgKILctWZ3apKbM368GNon5IQ7lTJ75zxIggIMVbNUccJBL0Gd1TC1mLacHtMkM
    p3ol68v8r3Yp+RgN00JgHBKq8UkEPtGCkzm1qb6ChyLShXDjaG2SL+1rAXFqx+Z4K7b8
    ReGab9INaY7hPHKRUfx2dqsqAQrWDY/Xj+2qASyI7ylF7WcxUA7OtdU1i1ucO9NJlnr8
    uLN0Mig639KaSzp83pUzIDSxNZd2iWMwmevHmhwbZH3qBVSJQxoVNGehEhSKuq943bFi
    txPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698673262;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=0kUSB11fDKSCCQnsLAQkRqLL84Gbj9QLRVuk4vhIrKc=;
    b=qzZs3y+49zgSiImhNmd5mnDxRbyVEuay/B4cBZrRum9fSsLifXyHwX9iWUk28jmlCY
    F/c8SuHxs6eZAUL8ivDw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVJiOM9vpw=="
Received: from [192.168.60.115]
    by smtp.strato.de (RZmta 49.9.1 DYNA|AUTH)
    with ESMTPSA id Kda39bz9UDf2DoO
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 30 Oct 2023 14:41:02 +0100 (CET)
Message-ID: <042cd67b-090c-4705-9a80-b322e7d4e639@hartkopp.net>
Date: Mon, 30 Oct 2023 14:40:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] can: isotp: upgrade 5.15 LTS to latest 6.6 mainline code
 base
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, sashal@kernel.org, linux-can@vger.kernel.org,
 lukas.magel@posteo.net, patches@lists.linux.dev,
 maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz
References: <20231030113110.3404-1-socketcan@hartkopp.net>
 <2023103048-riverside-giving-e44d@gregkh>
 <9bf2b7c9-fe80-4509-b023-c406f2fff994@hartkopp.net>
 <2023103038-spinning-uncooked-b608@gregkh>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <2023103038-spinning-uncooked-b608@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.10.23 13:42, Greg KH wrote:

> 20 patches is trivial for us to handle, please do it that way as it
> ensures we keep the proper history, AND we know what to backport when in
> the future.

Ok, will do.

> When you try to crunch patches together, or do non-upstream changes,
> 90%+ of the time they end up being wrong or impossible to maintain over
> time.

Ok, then I will maintain the entire history of fixes of fixes without 
crunching them together.

>>> But why just 5.15?  What about 6.1.y and 6.5.y?
>>
>> I have posted 5.10 and 5.15 for now.
>> 6.1 would be only this patch
>> 96d1c81e6a04 ("can: isotp: add module parameter for maximum pdu size")
>> I can also provide.
> 
> Why add new features to older kernels?  That's not going to be ok,
> sorry.

I will drop the module parameter stuff then, as it has no impact on the 
communication state machine that is in the focus to be consistently 
fixed and updated to the 6.6 code base. Then everything in 5.15 and 5.10 
will be on the same level as 6.1. This will ease further fixes and 
maintenance.

Best regards,
Oliver
