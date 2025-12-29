Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0DF331A7B;
	Mon, 29 Dec 2025 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025857; cv=none; b=j4Oz9P2YXQQQwrsxmt71AY4nPga0olBoEVAQC5mP4rtjIAT676BPRaYfFdkZJJZwCmhou1GA6W0Qa7aikKCqYKPORJiOHvfpbP9WKtChiCEJ9FMn2BqyvXyw7WVUuKNLzW3aAWm7yTkUSyy3wyTkh28/8YVg29pYEgWOnzt/10M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025857; c=relaxed/simple;
	bh=80Ttkt3Z6u/QazVLzrJTeV7Si+Dre+vK2cMx061dOKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNN9hkeYmOxheFN7sc2JpIL9VilRlMpIdUOQtDLiaFSg7ehAbF81zqi6Pxl7KZesgycuW5LWVVFKM4074zufXDegPjUJsWjC9Xj9Znn9HF0fIqiZttkIialeCrIhZ1QRZ/kdciOZOrOvC9sEE69Xgshrkkkle0WOcbFeHICh5aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCqYLpt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCqYLpt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D45CC4CEF7;
	Mon, 29 Dec 2025 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025857;
	bh=80Ttkt3Z6u/QazVLzrJTeV7Si+Dre+vK2cMx061dOKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCqYLpt+cQ7nsn6NSg0jni5R+1tdazZ7A/4kfMLQjxg5Ai87KBGQHOUPskSIYRVoA
	 oWcazndFJvP47PZ3vCR28bNoRecmG6ITvEKIblm1HfQOMhgEHAO4nAk1G4ob+2/zfl
	 t0Xgv5VdrmBEsONYZcXS1+nq7i+raKd+17SzSUug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Mirabile <cmirabil@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 362/430] lib/crypto: riscv: Add poly1305-core.S to .gitignore
Date: Mon, 29 Dec 2025 17:12:44 +0100
Message-ID: <20251229160737.651971167@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Charles Mirabile <cmirabil@redhat.com>

commit 5a0b1882506858b12cc77f0e2439a5f3c5052761 upstream.

poly1305-core.S is an auto-generated file, so it should be ignored.

Fixes: bef9c7559869 ("lib/crypto: riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
Link: https://lore.kernel.org/r/20251212184717.133701-1-cmirabil@redhat.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/riscv/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 lib/crypto/riscv/.gitignore

diff --git a/lib/crypto/riscv/.gitignore b/lib/crypto/riscv/.gitignore
new file mode 100644
index 000000000000..0d47d4f21c6d
--- /dev/null
+++ b/lib/crypto/riscv/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+poly1305-core.S
-- 
2.52.0



