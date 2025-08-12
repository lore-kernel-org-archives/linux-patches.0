Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346D7279DB6;
	Tue, 12 Aug 2025 19:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025827; cv=none; b=rOPowgvdp3bNcIT7BCfj5uDMGjlg6+QDnUJGN+4m7E9gL9Xr7R1WDbDgyFssV234yGiMsy/qZHw924YSgno++Ruc76b65OreMkx9lYSLxx3V8XgveV6eAuH/vsxFx7GGsiYtMud0qkBb3S+cn8zhuvSswrw/XhVMqxHMdNG4e2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025827; c=relaxed/simple;
	bh=L+gquhZjVb7mLpVWiW6pMhzcv4njPE/P7LUbNgvdn5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRjC99fgWmML5tpPOF5cJnFfCMsc7t+VG8qVlhtrtD6ov15hnwUapRHjZLuXokV6CNOxw9AvvanyBj4kigFhwxTFxLIVaelCGHf/SQeZY3L0LJ7u4r9H43y2KegBhdnOnYi7+TkemZh9Pu7GFe6O/OGMVuK/N0scrmmQ2W5hsCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iCNr76J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iCNr76J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FFEC4CEF0;
	Tue, 12 Aug 2025 19:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025827;
	bh=L+gquhZjVb7mLpVWiW6pMhzcv4njPE/P7LUbNgvdn5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iCNr76J2uV2F0WWAsCFD9MonAyjOnI8RTe0rnF1MX9YodWpJDefAMXsZelgLJ1R6
	 N2dq3FYK12sXze+4+1jSAYeh53SNMMuWssrvSY6GzDASNI/3QG8gjoouSX3GpHb5vS
	 MAFvIRwq/I1IFXAqQy7q59WewFNFI78teYB0FECk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 112/480] slub: Fix a documentation build error for krealloc()
Date: Tue, 12 Aug 2025 19:45:20 +0200
Message-ID: <20250812174402.108585009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Corbet <corbet@lwn.net>

[ Upstream commit e8a45f198e3ae2434108f815bc28f37f6fe6742b ]

The kerneldoc comment for krealloc() contains an unmarked literal block,
leading to these warnings in the docs build:

  ./mm/slub.c:4936: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
  ./mm/slub.c:4936: ERROR: Undefined substitution referenced: "--------". [docutils]

Mark up and indent the block properly to bring a bit of peace to our build
logs.

Fixes: 489a744e5fb1 (mm: krealloc: clarify valid usage of __GFP_ZERO)
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20250611155916.2579160-6-willy@infradead.org
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index be8b09e09d30..5c73b956615f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4929,12 +4929,12 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
  * When slub_debug_orig_size() is off, krealloc() only knows about the bucket
  * size of an allocation (but not the exact size it was allocated with) and
  * hence implements the following semantics for shrinking and growing buffers
- * with __GFP_ZERO.
+ * with __GFP_ZERO::
  *
- *         new             bucket
- * 0       size             size
- * |--------|----------------|
- * |  keep  |      zero      |
+ *           new             bucket
+ *   0       size             size
+ *   |--------|----------------|
+ *   |  keep  |      zero      |
  *
  * Otherwise, the original allocation size 'orig_size' could be used to
  * precisely clear the requested size, and the new size will also be stored
-- 
2.39.5



