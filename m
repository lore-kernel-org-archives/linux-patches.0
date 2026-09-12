Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A627492E55;
	Sat, 12 Sep 2026 19:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239661; cv=none; b=c65HhpixO/6tjk+2Nvi5PvNEDQaFwjIiV8OF7UAwdbpz2YwuhM7ARWEAedeHRcoZUkgp3idrBLoLTgC0PAX8I4YQjQl0pbjAy24BzVSAn3caCWK50sYIWBtXhcnAsMgYi/DWxDiDBHei6Lno/0P3GD66wHrJUrcr1UEERSJ+Gjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239661; c=relaxed/simple;
	bh=hgpepk4/a6tqtPdPpbmpw3hJwf7PqEI+PigcYcai1sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuPBMfXLRXXj52wXmp0fV8wQRHb6klEEp9ROw6fR261h8JRYH0UXhUZWssrwVSJ3i+RnsrJA1L/d9DhZ6OaCclrI6Z9K4bUoPNrqv5GlNtomJvi1MNPDb2BX48D2x2Ty5MsE1EkbMI4nMWAikD7DMcBILQ/pkaOI0ed0hKjv6cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwYr4cVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwYr4cVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CE31F00899;
	Sat, 12 Sep 2026 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239658;
	bh=5GXGLv1DHMs52ghiFig3FPMj0qPK/03k/J0x8zQfuek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwYr4cVYfUD8siXJEdIKaZM5MPmLVVRuw902v0ZA6VbIQa4TgtPJZAaiktzsXnFkY
	 w1D1eV3CbtWKcrc3iHS7s4p5+hDM5nAiNfkcO2jOBkkq0J34NV3WJ5EY0ZzE7Adc+H
	 xi3+PPt1XjIc+GUeun1ugJNuXyttODCCnUuT8VzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 708/935] of: property: add missing kerneldoc for of_graph_get_endpoint_count()
Date: Sat, 12 Sep 2026 09:02:18 +0200
Message-ID: <20260912065543.075250840@linuxfoundation.org>
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
index 922f70aa46f3b..982724b272353 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -807,6 +807,12 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node)
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



