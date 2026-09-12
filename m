Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D52B38F92F;
	Sat, 12 Sep 2026 19:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243042; cv=none; b=LucyceghoN+wZbsMyFdf5/g0K/miOhoJ6a/hG5m+rAUUTcRMJzO8ZGQTyG8QODnM38rvPON26InjWRxpEbETG09PO59TlElI3IW+vK5ljbZhYfDNyzVh7FFDnaEk6XQSbULfQyrikWOBAPxl+fOCIdePIxY0QwTMET5bgufuacU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243042; c=relaxed/simple;
	bh=Ix9/TzQk+C8q9OPr41NoqpGJXNzjE0H9sbvKnyxVjbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ri7WmcwLY9BlIFLZJmdnQHoVw0GLeE963mW4WJWAcnc6ePwvUenN9pTi2p+aCBMDhWGh7xz6l1hbhsWvdNDEgxKJ4f0XlItwxlCZe/qHixPXas/dmRFcHreDmMy7TAPaVTWHa1HAZh3Q9fgq10nzlBjHWBuoHWYqEOgJAkADDp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6OuKTc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6OuKTc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6783B1F000FF;
	Sat, 12 Sep 2026 19:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243040;
	bh=c3EDIIAa8dkxxF9pjT5sgNswjJNe949pK6Y2NzSqCwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6OuKTc8eEbU0xb5laEyVQuJ0hgqalrKPF0U5wl0DtPMKpo3iqD0fFzGH0ycJ5hqt
	 2cAW6x6vfPb8i//hw7KO8/d2Ndj7melT1tmbeRN9+RwuoheXEX4YsFdPSP198SFoBC
	 ZsbIl9r7J55x6dA9HA8fYV6kPcA9+LTJWoCw+JxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 617/798] of: property: add missing kerneldoc for of_graph_get_endpoint_count()
Date: Sat, 12 Sep 2026 09:04:05 +0200
Message-ID: <20260912065531.264811675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 758d6db590aa8..3cbcc948c5c64 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -806,6 +806,12 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node)
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



