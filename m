Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F8822157F;
	Fri, 10 Oct 2025 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760118277; cv=none; b=SXkqphSwSO6GDd8OgabFHfF8c0Z1QlCuzJYSHtVsxUBA2QwMXxyDxsJLeIvFGsDNH5nBZe7ZoZZsMtqf40MMLHmnKvuUCCMZ7B2oyrsa5yM9rEuuV9nv/r5TCt4/MD2PJTJUkMmX5heaeIM8+ZuxKS2pVOxBLm6SvtpJyvsKqqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760118277; c=relaxed/simple;
	bh=EOO32wpZESIcy0ZfUtjAk8LVrqNlpQog8AW67jHQPQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2Ig4D71T/F9HcUb2gnAZGCXxI1kIoZOJzmD03/sdsbT6cAsCK4KHiBt88LleDrLGIQY/1B/pBjkr/d4C9MSjllualcVFngj9EZLNovaIImVK8LcESHhBh8SbXOIPFwi5Pnz0p6ca6K4y4qa9LuC/89n/HYXkZfsq0We1AP/q1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfVYyn5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfVYyn5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C08AC4CEF5;
	Fri, 10 Oct 2025 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760118276;
	bh=EOO32wpZESIcy0ZfUtjAk8LVrqNlpQog8AW67jHQPQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfVYyn5dpB1xT+oJKw25VvakfVVGQslIqweOhC98t/ZvQ4OZKEz0DdDk8xUyDw2JC
	 NApXVTDtx5tqVQ3mpw+X40kaBt1a2EnrJsfvA37ZObo8ldhlOl6SrdPzr6cHf+Kz9L
	 Z4Qemq1/vru0W1mpb2jblPhm4kO6lez+5MQWT0KzRMFGUi0rlDC56dC2JsrsG4mYvq
	 +I07qBdtLO1SxsIqZCz41RNxKRYxCe/GnBUxzKlW6BogPYM+Fwn3Fces1CtBb0AT1F
	 NGcF6hpUoSdbITdnzoPGRyMl8My620hEp4jF+fJRLAbL1FTRDD8u2f0Dc7aDIQBPu4
	 aiQ2xzQpM+uJQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 3/3] rust: cpufreq: fix formatting
Date: Fri, 10 Oct 2025 19:43:51 +0200
Message-ID: <20251010174351.948650-4-ojeda@kernel.org>
In-Reply-To: <20251010174351.948650-1-ojeda@kernel.org>
References: <20251010174351.948650-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We do our best to keep the repository `rustfmt`-clean, thus run the tool
to fix the formatting issue.

Link: https://docs.kernel.org/rust/coding-guidelines.html#style-formatting
Link: https://rust-for-linux.com/contributing#submit-checklist-addendum
Fixes: f97aef092e19 ("cpufreq: Make drivers using CPUFREQ_ETERNAL specify transition latency")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/cpufreq.rs | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/rust/kernel/cpufreq.rs b/rust/kernel/cpufreq.rs
index 21b5b9b8acc1..1a555fcb120a 100644
--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -38,8 +38,7 @@
 const CPUFREQ_NAME_LEN: usize = bindings::CPUFREQ_NAME_LEN as usize;
 
 /// Default transition latency value in nanoseconds.
-pub const DEFAULT_TRANSITION_LATENCY_NS: u32 =
-        bindings::CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
+pub const DEFAULT_TRANSITION_LATENCY_NS: u32 = bindings::CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
 
 /// CPU frequency driver flags.
 pub mod flags {
-- 
2.51.0

