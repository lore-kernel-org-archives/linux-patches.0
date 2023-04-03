Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B74747B
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 17:57:15 +0000 (UTC)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id D3F1E5C01B0;
	Mon,  3 Apr 2023 13:57:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 03 Apr 2023 13:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1680544634; x=1680631034; bh=Fj6jwtuJwwXDKnuKOZE2jK35xWn0Haj++9r
	GqO2GEwM=; b=BAZHys7RbRPdGlIJk/oh4D4cTsgBFojioQzpjsnMMlfApqULNZq
	aVN8z9sPPj3McNCxNQy0edHaEI27x7buyh+QJbpkLkoUND1cCoq0CabAeHxn7UX8
	0pGOA2LK8dUlAtEMTNRA8qVp8rQxFeWLajrqz0kR5JrrcWzot6dM0UsOuaEzUUHX
	tDk7f2NLtRknHlnZK/+xEoGQyGcIZ6bnq7/MpSdadnBalt3Snygfk7IUteCFEEj+
	/yTSHGyQPEcUP/x77HdMjwrtieu4Dt1wNg6ozNewpIl2lHoeao4QuNOwYa/bWQcl
	/0XKhbgapv4AEx2AxMmES44v3a3PRHKROQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1680544634; x=1680631034; bh=Fj6jwtuJwwXDKnuKOZE2jK35xWn0Haj++9r
	GqO2GEwM=; b=UaZ8qLNTDdE2z5DALS14TvH/SqRfki+TAKLBkrKVjWl7+ee5+TG
	iCz9npHAt2OV6b72blpMFRKQx9MJgjfMmNbJKGxkVaUK+Mxjgamf6W7/jlGR20kT
	SSmsaQrKEjMqIgYVbxcr6+U6oeNNvHnpaqAZVzWKvDrXRaO2TRSJ478lf0h5XJOM
	cpTbqKqNV/f/Rx7Hooef2wTL0mPeM4QmkKozymLmIVK1+pzSQ8c/qFlS2ZJBOJnH
	UbF/vj7jT+kP2IZUoMfEbZ4LgRA1XWIGUD4sZGozTYxDCTbage0HXA308pyDiQ/l
	GpaCII5MTFO6WdPfgEoESyyEzKr1M39Bang==
X-ME-Sender: <xms:ehMrZKf448UhETwWmcEGccGoQdNzeP7nT7jKe_b-azTi9X9gqVhACw>
    <xme:ehMrZEMFYWetsZ6itz1AMmG-K2-7GKCQQlVq3JvvvWDKP6YLQ6-KnVVBeUhNN0jhX
    rQsT0_g5HNp0DntOg>
X-ME-Received: <xmr:ehMrZLjHLRoxJ3yazGL7JS4tEjikSMZdX_g5i76Ne26_joUw3MoV_su2Y-zPwO4tFKd4fZypgcIKdasixzAKESAbNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeijedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfhuffvvehfjggtgfesthejredttdefjeenucfhrhhomheptehl
    ihgtvgcutfihhhhluceorghlihgtvgesrhihhhhlrdhioheqnecuggftrfgrthhtvghrnh
    ephfehueeileevjeefkeetvdffveffudeuhffgtedvuefgiefgiedvjeegvdejleejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihgtvg
    esrhihhhhlrdhioh
X-ME-Proxy: <xmx:ehMrZH_FcDkjguEetl9wU2sidi0NDbAydlqaKqr9YZswThqJbM-BoA>
    <xmx:ehMrZGv1yzXChok11HwgTmbZlA9OBtbb2vj4bjzHg6k6_4z50DEnrg>
    <xmx:ehMrZOE84K-tFEf4KsylKW48AD69_Vv6FUeNrtjtpugUyAIYvxI7XQ>
    <xmx:ehMrZHm4liWIraWoarDaW9gufJuOMba7gH63aOy-XSdU7pGLn198xA>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Apr 2023 13:57:12 -0400 (EDT)
Message-ID: <2dfbd9ff-3aee-2fb7-8701-c03bd12c090b@ryhl.io>
Date: Mon, 3 Apr 2023 19:56:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From: Alice Ryhl <alice@ryhl.io>
Subject: Re: [PATCH v5 09/15] rust: init: add `PinnedDrop` trait and macros
To: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>,
 Andreas Hindborg <a.hindborg@samsung.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
References: <20230403154422.168633-1-y86-dev@protonmail.com>
 <20230403160511.174894-2-y86-dev@protonmail.com>
Content-Language: en-US
In-Reply-To: <20230403160511.174894-2-y86-dev@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/23 18:05, Benno Lossin wrote:
> The `PinnedDrop` trait that facilitates destruction of pinned types.
> It has to be implemented via the `#[pinned_drop]` macro, since the
> `drop` function should not be called by normal code, only by other
> destructors. It also only works on structs that are annotated with
> `#[pin_data(PinnedDrop)]`.
> 
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Andreas Hindborg <a.hindborg@samsung.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
