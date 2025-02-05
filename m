Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927EB13D52B;
	Wed,  5 Feb 2025 13:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763333; cv=none; b=C2R2BaFsoOtIBEuuBnBbWEsol/ffXeQgufwBj0d5pDJEv29hw6yY0OKoONtX7haKG25omQuAyNUK2cJ3pPTqsQwRXxbNWplDJOqtqrBkO9xCtcQvcj47nwQ6Gu6s/wA9qKo5xVJcenfyStt/1UHdUR9hrYAqKQ9R+RjIy0dfzEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763333; c=relaxed/simple;
	bh=6HEbxa3hjIKdKzHY8sS20HVJWLvbzuF6wLrCsLSPeR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5dALMMDwe3wdRAljGxJ16IxNZVJeEvdadbmq2ud3pXmCBRdWEkBW/IRtvUzIXaeHEcHuSo4Jo+3kQCKwt+bBxP+yLPO/n6UeLyfIl3vZx/MOgOCsRvBExip+5fHcess+0BkFp4OWbnxc5SI46K1JdmEIi/9osGktTpw1HAzAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7fPVHtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7fPVHtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0268CC4CED6;
	Wed,  5 Feb 2025 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763333;
	bh=6HEbxa3hjIKdKzHY8sS20HVJWLvbzuF6wLrCsLSPeR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7fPVHtMqfq3b1Pufk9oR7yBIT5ee28ArXnj1+iwsQFZ2IefDPZBz8cyxF/BrZ2kG
	 Mx9Z7zRSvRk+uBZvfta2imsAlkFB06eze0oDwI0Ar+CTLHFK7ORBhzQNRAa+GYOwUV
	 XeSRV0O88B6Jk2yi5sW6qTMQf2Hb/yOhCjVv2Zzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/393] drm/bridge: it6505: Change definition of AUX_FIFO_MAX_SIZE
Date: Wed,  5 Feb 2025 14:39:23 +0100
Message-ID: <20250205134421.988109960@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Hermes Wu <hermes.wu@ite.com.tw>

[ Upstream commit c14870218c14532b0f0a7805b96a4d3c92d06fb2 ]

The hardware AUX FIFO is 16 bytes
Change definition of AUX_FIFO_MAX_SIZE to 16

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-1-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 26d3b9b843267..24c5a926af8d1 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -299,7 +299,7 @@
 #define MAX_CR_LEVEL 0x03
 #define MAX_EQ_LEVEL 0x03
 #define AUX_WAIT_TIMEOUT_MS 15
-#define AUX_FIFO_MAX_SIZE 32
+#define AUX_FIFO_MAX_SIZE 16
 #define PIXEL_CLK_DELAY 1
 #define PIXEL_CLK_INVERSE 0
 #define ADJUST_PHASE_THRESHOLD 80000
-- 
2.39.5



