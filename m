Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81212D8768;
	Wed,  4 Feb 2026 15:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219218; cv=none; b=pYQiVSXs+wBu/ZwGmYmqptzmi3ZgV2mbYhpA0OfFMWIHfOcAei2PGaPrViKXJp9oeMgaqIl450bgG2zw5tKLS8QB8459GlTWNcv2UQy707eBE/8gIxk2LXj06iev6nik9/mDhjEiLbEpIwZuyuyTZTQMGO5fTNc3eFuMI2dCi0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219218; c=relaxed/simple;
	bh=Sr1FqpdHT7Vm1mkszt+aC8jBXP5PiKC5t6o3k/mnEmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwA5w1+pdC9gpnBZXbqr1pEhInGC7ovuZnqLuDqLpPzefYIlOAUF5MzJXj/OtvvH4/DdNri6Hn1HhocCaq6Xxj/C3fLL/S5ymOoJE5xooa8150+XWEwBhId2iXOf/Ho3fwG80JgfzzsoYI0ocUszX6Xt7CAeNM3nr8QnB4FpmEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdBu2ss8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdBu2ss8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BC6C4CEF7;
	Wed,  4 Feb 2026 15:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219218;
	bh=Sr1FqpdHT7Vm1mkszt+aC8jBXP5PiKC5t6o3k/mnEmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdBu2ss8enkvS0TGoIXL8kSxCYhNc6F05R84JRBkL/FHDSzexpAC1+E3ImXBRJRnq
	 Tv9BAj4Pg84MMB/xuWVWNrFaY1oNYO33HtnZ3gir9wlAJwqo2udiryJ2VPjRqtuQu3
	 7K/Lyp3Mvk0cZ/QSR5+fR1eXrYgsTROIBYD6arlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@kernel.org>,
	Jesung Yang <y.j3ms.n@gmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 095/122] scripts: generate_rust_analyzer: Add pin_init_internal deps
Date: Wed,  4 Feb 2026 15:41:17 +0100
Message-ID: <20260204143855.269167149@linuxfoundation.org>
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

commit 74e15ac34b098934895fd27655d098971d2b43d9 upstream.

Commit d7659acca7a3 ("rust: add pin-init crate build infrastructure")
did not add dependencies to `pin_init_internal`, resulting in broken
navigation. Thus add them now.

[ Tamir elaborates:

  "before this series, go-to-symbol from pin_init_internal to e.g.
   proc_macro::TokenStream doesn't work."

     - Miguel ]

Signed-off-by: Tamir Duberstein <tamird@kernel.org>
Reviewed-by: Jesung Yang <y.j3ms.n@gmail.com>
Acked-by: Benno Lossin <lossin@kernel.org>
Fixes: d7659acca7a3 ("rust: add pin-init crate build infrastructure")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250723-rust-analyzer-pin-init-v1-3-3c6956173c78@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -102,7 +102,7 @@ def generate_crates(srctree, objtree, sy
     append_crate(
         "pin_init_internal",
         srctree / "rust" / "pin-init" / "internal" / "src" / "lib.rs",
-        [],
+        ["std", "proc_macro"],
         cfg=["kernel"],
         is_proc_macro=True,
     )


