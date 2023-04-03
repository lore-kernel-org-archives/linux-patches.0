Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AD747B
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 17:57:11 +0000 (UTC)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id E6FDF5C00EB;
	Mon,  3 Apr 2023 13:57:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Apr 2023 13:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1680544630; x=1680631030; bh=ll8gpUVGJA6NPP08LtOOvFlPRy6vgkHj5Yp
	9xxOsn9c=; b=ljG/i0SMURxeCtZ2Potc5lsV2L0IkYo+ckhiwGpVI5J4rdxfb8n
	YGVLoSkx0YDtmKUP5lp6H6fsLGRZkm+lQCIwVI/rB4/2oNcX7J3NHSzkFrnTBvPU
	9b65xV81IsZxpwM+HJsVfQjZ+Rhz9RmUj0HiA/8oOzOnB00pDJIi3WaI4PoL0ME8
	Ysk2e13W8n2FhHu+olSW5eXxe8z5W2V8zmSjyHpF1bTh/ZyECvKsDWxOjcEUorla
	QC+ijOjiXdA7imuck33AHBxdlS0Wg/XVGbBlARSCGVGnDQNSEY5TVWcJ5Tm96ojn
	bxGkO9M2ChnKK+EX6/sZh/2O5Ia5kAj0Gkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1680544630; x=1680631030; bh=ll8gpUVGJA6NPP08LtOOvFlPRy6vgkHj5Yp
	9xxOsn9c=; b=eF8eorsqN0qYb8zhUUKysikZP9NKClZJk/XZUWA54XZEeKonR6k
	EqMYI+1LKaCMrB/SNibNGf3DRbgwlR4FFiDuCLZ489SNQliemfW2smmfsp+wd2jI
	GSsqKQQeC4FcPaoPLWxc55u8SdOHC87DUeLvrIp/2oZ7BbHRTbRBN+H4KTg7hYYP
	i49eYTMkZlE3S4kN78qB8urHHgztHRkBIrjuNiaOVybCxyUnXKwuDGBaLChkz1IF
	ks1/ETof8I93qHklR3cstXUziv3Tz/321zpihyp1M3GGMf1MfYx6uGJOFA4vMKx3
	DJyrm4lN5XjNJLOw+Wehr+shkdh27MuIFSw==
X-ME-Sender: <xms:dhMrZIhOM4W8laJ1fAEviAFU7vDTfHJGLXKDABaowEWhCWis4oaSsA>
    <xme:dhMrZBC8vGwLlijuZag5a-FHClVDecR-EKo3kCsaqwvI831ioEj28pv4lLqw_0br0
    OkqoyQduAaIPAE_8A>
X-ME-Received: <xmr:dhMrZAHLchM6abXu91Yr6tu3y0Cy4KQNtyKeDFhodJdv4-ykyQoNcFR6MOHeHbd-pFZekrwMCad0zs4iz59B8UoXSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeijedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfhuffvvehfjggtgfesthejredttdefjeenucfhrhhomheptehl
    ihgtvgcutfihhhhluceorghlihgtvgesrhihhhhlrdhioheqnecuggftrfgrthhtvghrnh
    ephfehueeileevjeefkeetvdffveffudeuhffgtedvuefgiefgiedvjeegvdejleejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihgtvg
    esrhihhhhlrdhioh
X-ME-Proxy: <xmx:dhMrZJTBErIQYDM_I53d1hN2-8mmKUqUmVXVwpVB-mK3fwWMQTeIow>
    <xmx:dhMrZFwom7QSioVlpsFerFUltcx1hAK2Vrg8xLIA5r7Y2L5KAIRaxg>
    <xmx:dhMrZH5zCcoPGFSI7iz5yaVIEwkdTNEI011qxOrek6M_ct8vpP5RMw>
    <xmx:dhMrZKqJzGvfuA7qcAh0nlWof2wtNn4UYh-Gvm-OY_Wt57lSXkzWTA>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Apr 2023 13:57:08 -0400 (EDT)
Message-ID: <a580c459-1453-1010-43d9-5af4c79031ba@ryhl.io>
Date: Mon, 3 Apr 2023 19:56:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From: Alice Ryhl <alice@ryhl.io>
Subject: Re: [PATCH v5 08/15] rust: init/sync: add `InPlaceInit` trait to
 pin-initialize smart pointers
To: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>,
 Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
References: <20230403154422.168633-1-y86-dev@protonmail.com>
 <20230403160511.174894-1-y86-dev@protonmail.com>
Content-Language: en-US
In-Reply-To: <20230403160511.174894-1-y86-dev@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/23 18:05, Benno Lossin wrote:
> The `InPlaceInit` trait that provides two functions, for initializing
> using `PinInit<T, E>` and `Init<T>`. It is implemented by `Arc<T>`,
> `UniqueArc<T>` and `Box<T>`.
> 
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> Cc: Andreas Hindborg <a.hindborg@samsung.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Gary Guo <gary@garyguo.net>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
