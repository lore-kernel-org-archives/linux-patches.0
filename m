Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3076025A343;
	Fri, 25 Jul 2025 20:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753475343; cv=none; b=aqxj+X1ktGK+AOiOysbNeDdfYHugIFIa/6JRYlKOEycF8TXGp+AQZjZO11U7zeyP11QX6DiWWeSCP3iScNAlGX98r7mnbIdVmN4wpZu44kmWYcWb4wdUMHj8tw/fsGEjmQH2pSdDQZTIIDVHEKTlFUqrb25EoTUCtS6zMb+YpNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753475343; c=relaxed/simple;
	bh=pefVZyjeujN2yBzzyJFiH0o1xvQSZirZhXuH/tz4584=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dTJ7L+nfvd6T22+5mubzxk+/sRXvw2YLIzdXYQkdYaySYWu75cpbSs07/IjwUkxdXpPKZqHWd2emzJvNsW7RsoCFMk670UMBlyEWbP4OuY6GkpPpf+9Y0t2GdMOz+lKk6GqU5ExskM6flJL3W3PEnMGpFKnqWqhv6vD+SLyx6ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOaso707; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOaso707"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC9AC4CEF4;
	Fri, 25 Jul 2025 20:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753475342;
	bh=pefVZyjeujN2yBzzyJFiH0o1xvQSZirZhXuH/tz4584=;
	h=From:To:Cc:Subject:Date:From;
	b=GOaso707QPrhVlAVAJpPSACpN/3Dk4D1BjB4m4XyRq5K8h3VFrLbtfTZa/2MijuCD
	 iKNKP1dyxlfFx35LAS9fxky/UDJQzsQeBxenhaMk31AuacX20quVZ7uvBwC0sOVe/X
	 P7TUgbtwgGag1qNyPbnEuaodrQegjo6Ex/+tlWpwMvcNwHGXWSeAhf1c4tSXulLEcp
	 4ezjfxNkPA4/QqR3zUp/Wy9nuGYrwKu6wzX6gwQnkIAtn2T978l/SXkXjxDHUd/3xf
	 QhXgi3Gm3hS0VAdy9HaEO8Ghbkga0FxRrqDn+Y80A8q1a7Exg5HL3OaWMBUZ05IhpP
	 PT/Kwfg+mBYdQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>
Subject: [PATCH] MAINTAINERS: add "DEVICE I/O & IRQ [RUST]" entry
Date: Fri, 25 Jul 2025 22:28:40 +0200
Message-ID: <20250725202840.2251768-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This entry will handle device I/O patches and abstractions (such as
memory-mapped IO and system resources series [1]), as well as IRQ ones
(such as the `request_irq` series [2]).

Patches will flow through driver-core, at least for the time being.

Danilo, Alice and Daniel will maintain it.

Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Daniel Almeida <daniel.almeida@collabora.com>
Link: https://lore.kernel.org/rust-for-linux/20250717-topics-tyr-platform_iomem-v15-0-beca780b77e3@collabora.com/ [1]
Link: https://lore.kernel.org/rust-for-linux/20250715-topics-tyr-request_irq2-v7-0-d469c0f37c07@collabora.com/ [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10850512c118..ededa04ef97b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6920,6 +6920,21 @@ F:	drivers/devfreq/event/
 F:	include/dt-bindings/pmu/exynos_ppmu.h
 F:	include/linux/devfreq-event.h
 
+DEVICE I/O & IRQ [RUST]
+M:	Danilo Krummrich <dakr@kernel.org>
+M:	Alice Ryhl <aliceryhl@google.com>
+M:	Daniel Almeida <daniel.almeida@collabora.com>
+L:	rust-for-linux@vger.kernel.org
+S:	Supported
+W:	https://rust-for-linux.com
+B:	https://github.com/Rust-for-Linux/linux/issues
+C:	https://rust-for-linux.zulipchat.com
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git
+F:	rust/kernel/io.rs
+F:	rust/kernel/io/
+F:	rust/kernel/irq.rs
+F:	rust/kernel/irq/
+
 DEVICE RESOURCE MANAGEMENT HELPERS
 M:	Hans de Goede <hansg@kernel.org>
 R:	Matti Vaittinen <mazziesaccount@gmail.com>

base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
-- 
2.50.1

