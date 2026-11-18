Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023090;
	b=LlrsMBeDaDDBJdZDFqFVAToo2UIs4Aj+FY3dlfxImN2IjU1vMwj1XADd7bMT9axp5M0p
	 lby5a+lV11ZPbP6yQSUpjFMkpK6SGD8Pq2ulQrdkoGIV9rWAW7UYaxb9YB73ldqfwSMYb
	 N52hfqopztmyQ5X6DSLW8UZXx03o3jcQNhGqEgj9d+nD4e4+HyW8vl4musvOdadwOXfcR
	 z6+MpiVFsRdtuK+MuCZWcLPFtTKE3zIa+QXG+3O8aJARb2af7hEOF0/hIUqndWN//uKx0
	 BpBv5WjjvGGUlU2MP2WBPZl/0JaoKSj+lNqdrsDeUis8kXvm984pBYuaLAkJzLZ5q8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pdNsGcT4+F/rKYep04Q8WnZBWs7lw/zY9PwjyROHWTQ=;
	b=sFLRaFg8rifvhYiYEj2Rb7biTavCmJAyKKTSsiX4l2mPEYY0c4yzICBpCm5U1eum1nXp
	 SXjzfkQPaPMCIFXKZ7ivmW/Dp5o7votLRKlOvTCBYLPWOJL9aCH6Xp+xCESC+ueeZC4Rk
	 pY5cjJVUUZGc2x/29s5Vz71GG5L3LaNy3c990PCQeweM6rCBbOoA6xbrmx4+e2KLrloB5
	 6tkhFmi3ZCE4XYoCEnv7YV+y3jJoz8+GGkB6gn1FccS5mGdPZYdk6Gm1xzG6JHWOFwREd
	 SYrpFLq4QPMSs9Yq3ebl04qysTcqrvnYNNfWliqW8Y6JkW38WxKCaohGiXik9oPuGHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxDLN2IC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B2A606A31C;
	Wed, 18 Nov 2026 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxDLN2IC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5BC1F000C4;
	Wed, 18 Nov 2026 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023090;
	bh=pdNsGcT4+F/rKYep04Q8WnZBWs7lw/zY9PwjyROHWTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxDLN2IC8C+BYWPkY2L4vhqct3LjoCtgtz9amhTs0JoTYUCP7zGdsv4s7+n3Rdof2
	 4Qw5N6OYNts5xD3EzVZKiOHiX+MqbH9vDI8z6Gben6moNBWq2QzWvP0B0lGz4vJczx
	 y2VwlPWPNX8BjDn3o7h1wgR2OYATl+u70z1oo0Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0194/2151] cxl/ras: Pass the PCI devices struct device to match_memdev_by_parent()
Date: Wed, 18 Nov 2026 15:32:09 +0100
Message-ID: <20261118150128.842272529@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 977eaad352bad4c4aac7cd15683800196c2ead57 ]

cxl_cper_handle_prot_err() hands bus_find_device() the 'struct pci_dev'
where match_memdev_by_parent() expects the embedded 'struct device'. The
comparison never matches. The lookup always fails and CXL endpoint
protocol errors reported via CPER are dropped without a trace event,
leaving only the root port, downstream and upstream cases reporting.

Pass &pdev->dev, and rename the callback parameter to match what it is.

Fixes: 3c70ec71abda ("cxl/ras: Fix CPER handler device confusion")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Terry Bowman <terry.bowman@amd.com>
Link: https://patch.msgid.link/20260828215726.1077498-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/ras.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
index f2d99865c6df5..1f8195fb51a93 100644
--- a/drivers/cxl/core/ras.c
+++ b/drivers/cxl/core/ras.c
@@ -70,9 +70,9 @@ cxl_cper_trace_uncorr_prot_err(struct cxl_memdev *cxlmd,
 	trace_cxl_aer_uncorrectable_error(cxlmd, status, fe, hl);
 }
 
-static int match_memdev_by_parent(struct device *dev, const void *uport)
+static int match_memdev_by_parent(struct device *dev, const void *parent)
 {
-	if (is_cxl_memdev(dev) && dev->parent == uport)
+	if (is_cxl_memdev(dev) && dev->parent == parent)
 		return 1;
 	return 0;
 }
@@ -108,7 +108,7 @@ static void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *data)
 		return;
 
 	struct device *mem_dev __free(put_device) = bus_find_device(
-		&cxl_bus_type, NULL, pdev, match_memdev_by_parent);
+		&cxl_bus_type, NULL, &pdev->dev, match_memdev_by_parent);
 	if (!mem_dev)
 		return;
 
-- 
2.53.0



