Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CE1101ED
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:40:43 +0000 (UTC)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 8BF705C01B9;
	Wed, 17 May 2023 16:40:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 17 May 2023 16:40:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm1; t=
	1684356042; x=1684442442; bh=ghk7mGsvuQGuVrjeRiTDYinTiiFkqaw9VUe
	QsZ2qew8=; b=rkqF1pWbMBTeBx4H44JeGXZ4V4sev7qMDienTltUrQ/wbVIpMx5
	lpyR8VEPGxcs6yizyn1BE5lXEjUIFjImSzP41ATpqCwz38owd5hZ/87LCXz9FgLG
	/qEUnd5eMa9FUmtoDONmqgYJgEuUxyrp8xMYLeNNivKA2lptKAAKEtxaHFqnLNXS
	qoSjN8CYLZ5crbZDulVL/ZHqCeeSc9Q0bIXeXzuBiYWt/R1wnGWvXAry669vdeRB
	UPrf6VSTKKKDKegDWx0uDzipS3E7/h3hZNQ+EznVljoGyXTuvuXZLRkZ9ZkJQX6S
	YxNdUzZskIKM29C7JfYUx1Gd9e/MIfax/VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1684356042; x=1684442442; bh=ghk7mGsvuQGuVrjeRiTDYinTiiFkqaw9VUe
	QsZ2qew8=; b=tv1dhMRYaY4wvGP3WdQW34d9yLhX6PzGXpvJaD3qjha0RL3Ew6R
	fBmuYbesXTH1LCRh3JJim/saMJzYGWStsZeQTzIzMIsw5J+zCmtUlzfITOHYnFav
	ucOb6mxNbGQuPcWXxPhzXNiLN4kPM1KOafRFWGjrpN034/ZgWegGG4HEGFnsvAFd
	swP3qrviYiNgVUHegCMV/4xZ5WKNHDYC00RTxKpAIdanIpsKRvly1VhNtH5bT4eI
	s6MYaczfXmw5Z8hJbAcV/p8+Ggg6SwFyBMO2aVNo5sDNH+xUCfxqz6pQjhKlDgef
	CdoP/vLgsTG+f927I9sXXixWUoewOR8AhIw==
X-ME-Sender: <xms:yTtlZBgoJackQwN4zJeCH7oYaek36RvPdKOTrXcW-iSaswORYqbwow>
    <xme:yTtlZGC-7Zr4wg0WC7-vXHvxDs3nkR_2wpx1UX2leC_3uiIHa5yC2XSNmctwIA-dk
    ZJQUBMQCPnKHrfWrQ>
X-ME-Received: <xmr:yTtlZBGnJEhz4cv9V2bY1NHW9kuRDWc8ZEnJN2tHdIsXQu96imyRcYQ5Vmgvz2-Up9u76Kzf5C5LwhJ5isImvaF8Onw36cF7qMYnIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeiuddgudehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttdefjeenucfhrhhomheptehl
    ihgtvgcutfihhhhluceorghlihgtvgesrhihhhhlrdhioheqnecuggftrfgrthhtvghrnh
    epheduuddvteekvdektdduledugfffhfdugeejgeeuvdevtdetveejheehiefffeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihgtvg
    esrhihhhhlrdhioh
X-ME-Proxy: <xmx:yTtlZGTUQ6zxCsEaeFPoHk5uoejU72xydi14pkEbau10L6HilMpDyg>
    <xmx:yTtlZOwKJwq_UA8OXQk1ROIp3fGDpjkhU6v8r9gfieYzO_eCRkOwEQ>
    <xmx:yTtlZM5K5qDhv4qMQh24ufgG4Js_oiHL6P6cdsqFrkn0bR7w5HJKXg>
    <xmx:yjtlZNl1_-V269yvRtAcu738AyLDPo87TKEIYL1Y6iHhln5kSc-kyA>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 May 2023 16:40:40 -0400 (EDT)
Message-ID: <83744422-a332-5b3e-8269-73b2f2ce281e@ryhl.io>
Date: Wed, 17 May 2023 22:41:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 1/4] rust: macros: fix usage of `#[allow]` in `quote!`
Content-Language: en-US
To: Benno Lossin <benno.lossin@proton.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
References: <20230424081112.99890-1-benno.lossin@proton.me>
From: Alice Ryhl <alice@ryhl.io>
In-Reply-To: <20230424081112.99890-1-benno.lossin@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/23 10:11, Benno Lossin wrote:
> When using `quote!` as part of an expression that was not the last one
> in a function, the `#[allow(clippy::vec_init_then_push)]` attribute
> would be present on an expression, which is not allowed.
> This patch refactors that part of the macro to use a statement instead.
> 
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
