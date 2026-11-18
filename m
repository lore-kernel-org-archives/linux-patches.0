Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015113;
	b=fm0Y3mCIFSYz9LD/ILm0P9tYa6GPwFKDCYDc785Eyojk6qisfd9I9PmPiDNgaaLFqG3B
	 4k3oECkGnY6rsqEG04rMeRGDCCxFyZSg6iRRe8tpl0xf+xhBLl9BaNh76/66Tyc4CrbwN
	 xQ4iz+Ttpyjwp7PpK2tquKrPu5UppBiAFrQxdxql7XDle5Dqfv38B6w3I2Do4Gbvp69S1
	 bo4HthCEEjxPWR8n/4y/e30TxuZ4qVxx/mH4kLCjS6gVuH1k4hX/+EzGBJGGwCj/bJn3i
	 zx3/FLcTex3TJg1DDrlw+sDr4Sx3qCZp9Wj3zj7OaZgO7AYLT2IqP0SU/hjZSFBxc8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Q0EhKKapcHhpTpahE+E1No47tUBGrpGXlq7WaxR4wI=;
	b=BxDVYec+oZUvrICzqLw1lMgnaBkR5zOUCfK6u1+GN24Gjj6e8zgAHFc0gZApUsxQbwX1
	 sOMRN7b0MTb2ZBuNIyjhD8RzBgNcayuXSY+wxxit9usC3OUbH9ARf3lxd65wBwOk8mxFN
	 U12QHjTUgiYy+D6TGx1m0k90YuGkq1Q/hdeiRg0Ua4W8WmgpnQBcP38vZmE8fgSxm14Fl
	 UOqUT5n1iiKo61DfxczLkSeBwo3pKIn+I4bwB8q9/TKHZkz/D9G7fpEYDWnaIsewMlFMC
	 0ssGYDdacrz7Aa9PJ6B6KrSyex2/uppEk1U1IFoVbPUpc3Qka18H4Bjw2gAPzNOYGXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5QCd8tL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A24E60A2631;
	Wed, 18 Nov 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5QCd8tL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870AA1F000C9;
	Wed, 18 Nov 2026 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015113;
	bh=/Q0EhKKapcHhpTpahE+E1No47tUBGrpGXlq7WaxR4wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5QCd8tLsZMg5x8JS+hmOEnwB8saZbR9Wxv0GLRLbrhZnbTv3eKp7VqXX6iKoXaBk
	 BS6PuYsULzrjDpYn1FEHvMOK43+bvuyDbCbu5gd/I4Mz1LrUM1DBP0m1mWaMWMpSjt
	 MYsD17+LBOoCYD81sHubgm0fLvrocRaVUJRnjI4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0056/2651] accel/qaic: Add <linux/device-id/mhi.h> to qaic_drv.c
Date: Wed, 18 Nov 2026 15:21:36 +0100
Message-ID: <20261118150249.965354879@linuxfoundation.org>
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

[ Upstream commit c8e6229a81d0400a8347c70b89ff363ec08c816f ]

qaic_drv.c uses mhi_device_id implicitly. Include <linux/device-id/mhi.h>.

Fixes: c501ca23a6a3 ("accel/qaic: Add uapi and core driver file")
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Reviewd-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727173326.2219191-3-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/qaic/qaic_drv.c b/drivers/accel/qaic/qaic_drv.c
index 0acf6cdd44f81..c1bb6db78d129 100644
--- a/drivers/accel/qaic/qaic_drv.c
+++ b/drivers/accel/qaic/qaic_drv.c
@@ -4,6 +4,7 @@
 /* Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries. */
 
 #include <linux/delay.h>
+#include <linux/device-id/mhi.h>
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
-- 
2.53.0



