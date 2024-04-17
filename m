Received: from wfout5-smtp.messagingengine.com (wfout5-smtp.messagingengine.com [64.147.123.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D4A1096F;
	Wed, 17 Apr 2024 18:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713380171; cv=none; b=R5CZ7LWWHOGwRwzc/g8uBtqhidCFlG0/T0xqlmieAxlmEO3Kaz8U04UJdfG7HgeTXpaL+VrFvg+7zN5duyqxgMyBibJtR1c0ZixXpoaNlGRS4luDPUeZjUlmIw3l6tPwIXFo6s4IP8l8YroAIvb48kgI79jtMbgjjKV+BP4pJeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713380171; c=relaxed/simple;
	bh=gi6ZGl9S1GNNL14N58pMtqrFxQFhqzOt/FJmhliCfaI=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=TJioRkZ3sKFAv4SpCegiMhT3dpZztDBlh5aS96oYSLlXGE+jq//MAwGkdQirCLwXoCkp90FmW7ut22bfUeB03JLl8AxNZRvE6IJw7UpLafZ1R7PmiKPj5/GN12Ensa3wxFwlxEn2zwBlq1CP4VMyaYQCRrC8tKVAUHBlYYefrkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Ob0SDT7R; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HoCKpiL8; arc=none smtp.client-ip=64.147.123.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Ob0SDT7R";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HoCKpiL8"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.west.internal (Postfix) with ESMTP id 86A251C0016A;
	Wed, 17 Apr 2024 14:56:07 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 17 Apr 2024 14:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713380167; x=1713466567; bh=k7OiZ4Ru4J
	WghjKvrQ2VYYslCE4MoaVURyBLh4oH0rY=; b=Ob0SDT7RSfk38a0HFJqcJk/7OQ
	YX8xP0BmLZ3pkBS7hmFZ5nZ1D869f65e9ymcMV0LVNBQ5bwf0IynTaK0xA8MzoPd
	pDdREyrqMFfAL0Om4QhU/tSzGix5bjU66B6wLvn8GzceealT9NSiF4zLha701iCk
	HZVGTmhyOSWNh8hxymTmbqyQsRrhRjljt9uhdjY5j6AlgW73s6z7q2cCq5kXAN05
	gIhQrkv2cDnFk0leMhyzrXZkIi/G5m75F+1L5nQVktjH/5F0/8WI2KuhtFNG0NV/
	gL9i5nE9oVyO4Iyt2/7JJaUik3j+bSxuSCHKMfwNJa4bkcbxFXjgjoW2MSqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713380167; x=1713466567; bh=k7OiZ4Ru4JWghjKvrQ2VYYslCE4M
	oaVURyBLh4oH0rY=; b=HoCKpiL8gOhMTcE1VMoXEYdxNrMobC+tK1Bw6hkYUoR0
	mZsTynQPKJkiniT7o0Q1rvhtS19k/4I6AR+wdArxTlr82KIU7XZeIIIecumbQxDA
	ekLmRA70N5tpYiFhYSA/B181mUq5mFbjiwC3JiTB97vOAm5HcyOQUCChoqGEKeiT
	6S4WLN4D4zgbb5U5QJ0lXpsJl1sWDcfTRLhre2fk8oU8ghp5RcF2chi4WTx3yqgF
	EmCCoXYA9nAcFDW2rbfzrCobF2lVzYrxOzZ8vbKpcGm1SUVOJIFlpwHTy+dPGCQZ
	F2G4iW2msGMy4jELWyCDcWJ4xYcjSm5ohIrP/4Fh7A==
X-ME-Sender: <xms:RhsgZkQHPhwIRaXWUOGkSSP2b7ARsVQMoZGObMfn4BMuqRHifoo0ng>
    <xme:RhsgZhxMlrO0f_ydz3zyBgItDu-DpqRpgwLdQBSn_WhIdE9bq80WUQRROwPxlAvV7
    ZB3eXQdu4q6Hgqu8Bo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudejkedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:RhsgZh3oj-ifqzqs86o6t1AMrxApaxUtwHTVT1y_m1fY9vAT1ApW-Q>
    <xmx:RhsgZoBOb7VJIZWJl1ByZfZvFBqHZbVewuluM0eRUUVWpvmoaK-naw>
    <xmx:RhsgZtgwL9vDG1rP5dDb0lWILyrlaj_8pCIVtmTV2p2cDsd30_Qt9w>
    <xmx:RhsgZkp4AJEp5ymnp6RIz4W-EwHNp3J5Yc0CM_PDUVe9uPVPds3hZg>
    <xmx:RxsgZmaXwtdi5o5otwrM5txBlIQWiqUFGoyjPt25Am4Tc7PEJS_cD930>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 85B5CB6008D; Wed, 17 Apr 2024 14:56:06 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <6397a497-b886-41dc-be18-9b6ba93ea779@app.fastmail.com>
In-Reply-To: 
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
References: 
 <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
Date: Wed, 17 Apr 2024 20:55:46 +0200
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
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Content-Type: text/plain

On Wed, Apr 17, 2024, at 20:24, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
>
>   drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const 
> void *)' to 'void (*)(struct device *)' converts to incompatible 
> function type [-Werror,-Wcast-function-type-strict]
>     746 |                 dev->release = (void (*)(struct device 
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
