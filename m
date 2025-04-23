Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B88296D1C;
	Wed, 23 Apr 2025 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422254; cv=none; b=gekYHgieTm/1PDYlka52nO79s7zFDPTOWObSZTw+gFaUnTf0zBtapnoVqmcm8fZfhZpsdETmzLUuVp8EsUojhJr1dmQYcm0VcOFyatXs+yNP8baHluy3iNjPKQ8sj0K6wxFeYPIjXkGyEbt+N/5qaET2zcGScC7Bnzx8iSKZvco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422254; c=relaxed/simple;
	bh=brEVplFA4S22X0XLHGfRoiG7eKxHQ0FFLaFiqfi+30Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9boKvs1Kg4zpCkEnAHTTofs007VITnNXyVZg7QbRTX1xRn6bhK/5QeiZAIFLpdW7H6dpOCQ7w2BkpFXTNBe5TpX7o5KmmMlvXEHm4snrq+SvNFqWnLWRdUEl/IMcaH1esJUfvc8pH3ZCnjM6XZ2+JChql8/IlUyYRoBS+cm+BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2SNP0Lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2SNP0Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39B4C4CEE8;
	Wed, 23 Apr 2025 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422254;
	bh=brEVplFA4S22X0XLHGfRoiG7eKxHQ0FFLaFiqfi+30Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2SNP0LrNyPtwtiwLVlKob1URuuQ2ehjFmMYhaqEaq+GO37gwD/ByRC37dXSniUFO
	 DAuYyf1xLbFlzQKDuFp0rdioat3N1gQsznOeWtQpSS8vBx4Rb6bjp9CXiW/C1bQGTS
	 VrR99Jxuxqtjy3Y0+n7XvAcWptjXLZXBEwUi3iyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/393] i2c: atr: Fix wrong include
Date: Wed, 23 Apr 2025 16:43:24 +0200
Message-ID: <20250423142656.052956435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 75caec0c2aa3a7ec84348d438c74cb8a2eb4de97 ]

The fwnode.h is not supposed to be used by the drivers as it
has the definitions for the core parts for different device
property provider implementations. Drop it.

Note, that fwnode API for drivers is provided in property.h
which is included here.

Fixes: a076a860acae ("media: i2c: add I2C Address Translator (ATR) support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
[wsa: reworded subject]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-atr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-atr.c b/drivers/i2c/i2c-atr.c
index c03196da11635..03caa4ef012f1 100644
--- a/drivers/i2c/i2c-atr.c
+++ b/drivers/i2c/i2c-atr.c
@@ -8,12 +8,12 @@
  * Originally based on i2c-mux.c
  */
 
-#include <linux/fwnode.h>
 #include <linux/i2c-atr.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-- 
2.39.5



