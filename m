Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214473;
	b=E3vNPEVNmSkySEWOR/nvD27S3Au9FJLiHtP7ppO3cjMn4qC/tJHeKmD+NUBR/HuPF5/A
	 RAiWr1XoqMxIVFafD+PvNlFo2Le/yJGdXeqoOR4sNYMu06Lzy35G2eprhTSpcdqBV5mrH
	 zwOXOGvYpeUEJOrz5OLEEhxlE6dAW9+6C/HjkPfooiX2t1/EVZo4o3eqDD+aTk4tWfT08
	 8W49B0A765SaBxYzQ7jme6qTAmkswFmU3SCduL94YvAULIRfJXkht32d9q4YR2Z5gaXfk
	 K32f3Q59ThHu36MoJGMs4Rf/HaDav7NxsDsMps9Q0YL0S9gLkKzt5g6er/HXnI4QTqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U1HFf7Nw+iPBmqnyRA2UCCVkUumXVWAzLQ5VdSmslh8=;
	b=QkNulesYMVqbJs8o5n+y75/4j/fkeAYigp9Swh1yGFIWjRvlsFfvzaQ5WGq1UutFGYfA
	 XtB+BkxMm+AEaxbpeUhYxQG2eC4WePM1jhKVtWsD7L4ugKv0inMOIMlm/J7oUEy4MYjhu
	 GncT49hXsXdmyIQAlIANyx/UzFu+50NGm1BieLsY7BokfuSOpo39+fsiXhtiOSC9No6ZX
	 roWTH1RWpe1BYBy0auZvzJzDOmfRbWi5Yriu5i5K6MfZiOzvLmkmPYiYolAAca3ptOoiT
	 xHO+0Kec2v+XCj4gVbwfoumiwG6NdC61+cqfJknuLONXHQATth/qz6kOxnhh7NY0Sdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTj+ClyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1B606AB19;
	Wed, 28 Oct 2026 19:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTj+ClyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4CB1F01828;
	Wed, 28 Oct 2026 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214473;
	bh=U1HFf7Nw+iPBmqnyRA2UCCVkUumXVWAzLQ5VdSmslh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTj+ClyBQRp/wWoDCWlb5vbuEHFRv4S69d3VP2CbFCTQecMIfWCuwiiNW57mS/Udn
	 QYwzfj7RsHKtYL+AuJf72LKlkvTZOpbH/7HSyUFICgHKHhDSCFwbQHNe6zMjyidthp
	 zS3EXnRWxv1BIhxpXqQKawNO7ESKwMCiq+jgZ5Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0872/1887] of: Move of_device_(add|register|unregister) to of_platform.h
Date: Wed, 28 Oct 2026 17:49:28 +0100
Message-ID: <20261028170519.262252805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit 4c32fb7dcf65b16cc7b2837ccfc35d00be92bddb ]

As of_device_(add|register|unregister) functions work on struct
platform_device, they should be declared in of_platform.h instead.

This move is transparent for now as both headers include each other.

Link: https://lore.kernel.org/r/20230329-dt-cpu-header-cleanups-v1-2-581e2605fe47@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 0aead8197fc1 ("mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of_device.h   | 4 ----
 include/linux/of_platform.h | 5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 1a803e4335d30..90dabbf1e0258 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -26,10 +26,6 @@ static inline int of_driver_match_device(struct device *dev,
 	return of_match_device(drv->of_match_table, dev) != NULL;
 }
 
-extern int of_device_add(struct platform_device *pdev);
-extern int of_device_register(struct platform_device *ofdev);
-extern void of_device_unregister(struct platform_device *ofdev);
-
 extern const void *of_device_get_match_data(const struct device *dev);
 
 extern ssize_t of_device_modalias(struct device *dev, char *str, ssize_t len);
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index d15b6cd5e1c3a..8ac5cb933dc3c 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -52,6 +52,11 @@ extern const struct of_device_id of_default_bus_match_table[];
 extern struct platform_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,
 					 struct device *parent);
+
+extern int of_device_add(struct platform_device *pdev);
+extern int of_device_register(struct platform_device *ofdev);
+extern void of_device_unregister(struct platform_device *ofdev);
+
 #ifdef CONFIG_OF
 extern struct platform_device *of_find_device_by_node(struct device_node *np);
 #else
-- 
2.53.0



