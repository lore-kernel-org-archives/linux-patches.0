Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B59A36C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302340; cv=none; b=KLWAYebLgYewEFtLGnM3KN2SHMdI60F1H11kPST6D0TBxchTIvvPlkqq1d6ddyChDOY0XCR0tiqPfDc55P4u4WKD6rxddX0tyIiUUfC9OHbm0jtdykdmjr7tpC8u8Vb6cCP5Wkkkz4h+xPbfq71+2jY1fYfkNdMd7qFmOFqhsDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302340; c=relaxed/simple;
	bh=wsfB+6W00eilqfrtoqgCgWRdo07cG4u9sXZe5mxVzd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/XVZGRJwPDdkV2S/4GlnrM106zctrH9KFLJevdv8wqTutUf3gQBUtPpk7RpOIWNrrSZGCj6LlZsFxYD4wTug91JIbXHEKVFzQrFO5gL37gxu4RdzC/a6JrEoMSUkjRSarMSlWd5mugKdAO5xXLDwwRrzxAtRn+GoFwkzc6LkMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rv3f7Dde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rv3f7Dde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A324FC19423;
	Sat, 28 Feb 2026 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302340;
	bh=wsfB+6W00eilqfrtoqgCgWRdo07cG4u9sXZe5mxVzd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rv3f7Ddea2qcvH7wyN1Dagq79DxGGuFCfzTqXXG1vds1mL5GlSOMFbqpNaZyE3aK6
	 v5FLjK7KixwN7MvOeauJdOrSwOKmLbRb16dHHRATzrgmQ6NIwIW6ZVzi6d/jq4aRtD
	 PTem1lnTc74yUQq6REhcfZspLkW8K/V7TPDjDqGZyZ24vnCyQ5NTH2pwNbUOcDB1Ia
	 ErIFOovIoFlknO9qwesQN76V2/7A56I9JSd/9fNNBYkeG5uoNytZaRJjKnYUNe+pBQ
	 bUK9detTR4pOY9muTQRnB0x25svPztIrL83HDxovS0gj6Pa8wYeCvYGx8plmoixVdT
	 15qrsb3fTFWrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/232] soc: mediatek: mtk-svs: Add explicit include for cpu.h
Date: Sat, 28 Feb 2026 13:08:35 -0500
Message-ID: <20260228181127.1592657-62-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Rob Herring <robh@kernel.org>

[ Upstream commit 26c682676471777c8464645695d3590b9134a5e7 ]

Removing the include of cpu.h from of_device.h (included by
of_platform.h) causes an error:

drivers/soc/mediatek/mtk-svs.c:2134:41: error: implicit declaration of function 'get_cpu_device'; did you mean 'get_swap_device'? [-Werror=implicit-function-declaration]

of_platform.h is still needed for of_find_device_by_node().

Link: https://lore.kernel.org/r/20230329-dt-cpu-header-cleanups-v1-13-581e2605fe47@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 6259094ee806 ("soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index f00cd5c723499..1ec6e631a7796 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -7,6 +7,7 @@
 #include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
-- 
2.51.0

