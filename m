Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A0F272E42;
	Mon,  1 Sep 2025 09:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756717833; cv=none; b=TC++CSeuDNp0nO37FRu7ZeHZnWWw1xvSMeRSu5XJ3Uu0ihB1dhSzswAh9UiZcbA4caxZBwnCnnwyPxJYOw6DzrCV6i2bfIM/1ikP9IXaqI2q7XqJBL12DUwJL4AyfRQ9mwANogxnhcam+KW9BRtbHD4ytIiu0SPqOQnOKldre9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756717833; c=relaxed/simple;
	bh=Hm6qhYO94fUqr0xGwnSI6ZGO9M3F832Ae2VRPrd+/6U=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=ETVlr5nsXlMCxdGSBopvxoA93cxa2aQsauc6zLWoStsYQ7vkJCWEmROZQZxU8VKvc3GgunyTbosuMKz08VlvNTB78HtAiJ6kVIRRWbACmU9rDhbasdsn3PRNDNCJ+5nXP14xvvBN4Gl/n48lbCYCvELtTcyU4GpHKVN8g3Z6sQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0oPbAPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0oPbAPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F268C4CEF0;
	Mon,  1 Sep 2025 09:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756717833;
	bh=Hm6qhYO94fUqr0xGwnSI6ZGO9M3F832Ae2VRPrd+/6U=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=E0oPbAPjoF6EvxDBRoSjS+tGK1/9TLoj752NL6MxidQF6Z3FEADfBGo9NJ2NTB9HS
	 OnhavDkGbuQJsnJJe681Q7FL0dT83d47Svcnbt3JNCjb2iVjAYczr8Pe9mq6jhjeSM
	 VBfiJtBplLWcK0gMA7eGAVGxqOSWxwJ1EztTm2Pe1wPV4BbN8kku86ZSslPQbwkMgs
	 jz+tk46HMV28eAEyYDmDcMjitRYN/jFnEtzo8BV+AMPXwtZHvWkH0NJq0hSqkNjmAM
	 OXBlwJMHocuarKKiPLcBrv7gXvkEuYt6/Qo24kWpHAkwTfcwjcmmv4P3d0hy8l2rJ1
	 YyYnMnzQn2fng==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 01 Sep 2025 11:10:28 +0200
Message-Id: <DCHCHXJ7SH0C.3EV79WNHDESY4@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 2/3] rust: error: improve `to_result` documentation
From: "Benno Lossin" <lossin@kernel.org>
X-Mailer: aerc 0.20.1
References: <20250829192243.678079-1-ojeda@kernel.org>
 <20250829192243.678079-3-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-3-ojeda@kernel.org>

On Fri Aug 29, 2025 at 9:22 PM CEST, Miguel Ojeda wrote:
> Core functions like `to_result` should have good documentation.
>
> Thus improve it, including adding an example of how to perform early
> returns with it.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Benno Lossin <lossin@kernel.org>

---
Cheers,
Benno

> ---
>  rust/kernel/error.rs | 39 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
