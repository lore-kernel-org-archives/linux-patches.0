Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385A149C4A
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 11:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718363216; cv=none; b=u7n4vOE61uO6T/6YP/lgwH3Dwvb5D4Py3i5WKN2VdlkU7rkEp7pdfbvpXaKN1Rnse1PPAyofctVs0bxFUPJW+sYAVcsJGEg8DdM2XsmPKr+LfW+jsvk7YMRfhA/MQ/TkurUP0FZkk9bOahpwFlWBiVFP8BNxVinW/G9OW4Podio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718363216; c=relaxed/simple;
	bh=K39z/7LGE/Fu+27l1PLvtZ8nbzeX+T5A+Oi7ylaDw7E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Hc3Hs8kl2GBa53i+yfNQPzhBOEUxcclopMf5x6kGW+p+dJq45egfcNGxURqBYix4bMFfzVU0vd5v8rvcVp7NMsnCsmFXo/jqN0vhmAUlP8X7HkPgLFw+dceS3yPzB4pbIZlwZWD2dXeU4didZUdsSN2vzZniTJcPMWUwVWA3xbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJkAw816; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJkAw816"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2eabd22d3f4so22005411fa.1
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 04:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718363213; x=1718968013; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HtDpJcdpavz6cBylx2JMFPBLe/yTCka1erD+aP6W33s=;
        b=iJkAw816owZoRoUqe0eIZnr5ofl97IEYSQ9k6rgaeQWNECOljSnpCB2X+dK/a0TK1E
         YQybSkd/NLr1K5heljD3DS6nP8XwIJ5AHDWyGJqupsBnZlOl7hEvPoFeNiRg2ADrTQpF
         JQsTUNeAKJ9W+nSXk3CpitVCrzO8rHagJFZx5fwfoeHrYfupBQ9X7NFaccGxWbX5o06Q
         rP3YgPMdHGtwQc2AWDGhRKTn6S3Irv2YD6sT8BJCJZMuaqR0bij5mg1kI3WTOTxC8JsM
         JpzJKppynf2yPFECwkbF0v9PpoJrEcSfArej1f45nB2HZNNbJkf//rNTLeD1PYJn9qAT
         8DbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718363213; x=1718968013;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtDpJcdpavz6cBylx2JMFPBLe/yTCka1erD+aP6W33s=;
        b=mqbvCOQOgCSIBxGmkwPU24Q7Nv55Tc833hZtlKJoDebknqpM5URicrgQhLzcxB/RHf
         I3ifgtiQEbddZYtrKfXMwDD1x8Sh3AiqdC+3i03qMd0MLH3cgz7OIhonHjMN4T2fWvdC
         M752cF6/q5gF2B/JEbMJk8d0Y4dxaUAhkVT0ncCS6x+ouEc0yz6KO+mbH0TSgnBJNqFi
         52Yf2IKpEyM7xz1Or5cKfilp2KC/6DeanY9rhwdvZLPdXnkA6o+BnIXg/9Bnasro+0SY
         5k+tiAH/QNK+t6mJxswO1FWgHx8F7Dbo/vPHShtOLmLJjThQzw3gVv8sFay13vaK/zD+
         610g==
X-Gm-Message-State: AOJu0YzK7vnM3Gp6P55pRH4Zx1mGjpI9LjqMwyQzriEO+TewPLpIzO7L
	nJ6zjzjDO1FqNM/eZ1gU99L7t5JqjDxCLSPQVMXhnGyjCWX8CXAN
X-Google-Smtp-Source: AGHT+IEIySahOq+eoCwln0+vI0Wmi80YGigUharhGehoW+hvSYQ+4A1gI84xogI+CDwmaTjW6EPPfA==
X-Received: by 2002:a2e:b04a:0:b0:2eb:e505:ebea with SMTP id 38308e7fff4ca-2ec0e5d0b93mr15640041fa.25.1718363212785;
        Fri, 14 Jun 2024 04:06:52 -0700 (PDT)
Received: from [192.168.1.227] (132.28.45.217.dyn.plus.net. [217.45.28.132])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422874e73e8sm94985885e9.43.2024.06.14.04.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 04:06:52 -0700 (PDT)
Message-ID: <a399b30f-fb9e-4d7c-8a3b-bce9898a7f19@gmail.com>
Date: Fri, 14 Jun 2024 12:06:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 004/317] r8169: Fix possible ring buffer corruption
 on fragmented Tx packets.
From: Ken Milmore <ken.milmore@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>,
 "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
References: <20240613113247.525431100@linuxfoundation.org>
 <20240613113247.702462647@linuxfoundation.org>
 <9592add5-b9e3-d14d-dd1b-2ef3d1057dd1@ispras.ru>
 <ae35864a-9a76-4e9e-8a33-2d141f475d4d@gmail.com>
Content-Language: en-GB
In-Reply-To: <ae35864a-9a76-4e9e-8a33-2d141f475d4d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 13/06/2024 21:27, Ken Milmore wrote:
> On 13/06/2024 18:21, Alexey Khoroshilov wrote:
>> On 13.06.2024 14:30, Greg Kroah-Hartman wrote:
>>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>
>> The patch is cleanly applied to 5.10, but it leads to uninit value
>> access in rtl_tx_slots_avail().
>>
>>
>> 	unsigned int frags;
>> 	u32 opts[2];
>>
>> 	txd_first = tp->TxDescArray + entry;
>>
>> 	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
>>                                              ^^^^^ - USE OF UNINIT VALUE
>> 		if (net_ratelimit())
>> 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
>> 		goto err_stop_0;
>> 	}
>>
>> 	opts[1] = rtl8169_tx_vlan_tag(skb);
>> 	opts[0] = 0;
>>
>> 	if (!rtl_chip_supports_csum_v2(tp))
>> 		rtl8169_tso_csum_v1(skb, opts);
>> 	else if (!rtl8169_tso_csum_v2(tp, skb, opts))
>> 		goto err_dma_0;
>>
>> 	if (unlikely(rtl8169_tx_map(tp, opts, skb_headlen(skb), skb->data,
>> 				    entry, false)))
>> 		goto err_dma_0;
>>
>> 	txd_first = tp->TxDescArray + entry;
>>
>> 	frags = skb_shinfo(skb)->nr_frags;
>>         ^^^^^^   - INITIALIZATION IS HERE AFTER THE PATCH
>>
>> There is no such problem in upstream because rtl_tx_slots_avail() has no
>> nr_frags argument there.
>>
>>
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> --
>> Alexey Khoroshilov
>> Linux Verification Center, ISPRAS
> 
> Looks like the frags argument was removed in commit 83c317d7b36bb (r8169: remove nr_frags argument from rtl_tx_slots_avail), which first appears in linux-5.11.
> 
> I dare say it would be safe to replace
>  	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
> with
>  	if (unlikely(!rtl_tx_slots_avail(tp, MAX_SKB_FRAGS))) {
> 
> Best wait for Heiner to confirm though.

Further to this, I have tested the following amended patch to 5.10 on the RTL8125b and it works without problems:


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c29d43c5f450..8aa0097bf887 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4279,16 +4279,16 @@ static void rtl8169_doorbell(struct rtl8169_private *tp)
 static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
-	unsigned int frags = skb_shinfo(skb)->nr_frags;
 	struct rtl8169_private *tp = netdev_priv(dev);
 	unsigned int entry = tp->cur_tx % NUM_TX_DESC;
 	struct TxDesc *txd_first, *txd_last;
 	bool stop_queue, door_bell;
+	unsigned int frags;
 	u32 opts[2];
 
 	txd_first = tp->TxDescArray + entry;
 
-	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
+	if (unlikely(!rtl_tx_slots_avail(tp, MAX_SKB_FRAGS))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
@@ -4309,6 +4309,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				    entry, false)))
 		goto err_dma_0;
 
+	frags = skb_shinfo(skb)->nr_frags;
 	if (frags) {
 		if (rtl8169_xmit_frags(tp, skb, opts, entry))
 			goto err_dma_1;


An alternative to this amendment would be to apply 83c317d7b36bb as a prerequisite, but that does not apply cleanly to 5.10 without some massaging.

Because of these complications, I would suggest it may be safest to omit this patch from 5.10 for now.

NAKed-by: Ken Milmore <ken.milmore@gmail.com>
