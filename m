Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072453;
	b=YgaWBrYuNZny1Kki8zNw/pWeWPWGpbnZbbGVhsidChAHNaqL75n8Bmywln9AKo+dhdTC
	 zwAhiqn/2FducA0nDpqC0af5RZ4Rn/wPCQu8vDCcwgNmIoL4JsQ7bPk9ZOsnLTVxDkg4R
	 774x4vmiAl+paXijN7RfAnpF5rGUsdeN/wHa086SAvY8w/hVAIgdkG/KzZzqmEzjNkcyp
	 V+jZwZGHwN5ayTBRADxjSS994BBIR4+SqFTXt+Ly0pHjiHZ1dEMj+gdEtoM+4C+3aM5BL
	 POPUzDTd8+omuQIuXdnoxtojMBrsgl2+e0EdA8rtRq9hEKXVW46zqGaPGUKdraBoHJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072453;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Lzcn4w3oaayMxf41T+zF2kyH4deWT2GR/BDQtdvQXQg=;
	b=3vTv1tknz6boTVj4n+C6Kw8ch4sY9BZ3mlZRZz1Bg3DqwOQ7H7+5mP9JP4VLT4er2Bol
	 EzuJ51k/cIurKCCI1/eagjSnrocUS/dWqpFhnCbpiwsxUlJmTXtuTCDDq2+VL+5UdxSpq
	 6SgYSA0GlKlr3OIFfYCGFvTGs+ZZI0kEqI65l8YkI8R/69KcW424FCY/o+W0zK38VUwJq
	 7sh5LS9VrM5wSSJPt+er/Artax/GOfAzOnLAaFwaja/deHT/ffxKpCqEhaNTd5n7Cq1FB
	 5KCFMFzXC5tI8pDZU2oflePn9/zu1qQwRNAnu0adamec1zy1VAMI2CiATSkXI8UQorA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="I/ccIKFo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB1C606A320;
	Thu, 19 Nov 2026 07:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I/ccIKFo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DC71F000C4;
	Thu, 19 Nov 2026 07:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795072453;
	bh=Lzcn4w3oaayMxf41T+zF2kyH4deWT2GR/BDQtdvQXQg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I/ccIKFopbk3wDKBhC4o5elEyIeoZLWMjsLUf4tBaPxFc8TuOVGFqJCmupop45IWu
	 ldgXWNiK8LX0CR+jgXSdpGrLSAcS7KtC9UfNO9+Tk7X2g0c5jyrO+hJI8XXZNuwG57
	 f/7+5yLVJ48OW2WBgwBsE5aTx1+KP2gR/lWWaaLYtcIU1pNQyfqBaCGfVlo3mCc3BL
	 2Q4rQ/6YcqoeinjqB4HzRGbzAuDY4wj6iNShnJG1NgZhzLusKDSVszffHkQEysnjlZ
	 f6+0K6F2r5YXmsmOcNE1ofBVAckKo3/GCUP7L+O3Its+P4KNIzgsHrA3Qov1sHOaQR
	 01tBnoIjWKrww==
Message-ID: <1dc09b41-c35a-4af0-a074-0e2c06b5b449@kernel.org>
Date: Thu, 19 Nov 2026 08:14:10 +0100
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
Subject: Re: [PATCH 7.3 0579/2651] rust: pin-init: internal: init: support
 tuple struct constructor syntax
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Gary Guo <gary@garyguo.net>,
 Mohamad Alsadhan <mo@sdhn.cc>, Sasha Levin <sashal@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150308.574020217@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261118150308.574020217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18. 11. 26, 15:30, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mohamad Alsadhan <mo@sdhn.cc>
> 
> [ Upstream commit 3b3ff9034a497fb3b8429f6fe8ba5697bc7dcebd ]
...
> ---
>   rust/pin-init/internal/src/init.rs | 381 +++++++++++++++++++++++++++--
>   rust/pin-init/internal/src/lib.rs  |  11 +-
>   rust/pin-init/src/lib.rs           |  16 ++
>   3 files changed, 383 insertions(+), 25 deletions(-)
> 
> diff --git a/rust/pin-init/internal/src/init.rs b/rust/pin-init/internal/src/init.rs
> index 5920bb281a500..dc5dfb2ca1142 100644
> --- a/rust/pin-init/internal/src/init.rs
> +++ b/rust/pin-init/internal/src/init.rs
...
> @@ -71,16 +145,103 @@ struct DefaultErrorAttribute {
>       ty: Box<Type>,
>   }
>   
> -pub(crate) fn expand(
> +pub(crate) fn expand_with_cfg(
> +    initializer: Initializer,
> +    default_error: Option<&'static str>,
> +    pinned: bool,
> +    dcx: &mut DiagCtxt,
> +) -> Result<TokenStream, ErrorGuaranteed> {
> +    let initializer = match initializer.kind {
> +        InitExprKind::Tuple(expr) => {
> +            expr.validate(dcx)?;
> +
> +            let mut initializer = Initializer {
> +                attrs: initializer.attrs,
> +                this: initializer.this,
> +                kind: expr,
> +                error: initializer.error,
> +            };
> +
> +            // Removing a tuple field renumbers every field after it, which cannot be expressed with
> +            // a `cfg` attribute on the initializer of a single field. Therefore, resolve tuple
> +            // field cfgs before continuing. Struct expression syntax uses explicit numbers, so
> +            // there is no need to pre-expand them and we only need to emit their cfgs on generated
> +            // code.
> +            for (field_idx, field) in initializer.kind.fields.iter_mut().enumerate() {
> +                let cfg = field.attrs.extract_cfg_attrs();

This does not fly either:

[   70s] error[E0599]: no method named `extract_cfg_attrs` found for 
struct `Vec<Attribute>` in the current scope
[   70s]     --> ../rust/pin-init/internal/src/init.rs:171:39
[   70s]      |
[   70s]  171 |                 let cfg = field.attrs.extract_cfg_attrs();
[   70s]      |                                       ^^^^^^^^^^^^^^^^^
[   70s]      |

-- 
js
suse labs

