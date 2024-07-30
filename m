Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E4317D8BB;
	Tue, 30 Jul 2024 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358793; cv=none; b=dxh015tfbMPN41HrQKBsdxxriRGouCRvtM33N569+2KAc3oToSNglJHkoWeFeBr90P62V+8XR00Ky98gxK+BaOLHth0IFanF7OQdGAnQgAUQlszTXIO+mEjVl1U6I2OAup4s+wmI8KKLt9wV+LrQy5N/saw6QgINIcomY/bCZrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358793; c=relaxed/simple;
	bh=yqoclFAlmgYjiXp/0e2nlOc0VChe8yrojLsHKeH4F38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI2lmRvMjB/0rrQTpOzjeffN8DNVUIaYzZXEVx0XJJ+KdqYjWObi8q1SK5DADucUmmSNMkqKCnrUwnCg/aNyHPRl9XKiJvvj7xAnLX0I+DuLf2mRDzzR9+pmkup+da+m4Q2IfqSFj31q74WuQL15a9cHIj3PqMLEObhK22EX1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2NYKvBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2NYKvBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3758FC32782;
	Tue, 30 Jul 2024 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358792;
	bh=yqoclFAlmgYjiXp/0e2nlOc0VChe8yrojLsHKeH4F38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2NYKvBhgrqo6uAtNxsrcmp17nQ2DaRuUX15CqV+wggeW/hB+H7rDcGaewjDQPAix
	 XzgTHkKnLVtfqMUPjTGQMbSUHHVB3oL1QAJjNFJqrIMEVjtI07m1i3/DQJlrQk7rDf
	 FiiHQHTykH1IMPTAq3gqj9YTQVglJmkvrR8wD6Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 397/809] iio: frequency: adrf6780: rm clk provider include
Date: Tue, 30 Jul 2024 17:44:33 +0200
Message-ID: <20240730151740.362061337@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit e2261b4a4de2804698935eb44f98dc897e1c44c3 ]

The driver has no clock provider implementation, therefore remove the
include.

Fixes: 63aaf6d06d87 ("iio: frequency: adrf6780: add support for ADRF6780")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Link: https://lore.kernel.org/r/20240530092835.36892-1-antoniu.miclaus@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/adrf6780.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/frequency/adrf6780.c b/drivers/iio/frequency/adrf6780.c
index b4defb82f37e3..3f46032c92752 100644
--- a/drivers/iio/frequency/adrf6780.c
+++ b/drivers/iio/frequency/adrf6780.c
@@ -9,7 +9,6 @@
 #include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/clkdev.h>
-#include <linux/clk-provider.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/iio/iio.h>
-- 
2.43.0



