Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63013AD28
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:48:07 +0000 (UTC)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 7CBD05C01B0;
	Wed, 17 May 2023 16:48:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 17 May 2023 16:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm1; t=
	1684356486; x=1684442886; bh=pFDxtEWtnh290gDvTyGldDFfJHa7QfMoAy8
	KN2pcuoM=; b=ho1lGA42K+++lh3DRebdBMTa8hAFcGZw8+B388bX/1twYA356Ul
	F2u+2k5eFCFgj6QxUTX+ghZ1NV/z3W6ffM4qBNpFdoa807YhQSOyLBLKzlbLG2rB
	5+EipP87o4IFKNnC3pi83HNeSF9d9PJczDcDI5dbPc2TFuJBXUPupI8B4KEHG8vW
	aWbVsK9850VQ1NhuWVGFsWai907TN7nj6bu52dnKJzFpU22jO/F3LchcJ+SDQ06P
	abVMscG9c7XRdH1pjwpbraRoD2we1kyulX4JfCDLeGENxiR2gCz9ZA0memZmID4t
	4jmKcniQCs8lFa9LUjz3Jj7S7w9LB45H2fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1684356486; x=1684442886; bh=pFDxtEWtnh290gDvTyGldDFfJHa7QfMoAy8
	KN2pcuoM=; b=sq6wlRfDxWkqzVIcrW40qVuiFKM50HlA6QZ1rrzTwgbKYgMApRS
	MPk5ifV8ZsWj4ZbWgb42N7u5Rs74aCuUC+vhkx6y8iIyVlcK1ov+/Z9HVC5OQI3T
	3XZcOIyQ3gQ0uBMxNxphTkoy9qfG5Sl2hEDGY4qXm+y/gAQdm0OVPQzYd+nyPF95
	9pUQwlQ0j79C5fRBG9vv6caAWIIHr7ZhiEogFQbK4VNWuFu0V2GbSeaBZn4ypQRc
	fdcDQ2oI8/IAvFyLWkY3NvgELki1CHQhah1LScmzzrxMcZ7US7jujiSBeaTCiddF
	akSQvqOQTFl/8Fn/MtWJCd63VY10UX/2R4A==
X-ME-Sender: <xms:hj1lZPjBgI-4JfDPkUPDIb82KeFJkqkp8NYseoIMBqvZNoCTHnuH1A>
    <xme:hj1lZMCCrfCNvI2gEfYaTWcmnsUB7w8IsC3uRAYF2FX7l6-VAMeVsm-mxdJCJGVwv
    xGgxkUVVIrw5n5AqA>
X-ME-Received: <xmr:hj1lZPGDuV0iXK31YEyD66fF8SGKf3GriE1S7DuMmMvn0IPbK2HVIPCOlx2J5ZQkfFDPfubHSpUu0E_gXDdIwzrucUIXou8FHvuFxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeiuddgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttdefjeenucfhrhhomheptehl
    ihgtvgcutfihhhhluceorghlihgtvgesrhihhhhlrdhioheqnecuggftrfgrthhtvghrnh
    epheduuddvteekvdektdduledugfffhfdugeejgeeuvdevtdetveejheehiefffeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihgtvg
    esrhihhhhlrdhioh
X-ME-Proxy: <xmx:hj1lZMQfl3mHoVAqzDwqZ9S4Ch7zmIcXQ8rWOg0Q3ROhZAZD6dAh1Q>
    <xmx:hj1lZMxi1ghKAAOc0-ByjnwkkOP3_DFv9KXjyNRPUzfNRItNAfROcA>
    <xmx:hj1lZC71Ad3G8jm0ClJ7RuJw0EK4m4NQFwxxvo_VbBgQlPBPbp3nSw>
    <xmx:hj1lZLlKBaDy1FpoZeRwVBGqcDzfoAPnX4rD2I12DtxkhUtuRlFi0A>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 May 2023 16:48:04 -0400 (EDT)
Message-ID: <706ec8e9-6c85-a2d3-1d7b-729d6de4893d@ryhl.io>
Date: Wed, 17 May 2023 22:48:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 4/4] rust: init: update macro expansion example in docs
Content-Language: en-US
To: Benno Lossin <benno.lossin@proton.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
References: <20230424081112.99890-1-benno.lossin@proton.me>
 <20230424081112.99890-4-benno.lossin@proton.me>
From: Alice Ryhl <alice@ryhl.io>
In-Reply-To: <20230424081112.99890-4-benno.lossin@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/23 10:11, Benno Lossin wrote:
> Also improve the explaining comments.
> 
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
