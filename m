Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388ED3290D1;
	Sat, 12 Sep 2026 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231064; cv=none; b=T50Ck5gkyQrGNfzsb+hJpJzxC7CeJmQj4+ydAGo5fPk5gbsRBOCBXTUU5OwA+78BXLmLmmD5dkThStKO5xdHgzQ8LsxWxd6Xt+WZEwsUNrPbsAK6cGCU8vRaa1PM7UWrDMgaUzZyM5NqSbomHtBJc/mE0MTHfTZtCl/j590H5CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231064; c=relaxed/simple;
	bh=aUiJ6PXbEMkf8t64cv/afLiPgfh/nFbpcfHP9sSUTa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ik/MqfNp1dv8KsjaNE9eB89RofiMm/mV0RYN+rFXq5MeeJ3cvUeSQt8gcIeYzWbaR5sHFvKQCmLnB3EWihItfaQPLywKyO25l9YNKifI0uIn+9skjf2c4GWRoHEcBx+UCqTZkx5/RA2dE+EDADo9UudPizz4AIIewEu19KJTAlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMJwdHTt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMJwdHTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C641F000FF;
	Sat, 12 Sep 2026 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231062;
	bh=hmyMT7fn2Rw64KvxK1JkoSY48rwHFN+uuczGY9qfDCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMJwdHTtAMqqdqxDZ8sG7jIaz8qI3dyii4cHYyA/Y0YwlsOul2dF2a6t3NXRVzcAX
	 XRvmG8qaRsf0/bOjx04bEpczXGoRVAOGA7a34GzwkL7NWkF/ZZJl8l8B4jHdikU47S
	 eGXt5m3GQw2PtewYTLsF1Zjk0P+mBbjPERYphzlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0879/1191] of: property: use unsigned int return on of_graph_get_endpoint_count()
Date: Sat, 12 Sep 2026 09:00:07 +0200
Message-ID: <20260912065607.989455775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 574849054d97cee5be78d6c149d84685647fe774 ]

Because of of_graph_get_endpoint_count() doesn't report error,
just return count of endpoint, the return type should be unsigned.
Tidyup it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://lore.kernel.org/r/87plxbcvzb.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 62bac3202042 ("drm/sun4i: tcon-top: Keep mixer routes distinct")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c    | 4 ++--
 include/linux/of_graph.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 27779032109bc..0993417f071ad 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -819,10 +819,10 @@ EXPORT_SYMBOL(of_graph_get_remote_port);
  *
  * Return: count of endpoint of this device node
  */
-int of_graph_get_endpoint_count(const struct device_node *np)
+unsigned int of_graph_get_endpoint_count(const struct device_node *np)
 {
 	struct device_node *endpoint;
-	int num = 0;
+	unsigned int num = 0;
 
 	for_each_endpoint_of_node(np, endpoint)
 		num++;
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index 4d7756087b6b6..a4bea62bfa290 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -41,7 +41,7 @@ struct of_endpoint {
 bool of_graph_is_present(const struct device_node *node);
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
-int of_graph_get_endpoint_count(const struct device_node *np);
+unsigned int of_graph_get_endpoint_count(const struct device_node *np);
 struct device_node *of_graph_get_port_by_id(struct device_node *node, u32 id);
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
@@ -68,7 +68,7 @@ static inline int of_graph_parse_endpoint(const struct device_node *node,
 	return -ENOSYS;
 }
 
-static inline int of_graph_get_endpoint_count(const struct device_node *np)
+static inline unsigned int of_graph_get_endpoint_count(const struct device_node *np)
 {
 	return 0;
 }
-- 
2.53.0



