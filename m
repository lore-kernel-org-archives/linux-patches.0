Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB71D107A2
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 16:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6DFC43150;
	Thu, 10 Nov 2022 16:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668098571;
	bh=J+cwd2iu48BeHn73Bu4PeBxaaHkYRYafz2YHSK3Yjjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSw9FyisDjfN09jEGFqMNicm0MJQe4gjqoQHUcw0zW8s3zbT71HkF7coKOTFDAIEF
	 KeUAeyvy+trgzIGFr7nvNIJdho1rG3qLM/6MeFCQJqonH9iAMxHZEaf7CaQDsl5rHi
	 pxtgrv2vNzqPZqfvKpIhhVcLd816IsfyaBZLV9ifPgsgwe3XSmr3EDC7dRb1HiPUqj
	 87PKmFi2DHO5LxTg+sErRFR9xN0Oe2rM1unhtzfDoibHtxRMWvP08FALvX7eyqz+WA
	 7pp60pskFP9ppg3E1HOuKdgPqGDGrpXKlpe9CFOfIvdIVxUZQwwF8eI9GK1CgQVA1w
	 MUqryAoSBk9HQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v1 11/28] rust: prelude: add `error::code::*` constant items
Date: Thu, 10 Nov 2022 17:41:23 +0100
Message-Id: <20221110164152.26136-12-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-1-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wedson Almeida Filho <wedsonaf@gmail.com>

It is convenient to have all the `Error` constant items (such as
`EINVAL`) available as-is everywhere (i.e. for code using the kernel
prelude such as kernel modules).

Therefore, add all of them to the prelude.

For instance, this allows to write `Err(EINVAL)` to create
a kernel `Result`:

    fn f() -> Result<...> {
        ...
        Err(EINVAL)
    }

Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/prelude.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 7c4c35bf3c66..1e08b08e9420 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -19,6 +19,6 @@ pub use macros::{module, vtable};
 
 pub use super::{pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, pr_notice, pr_warn};
 
-pub use super::error::{Error, Result};
+pub use super::error::{code::*, Error, Result};
 
 pub use super::ThisModule;
-- 
2.38.1

