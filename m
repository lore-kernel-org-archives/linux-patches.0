Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEB579CF
	for <patches@lists.linux.dev>; Mon, 28 Jul 2025 00:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753661710; cv=pass; b=MVxsqIFxov11IuWJFR1RnQkrRQbeYe6TUW7VocqOGB3yb0GelBayKf5S6ABHMdiDpiW4iacZXvvzDEdoZx8bJydzETFq9YdoX/JC4EJk+5Gso75GeBg7wLsgxV02b7HOsUC5phE94kFtoRMKAekOZcUa+No8e2IBj+TAz+LzHD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753661710; c=relaxed/simple;
	bh=JwxVvArkyP39QEnSFJqXUfjKXP+S/mEocXKgc9Sx78k=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=W4IvXHjkw2daTx0TSkIfUqsLoVcXuVueZoyOZeXKENt6uhmfv4iZ+U5dFefAh20E3eImv51o2Nfx7toSHPjHu4XplZqMKw/qp5l1+z7SPDwV5bMeAK1Q+MblSkY5EAvnGWiyLqTffdZtRlIOMW6N9cn8kD2qH/me33TMSXauqMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=Jw7MJ5Vz; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="Jw7MJ5Vz"
ARC-Seal: i=1; a=rsa-sha256; t=1753661699; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=j5IZcRVgKvnY4f2D6066rzIM2QCESkxjpVYir9daMx0kirIDSFQeph6Qm9kBwlzPDN2yEqXaatvHBy4c9DepZhNw1rfaoQ4o7QS0KcnYmM1P2YL7UNjU2pIfqjHMH4ybbdMSN+yTprSpAPCPrHW4Q81G5KNw7Zwq665IBQM4NdE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753661699; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=JwxVvArkyP39QEnSFJqXUfjKXP+S/mEocXKgc9Sx78k=; 
	b=EaN6LbEptaKX6k5er7Yp+9SaywxI0QMMVF2SdibHcAyTPCrUn5ewj7XrF5zgOnkO7+EEXzDjzv8DA4N7AsXs4Q9fhxgSsawZJt5Boo1Il+0skj2vTAVFPcffFKX0tE80Wxhc47W+3lEPkr55j7/i0OI0wkm1jOqCydWUqvvZQVI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753661699;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=JwxVvArkyP39QEnSFJqXUfjKXP+S/mEocXKgc9Sx78k=;
	b=Jw7MJ5Vzmh9tcBaHOwIaIE/ETnL+j2iOI9uloxDfZyIHL1MnYM6st6SX5EI4T/JD
	qLCLHS/uHO9EvS9I/Rr9R4OmsC57HhLINe6hPQfTKxHw/dIvgf/BYus3RmrN5ax57qH
	Upk+3siKOMXq40ro7WOuIHtY3pkmI6ZJZU657u6k=
Received: by mx.zohomail.com with SMTPS id 1753661696217176.06162511726257;
	Sun, 27 Jul 2025 17:14:56 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH] MAINTAINERS: add "DEVICE I/O & IRQ [RUST]" entry
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250725202840.2251768-1-ojeda@kernel.org>
Date: Sun, 27 Jul 2025 21:14:35 -0300
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <9894D97E-0048-4A12-980B-1BA16AF8B587@collabora.com>
References: <20250725202840.2251768-1-ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External



> On 25 Jul 2025, at 17:28, Miguel Ojeda <ojeda@kernel.org> wrote:
>=20
> This entry will handle device I/O patches and abstractions (such as
> memory-mapped IO and system resources series [1]), as well as IRQ ones
> (such as the `request_irq` series [2]).
>=20
> Patches will flow through driver-core, at least for the time being.
>=20
> Danilo, Alice and Daniel will maintain it.
>=20
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Daniel Almeida <daniel.almeida@collabora.com>
> Link: =
https://lore.kernel.org/rust-for-linux/20250717-topics-tyr-platform_iomem-=
v15-0-beca780b77e3@collabora.com/ [1]
> Link: =
https://lore.kernel.org/rust-for-linux/20250715-topics-tyr-request_irq2-v7=
-0-d469c0f37c07@collabora.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> MAINTAINERS | 15 +++++++++++++++
> 1 file changed, 15 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 10850512c118..ededa04ef97b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6920,6 +6920,21 @@ F: drivers/devfreq/event/
> F: include/dt-bindings/pmu/exynos_ppmu.h
> F: include/linux/devfreq-event.h
>=20
> +DEVICE I/O & IRQ [RUST]
> +M: Danilo Krummrich <dakr@kernel.org>
> +M: Alice Ryhl <aliceryhl@google.com>
> +M: Daniel Almeida <daniel.almeida@collabora.com>
> +L: rust-for-linux@vger.kernel.org
> +S: Supported
> +W: https://rust-for-linux.com
> +B: https://github.com/Rust-for-Linux/linux/issues
> +C: https://rust-for-linux.zulipchat.com
> +T: git =
git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git
> +F: rust/kernel/io.rs
> +F: rust/kernel/io/
> +F: rust/kernel/irq.rs
> +F: rust/kernel/irq/
> +
> DEVICE RESOURCE MANAGEMENT HELPERS
> M: Hans de Goede <hansg@kernel.org>
> R: Matti Vaittinen <mazziesaccount@gmail.com>
>=20
> base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
> --=20
> 2.50.1
>=20
>=20

Acked-by: Daniel Almeida <daniel.almeida@collabora.com>

