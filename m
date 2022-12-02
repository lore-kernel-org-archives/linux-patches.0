Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C54A4C71
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 16:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF922C433D6;
	Fri,  2 Dec 2022 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669997768;
	bh=H8GrOu07IRuGrUGFNBmi30U0LGPQsGBzhM2gPsNjUkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSXqOdyvoi8n6XgrzYEVF4fhRH5tBbsPS7tPg3IrH4f/YUi3ehHMrKcQl2ulQ/Kop
	 XEQoyYJuaPY9MWeMLa5swvgmArnT5mNqjne8069nzMrXH9An5X8Hsv9aa4fgWZruPw
	 v5eiihrOunn5lnROLNG7vBCwouR95qcm+C7ctlR14lAs3iewozoi8RA31YmSBBfxzK
	 KoOcheBvdRW7gelraQ/dzHya7zURlnBmn9909XlxyvrIg/Wg01jxUpxIOZDgXp8toF
	 Q4DmdoaBMRV26zZjzNGTpwLmKwOx7hT1Fm6cKp2FDR/3/ZQAx/yZ6nnOrJ6EyUM/A8
	 wc7KBED35y1cw==
From: ojeda@kernel.org
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 14/28] rust: str: add `BStr` type
Date: Fri,  2 Dec 2022 17:14:45 +0100
Message-Id: <20221202161502.385525-15-ojeda@kernel.org>
In-Reply-To: <20221202161502.385525-1-ojeda@kernel.org>
References: <20221202161502.385525-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gary Guo <gary@garyguo.net>

Add the `BStr` type, which is a byte string without UTF-8
validity guarantee.

It is simply an alias to `[u8]`, but has a more evident
semantical meaning.

Signed-off-by: Gary Guo <gary@garyguo.net>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/str.rs | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index e45ff220ae50..3aa1a0cb9bf8 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -4,6 +4,11 @@
 
 use core::fmt;
 
+/// Byte string without UTF-8 validity guarantee.
+///
+/// `BStr` is simply an alias to `[u8]`, but has a more evident semantical meaning.
+pub type BStr = [u8];
+
 /// Allows formatting of [`fmt::Arguments`] into a raw buffer.
 ///
 /// It does not fail if callers write past the end of the buffer so that they can calculate the
-- 
2.38.1

