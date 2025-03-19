Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C31DE4C9;
	Wed, 19 Mar 2025 14:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395155; cv=none; b=OMdLYOwbM+y4hBWjlBe+Cu56CIrnhYgQ4RB71gMp1kuNQ24lQwiNB+Q15+lViWEGoNA5hztKdm7QRQY1jSeaAy8TnhQ4l7PMWyYh1W27QdhZ7YewQ8g33il6H7tb6KoZqpsdR06XszC0wftn7Z82HTzS2//JrMbAKyjxcH7uPMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395155; c=relaxed/simple;
	bh=tT+pB8SKwgXczENcgIyju9GNi6DvuuPAGerpGZd5UBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKNmUbSJPxujOCyypjoG5S1qdF4ol4bYLkaaIG+RpDmRlpHA+nQf4IceUFmX6qwrCF2abU+e9kzig4gfEDu90ZPKWDt5+k24Rqc2Le+PEchZnCP4ypW0v+TcrqWuS3Wj5bbZb2WitzlAaobb3DFq0qxExrnn22jGpiCrJkd3Qqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQ56CmyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQ56CmyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26916C4CEE4;
	Wed, 19 Mar 2025 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395155;
	bh=tT+pB8SKwgXczENcgIyju9GNi6DvuuPAGerpGZd5UBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQ56CmyZTflKFxe9RRY1Aurf7DkXOtDGvBl/NSAULflcYefcJ+WCcevfod/0JBxeX
	 hZr2rMkyIUNl51f1WvizH8JW/6U4OGbTwl+tjh1QormEbUG8Fxwsec00lFtB6OyNMf
	 Lic/3Ss9ebIv/SktcuiRoJvWrPJUoyNdOyaKInz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/231] scripts: generate_rust_analyzer: add uapi crate
Date: Wed, 19 Mar 2025 07:31:46 -0700
Message-ID: <20250319143032.112697742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@gmail.com>

[ Upstream commit a1eb95d6b5f4cf5cc7b081e85e374d1dd98a213b ]

Commit 4e1746656839 ("rust: uapi: Add UAPI crate") did not update
rust-analyzer to include the new crate.

Add the missing definition to improve the developer experience.

Fixes: 4e1746656839 ("rust: uapi: Add UAPI crate")
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Tested-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/20250210-rust-analyzer-bindings-include-v2-2-23dff845edc3@gmail.com
[ Slightly reworded title. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/generate_rust_analyzer.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index 2a64067b09b0c..d1f5adbf33f91 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -110,7 +110,8 @@ def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
         }
 
     append_crate_with_generated("bindings", ["core"])
-    append_crate_with_generated("kernel", ["core", "macros", "build_error", "bindings"])
+    append_crate_with_generated("uapi", ["core"])
+    append_crate_with_generated("kernel", ["core", "macros", "build_error", "bindings", "uapi"])
 
     def is_root_crate(build_file, target):
         try:
-- 
2.39.5



