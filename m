Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C631D1512;
	Wed,  2 Oct 2024 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880662; cv=none; b=iCWIuscDZbjqm1HZJhgcml4PoG1TwgN1ZdaMiffgFbAswJHgfIc+CWSueLlcwzPqxs6JhllbZ52in88knQl9BjRw8lS68sOOaKIWJCkswywG/KdwpnQxNT/p0zsKcTnqK74sRM9gOJv1dygqk6CYUI1sYL0DBmNIFLfrSpLb8nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880662; c=relaxed/simple;
	bh=/6dI35bbZ3Okv0i7rwVJ/mVZVOkVOQ3jJooU9UTYbUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpIf1bvSr2qLKU3yL6a+wfDjnuDwAYBfTaIpFwbX5oYvTgvJdwrpHGibtRmPkfisyj6CV0t9Rimph0+RapJN+0WnsZh7/CUjd+mVOx7yRFYk2l28HNZlkeB3JWM2IAD8gPOXJ/Pq+bLwF3gs49eoTA7uAON/KWQBbFf3IBgfyno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6AqyYpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6AqyYpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6835C4CEC2;
	Wed,  2 Oct 2024 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880662;
	bh=/6dI35bbZ3Okv0i7rwVJ/mVZVOkVOQ3jJooU9UTYbUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6AqyYpj+wvebJ/JeHRB8bqeTaE2UZzmDMND7aGdymY8gp+7sG0B9ZMe/8HBjB0DC
	 OeW1qNEImotscq76/u+DXh0LNXLGcwlYeN/RNh/OBhX7J4zCtM4K3qlE7gZ3TgUp81
	 /gjwc6RvS3eQuICWPPNRNHH8fyS1nn1qO8rz4hoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"qin.wan@hp.com, andreas.noever@gmail.com, michael.jamet@intel.com, mika.westerberg@linux.intel.com, YehezkelShB@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Alexandru Gagniuc" <alexandru.gagniuc@hp.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 504/538] thunderbolt: Expose tb_tunnel_xxx() log macros to the rest of the driver
Date: Wed,  2 Oct 2024 15:02:23 +0200
Message-ID: <20241002125812.334856752@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit d27bd2c37d4666bce25ec4d9ac8c6b169992f0f0 ]

In order to allow more consistent logging of tunnel related information
make these logging macros available to the rest of the driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tunnel.c |   26 +++++---------------------
 drivers/thunderbolt/tunnel.h |   24 +++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 22 deletions(-)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -58,27 +58,6 @@ MODULE_PARM_DESC(bw_alloc_mode,
 
 static const char * const tb_tunnel_names[] = { "PCI", "DP", "DMA", "USB3" };
 
-#define __TB_TUNNEL_PRINT(level, tunnel, fmt, arg...)                   \
-	do {                                                            \
-		struct tb_tunnel *__tunnel = (tunnel);                  \
-		level(__tunnel->tb, "%llx:%u <-> %llx:%u (%s): " fmt,   \
-		      tb_route(__tunnel->src_port->sw),                 \
-		      __tunnel->src_port->port,                         \
-		      tb_route(__tunnel->dst_port->sw),                 \
-		      __tunnel->dst_port->port,                         \
-		      tb_tunnel_names[__tunnel->type],			\
-		      ## arg);                                          \
-	} while (0)
-
-#define tb_tunnel_WARN(tunnel, fmt, arg...) \
-	__TB_TUNNEL_PRINT(tb_WARN, tunnel, fmt, ##arg)
-#define tb_tunnel_warn(tunnel, fmt, arg...) \
-	__TB_TUNNEL_PRINT(tb_warn, tunnel, fmt, ##arg)
-#define tb_tunnel_info(tunnel, fmt, arg...) \
-	__TB_TUNNEL_PRINT(tb_info, tunnel, fmt, ##arg)
-#define tb_tunnel_dbg(tunnel, fmt, arg...) \
-	__TB_TUNNEL_PRINT(tb_dbg, tunnel, fmt, ##arg)
-
 static inline unsigned int tb_usable_credits(const struct tb_port *port)
 {
 	return port->total_credits - port->ctl_credits;
@@ -2382,3 +2361,8 @@ void tb_tunnel_reclaim_available_bandwid
 		tunnel->reclaim_available_bandwidth(tunnel, available_up,
 						    available_down);
 }
+
+const char *tb_tunnel_type_name(const struct tb_tunnel *tunnel)
+{
+	return tb_tunnel_names[tunnel->type];
+}
--- a/drivers/thunderbolt/tunnel.h
+++ b/drivers/thunderbolt/tunnel.h
@@ -137,5 +137,27 @@ static inline bool tb_tunnel_is_usb3(con
 	return tunnel->type == TB_TUNNEL_USB3;
 }
 
-#endif
+const char *tb_tunnel_type_name(const struct tb_tunnel *tunnel);
+
+#define __TB_TUNNEL_PRINT(level, tunnel, fmt, arg...)                   \
+	do {                                                            \
+		struct tb_tunnel *__tunnel = (tunnel);                  \
+		level(__tunnel->tb, "%llx:%u <-> %llx:%u (%s): " fmt,   \
+		      tb_route(__tunnel->src_port->sw),                 \
+		      __tunnel->src_port->port,                         \
+		      tb_route(__tunnel->dst_port->sw),                 \
+		      __tunnel->dst_port->port,                         \
+		      tb_tunnel_type_name(__tunnel),			\
+		      ## arg);                                          \
+	} while (0)
 
+#define tb_tunnel_WARN(tunnel, fmt, arg...) \
+	__TB_TUNNEL_PRINT(tb_WARN, tunnel, fmt, ##arg)
+#define tb_tunnel_warn(tunnel, fmt, arg...) \
+	__TB_TUNNEL_PRINT(tb_warn, tunnel, fmt, ##arg)
+#define tb_tunnel_info(tunnel, fmt, arg...) \
+	__TB_TUNNEL_PRINT(tb_info, tunnel, fmt, ##arg)
+#define tb_tunnel_dbg(tunnel, fmt, arg...) \
+	__TB_TUNNEL_PRINT(tb_dbg, tunnel, fmt, ##arg)
+
+#endif


