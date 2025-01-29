Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34A9198E84;
	Wed, 29 Jan 2025 22:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738188033; cv=none; b=fHy7yAUL4BSblITiNwU/JhsJmfElcF7TU32JdGoUwetoPfApUNJeno/Zql5eglUN6Yx6+BkPhR7fAiDwS261lSWysP1R7M18Tw7NUKr9TtoUkm9kJ8pBtR0Wkpj6bE7T7ZSDpTuJCiCqyKWttJjfE0sz9XtflqI5H+XjNbBYFS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738188033; c=relaxed/simple;
	bh=e6HsxsXM2vwdwLzScz6X6o01s/HmswmjCzRxOJC0k8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mh7zbFT+ebxmgfwnzsrr7+66SC217ijdkh2co4Ew5O7dmufZOtQSLt55EU4Xm09l01sFmzd4VFWQZ3OOsKHTChFfYkEXtPkcXM2QxAUoXElE4N+ppXBHz+q26kyvvM/a54h8SRk1bgYdzVGi882zDzcwWufradGIfKx0ZBMEPeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksy5mFkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksy5mFkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E48C4CED1;
	Wed, 29 Jan 2025 22:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738188033;
	bh=e6HsxsXM2vwdwLzScz6X6o01s/HmswmjCzRxOJC0k8g=;
	h=From:To:Cc:Subject:Date:From;
	b=ksy5mFkXCa4ozJqwME8FsnZAMoYqWezWOR7Q0+0OthfgeEyvv0h0wUBlJNB6FiCOb
	 /w5nURU6392B9jC1y6pj24G6zljmuwpl5IVxZbm/hlb3wb5Bpae4PA0oJ1wgvObuqy
	 5St6RV1nAWPtq/mbJnTog4ZQgSiQqGqkGvqUtudKmfxhMFdKnGJpvxKs6YjSMBMfCf
	 tb3i245x3kC+lIf2gKaMzbD+HzMc9ZIBeToEVuDEfr+csxkPrXp/cEyyofQNUXRnxn
	 4y3B4y1RNqrG+lIvlEQbk4/ThyIBdoFPuYGr+7DgJMT20/jVkMoCI2txEn4aRM+ZuP
	 ptobjcu6Ortuw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] MAINTAINERS: add Danilo Krummrich as Rust reviewer
Date: Wed, 29 Jan 2025 22:59:48 +0100
Message-ID: <20250129215948.135486-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Danilo has been involved with the Rust for Linux project for a year now.
He is primarily working on the Nova GPU driver [1][2].

In addition, he has been active in the mailing list and most recently
submitted the Device / Driver PCI / Platform series.

He is also already a maintainer of `RUST [ALLOC]` as well as several
other DRM-related entries.

His expertise developing Rust abstractions and APIs for one of the major
users of Rust in the kernel will be very useful to have around in the
future. Thus add him to the `RUST` entry as reviewer.

Cc: Danilo Krummrich <dakr@kernel.org>
Link: https://rust-for-linux.com/nova-gpu-driver [1]
Link: https://lore.kernel.org/dri-devel/Zfsj0_tb-0-tNrJy@cassiopeiae/ [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0fa7c5728f1e..64ee11eac61c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20466,6 +20466,7 @@ R:	Benno Lossin <benno.lossin@proton.me>
 R:	Andreas Hindborg <a.hindborg@kernel.org>
 R:	Alice Ryhl <aliceryhl@google.com>
 R:	Trevor Gross <tmgross@umich.edu>
+R:	Danilo Krummrich <dakr@kernel.org>
 L:	rust-for-linux@vger.kernel.org
 S:	Supported
 W:	https://rust-for-linux.com
-- 
2.48.1

