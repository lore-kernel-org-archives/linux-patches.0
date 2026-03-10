Received: from buffalo.tulip.relay.mailchannels.net (buffalo.tulip.relay.mailchannels.net [23.83.218.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD9C399371
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 13:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147664; cv=pass; b=AXiUX6sxZyTxbVVTc+Cw8P8qEJnV6I68iOi6cBlHMAKjiyIT0Wab+LJfJaIdaFXw6F9ZW7e7KN5Fb/oOJDkaOfyNYoRNbxG09f1b6de9u0pkGekPE2I30UjBxnTtPd/SC6wVQ76mtg6RYc8D3UQkVDWHewSuPOuhPeqbAhTWvGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147664; c=relaxed/simple;
	bh=pNzZKas2ZtzHmNNSQQSGpyTKI26YoaTc5IACXsi2rt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPoX9i324swaF331+Ly6tqg4gyLT1Owz152oi+1VrlaVNDD5e3X+X1moEg/Xe7k/ROrWrtuOGvjIpNtyuu7OaF9QbOzbVYydvdmSvSRsfZlfVxZBEUN46+X7tyOdphOWCRopwNVCbOkLp6p1je8jSJdN9jiIb9ppCyaqaIYIi4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=landley.net; spf=pass smtp.mailfrom=landley.net; dkim=pass (2048-bit key) header.d=landley.net header.i=@landley.net header.b=fdfaOaJr; arc=pass smtp.client-ip=23.83.218.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=landley.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=landley.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=landley.net header.i=@landley.net header.b="fdfaOaJr"
X-Sender-Id: dreamhost|x-authsender|rob@landley.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 9A17A9227B8;
	Tue, 10 Mar 2026 12:51:50 +0000 (UTC)
Received: from pdx1-sub0-mail-a222.dreamhost.com (100-107-106-54.trex-nlb.outbound.svc.cluster.local [100.107.106.54])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id CB51992112E;
	Tue, 10 Mar 2026 12:51:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1773147110;
	b=hFQA6o2B8SK+clQ6CAcG1qC4T0SUuEzNQhfB1UlPD4c81M3jOw5NyvKa0xRAAcPqhNVa1y
	OaDfb3wd7JZjHGbnSDYpz1fQr0wzonraOfRBzgdlgOwLFLCiyA+TBR1Jfw6oIlLX5I7ijs
	ln7NdTTiDBYUYw+F77oeXpaxsJimF6aEbgMn9GenjLC0W7WGnpSMH7rSiX/UrhNm85KJ0D
	qNXtnEAOkyoQlx53FrFCGOQSm5wSKeRQrCNM/M0vgdhK83ReJ73JMEl0Ls6Lnvy2qeegwc
	3TsU7/oDhztdxW4zzmY3hrEu9KtuPg+3YW/XAhc2IwNwmOdDECzq9zZjuCwXbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1773147110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/IhzbasK0cIjsjppiT2+8RzOyLJ0u+k3bxUMCZYXS0=;
	b=08A6/Tcmwuc5FUFIyqebdLkvcAFOBHlwCezdfc9kYzMHQCLkEgLZDyFEUnwbCsealxVZr6
	QOByHza47Fa0SAeX+VzcB+SXoOsnoL5UrREpS/egFLUCYmYAd3mwUJFhj/WZClH3MMheLE
	OSnseDjmvkqfeqt2s9Ceiq8/R4PRwGEtE8VFjtwTb6zyB3MBKuRT9tvfTkEt1I2E8Ax0qN
	Va2CZBieW1KIkPY6W6tbnpXC4aWN4L+O7nzkHY8c8YqxPy/UqWIDvOR8+4CuRTi9D72Z+r
	LPALgKAD5qOb/3dIgZXDRDUJwdi8Njh6xBDtPvmgvEAgXXgBMtocCQszf0uGoQ==
ARC-Authentication-Results: i=1;
	rspamd-6f5c445b59-k98sl;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=rob@landley.net
X-Sender-Id: dreamhost|x-authsender|rob@landley.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|rob@landley.net
X-MailChannels-Auth-Id: dreamhost
X-Irritate-Madly: 6e3306b557cccc9e_1773147110416_1850464333
X-MC-Loop-Signature: 1773147110415:1444249190
X-MC-Ingress-Time: 1773147110414
Received: from pdx1-sub0-mail-a222.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.107.106.54 (trex/7.1.3);
	Tue, 10 Mar 2026 12:51:50 +0000
Received: from [192.168.88.6] (unknown [209.81.127.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: rob@landley.net)
	by pdx1-sub0-mail-a222.dreamhost.com (Postfix) with ESMTPSA id 4fVYfp6R24zT7;
	Tue, 10 Mar 2026 05:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=landley.net;
	s=dreamhost; t=1773147109;
	bh=X/IhzbasK0cIjsjppiT2+8RzOyLJ0u+k3bxUMCZYXS0=;
	h=Date:Subject:To:Cc:From:Content-Type:Content-Transfer-Encoding;
	b=fdfaOaJrQBNBCd3gR49zIUWuViPoJDCRi1AwbxvMK3LY+021jbsmzYWZL5MtOgK64
	 3kezyJqpQTobolgVHTCw0i6WhlMpOL8hF90dWbNzyy+Tx+5xcmUuVnKhRm916rZOrh
	 IglSjyYYw6ttQepI3rfVQl2hWlBhQmDKcJs0YCVF3td/iJ0h/mfGvAseDNxnlyWFef
	 7OXwJL9fnJ2a2/BxMQTFYCosb/6jpwV5QGn4FiCaY16Kwm3ELHeuQPjyaYK/QBgAnu
	 YBVafTpAFV/ORIK5s2UGbO4f0Uoar7Do5di9e29sCsFh9q7zIxIbPQfMvNfO9rfmDJ
	 jSXkF/xmWg20w==
Message-ID: <54f06055-c5ca-4b8f-9aed-065755e7c1b2@landley.net>
Date: Tue, 10 Mar 2026 07:51:45 -0500
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
Cc: brauner@kernel.org, ddiss@suse.de, initramfs@vger.kernel.org,
 jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, nathan@kernel.org, nsc@kernel.org,
 patches@lists.linux.dev, rdunlap@infradead.org, viro@zeniv.linux.org.uk
References: <bd45c86c-e1ea-4995-bb00-df83cc873105@landley.net>
 <20260307032258.2857157-1-safinaskar@gmail.com>
Content-Language: en-US
From: Rob Landley <rob@landley.net>
In-Reply-To: <20260307032258.2857157-1-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/26 21:22, Askar Safin wrote:
> Rob, I kindly ask you to test this solution to your problems:
> 
> https://lore.kernel.org/all/CAPnZJGDDonspVK1WxDac2omkLJVX=_1Tybn4ne+sf3KyaAuofA@mail.gmail.com/

Your earlier suggestion that at some point they fixed the kernel build 
so I can go "/path/to/dir /path/to/file.txt" (which didn't _used_ to 
work, I tested it way back when) would presumably solve my problem 
without kernel patches.

I just haven't been programming much since Gavin "spyware" Newsom passed 
his stupid "age verification in the OS" bill 
(https://mstdn.jp/@landley/116194386057190345) where every cloud 
instance needs to report an "age" to Palantir, implying I'll have to 
take mkroot down before Jan 1st to avoid $7k/download fines, and I'm 
looking at maybe getting a job in healthcare or something.

Rob
