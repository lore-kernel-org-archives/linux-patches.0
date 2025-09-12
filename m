Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB2B2D3EDA
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 08:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757664459; cv=none; b=YbF8PJRxHGaRU5R2H9eBy6GODKY1gzeHRmgdOcxQifHtRUYLE+b1xeKfffcbKczdu851c7tzmL/T7srach9BknTtTKQYxqrVwVaftXsW54gukwrG29+tgXxL6hjElEr/eEkTzXceWgDx9ulQrZ+kSFs6Rt4s30CCn9Ddea+McPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757664459; c=relaxed/simple;
	bh=gXY6rpD6dmiNO8w8Ji0dVoTPlEqZB76ZsSgmdEXvDW0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DoQ3pkJ7OtrldhOn9hQaqL37hzSZCjVxxwllkntWIy3qk+BsLhEhJm0FfuA4IKW16Jr0Jy+X0AjHjfCxe4HuBP1qk9RgMNefMlEWnUx/urApJBrVSGOL8NQGRzjacKCbmHDZJT/j3qH1W3b1grLguj2tggx3vCwfFR29epv8/iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rJonUKXd; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rJonUKXd"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3e04ea95c6cso744231f8f.1
        for <patches@lists.linux.dev>; Fri, 12 Sep 2025 01:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757664456; x=1758269256; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+tgtoriTVA3wUl1fLwqvusUWB5z4BoYTpvvOhTysEkY=;
        b=rJonUKXdLf117R9yqG+5zI3KAVf5ymNBOjyFv62kuNVpkwl6dKWxq28QW0bqfUe2XA
         y95OKb8Qgw8BRogEprzPVSd5W/cEWhUVHqUiLuojrJRERImoNPwqFc7FQySaUY7iIwpM
         tYxFdm3Trx61TUrDEOnRW3V/AYnd+aBBs0tOkF5XgMjnIFPjGE3xZs02W2pMWmQz+cYc
         5hC3z2FbqxuB3yu0/RnodZ+ZRN0TND2w+WExoO/v1J6lXgp9aMO66QbjmKodqSTcaPSN
         foGSeSL1lz4F+Ll6UwymJa9JJ5/z1YPFn4MhhGKyadtJdiiGgxfAmFMiXN3LUckmhZP7
         jp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757664456; x=1758269256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tgtoriTVA3wUl1fLwqvusUWB5z4BoYTpvvOhTysEkY=;
        b=bK2qhJ8ZR2Hywl5jrueZ94l20SZtBNIdSpq5Bdt+4gOT/3PGTawT+JsQORGTPzo5Pv
         Raoul9ObGBoSzQNyTtc+OetvemXF+mcJET/doDrUzpvJ/vLOFnFHfVT21XczYlO0MiMa
         pIxQB3VVUsZWrkmb4/tJ+4MS25FTbFWXArr/Bd8BCA7F8bTjU2DVdhy6AtvoePcZtVMI
         c9ONsGZVV7jZcTY/1GcgQa1Y2SEBFFy4tjFaIAL6uSliz8OrYI1xKHo7q7g9hIpmaQvY
         Edo0C5GZin9UnHVTU2uqWOThKnB5lyAznSmkeRHJC9Fy29RtwUiI5IkO6BKifPVJjMRO
         mARg==
X-Forwarded-Encrypted: i=1; AJvYcCWC4kMpbMjvcVZV33yCulsd3lG8PHiuDojaFjPJYmY7dFQ6OYw7cLoNASTUawwpgvZIKZrNzRCQ@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3t4IyRSHALvbrFw3GvMOl+zzE9CQLFIgDDW1ejZUvRmm8GBFz
	/sXJFvr0KpGOza1TcRtTfIxsGzbfyIPtqSl6mGEsTYRqK2WePLM8gNNNXqnA1SV7JqvTfXzf9Ar
	HUBgixWb6NsYcpEeKXg==
X-Google-Smtp-Source: AGHT+IFkxsfqAcrnekL3Ice7pB/PeSHdeKiiZaFaWBiHr3Z/hX7oTQ21wuR0+bX+ocJ/wu6+RCMQdyFuzPpJpAo=
X-Received: from wmbdp7.prod.google.com ([2002:a05:600c:6487:b0:45b:9acb:6940])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2f87:b0:3e4:8163:b6f9 with SMTP id ffacd0b85a97d-3e765796c6bmr1878906f8f.14.1757664454769;
 Fri, 12 Sep 2025 01:07:34 -0700 (PDT)
Date: Fri, 12 Sep 2025 08:07:33 +0000
In-Reply-To: <20250910140212.997771-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250910140212.997771-1-ojeda@kernel.org>
Message-ID: <aMPUxZoV9BCqDg0y@google.com>
Subject: Re: [PATCH] rust: maple_tree: fix intra-doc link
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Wed, Sep 10, 2025 at 04:02:12PM +0200, Miguel Ojeda wrote:
> A couple `Occupied` intra-doc links are broken:
> 
>     error: unresolved link to `Occupied`
>       --> rust/kernel/maple_tree.rs:96:46
>        |
>     96 |     /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
>        |                                              ^^^^^^^^ no item named `Occupied` in scope
>        |
>        = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`
>        = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
>        = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`
> 
>     error: unresolved link to `Occupied`
>        --> rust/kernel/maple_tree.rs:135:36
>         |
>     135 |     /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
>         |                                    ^^^^^^^^ no item named `Occupied` in scope
>         |
>         = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`
> 
> Thus fix them.
> 
> Fixes: 7f51d867d2ed ("rust: maple_tree: add MapleTree")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

