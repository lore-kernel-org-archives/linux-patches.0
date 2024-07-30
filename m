Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5C8146D6B;
	Tue, 30 Jul 2024 16:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357450; cv=none; b=KLhCExq7F3P31njhLm7SBFvryNkm4vQqL5TDybty7tVgIxjvCY4KlToIt6DUycUFCkB4+s3SCSvuij2pe+8PFdVxk8ggqoh+S1FP0YIddUGwRMqcFeFot3igZsMFVtHT1g2lgW5uLEXf9AYXfrI3AZ66yQD1Wq+F2S5WrkXPbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357450; c=relaxed/simple;
	bh=iiUOnuziFgbIP4l2OFrTVS3MtH2Zja+wgR3ZWYOqB3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nga+PfPcFDgFuzp60IpVsu04dGPbX8CfBr3W10PY74kDSGTiOwGvq7Xn1QMlsjuinuDMHEtd9KQFRS4tVLUVA/9u1w8hoLmYJm4sUotG/B+TVCxyywCw6/1GcJZYhEYWH0cSQKqMIFf/d/7hP9aZQ+K9IiaT+JcEmdYV7dzteF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7MzIqqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7MzIqqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E14C32782;
	Tue, 30 Jul 2024 16:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357450;
	bh=iiUOnuziFgbIP4l2OFrTVS3MtH2Zja+wgR3ZWYOqB3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7MzIqqa2XIF92zILOulLtpY3JerPz85tgWhHq8vqE3b9ivMIhV2LEdjMXFbaONTf
	 HH22jrbrM3sGYxDeQKOYCYn5VxUkhM+F/9g+mcmD1/9d6h++4P/YsQmCibtRy2j8dj
	 lsieECXMnEnLMob6uk62aBr6i59ItQnbo/+PbXz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/568] iio: frequency: adrf6780: rm clk provider include
Date: Tue, 30 Jul 2024 17:46:03 +0200
Message-ID: <20240730151649.884656471@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



