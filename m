Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017811;
	b=2sm9qsWdPicEzraU28LxxHhB5TuvPWcACZXLPbBlscT7YcS0URdixQ0VW6emQnOV33eC
	 fcfVshxD1ucG38s8X9miPvV/KefMUMsJJ7q18IogPLeL6UPkno8wuO8L3z9Jh2JVXPzzK
	 zdZP+tOou5EWw5y8eiJ2nJHEC0+P31VRymQo3vaG+tFWllETdiBfZdGL38e6qu04LwPlA
	 T900b6hoWj/b8nH9X7Jp7SPi1JyP14gY/jexn9XPBBhdoc4B7yRD5vFg233sNwwZlx+Me
	 zIPzaEC9/L9+HEVtngSaJXciVtkPOo0rxXSVOPSqTrYIYKYreiTmlmNi1bnCHHhOHKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3w+KpvUQqdmPa1oyW5K4/dYd0caZp7zhllQ9oTd74o=;
	b=enUaKekpSwlbdSWnCdEGS8Dqrd79SO6nbx4LT7iYgLCUjouk5GfUm1ITfVfwfbwsBzBq
	 tCNwrsyt0eUZ4+/e2wK+4ckFfQwRnCYBJeJIJAuVb5aaFy0fWlJ8/zYQgOZj16o+pFEJ5
	 7QARXlkXvIDyjsLFwkSKRwGZXFRd/togKfSGPIFc2iI8XasXPIsaqtiEkpsX/UJCVEZ0J
	 qV+PtdSznpqy4C0p64LoVRcmpeno2qG/7gvn/E8jJbwXX48nHgQ+yRIgWVvmNLQE8BqV3
	 vOXXxS9zja7aRzJd7/jffq/bexHjtsT7iymFgTCo0MBoEXfG0VUcny1MrCVlu9IZ2Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kMXEtdtx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37164606A333;
	Wed, 18 Nov 2026 16:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kMXEtdtx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B60A1F000CD;
	Wed, 18 Nov 2026 16:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017811;
	bh=Q3w+KpvUQqdmPa1oyW5K4/dYd0caZp7zhllQ9oTd74o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMXEtdtx+drr5ejf+h1sJAbxttnQl8lOI2yyNpzy7iAv/kHuVcwXw8tWJIWkwtbOo
	 mLa8SdfYaLHS9HN5iGPvxvdu1YZS27qsRbJINI8p5WQ1ur+L3L24Ajqk7HXQ6uzFAE
	 3eArLfSJ4v7AU7dvB4/tTD6RgsZdDTuP4ZtZqNCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1017/2651] media: iris: cancel sys error work on driver removal
Date: Wed, 18 Nov 2026 15:37:37 +0100
Message-ID: <20261118150324.539049727@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 4524809316482b64ff092afb7e7b0525ce137c75 ]

Cancel sys_error_handler before tearing down the driver.

The delayed work may still be pending when iris_remove()
runs. Since iris_core is allocated with devm_kzalloc(),
allowing the work to execute after driver removal could
result in accessing freed memory.

Fixes: fb583a214337 ("media: iris: introduce host firmware interface with necessary hooks")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
[bod: Fixed patch title]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_probe.c b/drivers/media/platform/qcom/iris/iris_probe.c
index 6581a969fe3fb..c4b8b4be339d9 100644
--- a/drivers/media/platform/qcom/iris/iris_probe.c
+++ b/drivers/media/platform/qcom/iris/iris_probe.c
@@ -251,6 +251,8 @@ static void iris_remove(struct platform_device *pdev)
 	if (!core)
 		return;
 
+	cancel_delayed_work_sync(&core->sys_error_handler);
+
 	iris_core_deinit(core);
 
 	video_unregister_device(core->vdev_dec);
-- 
2.53.0



