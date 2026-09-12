Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AA12882AB;
	Sat, 12 Sep 2026 16:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231058; cv=none; b=efEe7cv1wJgHyiKY8ZrfK8qhBquO83ySNG8nJMVNO0CxXIei9Hi4IIfo4wnBDCIlLyzpLZnaScbQepyRWP4bUUGYuHvIDSG+W5htT0dZitAIHBanm4FD8y5cGCWlwPaxP7AOvmRZvEzd9JmTjyz4crEqdz9Fv0y3rNU7CD8nvvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231058; c=relaxed/simple;
	bh=NLFSW/xVBCQ+uKPMsD3L5WOSs/d+K6oV5WnUE2c3Zwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLPTQ1czNAz0yIiUz3TD+8OeGex4WnbGC2esl/ciGyIDP49P4HR76HOvmMRwFYogordWxqtHunsWUINQGH6KGS9ZrYa3ljtLPoBzxWCOcBEesULDo8LrTlHyrtLNT4jaU7umq3WzRuIyJZKQ35Pb1xIRXfugWSZpD7hRK0bdnUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCcF4Uld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCcF4Uld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B754F1F000FF;
	Sat, 12 Sep 2026 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231057;
	bh=1c7qN2sXe5UtzaaoTKRO4kgqqrBjsolDB9vPnU3IWO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCcF4Uldn0VUwtXVaWWTk7CPEbPr1PhQehcjQpfGKXncMGs23y8Z00D6ng/PYCQG3
	 CD2UNJZIpudmIAwPLzuQaD47wD0e2RCH2eCLwuKfOrjT22RubhDqonW6qqOUDVBUXK
	 UafHjf1SGWjW5AplV/2/V94utRLXI5bKBeQVGJZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0878/1191] of: property: add missing kerneldoc for of_graph_get_endpoint_count()
Date: Sat, 12 Sep 2026 09:00:06 +0200
Message-ID: <20260912065607.969156385@linuxfoundation.org>
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

[ Upstream commit 4c3b386c46065c0d26ae5503e73d6634f24e2d36 ]

of_graph_get_endpoint_count() doesn't have kerneldoc. Add it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://lore.kernel.org/r/87r0hrcvzk.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 62bac3202042 ("drm/sun4i: tcon-top: Keep mixer routes distinct")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index da5d712197704..27779032109bc 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -813,6 +813,12 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node)
 }
 EXPORT_SYMBOL(of_graph_get_remote_port);
 
+/**
+ * of_graph_get_endpoint_count() - get the number of endpoints in a device node
+ * @np: parent device node containing ports and endpoints
+ *
+ * Return: count of endpoint of this device node
+ */
 int of_graph_get_endpoint_count(const struct device_node *np)
 {
 	struct device_node *endpoint;
-- 
2.53.0



