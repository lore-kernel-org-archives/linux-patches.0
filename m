Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB5C347DD;
	Fri,  1 Aug 2025 19:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754075367; cv=none; b=YwLHsR4YI5qD5d30zx9gDp4xHGFNkRWHYDCxHOrHY6UVP002dUQ+BSwgA5zBYJsS8r/jlWeMzmTeykbTpcb7RYdU5LgeYl/xYUxjJAj3dfm/nL3YCUaSBokV9opLAX9nxkqIveLDUF6ih1J/gRoeXFphqnfkQH1majeWQeZUUFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754075367; c=relaxed/simple;
	bh=kO9wrnucrOAW44UKJumefrBMsdJJKbh3QjKVipeFrYc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=NpzHLhd6N9PgiqkaIHJbIIMt7eHwpu8Rrvq4nTF8bOBgRFk/jynYdGHP0wZWl0RlCzRasMfZYeAmbwypftxfG2THfqjAnztDZmxl5+7paXJI0+gHDP0ZBnH8cbpQOKE5pPKVm0oIorGmMO3jtRpuDIVL+Kiz54yenVG4Z82Hcbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzUL/xBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzUL/xBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782CAC4CEE7;
	Fri,  1 Aug 2025 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754075366;
	bh=kO9wrnucrOAW44UKJumefrBMsdJJKbh3QjKVipeFrYc=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=kzUL/xBBvzl9N2h4bMfuiw7qvFdTG6dMbf3sn2aCa26GA6oKfrqSrjeElHLM7PviX
	 9pJIA5zMO+/MFKH2ajDenZpBwQgfQ5iQ7Uo4sHry7nLZMsyDYl30C1EYubzeice+sL
	 yVsGLyEP9WolnqkXOdOu5ZNS8CHdEMeorDhC0y3T3psk89PBye1pPQQlJ6N3Ryc2t4
	 qt2JBbMwCHcwLdHfiCGkdbSrWhD13GIbm0aqmDrz8bbAyqpDgW5EekjIPUQ6th6aaB
	 oOtd+1zKMj8/puH/BW9oeOEsrqWRlbpoCKRLfS2Kp0xExzPALqwPGKY+lBZoMkgDnX
	 W+UXyoJ6FBq2g==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 01 Aug 2025 21:09:22 +0200
Message-Id: <DBRBTLBPR9AT.3TB5N5Z79DQ6W@kernel.org>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 "Alexandre Courbot" <acourbot@nvidia.com>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH] rust: prelude: re-export
 `core::mem::{align,size}_of{,_val}`
From: "Benno Lossin" <lossin@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
X-Mailer: aerc 0.20.1
References: <20250801161752.443431-1-ojeda@kernel.org>
In-Reply-To: <20250801161752.443431-1-ojeda@kernel.org>

On Fri Aug 1, 2025 at 6:17 PM CEST, Miguel Ojeda wrote:
> Rust 1.80.0 added:
>
>     align_of
>     align_of_val
>     size_of
>     size_of_val
>
> from `core::mem` to the prelude [1].
>
> For similar reasons, and to minimize potential confusion when code may
> work in later versions but not in our current minimum, add it to our
> prelude too.
>
> Link: https://github.com/rust-lang/rust/pull/123168 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72kOLYR2A95o0ji2mDmEqOK=
h9e9_60zZKmgF=3DvZmsW6DRg@mail.gmail.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Benno Lossin <lossin@kernel.org>

---
Cheers,
Benno

> ---
>  rust/kernel/prelude.rs | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
