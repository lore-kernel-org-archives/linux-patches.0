Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8124B37223E;
	Sat, 28 Feb 2026 17:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301501; cv=none; b=LQqTVOnUFlLj85C0r/VgrCIRRGJkTSsNIuW7UP4FuZxM83aM24b1TfgXlBaiih6Nu9d0EUoh8ZthksO4CKfNnN+aOe5gojHsbp5uoIjFDVP7Obi3KHCW8KIwaBZNmvp3gxyhTtTuVQOvZagCBGPl1keoGwmeTZYgQhwnVPIbxR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301501; c=relaxed/simple;
	bh=3YmsyL7JsOgjjRhEb2dJkfc2tGV7iZrBD8n18IJa8W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKJHhOScMHidgucyZogTtubOAdeSjJjTam2uOZAxGxyDOFTeN7CgjktZl6ndtjhf8RuXj+1eST0k7/XIEIm893UV71/c+z2S4rgk9PTKBKpfM4XO/oiBeanAv+O0O96yCSyhIlnx1RUzzM1O8D0QhOcwbnmzQlzr6/gpM83CxfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQ46o/1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQ46o/1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D14C19424;
	Sat, 28 Feb 2026 17:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301501;
	bh=3YmsyL7JsOgjjRhEb2dJkfc2tGV7iZrBD8n18IJa8W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ46o/1DyvORS1zwOZOH3YVsn4iNdff9/6wRDO4yq25/Bk5WJEkGSHPw0VaUcuwZc
	 V2sWQk1ui3mO41jtKz7Uwulyn8388hzah/zGEXHpUWJnvzTYo8DqyvddLM12XhLVcr
	 0NXoN9ACX+6LffWXYtvnyACxIaLpaaTu14C0pLLODguNEwcrkNG+J3CYzDy48Fokbk
	 TMC7U5dTN7PDcFoBDf03dqDvHHbtPzEoZER58aewM40urDic6fDLMn7/yiKRv28htB
	 MqlLplaEZ1+xXgkp3jrFZVBaTQZXj0CAUAfS+0DAQe+zqrZCwghouYqOrNd+3xPjF7
	 cn58RfPkTbYqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miguel Ojeda <ojeda@kernel.org>,
	David Wood <david@davidtw.co>,
	Wesley Wiser <wwiser@gmail.com>,
	stable@vger.kernel.org,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 685/752] rust: kbuild: pass `-Zunstable-options` for Rust 1.95.0
Date: Sat, 28 Feb 2026 12:46:36 -0500
Message-ID: <20260228174750.1542406-685-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 0a9be83e57de0d0ca8ca4ec610bc344f17a8e5e7 ]

Custom target specifications are unstable, but starting with Rust 1.95.0,
`rustc` requires to explicitly pass `-Zunstable-options` to use them [1]:

    error: error loading target specification: custom targets are unstable and require `-Zunstable-options`
      |
      = help: run `rustc --print target-list` for a list of built-in targets

David (Rust compiler team lead), writes:

   "We're destabilising custom targets to allow us to move forward with
    build-std without accidentally exposing functionality that we'd like
    to revisit prior to committing to. I'll start a thread on Zulip to
    discuss with the RfL team how we can come up with an alternative
    for them."

Thus pass it.

Cc: David Wood <david@davidtw.co>
Cc: Wesley Wiser <wwiser@gmail.com>
Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/151534 [1]
Reviewed-by: Gary Guo <gary@garyguo.net>
Tested-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260206204535.39431-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rust/Makefile b/rust/Makefile
index 7842ad0a4ea72..d4618f646b05b 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -437,6 +437,8 @@ $(obj)/$(libpin_init_internal_name): private rustc_target_flags = --cfg kernel
 $(obj)/$(libpin_init_internal_name): $(src)/pin-init/internal/src/lib.rs FORCE
 	+$(call if_changed_dep,rustc_procmacro)
 
+# `rustc` requires `-Zunstable-options` to use custom target specifications
+# since Rust 1.95.0 (https://github.com/rust-lang/rust/pull/151534).
 quiet_cmd_rustc_library = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) L $@
       cmd_rustc_library = \
 	OBJTREE=$(abspath $(objtree)) \
@@ -447,6 +449,7 @@ quiet_cmd_rustc_library = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) L
 		--crate-type rlib -L$(objtree)/$(obj) \
 		--crate-name $(patsubst %.o,%,$(notdir $@)) $< \
 		--sysroot=/dev/null \
+		-Zunstable-options \
 	$(if $(rustc_objcopy),;$(OBJCOPY) $(rustc_objcopy) $@) \
 	$(cmd_objtool)
 
-- 
2.51.0

