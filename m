Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBEE7466;
	Wed, 30 Aug 2023 17:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73942C433C9;
	Wed, 30 Aug 2023 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693414839;
	bh=pcmI+YzkQKh4isMmLdt5NXs7Ibhic2WIRZBfFetQT7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TT8t6ADL0PIsiq2yNWW/uO2kELy1U7ZdzCLBzyUGYU8fdtkVfDmodgp5DVCd1WrsD
	 65637Qhq1Vvs+JpMaqx4v/9gpf5qPRhCAj0j3xxfd1yWNf0ANcLLRNvHJ8qSG83McC
	 feETY6MMdHqJ3eCJydLivc1XjPJ3z1jOFVdawocrAVdI5YqGwFlxSnGRbBCtDHKxCS
	 xBaHpjL56g3N+7Cg99ddqds5uM0tWa+omBJKZ64L7bC5qu3F+q97KhzXLSPSACVcxP
	 xu7dfC4+q3Kk2ISFHWM7YPdfHfcmvKhHhl94oqF1IBiwUdrysk9um690jD205ukouo
	 BoeBmZaO2zIJg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/2] MAINTAINERS: add Maintainer Entry Profile field for Rust
Date: Wed, 30 Aug 2023 18:59:49 +0200
Message-ID: <20230830165949.127475-2-ojeda@kernel.org>
In-Reply-To: <20230830165949.127475-1-ojeda@kernel.org>
References: <20230830165949.127475-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `P:` field allows a URI, and we have been adding information
on how to contribute to the Rust subsystem to our webpage for a
while now (and other relevant topics, e.g. branches, third-party
crates, Rust unstable features...).

The webpage/document does not currently follow the headings of
the Maintainer Entry Profile, but it does nevertheless answer
some of the questions we have got so far from contributors and
it covers partially some of the topics there.

Thus link to our "Contributing" document [1].

Link: https://rust-for-linux.com/contributing [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c8088e9a11b..a27b673b01c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18561,6 +18561,7 @@ S:	Supported
 W:	https://rust-for-linux.com
 B:	https://github.com/Rust-for-Linux/linux/issues
 C:	zulip://rust-for-linux.zulipchat.com
+P:	https://rust-for-linux.com/contributing
 T:	git https://github.com/Rust-for-Linux/linux.git rust-next
 F:	Documentation/rust/
 F:	rust/
-- 
2.42.0

