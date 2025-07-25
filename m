Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A41D5AD4;
	Fri, 25 Jul 2025 22:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481192; cv=none; b=uA+IBeSQJkuA0/vNQWhYABazePNXJb/lNvc1hsp99/RQOCVgFfe1fYTAfvHzgC/qCww+ZQDijHaKZXkE0yXXRqqXj+7wDSfvYwr3mu9L0p5dWflTXFzmKQcZ/QTnZa5RO1KKrxdU6MMgocHfQWPmsccTpsmUqhjid4sb+hXPGzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481192; c=relaxed/simple;
	bh=clZUi51w5Y3WNCYThAxjDWm+xSvKEptvaJBuWipIds0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=O2z/vXMvJyXAQHfGlrTcaaXnxwY9Z9Xn6uPiMcqfddQKFlCN5KKeI8EP6GxMa9ns4/BSl3MMpXewUpfyamJWxy4brcGznAYkwG7qzTa4CQgO76ycz9aEUEhiNr97uFgyIrU8tmuwzY3iJ7PQDugJUZHl05uuuAhTIzLfSD0EfMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGXEiP9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGXEiP9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085C2C4CEE7;
	Fri, 25 Jul 2025 22:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753481192;
	bh=clZUi51w5Y3WNCYThAxjDWm+xSvKEptvaJBuWipIds0=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=SGXEiP9fOT/FB5zrTci4DNRUON1Bqsh0E3Arkbj13OopfmDbA679IsLTsSIhVUE6V
	 8IBXdLc4lvEiwThZSZuw0Mv2UohsonlKRR05lhHKzYEU8rQ0Esukw5514T/YOGLOkT
	 0C9XgV5biF3KErpB8AIuVhO7AGRt+itYS4v/1yiW8PQK3JMGfp5yB6mHHdbmcEriIl
	 vlFRSGETZM+xOIryj8yidTIosODGoKovS1lHMruOAXhxm8CKTqrMh/gtE+zY+FXDwm
	 XsJsQ2iEM4No6//69TN8UCoR9NQ0yQVE02GQ0E4LOO9S23lyS0Ql1sHYSBqjEC9U4/
	 oT+RvT45Ft/tg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Jul 2025 00:06:27 +0200
Message-Id: <DBLH7D150TY4.2PIYWAVS3JYA8@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add "DEVICE I/O & IRQ [RUST]" entry
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng"
 <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>, "Daniel Almeida" <daniel.almeida@collabora.com>
To: "Miguel Ojeda" <ojeda@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250725202840.2251768-1-ojeda@kernel.org>
In-Reply-To: <20250725202840.2251768-1-ojeda@kernel.org>

On Fri Jul 25, 2025 at 10:28 PM CEST, Miguel Ojeda wrote:
> This entry will handle device I/O patches and abstractions (such as
> memory-mapped IO and system resources series [1]), as well as IRQ ones
> (such as the `request_irq` series [2]).
>
> Patches will flow through driver-core, at least for the time being.
>
> Danilo, Alice and Daniel will maintain it.
>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Daniel Almeida <daniel.almeida@collabora.com>
> Link: https://lore.kernel.org/rust-for-linux/20250717-topics-tyr-platform=
_iomem-v15-0-beca780b77e3@collabora.com/ [1]
> Link: https://lore.kernel.org/rust-for-linux/20250715-topics-tyr-request_=
irq2-v7-0-d469c0f37c07@collabora.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks -- gonna pick it up together with the IRQ abstractions after -rc1 an=
d
once ready.

- Danilo
