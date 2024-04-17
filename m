Received: from wfhigh6-smtp.messagingengine.com (wfhigh6-smtp.messagingengine.com [64.147.123.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D857925619;
	Wed, 17 Apr 2024 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713380264; cv=none; b=AXNwEZYwSJOh+UdAvRlJWUwJUX6DAsnnpK/zC2dQtNw8AzMwD0LPrbxlEL6d6Mucwd3YevfnbjWipi3E6g/BaMbIUY3jHAXXdYoP+OlADBaW2fY2sfxMUSosqb5IOKdQXqTZ7ZYPKl5LmxfbcmdI6+e+c/XDnClK7z2ap4XnUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713380264; c=relaxed/simple;
	bh=mukMXfRaH5+NMZIb5Xef9x+qYy3bjdENrO6zRsPJYd8=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=Taz5V8UMrbOtO0Jy4YOmA7wKtm3Pd4De5v6Q4+XhUbVFL2GKg9gmwzAbAES8/rjXGjdbDwtW4ybbg5REVgkiOX0Yjfsm+U4ZyMtqdC/zsl2ciW+joyKXdfZSW8iR7iBaaGwy1sptIZedwFzWAYjvp+J2uQdEqCzxpdzJjW9Ollk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=rOw5ijSY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SS6ODAj0; arc=none smtp.client-ip=64.147.123.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="rOw5ijSY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SS6ODAj0"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.west.internal (Postfix) with ESMTP id 391E818000E1;
	Wed, 17 Apr 2024 14:57:41 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 17 Apr 2024 14:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713380260; x=1713466660; bh=OxvFic6ocJ
	NdAQ1CbbZKQNKjRdfB7w7LA61IzvHtWvY=; b=rOw5ijSYBZv1I1XhE3WvVyJHq6
	X0lgHu9QGkRqpdOQufnm1KZl7XXp5zwDrzcQVV6RWg2hvTqQHKuWRVLOff3H8RlX
	BU4QBHhPtVV17o3v4kV7HcvoiNG4WMl+ERnyS12aK4Pzv+YU5xCsgoPZTNFftQNE
	SNXPElt/3CV5ggr3m2yO368rpPKMiIVecDvxfZKFtm4/s/nw9eutA+xIXir3mIGs
	2w8XWxmxsyyKKkKv/1Yxc4CdpnhyuKl32GsP1q/DvK3DMc2vozS9bhRKR4IYHQO4
	CkBVg1XxyQANUWil5N2AqRg3C8/IP1bomUg//U6v6GQZkDFQDH72O9ipB3Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713380260; x=1713466660; bh=OxvFic6ocJNdAQ1CbbZKQNKjRdfB
	7w7LA61IzvHtWvY=; b=SS6ODAj0UBa+zx3QqFbG/EHR30M0oqWRwWJGiNsN/m0V
	EyUOTD48mHRW+TpTHsr+eMaDeNgLEcuRqwIkMW/UcGd/DapLZCKGihRx6H+gge2P
	rB5/qOuuy2IAqgzrx3wzzVpP9bWEqmTJymAGYEtPg1uL2xKhaOkOrHDKtag0FCqZ
	3X4fPXqQQ6G+JBB53oeFfSYgYntdcUrJsEglGyoLzDXCTGPLbzAB92J5pQp4wi7N
	kRq55E8eKZxDWvRqlaiVwP7Wcm1hOqk4TG2q1x2XlD1mtaegYeQcg6hJL8XpeFRE
	+XyM6vTX+rly007dnPuJ3MU9Xc3suhxd8V17xvnT0g==
X-ME-Sender: <xms:pBsgZrDh-2pb37X5fawSDSV5ZBxjvnIAyt3BYosHh_UeBb__kiUbrQ>
    <xme:pBsgZhhUOdB_jMqVHjtNE8waKOGL7IsepZDTS1DsTtFj9NNJX0YlSoxoctW0aufTU
    o-F5mLXfDHfI20u-qI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudejkedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:pBsgZmm2dnejA125rIL6MlKgbatUPlX0L7kZGN_TUiCtCXnTrgi4Uw>
    <xmx:pBsgZtxsHQHOaqqN4hcb-R5oHpz1LJHxxGY-MFRZ7aWM_UbqBEwqDA>
    <xmx:pBsgZgTGaEhfdqxWh3Hmco2HaBJ7joP5PpU299mR6t3008CbL3gnFQ>
    <xmx:pBsgZgaEGnvgx1bo_wz4bjzo3fqxN-dYSPXHtXO4-5_G1SeqgEOuLQ>
    <xmx:pBsgZnJZbBb1Bju-n99SXpn0PZeOH6pJEHZa7U8I3M9xNZcrv1q4eZG5>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 467B6B6008D; Wed, 17 Apr 2024 14:57:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <46329c2f-dc04-4533-a958-bfe6b9a1fa0e@app.fastmail.com>
In-Reply-To: 
 <20240417-s390-drivers-fix-cast-function-type-v1-3-fd048c9903b0@kernel.org>
References: 
 <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-3-fd048c9903b0@kernel.org>
Date: Wed, 17 Apr 2024 20:57:19 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nathan Chancellor" <nathan@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Heiko Carstens" <hca@linux.ibm.com>, gor@linux.ibm.com,
 "Alexander Gordeev" <agordeev@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Sven Schnelle" <svens@linux.ibm.com>, wintera@linux.ibm.com,
 twinkler@linux.ibm.com, linux-s390@vger.kernel.org,
 Netdev <netdev@vger.kernel.org>, llvm@lists.linux.dev,
 patches@lists.linux.dev
Subject: Re: [PATCH 3/3] s390/netiucv: Remove function pointer cast
Content-Type: text/plain

On Wed, Apr 17, 2024, at 20:24, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
>
>   drivers/s390/net/netiucv.c:1716:18: error: cast from 'void (*)(const 
> void *)' to 'void (*)(struct device *)' converts to incompatible 
> function type [-Werror,-Wcast-function-type-strict]
>    1716 |                 dev->release = (void (*)(struct device 
> *))kfree;
>         |                                
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
>
> Add a standalone function to fix the warning properly, which addresses
> the root of the warning that these casts are not safe for kCFI. The
> comment is not really relevant after this change, so remove it.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
