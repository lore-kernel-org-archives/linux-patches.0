Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888452DCF61;
	Wed,  4 Feb 2026 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218774; cv=none; b=qVYdxXaBY4MbYYFyru4y24jnX8ttIndj5+8kxu4R0FNZ2ualpzqdx74upY9kmfcRNdebrYuueCd7rqgztK28yoPrtArpoojv21tOJcVS7Y7eHm0r2eDicV3D3cp0LnMhv5A8hLnUQzrA3yHG7HvWxbZB+5C6GUs36Qs69YNqdrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218774; c=relaxed/simple;
	bh=qpJcr3ACmJeqm++RZX76Fc+rDwWJloTYdo4lhyBMwAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpcHzsRRdzy46WbmsYG5+uv+NBo47oaQnxmF2fP8dssrEVjIAZAevVXkOY84T15pwIpPo2/GVlNdahCpN0O8fZrsAl2pljw7MXN0ipR7W0j3LULUxs4DocrN0DpU/wwIJt7p/wcZgFgjATfulWEFVINHGI9HzOZk7IryA9oIHMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nI+aCPbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nI+aCPbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E7BC4CEF7;
	Wed,  4 Feb 2026 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218774;
	bh=qpJcr3ACmJeqm++RZX76Fc+rDwWJloTYdo4lhyBMwAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nI+aCPbWVRnm9DhsJn9n4KppKuFur8X2URBlwAF2vl4BKaOkvNp3fK7CZFsnXnPkq
	 LcW/wC8P2mFifhidGQoWNQ8a4aGzG6IV/VCQuvF5mhiB/8W1fEVXW9mv+bhRP+ZQQt
	 1NSn62cstNqa2tqE/UNN+I9mpj2LZtW4c9L92mSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@kernel.org>,
	Jesung Yang <y.j3ms.n@gmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 58/87] scripts: generate_rust_analyzer: Add compiler_builtins -> core dep
Date: Wed,  4 Feb 2026 15:40:56 +0100
Message-ID: <20260204143849.006151659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@kernel.org>

commit 5157c328edb35bac05ce77da473c3209d20e0bbb upstream.

Add a dependency edge from `compiler_builtins` to `core` to
`scripts/generate_rust_analyzer.py` to match `rust/Makefile`. This has
been incorrect since commit 8c4555ccc55c ("scripts: add
`generate_rust_analyzer.py`")

Signed-off-by: Tamir Duberstein <tamird@kernel.org>
Reviewed-by: Jesung Yang <y.j3ms.n@gmail.com>
Acked-by: Benno Lossin <lossin@kernel.org>
Fixes: 8c4555ccc55c ("scripts: add `generate_rust_analyzer.py`")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250723-rust-analyzer-pin-init-v1-1-3c6956173c78@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -98,7 +98,7 @@ def generate_crates(srctree, objtree, sy
     append_crate(
         "compiler_builtins",
         srctree / "rust" / "compiler_builtins.rs",
-        [],
+        ["core"],
     )
 
     append_crate(


