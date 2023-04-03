Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89478747B
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 17:56:58 +0000 (UTC)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 994395C0050;
	Mon,  3 Apr 2023 13:56:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 03 Apr 2023 13:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1680544617; x=1680631017; bh=8RIO0uCEvz64g3NovXvBT0P64254DQg2kzJ
	W/e/1H9A=; b=jSKHpUw6brenmYW3Gb7aIeWXZkuijj4LRomLcC71oncTnIcL1FD
	N1Nwf8iX4RPNNxcZ7t1VWwCMLdVDUDIELi441qJIXwf9WkjbeVGtFmcigqC9YMGT
	cFdogfR8YYARUEwFgUW02SHwIzEXTPn8Y1Q+G/+yBXLURzp5ckdSE54CWrNQfOdW
	MNhJwJiqy95Th1xgPdgzC6hPUBhT/evth83okCu+DoMOPVOy+otJXkv60fyICJzx
	yQW7nTxMHPXqiEGz8+rAwEvVLVi1DGINJkr+tcyN1XcKzOhSm4zIOr6QU58NtlZE
	/weEv6+klXcXvQg+up/phQJyzzsTneW8+Ug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1680544617; x=1680631017; bh=8RIO0uCEvz64g3NovXvBT0P64254DQg2kzJ
	W/e/1H9A=; b=UYj9CGd0OnGazN/2vnUvxW+90loTPEZwp+b06GWOmSKdD+E7ZIl
	A4rea3i9vbpPYmW2q4dhdgerVe8af1ZXPMPHY9/BSSKr7/535EPFKTDGJdesvCkP
	Ho1SZlYsqr8l9T9k7rU3Q8cX1gIR0CydKja3xnteUBgpzMqKIoQ11/sC0OZPug1m
	o6IddIlSN/vMzvSVmidHbG7Th3/k9sWs4gvK3p18Pt9clheZk57LToXvHNhyE9ts
	upmPk2KaHx2aFJ+nUofZ9vZqNiKClA1Mk8pPGdOnRYgzvVNTrKZy6I7l07Gxhxw0
	KqXsXhhbgFbQw7EzcXFqEYHu3O6xqFfCvDg==
X-ME-Sender: <xms:aRMrZLAubeWUIo_OGBbS6Iujbikrg5GHly5wRxogPWuqfwseR_mqjQ>
    <xme:aRMrZBgdpblWLwDx4OrjPq5txThwQ1Y6kwgvm-E8Iw7ha7orq6OWwjDwx4YmzNwg1
    e4xALU9uno_v-ZSUQ>
X-ME-Received: <xmr:aRMrZGlL8fzsj8UuG6pknKJz5hlXFsknzCfrFSHAYmhzccKLAJaL6atWQ9o1M83k-3BEawfwI7GjYg-__CuUnHiXDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeijedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfhuffvvehfjggtgfesthejredttdefjeenucfhrhhomheptehl
    ihgtvgcutfihhhhluceorghlihgtvgesrhihhhhlrdhioheqnecuggftrfgrthhtvghrnh
    ephfehueeileevjeefkeetvdffveffudeuhffgtedvuefgiefgiedvjeegvdejleejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihgtvg
    esrhihhhhlrdhioh
X-ME-Proxy: <xmx:aRMrZNzdLFTTfMEauKcOYrrKX8c4PDhu_cCqHY60dYlQKhY022ByVQ>
    <xmx:aRMrZATjgbG_sDzb6S5fceCGajvcT_GAKN16ikh23UIrc79VGz7Xqw>
    <xmx:aRMrZAbd2YZ8KYF39He8JEQRd62StmdB641qZ5LKxl4yDxOB-Yn5-g>
    <xmx:aRMrZFI-9wMe4aM309tVI9EF4Vgx2FKL9ea9fsWeUUnVy3VXWMfFzA>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Apr 2023 13:56:54 -0400 (EDT)
Message-ID: <f50f9ef6-56c3-7ef3-9978-e30a55c55267@ryhl.io>
Date: Mon, 3 Apr 2023 19:56:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From: Alice Ryhl <alice@ryhl.io>
Subject: Re: [PATCH v5 03/15] rust: sync: change error type of constructor
 functions
To: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>,
 Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
References: <20230403154422.168633-1-y86-dev@protonmail.com>
 <20230403154422.168633-4-y86-dev@protonmail.com>
Content-Language: en-US
In-Reply-To: <20230403154422.168633-4-y86-dev@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/23 17:44, Benno Lossin wrote:
> Change the error type of the constructors of `Arc` and `UniqueArc` to be
> `AllocError` instead of `Error`. This makes the API more clear as to
> what can go wrong when calling `try_new` or its variants.
> 
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
> Cc: Gary Guo <gary@garyguo.net>
> Cc: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
