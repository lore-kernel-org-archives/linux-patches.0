Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459EE19A288;
	Fri, 24 Apr 2026 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037955; cv=none; b=eVp7mQqgWd7y66dnueNnCNOQ4C3RWgJ++zuOiwDdR8N5toobSi4gcYCqkOjvEdSHRUvwZLpNJHP1sH8SsYt9kLvS7vIHDEzcn25njOVSUckIhTQu4iJABrMQoFRf6/H1SGY4VlKTWmiIXeip5PkBEUHPqGA8O1wAyJuGiuCjJMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037955; c=relaxed/simple;
	bh=Ns5GIZe5MwnM0QaHF7B7gXBHBLpR1i00HGryUQykLy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ0Mls35jCZVzUAnDKoURg7P9MzZCKbmIzyFR+dK2h1yCgMNa7iZU5wdGdNFotX56rGNEGhJUiZHuytj8BZ4EnU9atgzICcB/2jY7FQFFImaBoJfqKOLAtbubd8z2Vs36yT7SgmJcWuccSAe3YxV4wIyIJje3nKoxknlV9ZeLpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcBDK/3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcBDK/3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC491C2BCB5;
	Fri, 24 Apr 2026 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037955;
	bh=Ns5GIZe5MwnM0QaHF7B7gXBHBLpR1i00HGryUQykLy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcBDK/3r95a1Sj8Tw905dTN+X724fU+mmToOXZgGVUOTz+uLFSJh9FTops3AYma4Z
	 EWxSumZfVesgRPVoxdEUASs9x+yVDIymhSJNEuon4VAYCCsFu11XxJoo3RvZnf1uWf
	 uFu0WCzl9B+nlvBVXbUoPyTdw3xjk14Tr3dRNyRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Fiona Behrens <me@kloenk.dev>,
	Trevor Gross <tmgross@umich.edu>,
	Tamir Duberstein <tamird@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/166] scripts: generate_rust_analyzer.py: define scripts
Date: Fri, 24 Apr 2026 15:30:49 +0200
Message-ID: <20260424132601.140346669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@kernel.org>

[ Upstream commit 36c619f6bd793493294becb10a02fea370b67a91 ]

Add IDE support for host-side scripts written in Rust. This support has
been missing since these scripts were initially added in commit
9a8ff24ce584 ("scripts: add `generate_rust_target.rs`"), thus add it.

Change the existing instance of extension stripping to
`pathlib.Path.stem` to maintain code consistency.

Fixes: 9a8ff24ce584 ("scripts: add `generate_rust_target.rs`")
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Fiona Behrens <me@kloenk.dev>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Link: https://patch.msgid.link/20260122-rust-analyzer-scripts-v1-1-ff6ba278170e@kernel.org
Signed-off-by: Tamir Duberstein <tamird@kernel.org>
[ changed `[std]` dep to `["std"]` and kept untyped `is_root_crate()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -119,6 +119,18 @@ def generate_crates(srctree, objtree, sy
         "exclude_dirs": [],
     }
 
+    scripts = srctree / "scripts"
+    makefile = (scripts / "Makefile").read_text()
+    for path in scripts.glob("*.rs"):
+        name = path.stem
+        if f"{name}-rust" not in makefile:
+            continue
+        append_crate(
+            name,
+            path,
+            ["std"],
+        )
+
     def is_root_crate(build_file, target):
         try:
             contents = build_file.read_text()
@@ -135,7 +147,7 @@ def generate_crates(srctree, objtree, sy
     for folder in extra_dirs:
         for path in folder.rglob("*.rs"):
             logging.info("Checking %s", path)
-            name = path.name.replace(".rs", "")
+            name = path.stem
 
             # Skip those that are not crate roots.
             if not is_root_crate(path.parent / "Makefile", name) and \


