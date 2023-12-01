Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7947159539;
	Fri,  1 Dec 2023 07:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="QBBW4O00";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XmJF9yUO"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 6B5815C00E5;
	Fri,  1 Dec 2023 02:13:03 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Fri, 01 Dec 2023 02:13:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm3; t=1701414783; x=1701501183; bh=UQ
	cJg/VTtDrgrhKBmRIKlMI4XLTbyNR+8ti2pMu62+g=; b=QBBW4O00v7oHdzlN1x
	2XsOtdrSiwUNsOoSKxJIS8D52OEPfglHY+2oeHKR2uoLLofwG36qcQpN6gmzk1lM
	zV8UcQQQIyldKjtDJjmXWCq+qonAwJR4uAPgBYTHmW9Dyykaf75DxZBv53wcDK+Y
	EzRVxmMHnwx2UFncInSFMSDTkDB+JAuoTeIbuvCDa4qgpL2YHavCAiJcQthp+1g9
	ZSz55op1ezLI8RbG1sjj3TO+rJpvwLLCHhuvHHiEHtu9j7WvL5rTRdwp9l04+U3T
	swpmeTrDymbc8EdB+4330KLsXy1srHA7MWgIJHs+vjz/XqZIyN6+WBaY4owovTVq
	HKTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1701414783; x=1701501183; bh=UQcJg/VTtDrgr
	hKBmRIKlMI4XLTbyNR+8ti2pMu62+g=; b=XmJF9yUOqF9uXI6sGmO0q535ykBS8
	9iGY8Js4Nmd2VjAgr4Y6GioYu1RbSZ/ESA1SeSQDeucTiHsP8HY2qtO+CzPXM4eu
	ZYVU4W5SQGD+3JOZ55l1COp3rB6LZDEgp8oZkdix7Jgp5Sh8C2bz5WSVcQSc7aB4
	HjWOqXwQ3TbUaT1X+QadRSFSlTx6wYOt+VYRL1JkCEJQTO9EEIZZqJANpWxeZA7Y
	9rHfiVdxEQ1yYZAEgr1z3lSw4fh9IyDRdRgEU2VHWrAsvJVibYczKYTBH8IhO8qp
	UChnXyJWD2L1CLGPooXBoe0c0ylvW1n1EYRV7OmbUElvucaH7rxKpM/VA==
X-ME-Sender: <xms:f4dpZe-At7CGBnOs2c45VGasV6QcZb7ztSpQ4GTipEfiPgJYmTXMUw>
    <xme:f4dpZeu7QoJNPoP72AQa7N3Bj1RcvKVIMJn49GoMD8ncW6rJhTZbNdHQ1ZEvMsMhG
    mQpdgFHAKMppm0c_iI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrudeikedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:f4dpZUB9Q2lw3ZGWTf50NsCn__5isdUJA_aCq_cvaIIcv4kQAYM4Uw>
    <xmx:f4dpZWdAJ7BdogPJXRMT9ZkLJQMTzLqNmvZ7AnqPwNMYuzR9wucCmA>
    <xmx:f4dpZTO6yjElFYpfb7AEBjFeDyRrukT77CnjKJS9oIJJB-srZa00MQ>
    <xmx:f4dpZcpzQaHY6zUxuDjHV8Y-sAS1qp_9oMuAOkZLQKdsoL3Yn9S6cg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 22826B60089; Fri,  1 Dec 2023 02:13:03 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-1178-geeaf0069a7-fm-20231114.001-geeaf0069
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <170c8da3-068e-43ff-9c0a-6e21555dfab7@app.fastmail.com>
In-Reply-To: 
 <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
References: 
 <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
Date: Fri, 01 Dec 2023 08:12:42 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nathan Chancellor" <nathan@kernel.org>, "Brian Cain" <bcain@quicinc.com>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
Subject: Re: [PATCH 00/19] hexagon: Fix up instances of -Wmissing-prototypes
Content-Type: text/plain

On Thu, Nov 30, 2023, at 23:58, Nathan Chancellor wrote:
> Hi all,
>
> This series fixes all the instances of -Wmissing-prototypes in
> arch/hexagon, now that it is enabled globally in a default build. I hope
> most of the patches will be uncontroversial but please let me know
> otherwise. This survives ARCH=hexagon defconfig and allmodconfig with
> LLVM 17.0.6.
>
> This is based on Arnd's asm-generic-prototypes branch but it applies
> cleanly to 6.7-rc3 as well, in case Andrew wants to take it (as far as
> I remember, he has handled Hexagon patches for me in the past).

The patches all look fine to me. I usually prefer to put prototypes
in a header even if the only caller is in a .S file rather than
adding them in front of the definition, but your version does
the job.

      Arnd
