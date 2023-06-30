Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36B616415
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 15:35:07 +0000 (UTC)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id ECDEE5C1D56;
	Fri, 30 Jun 2023 11:32:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 30 Jun 2023 11:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1688139178; x=1688225578; bh=hhBomBeAlOmsPL3qCHSlVfZmdBVSngojM0t
	0AkUf/oY=; b=X9J310eeZDjBWSv3x9bGvUYm6RSBDvVnQkm3AgoaiNmTSjazQ+0
	u61SPv8b4QmmmaDu3cLHR0QF7UkLBfShoRTMXdwy36uQelIYu22ou6Lqtru6o1zz
	eNqjI1CRa9eqlsJI67t3+bUV2zaZnZ91aRsDcppoKgb3aRooAG+yT8cgCU0RHUmx
	C8INgfwLw4qEfTyiZCNP3OlkJ8y+4YAiglAkbRPi3BWSkuDvGVBUCPb0ykSmDxWr
	ErmKFHkF6sxxHoIncH3RBC0SxIAsNgfjUUEUkQ2OmPPwJF2m3jJrEXciuC4iVTMK
	PdDqYymKPdIMFYIQX7Kqcm09vpKOqOIvpXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1688139178; x=1688225578; bh=hhBomBeAlOmsPL3qCHSlVfZmdBVSngojM0t
	0AkUf/oY=; b=gM5/CB7KkpABu1vzt1euSdFBywQmG+sEehJNJgFbgIOXbN+gJ1s
	sm04k4BvgGLiQF88ElgjNzufy4RuRYNZxT6S/NzKIsMdcnbJqPKoaoqUaRSe776T
	zZ2i1OPul+ACzlGTwpni08oMCZ/UMyro6h56a5lyCVSQSD18tEAK2NO7xOMQxWPf
	+VVTsEOuz7+VBIip3gIq5oA/tyPAZt2hvUbyHw78SfWCrF53+CJwDmTdBSqcOTiG
	d3+Qdq9Tb3KscXiRoa0Z9c8iOTxN0g09n2M9EA24LO41JsVV3tjHse6LwO8hd4u1
	A2oGBSUEtmEOdvrk0XP1w2l+YvypeEH9JcA==
X-ME-Sender: <xms:qfWeZEaUgFvq51TlJudLsDT-lveGksLn10qW1G6w_F7WM0C8dCacsg>
    <xme:qfWeZPYhdCeGF2uRXPXz5l1LJ-RnR5xfwumjjsOuFW4_fRAQEB3qwadym8p51aYku
    LpExwKzhznvPIO6fw>
X-ME-Received: <xmr:qfWeZO_RHb2aD9-hXkmgGv7a2Nm1XXHKDjmiDNJ2Gmd18vMf-L-c-DzikHqQXk3KgOjU5M3U8yRvuc5QIBVziQlBQTuWqNWeo3kuoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrtdeigdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfevfhfhjggtgfesthejredttdefjeenucfhrhhomheptehlihgt
    vgcutfihhhhluceorghlihgtvgesrhihhhhlrdhioheqnecuggftrfgrthhtvghrnhephe
    duuddvteekvdektdduledugfffhfdugeejgeeuvdevtdetveejheehiefffeegnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihgtvgesrh
    ihhhhlrdhioh
X-ME-Proxy: <xmx:qfWeZOqIhl_hAvqV0HfBPttWtTCg5gwNK2hBOjAC87EpoRwmXXoZpg>
    <xmx:qfWeZPpLRuvwyezFe0Jgxxlr8v0oZ0BcpukP2NKKli2LvcoWFttmMA>
    <xmx:qfWeZMSRj6zmdKKH48lRBDyY-KgLdTtoHiehvHbsS-pSQqfUmisWLA>
    <xmx:qvWeZMjQHwcwyl_16HSKdFe4C3UbLudv-WE0H3U0OvqnqeCVlgzQ5Q>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Jun 2023 11:32:55 -0400 (EDT)
Message-ID: <11c59308-1842-13ba-0945-a68e79d079b8@ryhl.io>
Date: Fri, 30 Jun 2023 17:32:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] rust: types: make `Opaque` be `!Unpin`
Content-Language: en-US-large
To: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230630150216.109789-1-benno.lossin@proton.me>
From: Alice Ryhl <alice@ryhl.io>
In-Reply-To: <20230630150216.109789-1-benno.lossin@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/23 17:03, Benno Lossin wrote:
> Adds a `PhantomPinned` field to `Opaque<T>`. This removes the last Rust
> guarantee: the assumption that the type `T` can be freely moved. This is
> not the case for many types from the C side (e.g. if they contain a
> `struct list_head`). This change removes the need to add a
> `PhantomPinned` field manually to Rust structs that contain C structs
> which must not be moved.
> 
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
