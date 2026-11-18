Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015121;
	b=NDFTreJuMhatYnWnylagtkXUly+QSvPfoRHfj9wPjq/VHwxhT8vfPtAT9qZ6jeG7UkXa
	 idbakhtDfpSByWZOQ3YrzlRoK6N66KjYHId9L8Iyi/rKcVIc8VdShQtEIp3jYmMA72QnI
	 fS877YqIt33bSdXSzhHEcESCvnOXFrxdECdWDi5C2LLOWQ6xZogfrWIMkTyRYIm8BzaKE
	 zytZhr5x8b8gKZeb+WE/xSKRVpsfAz7MwmKEp1Wmx6hDuLtKo8r24fNiZJmfDfcu8fAnO
	 bL0Kk4AOI1SDjFPVOCJEhi5CXc4o24wW5JtSXtSZODKhumXvV2oubugeIKrPi88pBlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZUnG1OUkJvRx1ZRO5kcCOi9TTCduZ8rXOiht0XTeOYI=;
	b=yVX5X5335FJxd23xRxg6ZD19MYneEGHXGyRbyLtiyDnnQkUzSTnn1ihUiwOzhlMbDgiU
	 4ASe1EJTM/lXLxqD4XNeBrNbduxi/hNvKvYo4u0UO0J0+FzIXbJHNhpyUcAY0DZgHZ29Z
	 RjmkAoiTWpNn/ViaE7Fo3ZS5i2N2srCrjHbLaWHd0vufUWNjpVmiPVmjuY9I0kMaQm62l
	 iDsOc55HKsnDQyDY9rC3QANH3+qNjq6EzldLGKOng84kCEJvJEuhBN2BXpTxJwDTS/tnK
	 dGX0/Tvm7wRuG13VdbF7Wjm0ex0D9sMi32TI6/pP/lDWxDF7+hY2XLZHeWsu2ogOKzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdwiXW+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E68606A33A;
	Wed, 18 Nov 2026 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdwiXW+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2F31F000C8;
	Wed, 18 Nov 2026 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015121;
	bh=ZUnG1OUkJvRx1ZRO5kcCOi9TTCduZ8rXOiht0XTeOYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdwiXW+MhmgBfVuzTrepHFkJkIa92/270l2yyv+EM5+VCASexnfs7hRCa8jnwze8d
	 ZTYG78cbhv16Gia26zHZa6g3U54Ow98NQk+f82H7vMl3HCjqUpihp4mSlc/rOuFKbr
	 UfwMV1IX9Kd9JJXolrF9AQ2bpnP/xnHRN0aqp6m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0059/2651] accel/qaic: Add <linux/device-id/mhi.h> to qaic_ssr.c
Date: Wed, 18 Nov 2026 15:21:39 +0100
Message-ID: <20261118150250.070162162@linuxfoundation.org>
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

[ Upstream commit f29ab62f7ed55eae7b246bb535ede56d3b338674 ]

qaic_ssr.c uses mhi_device_id implicitly. Include <linux/device-id/mhi.h>.

Fixes: 9675093acea0 ("accel/qaic: Implement basic SSR handling")
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Reviewd-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727173326.2219191-6-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_ssr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/qaic/qaic_ssr.c b/drivers/accel/qaic/qaic_ssr.c
index a989286549599..418f14936f9a0 100644
--- a/drivers/accel/qaic/qaic_ssr.c
+++ b/drivers/accel/qaic/qaic_ssr.c
@@ -8,6 +8,7 @@
 #include <drm/drm_managed.h>
 #include <linux/devcoredump.h>
 #include <linux/device.h>
+#include <linux/device-id/mhi.h>
 #include <linux/kernel.h>
 #include <linux/mhi.h>
 #include <linux/workqueue.h>
-- 
2.53.0



