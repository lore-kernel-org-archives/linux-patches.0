Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A583187FEC;
	Tue, 30 Jul 2024 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355347; cv=none; b=Ypg9OWlKyCSBLjaQyrY4C1nToaH7QHa7Sz2jR/VjNj9cNvHgx3vIMCoWIy/bfyK2yU7kwb/kAQdTjCv2vJaPT1zp/lc/WTVstWQ3lAJNNoWZk7R1+GroGV+RoyZ8J71y0x4qMGSwWzfMAxRiHuySLOb6E+QmD0/9yBZjdxtR/Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355347; c=relaxed/simple;
	bh=awwjwgviDilkjdv874Yg9g/lT/VTc8McVAw9r3UIumY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwDoqKF8l6xgE1vLlKwLJnIYzONLPld3bf3um9dNkQzjDx4Iuoa0w1uCpF/xOp8HCKpVdyvYP3s3ixzIUhDYSgshdOCKI+YrLUWq4k5uZI6XEtCyerGTo63oABvnP9KP+5gWniG24zyx90nCBoCIPBK0bKi25jPtJkIC99WSKAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHKlRyAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHKlRyAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C3AC32782;
	Tue, 30 Jul 2024 16:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355347;
	bh=awwjwgviDilkjdv874Yg9g/lT/VTc8McVAw9r3UIumY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHKlRyAKinf8WFg4NfCDK54sZn0mSWsl6/kX3YQAXjQdYLDQq8HPbCP0JE3NWF3Ef
	 N70XkaWbGthvtJRJhjrkQbVkqKQUR/r236dPDPf21pLIakoxdQD9a0BFNr+odl/zUc
	 N5gM6Kf5vXiLAvPcYpE1DkcnwGAyjqyqN6tq6ssQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/440] x86/xen: Convert comma to semicolon
Date: Tue, 30 Jul 2024 17:45:06 +0200
Message-ID: <20240730151618.615253972@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 58db86f7b3846..a02cc54338897 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -736,7 +736,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 		 * immediate unmapping.
 		 */
 		map_ops[i].status = GNTST_general_error;
-		unmap[0].host_addr = map_ops[i].host_addr,
+		unmap[0].host_addr = map_ops[i].host_addr;
 		unmap[0].handle = map_ops[i].handle;
 		map_ops[i].handle = INVALID_GRANT_HANDLE;
 		if (map_ops[i].flags & GNTMAP_device_map)
@@ -746,7 +746,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 
 		if (kmap_ops) {
 			kmap_ops[i].status = GNTST_general_error;
-			unmap[1].host_addr = kmap_ops[i].host_addr,
+			unmap[1].host_addr = kmap_ops[i].host_addr;
 			unmap[1].handle = kmap_ops[i].handle;
 			kmap_ops[i].handle = INVALID_GRANT_HANDLE;
 			if (kmap_ops[i].flags & GNTMAP_device_map)
-- 
2.43.0



