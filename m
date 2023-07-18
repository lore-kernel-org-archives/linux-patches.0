Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AFF15A9
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 05:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55082C433C8;
	Tue, 18 Jul 2023 05:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689659130;
	bh=rG22R8r6LRo0ObZRqQ+DyJg6OJ/9CbzLbTaVWOW+Q48=;
	h=From:To:Cc:Subject:Date:From;
	b=PlDOpjFkgaKeFdzOuRfhUHkzO3TU8RKJCum72TPLwRdgZz3+mcH93+Jo+gD4nOvBx
	 trjQu6jGXTfZKjYDYLh2eSw4NEX0vBVoQCcnBvxLikc8hyrSepwbLOypUdTEhuzVoy
	 FX9qjc0z92WrHAWCQe5wiUSMZ5yNDgi/MqDH3NqzNO9T2giumCQU9r0UgD7AQN/Mvn
	 Mu/0jHXGkT4tsoO/n+o9pP8qwD5vueS8NAQbhJxc23tfaI6JpJ7Z2EwOS01Ro0w6BK
	 yzjt8wwMKqjs9DLphKQWDXR9Gl1pr4Vpgw5wU6dqDNkZTaO3yRmph6ONbwzJJ1gvtN
	 IEV5Sowcwq9eQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] MAINTAINERS: add Alice Ryhl as Rust reviewer
Date: Tue, 18 Jul 2023 07:45:20 +0200
Message-ID: <20230718054521.1048785-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Alice has been involved with the Rust for Linux project for
almost a year now. She has been primarily working on the
Android Binder Driver [1].

In addition, she has been reviewing patches in the mailing
list for some months and has submitted improvements to the
core Rust support.

She is also part of the core maintainer team for the widely
used library Tokio [2], an asynchronous Rust runtime.

Her expertise with the language will be very useful to have
around in the future if Rust grows within the kernel, thus
add her to the `RUST` entry as reviewer.

Link: https://rust-for-linux.com/android-binder-driver [1]
Link: https://tokio.rs [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3be1bdfe8ecc..f19f34e3926d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18542,6 +18542,7 @@ R:	Boqun Feng <boqun.feng@gmail.com>
 R:	Gary Guo <gary@garyguo.net>
 R:	Björn Roy Baron <bjorn3_gh@protonmail.com>
 R:	Benno Lossin <benno.lossin@proton.me>
+R:	Alice Ryhl <aliceryhl@google.com>
 L:	rust-for-linux@vger.kernel.org
 S:	Supported
 W:	https://github.com/Rust-for-Linux/linux

base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0

