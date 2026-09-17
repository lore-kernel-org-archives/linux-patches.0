Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA233B6F9;
	Thu, 17 Sep 2026 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659079; cv=none; b=RNY7GQ/+7lWnxjZnmYDjxWGrTgVpPchMQUS6G5zFqV0GMHxIzPiGZEq9+DUSvdsGb8yd1fkjK1HXjyeEIL4ekgAe+nyzCOH/mfT01tYPvAjwYO48+eoYT0wu+a4HUyo6zb5TRv8LNHMuU8Ziy1juqmf8kN5bbYp8bVSPw6xCTww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659079; c=relaxed/simple;
	bh=x7maBbbsDgCPW3mo2dbeMfe0u8CUgj+e9kD14FRuxHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u20DqziXA7GbbeRWYZNHtNZAZ+IAJ0hTcby/7fuUSAa4Jai0NLedvK0RUfy8/JYsznsIlu2b7tKZmE4o+LiWDvk7JQiDYnBkA8au/Uz9GttT0Hj/HoLtxMrMkGiJPeqlGO2szbgcCli/fGmkoILLFD43YhTUaDNyUwKjyq1URvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFTlfZrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFTlfZrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3061F0089B;
	Thu, 17 Sep 2026 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659069;
	bh=drRYaDALliuqRXUycj4YkZGCMsWEvzh+xQXAJkASQVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFTlfZrDuTtRdvNPPttuTru+YwgXN/gOO+ADPw+g0whLPYFn8H0bYyarI3D8yDJVn
	 oQa6/eljFuvdWYramz3Cfhbfe9XiyrQY8F8ZwJ6qIMzdFteYeGMrEj8Dgk4H7le8Q9
	 aqH0sG8iwUH6m3Asd5R1crsA0lVezg7k5d5SBf+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 134/733] rust: samples: add missing newlines in rust_print_main
Date: Thu, 17 Sep 2026 16:07:22 +0100
Message-ID: <20260917151354.367273926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>

[ Upstream commit e510334fbaeaa016ac76d80b4c5f47611c5f7860 ]

Calls to `pr_info!` in `arc_print` are missing trailing newlines, which
are expected as the `pr_*!` documentation shows.

Add the missing `\n` to all four formatting strings.

Fixes: f431c5c581fa ("samples: rust: print: Add sample code for Arc printing")
Fixes: 47cb6bf7860c ("rust: use derive(CoercePointee) on rustc >= 1.84.0")
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1139
Signed-off-by: Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>
Link: https://patch.msgid.link/20260828015148.221737-2-mehmet.mkoseoglu@gmail.com
[ Reworded to fix the description of the missing-newline behavior. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/rust/rust_print_main.rs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/samples/rust/rust_print_main.rs b/samples/rust/rust_print_main.rs
index 682207c81fc2b..01729e87d6b5a 100644
--- a/samples/rust/rust_print_main.rs
+++ b/samples/rust/rust_print_main.rs
@@ -23,10 +23,10 @@ fn arc_print() -> Result {
     let b = UniqueArc::new("hello, world", GFP_KERNEL)?;
 
     // Prints the value of data in `a`.
-    pr_info!("{}", a);
+    pr_info!("{}\n", a);
 
     // Uses ":?" to print debug fmt of `b`.
-    pr_info!("{:?}", b);
+    pr_info!("{:?}\n", b);
 
     let a: Arc<&str> = b.into();
     let c = a.clone();
@@ -42,7 +42,7 @@ fn arc_print() -> Result {
 
         use kernel::fmt::Display;
         fn arc_dyn_print(arc: &Arc<dyn Display>) {
-            pr_info!("Arc<dyn Display> says {arc}");
+            pr_info!("Arc<dyn Display> says {arc}\n");
         }
 
         let a_i32_display: Arc<dyn Display> = Arc::new(42i32, GFP_KERNEL)?;
@@ -53,7 +53,7 @@ fn arc_dyn_print(arc: &Arc<dyn Display>) {
     }
 
     // Pretty-prints the debug formatting with lower-case hexadecimal integers.
-    pr_info!("{:#x?}", a);
+    pr_info!("{:#x?}\n", a);
 
     Ok(())
 }
-- 
2.53.0



