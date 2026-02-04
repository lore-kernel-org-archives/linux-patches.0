Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF1C413254;
	Wed,  4 Feb 2026 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218112; cv=none; b=KrMonj3T54xqm5fn1SCqn4pcoUKZZj6vdaaxvW3vVVDwjw/M/kCMrTFHJe+YjSUV00YsbEbFZ0hJNSDotd+hxovWjDsRCLNXD1TS94BG8ParAlxIQzhWOTuBeQetCgOsVqVJTE0n3S6MmZxAq07Furey4BGweB0Zb+Mcldx2fFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218112; c=relaxed/simple;
	bh=h5dIhxU6O0StiXw8Ua24dY3EPoXj9Sl8IImOdoQCbVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PajwhsAQIyti58iqIkhtK07pd+2gauAy6Oedu50vABJzhKn3V0RiZppKUqgRKZvLSqDwM+bgYGJ0dcFuDdkQm6mTa1YxTwesMvntT8tv+SG1iYPSbfjUvJL3w1i1wZzagPxSvxwG7RMnVOfTRpBewfjDvWw3p/d90M2FKottXhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPsPpP03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPsPpP03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851AAC4CEF7;
	Wed,  4 Feb 2026 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218112;
	bh=h5dIhxU6O0StiXw8Ua24dY3EPoXj9Sl8IImOdoQCbVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPsPpP03p3ub2qkwx/F0p5JXzSJKLCK/4ul+E2fhGGS2ZPEUyKAeYRvte3/ubUIrB
	 a2qSsBVpZB/ikFQ3nMytIxssZN6NuiL+o63tiNFGuFiGkBpJ3b9mTTLmuH5mXP+cUP
	 kgNCXBDZ/H4ProQbe0KH7I/a/8TYa1nTAKWJxM44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@kernel.org>,
	Jesung Yang <y.j3ms.n@gmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 215/280] scripts: generate_rust_analyzer: Add compiler_builtins -> core dep
Date: Wed,  4 Feb 2026 15:39:49 +0100
Message-ID: <20260204143917.346947201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -73,7 +73,7 @@ def generate_crates(srctree, objtree, sy
     append_crate(
         "compiler_builtins",
         srctree / "rust" / "compiler_builtins.rs",
-        [],
+        ["core"],
     )
 
     append_crate(


