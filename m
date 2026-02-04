Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5DC286890;
	Wed,  4 Feb 2026 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219314; cv=none; b=RLbNF2EeMnmNKC66eHicD+OzDhBQhM5HxNeRjeCM/Vu7EUBnbNSHdo+L+mrtm1djoazo4R1O//Ss1orWb3oPUxy+tHNz0hnPM5mwute+rem0hGNNXcP4IAelyNZgGpG5BaL6uFPZWPwjdUeI4OVCqt5Mv3DUZJTFi/Rj842b+Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219314; c=relaxed/simple;
	bh=UZpKw81lL08Dj7hYLOPj/oqTjkz0jiSQlPH1+uJk+Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swYy7sqCbP2uJxVhLRscD33rIvTVpIJcaSN5L7CrC5rEmN3ntWdaKIZyUoLtZyCL0/44qT1pbKk+aJaE7o/C2FIphbZiwwGUP0ngeKw874LxdfvLvF/OTsJ/IjNdfQMgt08gWCtB/5zni3DspoO4vg1yUjZumLhPdwEm4msnb6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0lL9gFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0lL9gFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34253C4CEF7;
	Wed,  4 Feb 2026 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219313;
	bh=UZpKw81lL08Dj7hYLOPj/oqTjkz0jiSQlPH1+uJk+Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0lL9gFUtyshpHoRs6UmBXApMBxjGTaTzTOC/2G3tJXWvLbWL4K3vw6coXJsJu3pB
	 Gw+IyiOD/fKz1BugD2I90pSv4wN/E+2ma4UzDvOUpBqK7atNDzE0r44cRjj6KmIi9O
	 DzfJr0RBnaD9cFvSEcVJnJTk2ObGrylOkNA2ZBuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@kernel.org>,
	Jesung Yang <y.j3ms.n@gmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 094/122] scripts: generate_rust_analyzer: Add pin_init -> compiler_builtins dep
Date: Wed,  4 Feb 2026 15:41:16 +0100
Message-ID: <20260204143855.233218970@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@kernel.org>

commit 98dcca855343512a99432224447f07c5988753ad upstream.

Add a dependency edge from `pin_init` to `compiler_builtins` to
`scripts/generate_rust_analyzer.py` to match `rust/Makefile`. This has
been incorrect since commit d7659acca7a3 ("rust: add pin-init crate
build infrastructure").

Signed-off-by: Tamir Duberstein <tamird@kernel.org>
Reviewed-by: Jesung Yang <y.j3ms.n@gmail.com>
Acked-by: Benno Lossin <lossin@kernel.org>
Fixes: d7659acca7a3 ("rust: add pin-init crate build infrastructure")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250723-rust-analyzer-pin-init-v1-2-3c6956173c78@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -110,7 +110,7 @@ def generate_crates(srctree, objtree, sy
     append_crate(
         "pin_init",
         srctree / "rust" / "pin-init" / "src" / "lib.rs",
-        ["core", "pin_init_internal", "macros"],
+        ["core", "compiler_builtins", "pin_init_internal", "macros"],
         cfg=["kernel"],
     )
 


