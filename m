Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B01265CBD;
	Mon, 28 Jul 2025 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753706187; cv=none; b=KXSgzSG7DStpxx9y+9fToHShXnvIaZ7Xk5CMB4hxLZPKRd8CBd8TINp1vay1UXaebFfoLQBvIxis7atHO7guDehEWiOCXC3kEKdQs7m7qUQ8Himatl9Dlr2ltDcVsqmpAk+/88e01ANKNdAn8MvB4VkdNfg5UBPhlt52YIAwmo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753706187; c=relaxed/simple;
	bh=3159+tHNgAolEaJbHdGWXdnB9P/fR74TAU3dpAn+25U=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=OtuDrW1Bu7yZTYK+Xs+bys5xfK/d3sAu5g8xqE4DWnwHZ2zsuiMZER2bxGEEsKbLsCOzloHV9YuRER2GYca33vNvKm2zAN73v/A711Y0sAjOF6o6zG4XkUMrQX28X98hmLCchsDsN30Cf0Sv9Qs3aN6wMmC5zu5sg0J8XFU2/jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vD0UvKNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vD0UvKNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A878AC4CEEF;
	Mon, 28 Jul 2025 12:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753706186;
	bh=3159+tHNgAolEaJbHdGWXdnB9P/fR74TAU3dpAn+25U=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=vD0UvKNtOxINkq0lF0QkC86v5uKDzitOuR59FLqVeGduT7v+RncwOvwyzzcBbeZw+
	 z0dd4wDM+U4sbdTS+/tiX1qHaOnCKsDZO6781IGEexNIUz2bWV0lbsoLIkf7bHptQZ
	 lYPdwos1bA5oy+fXdValKFwZrO8EgqdOABLlEgoHQEab/V+LqTeQkATefqHATCQgfW
	 wvHvst7ZcLw+wpcA92u7QMX5H1XXI4ksrWfJBoiOkhT87RswV3bKgfkXLToB6F9t+G
	 eETW/Dbqtd6wFlXv20gMT23TJ6x81eEEQZYv4e9aAe5wAtrXYjtgOa72SPNXKfVFy3
	 mzj5GuVBzCy9A==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Jul 2025 14:36:21 +0200
Message-Id: <DBNOYHZEXOL5.8ST83ZHBA65Q@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add "DEVICE I/O & IRQ [RUST]" entry
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng"
 <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>, "Daniel Almeida" <daniel.almeida@collabora.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Thomas Gleixner"
 <tglx@linutronix.de>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250725202840.2251768-1-ojeda@kernel.org>
In-Reply-To: <20250725202840.2251768-1-ojeda@kernel.org>

(Cc: Thomas)

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
> ---
>  MAINTAINERS | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)

@Thomas: Please let us know in case you have any (other) preferences and / =
or if
you'd like to be added to this entry.

Please also see [1].

[1] https://lore.kernel.org/rust-for-linux/DBCQKJIBVGGM.1R0QNKO3TE4N0@kerne=
l.org/

>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 10850512c118..ededa04ef97b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6920,6 +6920,21 @@ F:	drivers/devfreq/event/
>  F:	include/dt-bindings/pmu/exynos_ppmu.h
>  F:	include/linux/devfreq-event.h
> =20
> +DEVICE I/O & IRQ [RUST]
> +M:	Danilo Krummrich <dakr@kernel.org>
> +M:	Alice Ryhl <aliceryhl@google.com>
> +M:	Daniel Almeida <daniel.almeida@collabora.com>
> +L:	rust-for-linux@vger.kernel.org
> +S:	Supported
> +W:	https://rust-for-linux.com
> +B:	https://github.com/Rust-for-Linux/linux/issues
> +C:	https://rust-for-linux.zulipchat.com
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-=
core.git
> +F:	rust/kernel/io.rs
> +F:	rust/kernel/io/
> +F:	rust/kernel/irq.rs
> +F:	rust/kernel/irq/
> +
>  DEVICE RESOURCE MANAGEMENT HELPERS
>  M:	Hans de Goede <hansg@kernel.org>
>  R:	Matti Vaittinen <mazziesaccount@gmail.com>
>
> base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
> --=20
> 2.50.1

