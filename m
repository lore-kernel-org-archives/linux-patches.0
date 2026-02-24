Received: from sienna.cherry.relay.mailchannels.net (sienna.cherry.relay.mailchannels.net [23.83.223.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B702DB791
	for <patches@lists.linux.dev>; Tue, 24 Feb 2026 19:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771959774; cv=pass; b=dphhrg6jsYu7EjlMTn8d5BO0bmKC4bSDwCLBQjeMYv8TkMVNkqh33IyNtvpAtjXfB7xn8dLMfGo+bRH99Mn+3rQmKvfgg2O72z1ktZgV4S7xejlIvd6O87cG/hjtSS+QVVF0T1FOm4oXpLajGYRCkt5CaVqVnEmdHiSxGGflU6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771959774; c=relaxed/simple;
	bh=Jr/PDVnNKvKlpq+USPz3dMI/D1o2FqG9PRfJXdMbzxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riKCmnxz4UR/FR7zkzZ/niFIj8IRWyILPK+vu4zwg0oLo/FC8p739UGZyW4uPKmRR/GEBwlTOoEEVckmb/WzZNDfXIJrncME8uVJT0UDmCgEUMH3n5IyH/CtUdUE3/3fgwjT0LH591dEFcx8SLA1XHIv2G/8Eoj8LZCRBCN21QM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=landley.net; spf=pass smtp.mailfrom=landley.net; dkim=pass (2048-bit key) header.d=landley.net header.i=@landley.net header.b=ZlK/Uv01; arc=pass smtp.client-ip=23.83.223.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=landley.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=landley.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=landley.net header.i=@landley.net header.b="ZlK/Uv01"
X-Sender-Id: dreamhost|x-authsender|rob@landley.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C9EE6181FB5;
	Tue, 24 Feb 2026 19:02:47 +0000 (UTC)
Received: from pdx1-sub0-mail-a209.dreamhost.com (100-99-12-80.trex-nlb.outbound.svc.cluster.local [100.99.12.80])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 468A218277C;
	Tue, 24 Feb 2026 19:02:47 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1771959767;
	b=pvB/qBHCxCT0aHmBMwVI5e+2bMlJq8Cj+GFdb+Sox00GZWxo5WXxg+DhMdvEQGGAwviO2/
	Q+PxTOLTcm5iM5iw+FAz+JpT14a0XQdwGRxsry+6TOERxrwrCredRnM70ZOmHqermKw/pk
	KLyPHjCmVaBs/TbhTsmyq8NXgu9fXRSI+PH8MsLr8ykhi+57Eoe/f/wt3+wWq723G/W6pJ
	WiiCSyzF+ov17/F1PYHyHAzilQBTY9/1GtJbFuhB6C2YjEyoLYLDrzI8DmWmBWSB1Nad7+
	9n1rvsee4KUhrNX1tHyyKggC1sFcrVr178CzTkJZqWItIzI8Qoi4cGfbqgvnBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1771959767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKJGCewKEjcg+ipjOOUMSQ1gSJ8lDiWlCzg0lPxp+p8=;
	b=bJQjHP5OPsK78libaOkE8diCp0+pfQ1K0djQ3GdAQQPTDPPXNV48+h/ZxdoB+H0c8pA6QU
	uqloVPhDfsxBhwZOZ97iyKZGzCr6tjRTMqRMwR7B/4DM774XhKAoHQeIJG60a4bkKJ/pXe
	ms49778XHbWt0KHRwuQcBtCEiofzoBdzzUlDcn/DZQ7B3fgh+S2s6gSR48q6Yi8l8BHPSn
	SuKK3xijAApfyEW1Wdi9pR7yurwRST8hOG8dtoERHqqQkk8PUEN6hY1YnbPmzae4DWBJDJ
	ZBpIF84pNoooSxRInfrwtsNmlfjy5krcuP4Dxw80YZHgJ2obEOoj31yudui+bg==
ARC-Authentication-Results: i=1;
	rspamd-7f65b64645-pztnx;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=rob@landley.net
X-Sender-Id: dreamhost|x-authsender|rob@landley.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|rob@landley.net
X-MailChannels-Auth-Id: dreamhost
X-Fearful-Lettuce: 4ec8746d1357a7d7_1771959767655_491962063
X-MC-Loop-Signature: 1771959767655:2667290202
X-MC-Ingress-Time: 1771959767654
Received: from pdx1-sub0-mail-a209.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.12.80 (trex/7.1.3);
	Tue, 24 Feb 2026 19:02:47 +0000
Received: from [192.168.88.6] (unknown [209.81.127.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: rob@landley.net)
	by pdx1-sub0-mail-a209.dreamhost.com (Postfix) with ESMTPSA id 4fL6YK4QY7zTC;
	Tue, 24 Feb 2026 11:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=landley.net;
	s=dreamhost; t=1771959767;
	bh=BKJGCewKEjcg+ipjOOUMSQ1gSJ8lDiWlCzg0lPxp+p8=;
	h=Date:Subject:To:Cc:From:Content-Type:Content-Transfer-Encoding;
	b=ZlK/Uv01G4CStwmTz++hMmyuEPPue6aqD3QQmJmKX61oV8Mc1a91AZfjp8H1Ro7dq
	 0xU54vLor8XgZzFwEGghruMb0kbafUwQgai7nlI4muNOgg7OephR/snaicxNn/0LMY
	 3b4Nvo0brV2P9bgfO6jNno/UJO7tARXrIjdyilRLWHWAu/ovsXRNZZFaxEkAOvbt4A
	 py0RuSV1BsL2/o7bMkRIvvwgnC7/9M/NHf6yN0YKqEEr+yGaEEwpMLrQn7tB4klxqH
	 oMHi33bHek9jPgWCsGrs9g3Ty7GW0EptpcXDkzGP3Hnt5MmcMcSZ9m0+jgGVbTAUnw
	 45uzkY8a0rfIQ==
Message-ID: <bd45c86c-e1ea-4995-bb00-df83cc873105@landley.net>
Date: Tue, 24 Feb 2026 13:02:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] init: ensure that /dev/console and /dev/null are
 (nearly) always available in initramfs
To: Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, initramfs@vger.kernel.org,
 David Disseldorp <ddiss@suse.de>, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, patches@lists.linux.dev
References: <20260219210312.3468980-1-safinaskar@gmail.com>
 <a7cb199d-928d-4158-8f16-db7ae5309082@landley.net>
 <CAPnZJGAw9o8BetWs_wO2B6YD7mYuOopP0CwD=KCfOJXw2QU4Gg@mail.gmail.com>
Content-Language: en-US
From: Rob Landley <rob@landley.net>
In-Reply-To: <CAPnZJGAw9o8BetWs_wO2B6YD7mYuOopP0CwD=KCfOJXw2QU4Gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/23/26 14:58, Askar Safin wrote:
> On Mon, Feb 23, 2026 at 3:17 AM Rob Landley <rob@landley.net> wrote:
>> FYI I've been using (and occasionally posting) variants of
>> https://landley.net/bin/mkroot/0.8.13/linux-patches/0003-Wire-up-CONFIG_DEVTMPFS_MOUNT-to-initramfs.patch
>> since 2017.
> 
> drivers/base/Kconfig says on CONFIG_DEVTMPFS_MOUNT:
>> This option does not affect initramfs based booting
> 
> So CONFIG_DEVTMPFS_MOUNT works as documented.

I.E. they added that instead of merging any of my patches. Doubling down 
on "initramfs isn't a REAL root filesystem"...

*shrug*

> (But I am not against your CONFIG_DEVTMPFS_MOUNT approach
> if it helps you fix your problem.)

Oh I've been patching it locally for years. I'm only replying because I 
was cc'd.

Rob
