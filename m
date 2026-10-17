Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB45F3839B2;
	Sat, 17 Oct 2026 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258032; cv=none; b=jxgGeUjaeFEpxbOmaq0DK4aoAc86u4Yyg7JIQEgO9rcFTUN+aV+LDq491AS3pKK8htrX2H1RNG954V9GOWKZZas9D0qRRFIbTEjPCscI3B3VhMzwu5iX7b/9N59hU9agSakZWZ2rM6rKIYz7tPswSYo1wNOlY3zvkUpFhOnJVuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258032; c=relaxed/simple;
	bh=mJGAtfF3xJDi4aP1dOCcgfrx+++I5M0Ly7Ybs3sy+oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnU115jmuTPPTOsPJ919BVXJAdAjfI1nzyeSkl6Eg6mHJabE0mmoYHBrcVgOQMzFknD2o9fURw/hNb4pvHyAVtrh5eYqJnYAaUgyvxorFFXk9rfHxz5njwg/PRcoSYGcG2FPNl7SM+Kx4u6RgHPorZv9GDZAxsI2B42zn645gt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcFZnhqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcFZnhqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497651F000C4;
	Sat, 17 Oct 2026 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258030;
	bh=toujwHBGljVHRKbR+Sk7c0gf5U1XJ4aK/6C/FK9WsqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcFZnhqiwwuHStLMa4vilH/n1ovPiF4yZsrfGkJOAAzKEhlFgG98648j1sd7Nbqys
	 E5jFJEv/0pNFXH+IP5eZRRjSI6EyoGN1GYUdGKwFGTtJUmYMmifoYR+WXLg0O6+NuQ
	 0X5aS08/ZbLcFy0RSYVxv2RI/rfkTfBA5KUGYakc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0747/1674] driver core: bus: add irq_get_affinity callback to bus_type
Date: Sat, 17 Oct 2026 17:50:19 +0200
Message-ID: <20261017160450.276684811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit fea4952df0eeec4e1a295ebaac9f61c0065fae87 ]

Introducing a callback in struct bus_type so that a subsystem
can hook up the getters directly. This approach avoids exposing
random getters in any subsystems APIs.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Link: https://lore.kernel.org/r/20241202-refactor-blk-affinity-helpers-v6-1-27211e9c2cd5@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 8bd2fa086a04 ("virtio: break and reset virtio devices on device_shutdown()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device/bus.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index d43ce072d747e..2ade5f02afae8 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -48,6 +48,7 @@ struct fwnode_handle;
  *		will never get called until they do.
  * @remove:	Called when a device removed from this bus.
  * @shutdown:	Called at shut-down time to quiesce the device.
+ * @irq_get_affinity:	Get IRQ affinity mask for the device on this bus.
  *
  * @online:	Called to put the device back online (after offlining it).
  * @offline:	Called to put the device offline for hot-removal. May fail.
@@ -93,6 +94,8 @@ struct bus_type {
 	void (*sync_state)(struct device *dev);
 	void (*remove)(struct device *dev);
 	void (*shutdown)(struct device *dev);
+	const struct cpumask *(*irq_get_affinity)(struct device *dev,
+			unsigned int irq_vec);
 
 	int (*online)(struct device *dev);
 	int (*offline)(struct device *dev);
-- 
2.53.0



