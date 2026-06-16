Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED8526CE05;
	Tue, 16 Jun 2026 17:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631392; cv=none; b=VR+h5eOQKZV6flJGFhIpV6gLP728MNbnKjCNkb4SCBt1uHvmdbSs/z8SB6JZLazoACbfmHN6zrkPxHUN4RtXAisOz1ZUC/oQSjRHer8yox5e8s8JF2dR7HQi60GpK8MTnTkNF8AIZ4awdGRhJx5/HXeI6TPoRoPqD5Fv726pBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631392; c=relaxed/simple;
	bh=bRtpTNc59MCfN2uhWSRma1ps2H8l8pHgNVeJ8wiL5Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBhrYsnwffTPJIrCyO1+78ED9bCFvp+Mq2ixQ6XBtaNL9nyTCy8GcnjEnAtVAgJ8veuVMgVRPrqTFrHleyoBWdSPEV3FDPSpHBpoawnSqZqCwzt0QyRxwuWQBpJex0I5sKbmqG9fSb18I30l/6YVaPMceyPhpEU3LE+sUcBtQY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkO8n4Ri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkO8n4Ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4878A1F000E9;
	Tue, 16 Jun 2026 17:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631391;
	bh=V0V4wP179+bXFPUnGKzh9cYccdDn3vBssONbHMhLFMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkO8n4RimYELCgMr01xoqe/sk4XbXP6XlnBt5qSiz8WUAiB/e9m67A/on2+91jLgT
	 I+5FfH2MFWkz3mJd7aY35qNopfd2Yz1m4+tuy7YGp63r7GJgcZr1MD4ukA8Hne+3wz
	 mLDGoaw5SCYlrgWAR4J1XsGx6b863WFCfwJUOyuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/522] HID: core: Add printk_ratelimited variants to hid_warn() etc
Date: Tue, 16 Jun 2026 20:25:26 +0530
Message-ID: <20260616145134.510910448@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 1d64624243af8329b4b219d8c39e28ea448f9929 ]

hid_warn_ratelimited() is needed. Add the others as part of the block.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 6c3dc24acefc2d..058ba486fdcf87 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1230,4 +1230,15 @@ do {									\
 #define hid_dbg_once(hid, fmt, ...)			\
 	dev_dbg_once(&(hid)->dev, fmt, ##__VA_ARGS__)
 
+#define hid_err_ratelimited(hid, fmt, ...)			\
+	dev_err_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_notice_ratelimited(hid, fmt, ...)			\
+	dev_notice_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_warn_ratelimited(hid, fmt, ...)			\
+	dev_warn_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_info_ratelimited(hid, fmt, ...)			\
+	dev_info_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_dbg_ratelimited(hid, fmt, ...)			\
+	dev_dbg_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+
 #endif
-- 
2.53.0



