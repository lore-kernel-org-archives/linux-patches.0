Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015110;
	b=SHNfLn2tZ2Th6GqUTILTwUzYTDnyEzrdPkYJE2YDeiTDXIatkc83KlMUAy43FS+pkTyL
	 AW9xPOxutmlDO3pZ9FYY2+FoYLaWO1AP6Yz+Y/Ki9g79ma4eGmVGpWvtUqsboRf7N0YDh
	 1Vm80R5Hyu/3q18XoEaFfNJ3elsuAHqZzOrTAcK2lujzHjgslVI7yXPhYXNAXBRDSHL/M
	 TeUCdg1YTRpMFfXJG1YgYxgdTdUGX/JRRzrdeyy6teYjH2ez1zWb0kDcu67FT5umuVRED
	 zrK9zSUmpS46Ba3vR72ITOsguc3K76AZSNPJfqz/fAZbUIhEOnweXA+gV/bS6hS049w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nzBYyfEsh8sHQFEdHmgLjjsK0sFJhRWu59XFRBOFeu0=;
	b=HXgoQhF0k9X5a051pMx00+5BRzjPJice2EtYJqEkK5fUdBiEVLBSCId2L75dWELpVMe4
	 EsjIR9c+Ajd/uCRA9EG4hC4G/f2pv+8/jOjaol9j1eq0Bmxgnewdywq/y3j+Y5iZH2pXS
	 Kha5HRxvlBUfGiNQ8PXWnjvKo1dyWK1Rqh+7VcZBCCY+Cz0cvomHuheNWDGgcEbGp7oXA
	 aPvsiP26EadrRpDZdR6LnE9DD8mnNlmdq887DsHUgpY0bMOF+R1qOt2v6xsO8XYZm4XA1
	 xKws3DvSvmHdpMW5oX4THD2OWSwpVuSEXDnzufazoSxarqX7GqUUEH7wOcNJLqEiVgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0q95yf5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74EC60A2635;
	Wed, 18 Nov 2026 15:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0q95yf5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96DF1F000C5;
	Wed, 18 Nov 2026 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015110;
	bh=nzBYyfEsh8sHQFEdHmgLjjsK0sFJhRWu59XFRBOFeu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0q95yf5eeO4UWGwvQQONRABLwebPvbg0iRvFcLqmP/YLsQiS5KbP4+I8AOYQXDAv
	 aB8hBaPKsocChPogq4yFBjiyOPswQPSId3jk6wS892W5cee2Bpcwx5gjInkqloiT9i
	 ndragAsDJJ6zhIdpZXIGfL7GM3iajPdpRBFVQ/G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0055/2651] accel/qaic: Add missing <linux/device-id/mhi.h> to sahara and timesync
Date: Wed, 18 Nov 2026 15:21:35 +0100
Message-ID: <20261118150249.931771171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

[ Upstream commit 0fb9e5faa8220db6b3268b3c8a39e31e0a963743 ]

qaic_timesync.c and sahara.c use struct mhi_device_id implicitly since
commit 995832b2cebe ("Replace <linux/mod_devicetable.h> by more specific
<linux/device-id/*.h> (c files)") removed <linux/mod_devicetable.h>.

Explicitly include <linux/device-id/mhi.h> in qaic_timesync.c and sahara.c.

Fixes: 995832b2cebe ("Replace <linux/mod_devicetable.h> by more specific <linux/device-id/*.h> (c files)")
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727173326.2219191-2-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_timesync.c | 1 +
 drivers/accel/qaic/sahara.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/accel/qaic/qaic_timesync.c b/drivers/accel/qaic/qaic_timesync.c
index 45e5f0728ebe8..b5162677ccc46 100644
--- a/drivers/accel/qaic/qaic_timesync.c
+++ b/drivers/accel/qaic/qaic_timesync.c
@@ -2,6 +2,7 @@
 
 /* Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries. */
 
+#include <linux/device-id/mhi.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
diff --git a/drivers/accel/qaic/sahara.c b/drivers/accel/qaic/sahara.c
index 6333c45ef7d2a..e951181e424f2 100644
--- a/drivers/accel/qaic/sahara.c
+++ b/drivers/accel/qaic/sahara.c
@@ -3,6 +3,7 @@
 /* Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries. */
 
 #include <linux/devcoredump.h>
+#include <linux/device-id/mhi.h>
 #include <linux/firmware.h>
 #include <linux/limits.h>
 #include <linux/mhi.h>
-- 
2.53.0



