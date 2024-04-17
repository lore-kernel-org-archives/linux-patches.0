Received: from wfhigh6-smtp.messagingengine.com (wfhigh6-smtp.messagingengine.com [64.147.123.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF111CD38;
	Wed, 17 Apr 2024 18:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713380210; cv=none; b=TLS5A2PK3zPyDSqMLXBEgPzOr10/RYjGdgpCkN+3wSPHcZ9MfOUWtfAa0jbMKNOrGEP2GtC48CkzAqPpJJVw6qFVELTSzXmvkQZPsXroVpByQ3bMxic5HNI6yEpyQYVwdByCtfvbIFi1uaFXY6kd5aHMTTlJ7Tx4MYsXHVCDHeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713380210; c=relaxed/simple;
	bh=UAsQBomj/SHBREw07wJUzx5OaPyJD43pdm17hkPCzqo=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=UFefm4ChD4ipMG4mTubyPXbVwVVdAtuCnnRa9hl9nOBqqT18i/6emKLwWid7OHQSXWKmYTs+Zz+Xf2wAlDZrnodyDRqULRPUGPlDt+B5cNZQuIbFVysAfwk1DOKRlh23vgwbxicqL3hCHaSgS46968aqiNu/s7kSFmDBsgmFHKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=cT3jTUgz; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CXZVlqSy; arc=none smtp.client-ip=64.147.123.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="cT3jTUgz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CXZVlqSy"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.west.internal (Postfix) with ESMTP id 787D918000FF;
	Wed, 17 Apr 2024 14:56:46 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 17 Apr 2024 14:56:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713380205; x=1713466605; bh=vkCkYCQDnX
	F/dz7RqOIpQo2PUMs6uWfn082eaRvRjRc=; b=cT3jTUgzC1R5vfQDJ9MxXvXt4r
	I45wTQTh2P68PXiLffGaKEgFUZiTGcfN/oAquzekS4I8LyCGqJEymMc+PbAITWjf
	52X9BCRMFvcG7Ged79ATn6vI2V6JNNjZg4YGiZt0JH03SlPJC+2u3HBYRJJ6U36X
	XQN1rJ9MIvDmTZFiTbinLdX7VJfobIOaXuY5H4Z+2VcuAOqMmY0pvbbewWvq83uI
	kdlZjWoX44W1e6XHsvqFoeA7OFLDwzVYFOnCUKiJoKPcA1WrbL4731blQMdQuY51
	XyjGtQkQU0ZjskCEKxxubgOuemy3+mHffIzBWOTuTWKIgtlm8taGoO5wl/kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713380205; x=1713466605; bh=vkCkYCQDnXF/dz7RqOIpQo2PUMs6
	uWfn082eaRvRjRc=; b=CXZVlqSyuIwByZsrZIhX9UELqwuVxQUYODDUTS4QiS/9
	7XrQsLXRr7RdQcEcEXgn2bn/yJ+n6GIyLEwRDZAsWvbqOVIsOUT1+4YIVVaYKH7S
	RD8zpnnr2IPrU8+ZtteCa7SMXFLRCczyIAi0ZovGKRZpPkdiTrf6ACt/cemO2q19
	7wDnkkaBfmompTMY7FdvWOOeewL52msjxcapNCHBUWelNVsLMzZWXpzAdTPTKMHE
	H1VrYknMe4RNVipArd4Ji+v81ODuaE8beMHYtweyTPct1KmEpYbPE0IZ2Kdq2SDf
	GQ5Zjle3jbmx0CiR67t/a5es8zjPjMpOCAPoWwZjSA==
X-ME-Sender: <xms:bRsgZjJC41wpiDNi2mqoVFS0o3uQ5SN1Dy3sUaXXTQKPnKvxqvuyIw>
    <xme:bRsgZnI3SmTwrKpmUmzPaMuGJ8nK3uQxVaXEFCeaezOCaVSnOQecnxlbUhMAojvyQ
    FUnMPAOEWFy5-nqRMY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudejkedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:bRsgZrtf4lHyegBbrWQt72IVR0SFq7JI4o4j9R43qfVN3ffVnKHNpw>
    <xmx:bRsgZsYwrO4bzkv3SDKfIl5_DKuvRCRHudReMWZWzwFjZ219q31UIA>
    <xmx:bRsgZqZs7jkQ8Z5UasTe2T5kJtyekxRZ3O-Ah7w8Wja0MJsJmtxUmg>
    <xmx:bRsgZgADEH63zoOLX_YWfDAbLBm2o9eGPGDFoLb6zeW-Ntrj3dfD-Q>
    <xmx:bRsgZmQGbBP38VskfBn1SoCJSaMX_cKYGt-Rm9OCh6ok7x3RhyTHtvdd>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 83F6FB6008D; Wed, 17 Apr 2024 14:56:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <6d370de5-fb19-405d-9219-e372c137fb66@app.fastmail.com>
In-Reply-To: 
 <20240417-s390-drivers-fix-cast-function-type-v1-2-fd048c9903b0@kernel.org>
References: 
 <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-2-fd048c9903b0@kernel.org>
Date: Wed, 17 Apr 2024 20:56:13 +0200
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
Subject: Re: [PATCH 2/3] s390/smsgiucv_app: Remove function pointer cast
Content-Type: text/plain

On Wed, Apr 17, 2024, at 20:24, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
>
>   drivers/s390/net/smsgiucv_app.c:176:26: error: cast from 'void 
> (*)(const void *)' to 'void (*)(struct device *)' converts to 
> incompatible function type [-Werror,-Wcast-function-type-strict]
>     176 |         smsg_app_dev->release = (void (*)(struct device *)) 
> kfree;
>         |                                 
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
>
> Add a standalone function to fix the warning properly, which addresses
> the root of the warning that these casts are not safe for kCFI.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>


Reviewed-by: Arnd Bergmann <arnd@arndb.de>
