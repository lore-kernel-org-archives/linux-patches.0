Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E746FCD
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 15:07:17 +0000 (UTC)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id E856032006F2;
	Thu, 30 Mar 2023 11:07:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 30 Mar 2023 11:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1680188835; x=1680275235; bh=LBgpEuVRLV1T8u09/zjqM82d32cWiHoXkNx
	4ST+kG3A=; b=Mn2MQFtCMDufOJX/6+aQOJNyHseLzzRKdAl2dO3KvU3v+w7h9Fc
	YeMbp6Cc7bQPwqD7q8HOefnxg0+5xUhPtFnKMYr9VV6B1/G3XC0Mj3Pnz0cX6kTc
	uuniZZct/z2dQ+I1bV87rOUXNvnGbt+nTaoFaA3biIl+RVphQ4QU89OtoMk7Co9u
	qhl8lguld4RTt6DYWM10Xvny1FBFLA7behEISgiYVYTauHzzY3M6IgDDYvuQNulB
	gKyiomP4RUuIPOIRwvvJylhRBJIBcWnnuKiJ+B8oW/QGF6GDnPEndrnxLd8BXEny
	LnU2Lm9b6noFb8WUJDXXrMFIXRmBpBAkalQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1680188835; x=1680275235; bh=LBgpEuVRLV1T8u09/zjqM82d32cWiHoXkNx
	4ST+kG3A=; b=XrNXNbEqRcpRfGFnpxb5OG2gI1kYvM77ukQD9XGDt/0/lp4GlpF
	VM40nAoTCVRL8X7earO8EhwyWu+PZryL4F9vZQts1FNvIURzy491ijZt7h1nxTKC
	6X1igKRoCrwvruAcRspvoFDEQHIjrbQZdMoYGbIP+P5CXX1eJwXJisDr0FVO7AUi
	J+e+SIILArAEWLTOAMWw9UKwAJtVM4rlxcf2KubOc25x/HpMxPsJcXbfzDyb3bu2
	z9Me3HVFJQVqIHl+Vtn6sm9V06fa95UZqJCJgtIeBbqXcoWwH7wZD5Lo2HdmlrdN
	DKwDtpj+j6I1Fk5KHb0/ztRvUbTcJ+/KaRw==
X-ME-Sender: <xms:oqUlZA3HyT_ZP9c7LvJBKQ1DBgmtTwPP21y_j06WP_3BTFVbBY84zw>
    <xme:oqUlZLGKsX-x7Y3WImwclD2jYFXlYy1syCU9RGqrz5m2zJNh9PXeU51dW4h0GK_Bt
    AETGIpsItcjMMMQYQ>
X-ME-Received: <xmr:oqUlZI5rvzGY9Nh2d_QcPcIaC_3NwCZnL97qnK6ML07DPmW9RJPZEsDno5D0AR-imcti3Lc5C7MeCh17gc45HEq8kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehkedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeetlhhi
    tggvucfthihhlhcuoegrlhhitggvsehrhihhlhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudduvdetkedvkedtudeludfgfffhudegjeeguedvvedtteevjeehheeiffefgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhitggvse
    hrhihhlhdrihho
X-ME-Proxy: <xmx:o6UlZJ3L7bg3mKPH15UanuEBi4SgIJ19qVaUzA3psLyxp-TmmrsxlA>
    <xmx:o6UlZDGELnnJchL74s60kQ0pFZHLXeHAd6KlVAS5L23u8-qjtFq-8A>
    <xmx:o6UlZC_rpD8zsl4y8ZVEr63-BgMwK81_pec2VdNQVjijbO84d_e2HQ>
    <xmx:o6UlZJZTeFQJCKyMOHHQ7hXQBYzXXBCNEro5hLKKGQMfPGQGI-dkiw>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Mar 2023 11:07:13 -0400 (EDT)
Message-ID: <672f991f-96af-9389-278d-77bde2ee2db8@ryhl.io>
Date: Thu, 30 Mar 2023 17:07:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v3 08/13] rust: init: add `stack_pin_init!` macro
Content-Language: en-US
To: Gary Guo <gary@garyguo.net>, y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230329223239.138757-1-y86-dev@protonmail.com>
 <20230329223239.138757-9-y86-dev@protonmail.com>
 <20230330120600.45418253.gary@garyguo.net>
From: Alice Ryhl <alice@ryhl.io>
In-Reply-To: <20230330120600.45418253.gary@garyguo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/30/23 13:06, Gary Guo wrote:
>> +impl<T> StackInit<T> {
>> +    /// Creates a new [`StackInit<T>`] that is uninitialized. Use [`stack_pin_init`] instead of this
>> +    /// primitive.
>> +    ///
>> +    /// [`stack_pin_init`]: kernel::stack_pin_init
>> +    #[inline]
>> +    pub fn uninit() -> Self {
>> +        Self(MaybeUninit::uninit(), false)
>> +    }
>> +
>> +    /// Initializes the contents and returns the result.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// The caller ensures that `self` is on the stack and not accessible in any other way, if this
>> +    /// function returns `Ok`.
>> +    #[inline]
>> +    pub unsafe fn init<E>(&mut self, init: impl PinInit<T, E>) -> Result<Pin<&mut T>, E> {
> 
> Could this be made safe if the signature takes `self: Pin<&mut Self>`
> instead?
> 
> The std `pin!` macro is stable in
> 1.68 so we can just `core::pin::pin!(StackInit::uninit())` and then
> call `init` on it.
> 
> Best,
> Gary

Yeah, I think that would work. If it's marked safe, then it will be 
possible to call `init` several times, but this is fine if `init` 
transitions the `StackInit` back into its uninitialized state before 
attempting to initialize it again.
