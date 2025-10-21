Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D08D2773F4;
	Tue, 21 Oct 2025 20:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077615; cv=none; b=KTsD7PMUVXeQQfr+Tj4A5xjWW91//bHTKORqC8+BLDX+QOXcqqG45vtt9lKcHbjtBxWgM3hCiSW1WU5TGDW8SeXkGCegMJwK27QcfpEnURwdUzYZzZeKhjhSYcl20QyNtZjRdfEo9sfMnq1zbq3bat1ZQXabmO0R3wU/PgdaHvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077615; c=relaxed/simple;
	bh=zXRbj6iQUZufqxSSXD9r8NYXxDqbqJdfht/tkaiQP+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piY2vkzvA31Od39Kz90vcw9phSkPNvKRBVgteXZaGaHHOfMIJKBZAadGssQ3YDrzgHAzYZ8Fh5OhmSG5hfD+DZ/uGMgxwkoyWiPb+6QU97b+cHCI8g/HUbCwZiD/pK5NbXF8RyYqzVMaINjMjy7K1CofFU/0FZbHH+aPjQyvDME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvhcjMiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvhcjMiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26103C4CEF1;
	Tue, 21 Oct 2025 20:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077614;
	bh=zXRbj6iQUZufqxSSXD9r8NYXxDqbqJdfht/tkaiQP+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvhcjMiJGFEEH8Pj3nE/yl59p7uotoA/1YIuH6yj/T+RyI2WxqYRc5r9yjM4jJfSI
	 3geWgQh0YMWdR6kSjQOuJSS5TLm+9399f0IAnooxyeWjy588tPc023Ijmf1yzHzv4M
	 hUwyqT5mwybrmDWWHZNfR3FOoyvRGdbIgbPThWrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 136/159] rust: cpufreq: fix formatting
Date: Tue, 21 Oct 2025 21:51:53 +0200
Message-ID: <20251021195046.415059572@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 32f072d9eaf9c31c2b0527a4a3370570a731e3cc ]

We do our best to keep the repository `rustfmt`-clean, thus run the tool
to fix the formatting issue.

Link: https://docs.kernel.org/rust/coding-guidelines.html#style-formatting
Link: https://rust-for-linux.com/contributing#submit-checklist-addendum
Fixes: f97aef092e19 ("cpufreq: Make drivers using CPUFREQ_ETERNAL specify transition latency")
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Benno Lossin <lossin@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/cpufreq.rs | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/rust/kernel/cpufreq.rs b/rust/kernel/cpufreq.rs
index b762ecdc22b00..cb15f612028ed 100644
--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -39,8 +39,7 @@ use macros::vtable;
 const CPUFREQ_NAME_LEN: usize = bindings::CPUFREQ_NAME_LEN as usize;
 
 /// Default transition latency value in nanoseconds.
-pub const DEFAULT_TRANSITION_LATENCY_NS: u32 =
-        bindings::CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
+pub const DEFAULT_TRANSITION_LATENCY_NS: u32 = bindings::CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
 
 /// CPU frequency driver flags.
 pub mod flags {
-- 
2.51.0



