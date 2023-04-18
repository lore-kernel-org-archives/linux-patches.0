Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6B8C94A
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C49DC4339C;
	Tue, 18 Apr 2023 21:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681854272;
	bh=PEJ21Jum+8RkGBoHGrrQC2DdRUmxtG2ZVlTGGrsyUic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGuC/XLSVrXqEujsgvql/IRDy7Wrla/QrdVy0fr/0AWv5wVdnDVzTwltqM2r6UAp1
	 SHhLoQi+2DPpMhYOj7XxFJPfoThVJp2dLZJyQAaOzhbFHg4SFVmHaf/CjxjRjYX9gP
	 pWdRfYiVWMcQkdCg67cWSGPiTEmoEUATcGkaXV7TwzZXIBdT1XCbEu5l0k+Hu90Jkb
	 tqLimTXcw1PPyiMqtAy/DoZMd/aAs03Zl5A4R+g0+AbKk3gx6pgtNwgiBLaV1uVi4w
	 gQh574fNpYajHkjPlYnP2KgWCEXHhJdLRtmtIHtgkBCDNjtWzLVzIKByKzmGP+E1WQ
	 aw0/pxTQu1GMA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Josh Stone <jistone@redhat.com>,
	William Brown <william.brown@suse.com>,
	Georgy Yakovlev <gyakovlev@gentoo.org>,
	Jan Alexander Steffens <jan.steffens@gmail.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/3] rust: alloc: clarify what is the upstream version
Date: Tue, 18 Apr 2023 23:43:45 +0200
Message-Id: <20230418214347.324156-2-ojeda@kernel.org>
In-Reply-To: <20230418214347.324156-1-ojeda@kernel.org>
References: <20230418214347.324156-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It may be unclear for readers which upstream Rust version these files
are based on. They may be unaware that they are intended to match the
minimum (and only, so far) supported version of Rust in the kernel.

Thus clarify it.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/alloc/README.md | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rust/alloc/README.md b/rust/alloc/README.md
index c89c753720b5..eb6f22e94ebf 100644
--- a/rust/alloc/README.md
+++ b/rust/alloc/README.md
@@ -10,6 +10,9 @@ upstream. In general, only additions should be performed (e.g. new
 methods). Eventually, changes should make it into upstream so that,
 at some point, this fork can be dropped from the kernel tree.
 
+The Rust upstream version on top of which these files are based matches
+the output of `scripts/min-tool-version.sh rustc`.
+
 
 ## Rationale
 
-- 
2.40.0

