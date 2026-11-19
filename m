Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072536;
	b=J6uhTytPkJcLmFevMkTiILskInCKxjTnZVTShfslpq62WMLDABlxhDJrYcP4Fn5GcJRQ
	 utX1r1CuELrTpV/01deFgv4zAj9rVJnucwxYsGnYYawxMHcV7Fe7sZUCJPbrigKLsN4K7
	 qQH+KXUaGo3MwFG42OtOi2ebjqyKYjxFIJ5CzvFRl4Q/Et6DDoJCpZ2TWADwAqMNQWKCR
	 q0WqwKc1FZEjlv7ibZUHunziVpQJLoP7+VqvtYW46R0ecL21Da0MnaVuS7T4UwMduEanZ
	 pc2aRslG2WFIxDwRUaXekSBqvcjhVjH4Y35AIfxJknS4/Hb1oYpQ3fikqzqDIlnd7MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072536;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:Cc:References:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=cbNpNqeEcejcdW8J47plwOXcUw/0+BzSVTXKYCKTZlM=;
	b=zfRAmKX7F8Y5xKUh8x7hxkhkpeleypoPoh9ocTeUlzn797VHIIKXwKzixOeiu+M8lgPR
	 5bG2TyTfm75eZEBomUpS8tWuvR75pXCO+7DQaeUE7cZCViHi8G/zWBZz4cWLPhQFvh/ZE
	 s+zVHgdJw1nnZGc3ofJC5DVayj+VkiunAo5EnrKk9bNtbAHsCEw0tnaNfiEsjvx2G7Kbi
	 oKCKHtH2bSA88WRmirABdf3HGxmbLEnBlgNNyWn/9+CRbFaQzW3ysRsZ6EiUtqlCVtWbI
	 1YM/Q/ltwO+cV+IimlvusDXeLBKIKel800MXzq0ClG+cJ4RJO4xUK9Vydf5To4lRzPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jk6/SbJl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE88606A320;
	Thu, 19 Nov 2026 07:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jk6/SbJl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038211F000C4;
	Thu, 19 Nov 2026 07:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795072536;
	bh=cbNpNqeEcejcdW8J47plwOXcUw/0+BzSVTXKYCKTZlM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=jk6/SbJl9KebGbyDvCcOomeedUD7BR8Ue6SpYnA+Bn0u2TfUc3qNTwXkVMxO9v6P1
	 A4babRNCdRF280mUCaKxBZ8KobjQzY7RqgGS7iFGfSp2+H0xGlLGNWbozwKv5CIXn8
	 ++tGzIfk7DLw88VI2Id87EQcoAEZVvmlUMZel5FwDbf2IelOXRHXfIIfgdjwhbC759
	 cccEgj1mf0QzZ0kWdvfZP2O1Mdw86hgDWt6r0vxW/qBDv5YVHTZ2jHWwdp2PPOkwcz
	 3oNg5WfuJsJ7xV1xDIIfa3UHHIqcZ7JKIa1BAXjOn2w33qKXlU8QNyq+QK7Yg4xWH7
	 NRsjbU7zDgkJw==
Message-ID: <e641cbaa-9632-4209-beb4-6e2b25af6736@kernel.org>
Date: Thu, 19 Nov 2026 08:15:33 +0100
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
From: Jiri Slaby <jirislaby@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Mohamad Alsadhan <mo@sdhn.cc>,
 Gary Guo <gary@garyguo.net>, Sasha Levin <sashal@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150308.536638917@linuxfoundation.org>
 <c73ab715-394b-4edc-a52b-2035f00b9a63@kernel.org>
Content-Language: en-US
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <c73ab715-394b-4edc-a52b-2035f00b9a63@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19. 11. 26, 8:12, Jiri Slaby wrote:
> On 18. 11. 26, 15:30, Greg Kroah-Hartman wrote:
>> 7.3-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Mohamad Alsadhan <mo@sdhn.cc>
>>
>> [ Upstream commit d48aa955cb91745ef2e5089f9277a7a95060cce3 ]
>>
>> Extend the initializer syntax so that a field can be named by an index,
>> addressing tuple struct fields the same way a struct expression does:
>>
>>      pin_init!(Foo { 0: value, 1 <- initializer })
>>
>> Tuple fields are not exposed by a `let` binding to the fields after them,
>> since they have no name to bind; `_0` would shadow a user variable.
>>
>> Signed-off-by: Mohamad Alsadhan <mo@sdhn.cc>
>> [ Fixed incorrect index calculation and cleaned up the code - Gary ]
>> Link: https://patch.msgid.link/20260904-tuple-struct- 
>> v1-3-72c50bd037fd@garyguo.net
>> Signed-off-by: Gary Guo <gary@garyguo.net>
>> Stable-dep-of: e30decc3f9a0 ("rust: pin-init: internal: init: emit 
>> `slot` using mixed site hygiene")
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   rust/pin-init/internal/src/init.rs | 115 +++++++++++++++++------------
>>   rust/pin-init/src/lib.rs           |  32 +++++++-
>>   2 files changed, 95 insertions(+), 52 deletions(-)
>>
>> diff --git a/rust/pin-init/internal/src/init.rs b/rust/pin-init/ 
>> internal/src/init.rs
>> index fd0b5ea4a0a30..5920bb281a500 100644
>> --- a/rust/pin-init/internal/src/init.rs
>> +++ b/rust/pin-init/internal/src/init.rs
>> @@ -8,10 +8,13 @@
>>       parse_quote,
>>       punctuated::Punctuated,
>>       spanned::Spanned,
>> -    token, Attribute, Block, Expr, ExprCall, ExprPath, Ident, Path, 
>> Token, Type,
>> +    token, Attribute, Block, Expr, ExprCall, ExprPath, Ident, LitInt, 
>> Member, Path, Token, Type,
>>   };
>> -use crate::diagnostics::{DiagCtxt, ErrorGuaranteed};
>> +use crate::{
>> +    diagnostics::{DiagCtxt, ErrorGuaranteed},
>> +    util::*,
>> +};
> 
> Now I see:
> [   70s] error[E0432]: unresolved import `crate::util`
> [   70s]   --> ../rust/pin-init/internal/src/init.rs:17:5
> [   70s]    |
> [   70s] 17 |     util::*,
> [   70s]    |     ^^^^ could not find `util` in the crate root
> [   70s]
> 

And for this one I also see:
[   70s] error[E0599]: no method named `as_ident` found for reference 
`&Member` in the current scope
[   70s]    --> ../rust/pin-init/internal/src/init.rs:413:28
[   70s]     |
[   70s] 413 |         let ident = member.as_ident();
[   70s]     |                            ^^^^^^^^ method not found in 
`&Member`


Either you do not pick up rust patches, or you compile-test rust ;).

-- 
js
suse labs

