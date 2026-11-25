Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618527;
	b=wt/ZpHiatuI2rI2WGpIfPE73oeb2iOwtfOWF60EHNomHrWvcvDcKTBie7VEw9SEBUbNA
	 o2PJlsbPAHRhB0YH+U2PVtHbU598myfOVx4MKwp8L/76NuNnJoniTyMKZV+pVpDOAS7TV
	 +4BGDHt7bhR3XEhGguQ4bwS0heE89INRWJGU+nIMjuSRuGzddr42gIS6lXo63d0TkT7X8
	 vlenH0RfW0mv2Y2ly2d9J9W7PjLHRpkdnsDSHDR7aHXUhzHuyDbius0eeeLTTq/OacrXj
	 rVKW8AKv0VffKPUCs1czsyVKY1KiZOWsWKH3K/KDqL8WtLpAKPEnmTGRTT+UqpzLEtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uXqDyTLqewFdN5Hxvuy0vLHZoeC4Zq0lxlwXrNjvnEM=;
	b=Qs9jw6uppNzuS/mvFCqnpu5hfj92D0tZeXpmWzLhsawHmFiR6ouBvbWuC5WmRCPlw6gv
	 rPEP2/5n3wjqv+5fvY0iT9CqizZXtGSASJ+/2pPs2y2W+6SWMb7gFqydQAB5yip7haK/h
	 +Oq1V/O7EUZrr3K5h/IWMpHnry4J4CICiQnsiDXooCCwvQOpVsU83MlFaUtNDLN/pDouo
	 C3S3BbqHDV3eJrmIc9M/jc9NIXR98hssaIhc44n8iiLCSsS9WNvmhL/uHlBzQfypni+vV
	 aw7GYtNTS6QRZb1ZAuB+FX8E3bt158eXFX6b9Gm4pSvZVh+USz3CMmG5G9CCmLrV8Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZvNsqq1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F25606A339;
	Wed, 25 Nov 2026 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZvNsqq1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB2A1F000D0;
	Wed, 25 Nov 2026 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618526;
	bh=uXqDyTLqewFdN5Hxvuy0vLHZoeC4Zq0lxlwXrNjvnEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZvNsqq1A6XRkSIuxmVJrT3HinPZFuMkJZeBzaeJO8cWjDHeyRoZ2tgIs4cRrRVWc
	 qtMqxY3h73aI20Ryn94HxNO0h1VKg6T6LD6HOT8FH2I4rV01kyfhL4UX5adpHFlZLL
	 5CEx2jaM9fAUxJuBNGWN6kmUVf75j7hqhkuURkpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinseob Kim <kimjinseob88@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0306/1005] gpiolib: reset lookup flags for each hogged line
Date: Wed, 25 Nov 2026 15:27:24 +0100
Message-ID: <20261125143828.903337080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinseob Kim <kimjinseob88@gmail.com>

[ Upstream commit c20464a78162cf8b3a1c9dc7e0d764e535bfe582 ]

gpiochip_add_hog() initializes lflags once before iterating over the GPIO
specifiers. In the non-OF path, an active-low line sets GPIO_ACTIVE_LOW,
but a later active-high line does not clear it. A single firmware hog
with mixed polarities therefore configures later active-high lines as
active-low, including inverting their initial output value.

Initialize the lookup flags for each line before translating its flags.
The OF helper already overwrites the flags for each specifier; the
non-OF path must also start with a fresh value.

Codex assisted with identifying the issue and developing the fix.

Fixes: 802c51a83e9a ("gpiolib: fix hogs with multiple lines")
Signed-off-by: Jinseob Kim <kimjinseob88@gmail.com>
Link: https://patch.msgid.link/20261104115938.226-1-kimjinseob88@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 90731a547ed63..b16d6d727ac35 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -975,7 +975,6 @@ int gpiochip_add_hog(struct gpio_chip *gc, struct fwnode_handle *fwnode)
 	 */
 	u32 cells = 2;
 
-	lflags = GPIO_LOOKUP_FLAGS_DEFAULT;
 	dflags = GPIOD_ASIS;
 	name = NULL;
 
@@ -1014,6 +1013,8 @@ int gpiochip_add_hog(struct gpio_chip *gc, struct fwnode_handle *fwnode)
 	fwnode_property_read_string(fwnode, "line-name", &name);
 
 	for (unsigned int i = 0; i < num_hogs; i++) {
+		lflags = GPIO_LOOKUP_FLAGS_DEFAULT;
+
 		if (is_of_node(fwnode)) {
 			/*
 			 * OF-nodes need some additional special handling for
-- 
2.53.0



