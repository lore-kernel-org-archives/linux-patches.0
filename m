Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774371;
	b=iWtUBF+bI3w05NwEcI88PCN2JvItmE2qRqgAYbr79y57t5vapQ8IlL5iNSPahJPtSQ3e
	 OCeaM/hT3wh9UKbzfJODNz1H/thLAG57gWCZ/BFW8bwXKYOA4CX+3GfJeR1cKVbLxJ7sF
	 HRUEU28kE2LtXoqWHrt7sTprwiX5rQQKb/k9aLIcfVuLkv1hURSi1RnU9HwS6m4qxqZou
	 Gj3uwzeDEm2i5NI8qABp19KMOWbclxAWvIW3JctouhiXBq7h7cxouxiz6NNNVN83dUlBN
	 TOjau96ddyOsCfjeqyxnyYAfF5j0hdXg6cvuFhrAzof+46MYz76wr72mDRuJhojrWsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NV8pnxioBDg6f7qm07GNIuNkS71Hp4j8IpdG+vrm+40=;
	b=WHGNKkgCBM8qAzGFSIv3zneKbVTWou5lujYHXWzan3WHB1B7TWBXDK/alqGZVAEMoKLI
	 yiqeJQhnHAOa+SF6g1IjqBLZJ7Hn1mTmPUPrh/qEWHxb2j3ewmAGHI0YD3fGdQRHPzK7N
	 Juc4wIK0wcc0Ro5MIZlV0oMSx03nMc0SsyJ+BUneQDNvfCcPLar78vD2BaxCBrjY9eTbk
	 wLlUhm2SAgS1LTLS31n4dxzUdwPJJCcAqAuzXhdX1r7WBKb4JFgDBebMJ5dhpo1GPcfOW
	 rLff7D/gsPr+cxkvKksdo4o2skXjA0mnQMHLQOwPPEDRFP0XiKa1sWm7eylXcCOGn2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lM6IRRsh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F214606A31B;
	Fri, 23 Oct 2026 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lM6IRRsh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC5B1F01825;
	Fri, 23 Oct 2026 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774371;
	bh=NV8pnxioBDg6f7qm07GNIuNkS71Hp4j8IpdG+vrm+40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lM6IRRshK3sCyaFzlXD+ZrydnzYG4nuZby8WVX04chZl1Dn4Jh/Fq0YHeNOpQD1rC
	 Xqhig8UTwtqq94446yXpSxNOOKndfxksRmKNg/P8W2fnaEDSSQPCu2ZGoHz6xcURwu
	 s4PZdcCWZOjVkS4QovZbYB9dYmCbBP666smPpsUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 019/242] tools/power turbostat: Fix CWF PMT off-by-one
Date: Fri, 23 Oct 2026 18:37:41 +0200
Message-ID: <20261023163714.238479253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 5e940dd96bef6ca03b3b1b4740351237e5ec17e3 ]

Fix off-by-one error causing last CPU on CWF
to never get a pmt counter allocated.

Fixes: 5ce1e9bbb2a1 ("tools/power turbostat: Add CPU%c1e BIC for CWF")
Assisted-by: GitHub Copilot (claude-sonnet-4.6)
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index fc488157d3a37..01644d858a98f 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -10441,7 +10441,7 @@ void pmt_init(void)
 		mod_num = 0;	/* Relative module number for current PMT file. */
 
 		/* Open the counter for each CPU. */
-		for (cpu_num = 0; cpu_num < topo.max_cpu_num;) {
+		for (cpu_num = 0; cpu_num <= topo.max_cpu_num;) {
 
 			if (cpu_is_not_allowed(cpu_num))
 				goto next_loop_iter;
-- 
2.53.0



