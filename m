Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5221AC8AE;
	Thu, 15 Aug 2024 14:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731108; cv=none; b=I94NmZtordM+EkUQG21LOJejJcVY/Ubewl0vZOurNkBWKqbNoN3LSlkgYSS+/yzHtABO9ai6eKFu+H52PiRN54sUsPyErkuQHX5vlWYFFsi71qbQZ1G48m/NULSR/0messbjmcQ4wOFioZa4JNItshBQHUvQ1/wgVaGlBO/GBog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731108; c=relaxed/simple;
	bh=STf7f2RBFSul8Eq9Iohg2B5cVbBuwvotawGHhFnXj6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ju/w9HyTifrIebkOrp39tgSq09nLB6wSCN4j2FG4B312wcLnsnaff26qh7a2rWFlkvCFOCRqD1PBAEZyORw/9vzrneBBlUz6ycFH8X8wVifRWMcbVL1pp0HLrr5FxUBbbMHhWW18YKUskA5SKQILMogUOFrsKlx43L6N4x2dRlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2u3yI73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2u3yI73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D4AC32786;
	Thu, 15 Aug 2024 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731108;
	bh=STf7f2RBFSul8Eq9Iohg2B5cVbBuwvotawGHhFnXj6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2u3yI730QUXuukxetiVWvlaDQEkKUjclF3iO9nG8rxUSZWr7zhN+yEBy19++qHGd
	 i1MI2Md/SRLsBLM5tv9AFtAZfrObMPUijHgboVH2xrQG3p9/GpE8Z8AMY7HRrwFifs
	 y5m8D5nro78vA/QgR7Yqffofy7Eoa9BLECil8c8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/259] x86/xen: Convert comma to semicolon
Date: Thu, 15 Aug 2024 15:22:38 +0200
Message-ID: <20240815131903.769033089@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 349d271416c61f82b853336509b1d0dc04c1fcbb ]

Replace a comma between expression statements by a semicolon.

Fixes: 8310b77b48c5 ("Xen/gnttab: handle p2m update errors on a per-slot basis")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20240702031010.1411875-1-nichen@iscas.ac.cn
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/p2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8b1e40ec58f65..bfe6e862e13e2 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -741,7 +741,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 		 * immediate unmapping.
 		 */
 		map_ops[i].status = GNTST_general_error;
-		unmap[0].host_addr = map_ops[i].host_addr,
+		unmap[0].host_addr = map_ops[i].host_addr;
 		unmap[0].handle = map_ops[i].handle;
 		map_ops[i].handle = ~0;
 		if (map_ops[i].flags & GNTMAP_device_map)
@@ -751,7 +751,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 
 		if (kmap_ops) {
 			kmap_ops[i].status = GNTST_general_error;
-			unmap[1].host_addr = kmap_ops[i].host_addr,
+			unmap[1].host_addr = kmap_ops[i].host_addr;
 			unmap[1].handle = kmap_ops[i].handle;
 			kmap_ops[i].handle = ~0;
 			if (kmap_ops[i].flags & GNTMAP_device_map)
-- 
2.43.0



