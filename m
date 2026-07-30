Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E2E450901;
	Thu, 30 Jul 2026 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428027; cv=none; b=slCKwjDLvIi3K1rFxk9Of6qDn61m8J1sR86i+FW9KWb4OpVa0uhrAmoqdzeIEpwkPvFX69PXgjb4lhmxFQJM7QFdJ2rrsN9YsmFCk0BsL/b0sRn5edTzlnUpANMi6bcRPklR7VPBNa4M2WyYzCanJ1gCpienlWkSXUMj3lMPbco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428027; c=relaxed/simple;
	bh=TXOI53Vg798HK8GNJMQS46fuVirWVKZ27TXCmd3ObAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQo5l+Kqi9rZgNLMV1ha19ECqEK8agGh+tSLL3iJ31+4T8tz7SfmjQbGrKKepYb4DwRaaBDOIpRdsYliLT/rOJWqHv94fiMGVtd4HiMzK1ICdcbOcE4CEeEkhbM5U6jm75teoYx/NvgH+JE1J6xnXn9oOSeEgDObBIgsAtM0lZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tl+JTbFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tl+JTbFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FC91F000E9;
	Thu, 30 Jul 2026 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428025;
	bh=vrox839mmc9+R1tPkXZWXsqtUtQm8rOWvJpPWdaOVjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tl+JTbFGImQgfOfHmDGYPNdPgEN/TL3hlg6tBjZhr+CzLqeRUwUcs5eF+9DWygwjA
	 ItrMdvAmwaMAybFdWfBRqy/EA9GFMXSRahHnUwHRLNgjGWu25rNkNwMxM4NxEnCGMT
	 22gXDu4BZJSdleKB4UvI3TfOcLTURF+NHSvSvCZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/484] afs: Annotate struct afs_addr_list with __counted_by
Date: Thu, 30 Jul 2026 16:14:35 +0200
Message-ID: <20260730141431.683491177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 2d26302bdff1300029a67931739f5770eac22493 ]

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct afs_addr_list.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: linux-afs@lists.infradead.org
Reviewed-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20230915201449.never.649-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: dc175389b18c ("rxrpc: serialize kernel accept preallocation with socket teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -87,7 +87,7 @@ struct afs_addr_list {
 	enum dns_lookup_status	status:8;
 	unsigned long		failed;		/* Mask of addrs that failed locally/ICMP */
 	unsigned long		responded;	/* Mask of addrs that responded */
-	struct sockaddr_rxrpc	addrs[];
+	struct sockaddr_rxrpc	addrs[] __counted_by(max_addrs);
 #define AFS_MAX_ADDRESSES ((unsigned int)(sizeof(unsigned long) * 8))
 };
 


