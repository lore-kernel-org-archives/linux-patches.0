Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7A124BC07
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775696; cv=none; b=FTLFQ3XmCAYpgzLDrKSMJD8EcxOcCwcgXbAHd8QwHsfrFOjz+zN4wgJk3+q28H4eTVpdS8DhmooRl+GjC/M1at+TDsuD6RotNOGfI6TGE4Xn/l1zyZYC5qUh20s7Z6D9q4U1FebbrGoKaczxdVu2t4pSB2y9FFuX9U9kHMUprD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775696; c=relaxed/simple;
	bh=Wld7jp9tEQXuIh09SWUvMZLGcORmYH4LRprox5mayS4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Aj/KvZxrMC4r1qO7r3HmIIT0aClk37HP3dnFlPo04+ZrFwlW0TbX+Ohs2qcYefLrG3nOET3jSY67FQEhRs+6MeQazTvA20hw3Nz95UmUiSqODGW02jZVavQV5LIFPZ7l875tjJ/gnaiR6/8dSRPQKgWfRBq8WcpzkN//TcIW5Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BgSTBJIQ; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BgSTBJIQ"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64097bef0e2so4156497a12.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762775693; x=1763380493; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQQBm4PwQuyI6yZ9AdqTjALBwiLdrNslKJZVi9Mtf9A=;
        b=BgSTBJIQ6hJpX2TfQpABibD961p3yKu4AIq5MjqgzsiBfpqRhNlvVYWFrKEWlpT/FY
         iSejL5WlPpSQQGdCd84Say8m+64VtHw6sMcwOao+sLvf8+eIOsZA6LCWq8Yg0AX2sHuu
         9h67AneuyjHaFfUCBOW1/CfzQ665F7IU6vfGgfU/JefJ8YOw1Fgrw3ZWuH5ryCNfAw/D
         p1E5NZyNM2TNYaOz5YMrhJovJby2CUe/meymJZm39GQkXDklcZeW0FEJx+apEyWYjXwN
         +0JZPs+f1HbMFaX+79ENPNg4TmWL2cXD3/lmTSl3FTsHv0h8VSKcbHzMOm5ZzpgIEdQP
         eWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762775693; x=1763380493;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQQBm4PwQuyI6yZ9AdqTjALBwiLdrNslKJZVi9Mtf9A=;
        b=LtKNKXfU+w2D9A1Mcf0qvT09lFMbj1XxBLDbXIjLGpnDoMKfL40F8lFdOcyTfYPU6m
         P8ABJ4hMRD1TL7+9r3FMRhxZVKjgJYMyE8k1ff+5z8Gd2NlIqJshcHri6no04tn1FYnk
         uxCExqGCHvz7k3kyc+8Kb8LqN6G8Cs1WyIVUsaJf1j8tgZX6/bQzw84pfx0Wdcwohq/O
         vjkuhSzSJtxASoFEGfeiJ7aDwEy17cZSV2U2adnjcyhGSZh04FMd8umBs3CFeuz8AmEQ
         yn/9YMv2FYMHIY554RVzuEtNzf1gtbu9GuXGxEHM7RsPbE2xflumwdgYFj94DZddF+c2
         bOCw==
X-Forwarded-Encrypted: i=1; AJvYcCU4hAURG/oBuja66dyF4tEQP4x1uX0O1ldST9mTLqqLsdPc0exJbc/3FNptJQR44Pu1ABM2OzZW@lists.linux.dev
X-Gm-Message-State: AOJu0YwKQS3RBUCS/HkdutA/O9BoIT5b38uh1DHJ9+BhsuIK3tZz1h/p
	ela7QkD76BeGtg/34TvguvhO0WMga1RZbWAtOA5wmzVZiFnVUsxL+TwyqGFQsHg4GZHZd4MeJBh
	JutnQa+1KzBZRtxipOg==
X-Google-Smtp-Source: AGHT+IF3M40dNIzNZkxr/1+aJ+nfeEg2fTctw3V8OcAEVxMO8ut0+MdQ2WzFfOK9xMLQ2EWoslAnSoMKLCyCugk=
X-Received: from edaa20.prod.google.com ([2002:a05:6402:24d4:b0:640:949d:9bf8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:27d4:b0:640:fb00:9b0b with SMTP id 4fb4d7f45d1cf-6415e8565d6mr6321846a12.32.1762775693084;
 Mon, 10 Nov 2025 03:54:53 -0800 (PST)
Date: Mon, 10 Nov 2025 11:54:52 +0000
In-Reply-To: <20251110113528.1658238-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110113528.1658238-1-ojeda@kernel.org> <20251110113528.1658238-2-ojeda@kernel.org>
Message-ID: <aRHSjKsZVz3NfUrW@google.com>
Subject: Re: [PATCH 2/2] rust: device: make example buildable
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Rae Moar <raemoar63@gmail.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Nov 10, 2025 at 12:35:28PM +0100, Miguel Ojeda wrote:
> This example can easily be made buildable, thus do so.
> 
> It would have triggered an `unreachable_pub` warning without the previous
> commit.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

>  rust/kernel/device.rs | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
> index a849b7dde2fd..d00f4af507db 100644
> --- a/rust/kernel/device.rs
> +++ b/rust/kernel/device.rs
> @@ -67,7 +67,16 @@
>  ///
>  /// A bus specific device should be defined as follows.
>  ///
> -/// ```ignore
> +/// ```
> +/// # use core::marker::PhantomData;
> +/// # use kernel::{
> +/// #     device,
> +/// #     types::Opaque, //
> +/// # };
> +/// # mod bindings {
> +/// #     #[expect(non_camel_case_types)]
> +/// #     pub struct bus_device_type;
> +/// # }
>  /// #[repr(transparent)]
>  /// pub struct Device<Ctx: device::DeviceContext = device::Normal>(
>  ///     Opaque<bindings::bus_device_type>,
> -- 
> 2.51.2
> 
