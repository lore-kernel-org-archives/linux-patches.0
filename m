Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4002107A2
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 16:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8D4C433B5;
	Thu, 10 Nov 2022 16:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668098603;
	bh=I3b0Z7RHs3m0QbSSsLLKwiQESMTWz+K564vWJV2JsjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yp/6XFlz+k04kCIlhS2B7ArlTF8uHXzFiMTnjRyUTjiwb4202IV8ifYnWqDb0mU+G
	 yfICCMeY46vT+WeRhUyJuToCRSCPgt8qdqSJuizlKRzNeflPzGSyO/ZCEuIfhErpGM
	 0COeovEJQIyeGhyYcArZACHaQFby9VJdFW80t+7Lcmzb/3G0P4ocVCPY+V3gZ0u6y2
	 YorzeDzm32SzM8hpLKcB59M8689V8Pmgh2d7CpI6V67oa3UqYcuCAJXiY5/RQU7KM2
	 Vix8vowoVr8xSF7f1Ui7Ed8/AV7G7x/zteQ5HQSxeAqg5bTmc7Md0hsusR7qwG2E+1
	 FUW9QoBga1rQw==
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
Subject: [PATCH v1 22/28] rust: str: add `fmt!` macro
Date: Thu, 10 Nov 2022 17:41:34 +0100
Message-Id: <20221110164152.26136-23-ojeda@kernel.org>
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

Add the `fmt!` macro, which is a convenience alias for the Rust
`core::format_args!` macro.

For instance, it may be used to create a `CString`:

    CString::try_from_fmt(fmt!("{}{}", "abc", 42))?

Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/str.rs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 877148b77e71..ffac633423db 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -592,3 +592,9 @@ impl Deref for CString {
         unsafe { CStr::from_bytes_with_nul_unchecked(self.buf.as_slice()) }
     }
 }
+
+/// A convenience alias for [`core::format_args`].
+#[macro_export]
+macro_rules! fmt {
+    ($($f:tt)*) => ( core::format_args!($($f)*) )
+}
-- 
2.38.1

