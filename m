Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CE3297A62;
	Wed, 23 Apr 2025 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421131; cv=none; b=VqIt+gmMOMYcbdC/8fjqNBefT5nABn6WeL6MqMtPARWy10QSdkH+yQ1i4JtvnTmPG6tBKiOF0kkA2eikk0OtYVDCx7y19beIrmyKbDRxqCa/7kz9U/r4t3/nsJWKt4HCfQCLJZJyHqoOoMvK4AUtZKqUsw1p/xEs5lvnQACJd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421131; c=relaxed/simple;
	bh=egaRAHAW2A59Ky7lry7evxNSsKe9tJYRrD0EdgwUw34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFyB9k35CLT7HU9eFIHjt8WhpHRjR/zByhZBusb9VTHsrRB8pXjDeJyI9NQW7gtioC9fNzQNtk/To5IDXijNBqjcuV5lC09WMOxBLBEYhrKM6IXvjDH0OkASdJeJ6QHoVQt6cKsomvrg/CoFyFj3k6odX57OWM8zbpFD/hBDT34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSp9lOXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSp9lOXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073BEC4CEE2;
	Wed, 23 Apr 2025 15:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421131;
	bh=egaRAHAW2A59Ky7lry7evxNSsKe9tJYRrD0EdgwUw34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSp9lOXQ4vRxChAQx6wmjlzGdIFNfW7ZBZ1V8T1YJpujts+rtc+8+4KfwDu6PIpjN
	 hZi7GHQDFxwidfW1pAoUbLTlG9nTYf/idoB7HTfkjgiSo8xEmAsdsaBnr5i4L/u0Mu
	 4vt4cuWBEB4Oo/qLK87xK0hEsfNadeMsWuU9NNnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Fischer <kernel@o1oo11oo.de>,
	Tamir Duberstein <tamird@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 194/223] scripts: generate_rust_analyzer: Add ffi crate
Date: Wed, 23 Apr 2025 16:44:26 +0200
Message-ID: <20250423142625.077924572@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Lukas Fischer <kernel@o1oo11oo.de>

commit 05a2b0011c4b6cbbc9b577f6abebe4e9333b0cf6 upstream.

Commit d072acda4862 ("rust: use custom FFI integer types") did not
update rust-analyzer to include the new crate.

To enable rust-analyzer support for these custom ffi types, add the
`ffi` crate as a dependency to the `bindings`, `uapi` and `kernel`
crates, which all directly depend on it.

Fixes: d072acda4862 ("rust: use custom FFI integer types")
Signed-off-by: Lukas Fischer <kernel@o1oo11oo.de>
Reviewed-by: Tamir Duberstein <tamird@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250404125150.85783-2-kernel@o1oo11oo.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -90,6 +90,12 @@ def generate_crates(srctree, objtree, sy
         ["core", "compiler_builtins"],
     )
 
+    append_crate(
+        "ffi",
+        srctree / "rust" / "ffi.rs",
+        ["core", "compiler_builtins"],
+    )
+
     def append_crate_with_generated(
         display_name,
         deps,
@@ -109,9 +115,9 @@ def generate_crates(srctree, objtree, sy
             "exclude_dirs": [],
         }
 
-    append_crate_with_generated("bindings", ["core"])
-    append_crate_with_generated("uapi", ["core"])
-    append_crate_with_generated("kernel", ["core", "macros", "build_error", "bindings", "uapi"])
+    append_crate_with_generated("bindings", ["core", "ffi"])
+    append_crate_with_generated("uapi", ["core", "ffi"])
+    append_crate_with_generated("kernel", ["core", "macros", "build_error", "ffi", "bindings", "uapi"])
 
     def is_root_crate(build_file, target):
         try:


