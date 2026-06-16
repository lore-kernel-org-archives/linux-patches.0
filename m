Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561053D890D;
	Tue, 16 Jun 2026 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627940; cv=none; b=qwYKeyi5uk5+jcmEZCywvSApOiG/eKFEUlamF1QtnQbuPibwrVlOo1uJD6XiZLRAbUEpV9UXNTTey2FzBXilsdUa9fj6Jfp4TPi9NEQsYEgPvxoV04gCL/gpxI4Lf7y7cwFD7JjPVCn+w0qHPgjfxZPAiK4/Uc/Mwepe3bMlPjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627940; c=relaxed/simple;
	bh=62jtgpS7XQxlXDvd229IWR9548txxhccbpFNPCO03LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aa6hlgUIpPcMe6JtWmWz5OQ8raazeiPJpBow8+ztHTZFrU2/sbrE/xb9ZFb+T7TiJ2Segg9VVUKGgDbK/U08TDcTiQxcxvikBJVgL1p5VLf9SSGnDcoqQNY4sMuwFRKUS3dP1tjxVwZdSeF9FXgMMO2Mvwv5taLMcn6e9TZTUWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xE5EvGEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xE5EvGEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6001F000E9;
	Tue, 16 Jun 2026 16:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627939;
	bh=z4I7DQJ8VlOTfUYz3mRlBZPEjeLXuczEDlIl2N+oWUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xE5EvGEmX3QjFTwknHBB5EmAModLDfDTYnM6Gzujfeg4onHrkLjlTdXYklXdDJZqN
	 gphTeO2+B0dyHcc1szye2qD0pvIE1FHJxIIj7cxmSI93W9pQTJzPRWEL3RKOXKjGOL
	 4KBJhEx3jtS+OC2hGiZrWlpxKRHN0zzg6DVE9y5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>
Subject: [PATCH 6.12 257/261] net: introduce EXPORT_IPV6_MOD() and EXPORT_IPV6_MOD_GPL()
Date: Tue, 16 Jun 2026 20:31:35 +0530
Message-ID: <20260616145056.972300098@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 54568a84c95bdea20227cf48d41f198d083e78dd ]

We have many EXPORT_SYMBOL(x) in networking tree because IPv6
can be built as a module.

CONFIG_IPV6=y is becoming the norm.

Define a EXPORT_IPV6_MOD(x) which only exports x
for modular IPv6.

Same principle applies to EXPORT_IPV6_MOD_GPL()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Link: https://patch.msgid.link/20250212132418.1524422-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit 54568a84c95bdea20227cf48d41f198d083e78dd)
[needed as dependency for tcp: secure_seq: add back ports to TS offset]
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -675,6 +675,14 @@ static inline void ip_ipgre_mc_map(__be3
 		memcpy(buf, &naddr, sizeof(naddr));
 }
 
+#if IS_MODULE(CONFIG_IPV6)
+#define EXPORT_IPV6_MOD(X) EXPORT_SYMBOL(X)
+#define EXPORT_IPV6_MOD_GPL(X) EXPORT_SYMBOL_GPL(X)
+#else
+#define EXPORT_IPV6_MOD(X)
+#define EXPORT_IPV6_MOD_GPL(X)
+#endif
+
 #if IS_ENABLED(CONFIG_IPV6)
 #include <linux/ipv6.h>
 #endif


