Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93BC3AFD0C;
	Sat, 12 Sep 2026 19:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239668; cv=none; b=IFVuMqlnHnRG4le3C+Q+EhRUZcvgiU4E2qF7mUB/pbLhd99CePZfXdIXnJVEwesB3lznueeBaqBizik5X01H4DT8tKoJT8/oSVZqq+0IXAYeYeYOpX/hKA/8SQBncNu63M/V10S4PuXajkjxZDCQfa+HcspjK1yJbv4OlJ5jm+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239668; c=relaxed/simple;
	bh=NkVMhu8K8g/lFp1E6rDBwfv0JNoFabzVl0vw3+K4BKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR3dcjtw0fE/fd8eUeU+1s4XG5AF2+nTmg78QwrvkSPIaqBJWN/i0ggXxv8hovj2k3YNLhtqUByiEH9sJek4lNY48BvwCyTDW5s+X2Bn/bF/+VtHsAecmo/syl8uFISWpqGl5KXRq6v4Szrplev4sCSYD6OBqRDFPJf/C7lwWt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHzFWYh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHzFWYh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22081F000FF;
	Sat, 12 Sep 2026 19:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239663;
	bh=8peirAH3ejU+nkOGCmPwPSv21OHq4w9C7xA7RpH6+Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHzFWYh2AMGt9gOCkIz09Kbi3QO8bNP9iJPXoHLOR+VMG/9rKBtsa8r9cJPymRy54
	 q2IJvYHSV9UBSDd3mDATRacfOaYRg6FLe0qp8VymVTZJymV25548/XmVKaVs1n4eD1
	 Trtkixveht4f1ZDjhHmK1DAXHqffkJYF9rrDcVU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 709/935] of: property: use unsigned int return on of_graph_get_endpoint_count()
Date: Sat, 12 Sep 2026 09:02:19 +0200
Message-ID: <20260912065543.097747738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 982724b272353..41c31213db508 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -813,10 +813,10 @@ EXPORT_SYMBOL(of_graph_get_remote_port);
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



