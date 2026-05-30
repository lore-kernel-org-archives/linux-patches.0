Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DE23242BE;
	Sat, 30 May 2026 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159785; cv=none; b=mRlsn57TUBB+UzmamsisKvKS3modLLqGNYI+1O1a7A1KTGTRo2QUqhNzdupbbFekG2KXq+ztJ8Qb7Xam9nrnvxMuXr4XKQrHyMLMoLdpDrrvfvgkUtYtTaX3XTPGPbUVssGxYTIFJ4uIZLwNk7UkPeIjk3hXEwCNK3Tfx5qu6rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159785; c=relaxed/simple;
	bh=iZT0CN7S4A2jLOWkTy6xbvq/zfZyOrOnc+e1W+yc4sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1eHWXhFu1N+SDb93s3tPI+IBHnirMj9PgGakAgpT3y1IVHhhcycVhB/U0Ndp7TlwNIh4qfhPJJysRutVFEZn4zAxcJoWC+9+s62CULninjgqc4M4W78hszcAPml2/ia++yJebcE7M06+Pm9+6b+SXmkxnZKVBA1I/4+E/GDwms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPtbwItM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPtbwItM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4EF1F00893;
	Sat, 30 May 2026 16:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159783;
	bh=pWLRkusrer7Ww/kKd7EL43uJxjwu3mSLAgatrqqxiG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPtbwItMgqBQ/j0SkLzUdXv+BlAKbTW6fwALutBwqvHzy7zQNO/MT0xYawL75nvbl
	 E6efAVIFih985GHmh98TwkuiaEWw54hTAqV/7XMFQAnSGOyyWPwIbw520Z1TvK/2+M
	 q2w2C3RYW9n9jTsPgBaAzPgWxW5k1/5oofgjaE7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Fiona Behrens <me@kloenk.dev>,
	Trevor Gross <tmgross@umich.edu>,
	Tamir Duberstein <tamird@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/969] scripts: generate_rust_analyzer.py: define scripts
Date: Sat, 30 May 2026 17:54:14 +0200
Message-ID: <20260530160304.161820555@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -113,6 +113,18 @@ def generate_crates(srctree, objtree, sy
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
@@ -129,7 +141,7 @@ def generate_crates(srctree, objtree, sy
     for folder in extra_dirs:
         for path in folder.rglob("*.rs"):
             logging.info("Checking %s", path)
-            name = path.name.replace(".rs", "")
+            name = path.stem
 
             # Skip those that are not crate roots.
             if not is_root_crate(path.parent / "Makefile", name) and \


