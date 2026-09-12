Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CB0274B46;
	Sat, 12 Sep 2026 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224804; cv=none; b=WGlItmlc9g0yK2pA7AVs5B8Pplihc76znffZpmMV82t9j12NFYPE/ZmE4NXpj+Z4DzJqMVWWn7STOKqmcuY+W4fURdVj+eFv6HzoXtzphbwo8tPqx4JLA+qb3woh4qNDBLn8qOXsDxTAEaCsekSaTDbht+Juk7We0EBdZ7lKOsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224804; c=relaxed/simple;
	bh=OhfmicWEMQsYD1GlE26xlY6WLflS3tP8/L0LWVDoDQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGN0ZDFfbqDBmfy3+S82XCMuguhPYbjSpfLaYegyUVA5Qvc1ZyBhYQx54iiMiUXVEL1NXV2andhvOo9jRGXGRJG9p3+VuUv2bWCG9tUx7kNniGTBgqcNOG1kMRecSTxMZdZffeLh2DM5gUUyiwFOFPSMHC6EpCeZiWZDIhu9ZYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAs8Bjtj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAs8Bjtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF041F000FF;
	Sat, 12 Sep 2026 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224803;
	bh=M2Cauxj7i5kL65tbfziPLiLWa8k0cvjgH7A3zXs60I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAs8BjtjnMwat8HOaYMCa1QpMEUg/qa+/udncy+4bp/lr8nAEnFzqiPLEyLsWPiAD
	 xt719DQJlutX/tll96TKqyzHKGTy2QiyeYXejHecatJA1M1mcKxg3PIr5CL7lwd/Pd
	 aW5jZlVog3vMNKDwtMN2/ARUxQpEDkmZDSu13unM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1068/1424] of: property: add missing kerneldoc for of_graph_get_endpoint_count()
Date: Sat, 12 Sep 2026 08:58:20 +0200
Message-ID: <20260912065631.220813412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b3f0285e401ca..aaaab76ad4179 100644
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



