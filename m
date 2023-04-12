Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAF0A935
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 22:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE84C433D2;
	Wed, 12 Apr 2023 22:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681337934;
	bh=Q0bqOpoIZZcmgwns//TSAMeE2DQS7zVb958Lhe91z04=;
	h=From:To:Cc:Subject:Date:From;
	b=JKJrm/Wp+slCy+gATbqfwo+lkM2NDwq6z3YpgXrdo7eZt3jqCO+BcU4NQhB6cJYtu
	 mMyMSXEX7XqtW1REGrbKjegPVgutMNxLl1fcEIOKvNh/ZfHlGTb3zGvKC/NTigVsDr
	 JGin1H+5CYBqnvpiDDX0yuzXqAYtg+aDDybnm0dEO3IJUc8AEs86bboxD3waAiRGM2
	 RmEDleiG1ZzN9RUhmcBGmD4z/2JRTLhickJu5P4PqLp6E0GoZBkIbb3vSiGmQeiAs5
	 601QGIdqCqZMn4EnfZaOWEbuZZkUnhpvUvWmiB+J7uGiZ5G6rW4ujHo8nfLhuuSVJO
	 bP51V859j8ZUg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>
Subject: [PATCH] MAINTAINERS: add Benno Lossin as Rust reviewer
Date: Thu, 13 Apr 2023 00:18:22 +0200
Message-Id: <20230412221823.830135-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Benno has been involved with the Rust for Linux project for
the better part of a year now. He has been working on solving
the safe pinned initialization problem [1], which resulted in
the pin-init API patch series [2] that allows to reduce the
need for `unsafe` code in the kernel. He is also working on
the field projection RFC for Rust [3] to bring pin-init as
a language feature.

His expertise with the language will be very useful to have
around in the future if Rust grows within the kernel, thus
add him to the `RUST` entry as reviewer.

Link: https://rust-for-linux.com/the-safe-pinned-initialization-problem [1]
Link: https://lore.kernel.org/rust-for-linux/20230408122429.1103522-1-y86-dev@protonmail.com/ [2]
Link: https://github.com/rust-lang/rfcs/pull/3318 [3]
Cc: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90abe83c02f3..bf9deaa4aa5a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18225,6 +18225,7 @@ M:	Wedson Almeida Filho <wedsonaf@gmail.com>
 R:	Boqun Feng <boqun.feng@gmail.com>
 R:	Gary Guo <gary@garyguo.net>
 R:	Björn Roy Baron <bjorn3_gh@protonmail.com>
+R:	Benno Lossin <benno.lossin@proton.me>
 L:	rust-for-linux@vger.kernel.org
 S:	Supported
 W:	https://github.com/Rust-for-Linux/linux

base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.40.0

