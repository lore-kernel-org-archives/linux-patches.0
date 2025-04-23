Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3652428D843;
	Wed, 23 Apr 2025 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420754; cv=none; b=hZ1Ll9ejPTTw8xKy9FCsG/urhomV17ZaBF1Zh1T6OyHQlVmsLGFgqtY9N/hQzT0NLYK7+DiIYmytdpzdopWDiD4gekquIcj1RfMrDD+pgktHTyjrZtGpHP+FF3w78eBRPKqDGrTV5saof+Fd4OcI/qqo89+VW7ktf9LzCFD5Q1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420754; c=relaxed/simple;
	bh=37JvIAMG/SgyPfZ1WXs7EC9JJphPjQpsTgJgJ+/WhHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtFMBhVocQ/nan6Hpy6MhYp7nRphBmoeOghYa1JAPrGWrBtKDwMjaYjctUPFiw6ETtNtRYJR9aVLV+sRwG+lJ0JYtUntIDP43OcFMT3eC94U4eVZsbNZpvTKkVJrQ1cFWyYJefe16oj0PLFS5ALhFT9qA5LDxdy90SLQxkuYpt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RW6QySFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RW6QySFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9B3C4CEF4;
	Wed, 23 Apr 2025 15:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420754;
	bh=37JvIAMG/SgyPfZ1WXs7EC9JJphPjQpsTgJgJ+/WhHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RW6QySFb7o+YafN97vCJZ/S0SZ66aCp3QRL9mk8I6Gf0977eTtWlGJJvkSS92RhDy
	 NTuYw+KmzTMwJ/4svezO3nUxlUFMI202KeRO25mB1+fRiy2GCgJdvVORcc8R2oZx/a
	 10u+VV9/82b41Dda2Vvm/Az0HgIWRJ3keFl2fLtM=
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
Subject: [PATCH 6.14 119/241] i2c: atr: Fix wrong include
Date: Wed, 23 Apr 2025 16:43:03 +0200
Message-ID: <20250423142625.446342462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 8fe9ddff8e96f..783fb8df2ebee 100644
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



