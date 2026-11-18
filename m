Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023882;
	b=z90rxv92hlLIb3Sc7cMdnIeRf/ewRpVhTSrPkstL6CkwPV3pHGqDTd4UjwRTtKHvo6y+
	 M56pOlyG7LRr+WxS3RSR0wF+A/3RFCAJX6UqOg0rb5yWnnP5okUEHCSRiHMhM0rxXnOQw
	 d13P3wjzyy35+TH45c5yyT46HgvQHqchxsOpaDLA3tMLnQ01B2fnHIEep0WWl97Z/Q8vt
	 m4kmTG2t2Kpp5JTTbefUPu34Fmzr4p+lYTMz37VMPmfM0HvguqDinp4Pe7enBD396RsQP
	 XkDWvf8S6mCDU0pjYlrYxUPzatTi51T+exhWXS7s7Ws3ijkzM2b2d0zmK+IgslwLCCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n3BGOPyE3t+1E5r2tUx0YshpLGNFtvaDwiUMtmFsVfs=;
	b=Kj0rQBklV5BoiisSamM5UtzewJ8FEjYYQfA28RLLTX3Q7ciFHWFjahrt4CsICSePDOIK
	 iZB1rZQd/9v19P2Xuh3uuIkTI6dQr7FNe+aER7rm7gcrSxrHvjB2pqSTZAsNTNqE4Wzyf
	 SDkijOcNSPU8DgOWAE58HSxGeO4pte3cmo3MkfCe8ZTDVFgzfWmLYs9xMHPUqPWeWF00C
	 6+LZg8scRE3Qcyt/4fngXbL/UgBEjq4ufryevpiEAWqI2htgTqqO1xZ/tLffq+3AiXu/k
	 isgDFkDE5n794d7RA5G/YTP7oyDqrcQHtOGu+0fsNdvJJQAHEkHpEikn/NpIOrbyMSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkoArBk+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEFF606A31C;
	Wed, 18 Nov 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkoArBk+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1721F000C4;
	Wed, 18 Nov 2026 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023882;
	bh=n3BGOPyE3t+1E5r2tUx0YshpLGNFtvaDwiUMtmFsVfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkoArBk+w7/nq0fgFJZ18QzPLKbrpLi0LKU+Tn8Y+avJ06YGwJGZ9XfymBbZ3m3o3
	 pNp7oVv2FBLEoUH7pA5ysDo1uzimHcIONhKbjKcWXPJ4RJeShG8VR6mY3cUh9e3dlO
	 Yv66slH4vpGLFeo51gbwCil6ABvCJYfaqCKODcuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Li Ming <ming.li@zohomail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0528/2151] cxl/core: Skip einj_inject creation when devm_add_action_or_reset() fails
Date: Wed, 18 Nov 2026 15:37:43 +0100
Message-ID: <20261118150141.261217467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit b25af6afd2f26b455108bab03dfeba52378e8dd2 ]

cxl_debugfs_create_dport_dir() ignores the devm_add_action_or_reset()
result and creates the einj_inject file below @dir unconditionally.

When the devres allocation fails, remove_debugfs() has already run
before devm_add_action_or_reset() returns, i.e. debugfs_remove() has
released @dir. The subsequent debugfs_create_file() would then use
that dentry as its parent although its final reference was dropped in
the removal and its memory is subject to call_rcu() delayed freeing.

Skip the file creation in that case, consistent with how the rest of
the helper tolerates debugfs failures.

Fixes: 9185b1a3043c ("cxl/core: Fix dport use-after-free via the einj_inject debugfs file")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915060138.2007974-1-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index bfb2e457fa223..b9a585f64b8ab 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -858,7 +858,8 @@ static void cxl_debugfs_create_dport_dir(struct cxl_dport *dport)
 
 	dir = cxl_debugfs_create_dir(dev_name(dport->dport_dev));
 
-	devm_add_action_or_reset(dport_to_host(dport), remove_debugfs, dir);
+	if (devm_add_action_or_reset(dport_to_host(dport), remove_debugfs, dir))
+		return;
 
 	debugfs_create_file("einj_inject", 0200, dir, dport,
 			    &cxl_einj_inject_fops);
-- 
2.53.0



