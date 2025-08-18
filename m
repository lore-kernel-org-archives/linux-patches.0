Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957482E22AF;
	Mon, 18 Aug 2025 13:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523806; cv=none; b=RY7aMlytF7JKGERglNoiClQ9O2tvfZXgA1wh2ZDnE0pZpp9fJMuiJMTYMIHI4zQDs8RdVWDQPt9RjpLab2gwZRXnMMUnDpdibqYXGEOI65M8EEQ91pbRBhuMarrTzi16R3KVKWR4CBrsM0qCmCscdQ0MYT8VQyXhYtKcj1iDL5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523806; c=relaxed/simple;
	bh=y89Jl75u+36RaOzpcenKCTlL3rWAYU00a+/crcMQJuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkPd5xMSwa0CSOzzRtwOBMvS/4wCVLAAqb7prDYrMTD/6JBo9YtHdTg67FX3TGadde3/KJ5Ee9PnwgrUXDOQyIpRU11+zZc3P4xg6dBCAdTpz0sHpfJAnacpDqQ2XBv0YsnWKOt4d7Iu1vwCp0yb9alHwreKaT/7Gl1I4tWH1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ca9gynEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ca9gynEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A31CC4CEEB;
	Mon, 18 Aug 2025 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523806;
	bh=y89Jl75u+36RaOzpcenKCTlL3rWAYU00a+/crcMQJuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ca9gynEQzzfcyJnmFwc2cS5GS+IJ9FA+ljEirOiqzw5uzZSM1S6flj9iyT1TIncQb
	 rbNp7DSjZvXIfJzV7xhWTasNVLee4botr+e0bKdPtEzq9TjpZB0SUoRT+OmJDeAkIl
	 i7GFx+Ag3KpukiKIdH/oNUPJMfZBc9ENAl/y5Am4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathan.lynch@amd.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 278/515] lib: packing: Include necessary headers
Date: Mon, 18 Aug 2025 14:44:24 +0200
Message-ID: <20250818124509.128692910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Nathan Lynch <nathan.lynch@amd.com>

[ Upstream commit 8bd0af3154b2206ce19f8b1410339f7a2a56d0c3 ]

packing.h uses ARRAY_SIZE(), BUILD_BUG_ON_MSG(), min(), max(), and
sizeof_field() without including the headers where they are defined,
potentially causing build failures.

Fix this in packing.h and sort the result.

Signed-off-by: Nathan Lynch <nathan.lynch@amd.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20250624-packing-includes-v1-1-c23c81fab508@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/packing.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/packing.h b/include/linux/packing.h
index 0589d70bbe04..20ae4d452c7b 100644
--- a/include/linux/packing.h
+++ b/include/linux/packing.h
@@ -5,8 +5,12 @@
 #ifndef _LINUX_PACKING_H
 #define _LINUX_PACKING_H
 
-#include <linux/types.h>
+#include <linux/array_size.h>
 #include <linux/bitops.h>
+#include <linux/build_bug.h>
+#include <linux/minmax.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
 
 #define GEN_PACKED_FIELD_STRUCT(__type) \
 	struct packed_field_ ## __type { \
-- 
2.39.5



