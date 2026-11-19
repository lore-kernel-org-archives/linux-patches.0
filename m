Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072349;
	b=Q8PamheILBNTgud6roSknkf6xD0dzj52NyE6t/1YBDsWfjO1MWjmOc7ZQxBTv4aHLVCM
	 vlfIoy1lVtXNsWtfotoq9uiff2ayadVgxMHj+cBr67jOdNLGbuwcr1YJC14FYU2kAx6ar
	 vuqhoAEV9oVi+Kf7wwmXhyNjStPr5KHUtSwSQZwSN1zCHOcTZlXOf0PhPsZeaHMAUy5Ov
	 7SmpVLygxPArCMh83VoZpQE79+8Xfz9t6UOFx3K8AKzfxh3p75ii8DQSoSfiRRFBlOc5t
	 i8kQVzF9/CDLCVJpQWiw9r5STgg+mQXRLeQeiLua5WEivj4DfP0zNKzFXQr5eZN2zJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072349;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=HRTOMsxmxzZbjnQgnTFcfl9MhnENbv2l7b0g6/Bf7Jo=;
	b=zE/W5ksJ1vr4uVWi/wIqP0G99m3lo9dMwHy+ROrWtm/2s5c9Sw0ZvO/+dAeGO1rcmS5l
	 u5FoPYnkRaz08mYPKtPxm2QZdPxZZ+SXoXUoWjcAZ9+o6pu0DY6sc18G5bEpBhTul06wS
	 edjMsPGU1aeSQRcF2yRmGhER5+7dibILVwGFRuPO5/ab6TkT8mvvX++9LpIwZUYZtSihO
	 hsO2a6gdj8vyh4XOtm21jeeH2U5c+VFfpxHE4aERV7Kn0cihshzSJ2I6Tu1ryADhqAgJe
	 hRruBTnU5fI6VqvobN+hBeDPUpso5ZlKRC9X+OcSXgNKu3Gc8OudtPCukYs1L3uCpEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UVO18r/W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EC2606A324;
	Thu, 19 Nov 2026 07:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVO18r/W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB561F000C4;
	Thu, 19 Nov 2026 07:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795072348;
	bh=HRTOMsxmxzZbjnQgnTFcfl9MhnENbv2l7b0g6/Bf7Jo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UVO18r/W1B3P6ipKbXGpCk228hsftOzuCH3dU/hs9YhHSM+Nqxmiz7U4cXpv0udmy
	 td7PKqcl0zHXTwYfYlAahHcAV1tjl4KmAdBHQR1WqkIWIb8s8yB6JqIJWBPlT9yQS2
	 15pgcLqQq3PyeHIZPdT6/CQFI9+j0D2i5N+6GU7iIftZP9f9AnsxAKsCo9jIUP5fGN
	 qp5sYn+KvifobV4ASLESVBgMmpQt59u1i4qoveHQyA2FTc1g7ScEnwk0R8ClJAyKAn
	 KVIuYRJilBv87rHBuid5H6xsv/d2KFrNe2OX2iC1h0S2Ei7p/0Zt2Q1i5Tqby42Ik7
	 XhNVxpD8/LAyQ==
Message-ID: <c73ab715-394b-4edc-a52b-2035f00b9a63@kernel.org>
Date: Thu, 19 Nov 2026 08:12:25 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0578/2651] rust: pin-init: internal: init: support
 tuple structs in `[pin_]init!`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Mohamad Alsadhan <mo@sdhn.cc>,
 Gary Guo <gary@garyguo.net>, Sasha Levin <sashal@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150308.536638917@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261118150308.536638917@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18. 11. 26, 15:30, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mohamad Alsadhan <mo@sdhn.cc>
> 
> [ Upstream commit d48aa955cb91745ef2e5089f9277a7a95060cce3 ]
> 
> Extend the initializer syntax so that a field can be named by an index,
> addressing tuple struct fields the same way a struct expression does:
> 
>      pin_init!(Foo { 0: value, 1 <- initializer })
> 
> Tuple fields are not exposed by a `let` binding to the fields after them,
> since they have no name to bind; `_0` would shadow a user variable.
> 
> Signed-off-by: Mohamad Alsadhan <mo@sdhn.cc>
> [ Fixed incorrect index calculation and cleaned up the code - Gary ]
> Link: https://patch.msgid.link/20260904-tuple-struct-v1-3-72c50bd037fd@garyguo.net
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Stable-dep-of: e30decc3f9a0 ("rust: pin-init: internal: init: emit `slot` using mixed site hygiene")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   rust/pin-init/internal/src/init.rs | 115 +++++++++++++++++------------
>   rust/pin-init/src/lib.rs           |  32 +++++++-
>   2 files changed, 95 insertions(+), 52 deletions(-)
> 
> diff --git a/rust/pin-init/internal/src/init.rs b/rust/pin-init/internal/src/init.rs
> index fd0b5ea4a0a30..5920bb281a500 100644
> --- a/rust/pin-init/internal/src/init.rs
> +++ b/rust/pin-init/internal/src/init.rs
> @@ -8,10 +8,13 @@
>       parse_quote,
>       punctuated::Punctuated,
>       spanned::Spanned,
> -    token, Attribute, Block, Expr, ExprCall, ExprPath, Ident, Path, Token, Type,
> +    token, Attribute, Block, Expr, ExprCall, ExprPath, Ident, LitInt, Member, Path, Token, Type,
>   };
>   
> -use crate::diagnostics::{DiagCtxt, ErrorGuaranteed};
> +use crate::{
> +    diagnostics::{DiagCtxt, ErrorGuaranteed},
> +    util::*,
> +};

Now I see:
[   70s] error[E0432]: unresolved import `crate::util`
[   70s]   --> ../rust/pin-init/internal/src/init.rs:17:5
[   70s]    |
[   70s] 17 |     util::*,
[   70s]    |     ^^^^ could not find `util` in the crate root
[   70s]

-- 
js
suse labs

