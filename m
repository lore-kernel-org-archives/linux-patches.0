Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025019;
	b=VTZhF+GF2GOLgcdNbJg70/SN0pN5awhQny8SjRcv9Uec0VoSMW9IlAsKveHGLRfk94EP
	 ZJYkCtJF0Twgg8Dd7zPUu1EVg8yvG7vEj2kidluPC62dRVPGumDSAK0oudz5lajToNm9u
	 9t4cpVI1vGKXjnW4tvFdhqM+KrVyGpS8PlUx9Ps3mahx0mzWsXtbeLiOx6MTat7M1+HeM
	 vU4SpQ7kUYHkIyXhXnpmpijTkWL7GG+xqiL95vS1ZbViQuBAdn4V6IT6wBD8p1UnrwqNT
	 8AbXy+I643CRGu3p7eQyiD0l8GwcWwui/Nc6CT3kQyv/yDS3xFku0xmNe/TSFw4fkIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RZZNoyVcNDz7ZxEDG4lkxWhIMCLh9P3W2yro+9QD9dk=;
	b=ZRRlAHBDzdnK9TLcVTrAyuATSYo4p3lRMmyiRKVY0HzfVLvbiKdfj/qeN8zuJWdIqe4O
	 O270KPP8vD5fIOORkwyDkVgfUPbEB27r2vywKdMjN8JguKwzL3y04O5BMUPlxTAnwd7Po
	 DhbM9lA3KAcGHyMvgSQaq9AYhaWi/M1ilxIQtGDNHOJ64RN2jlrTghPUpDFp7ubwfjwKJ
	 9ZggJ7NS4xf6PYC2G3KVCa5tLmX2yO5N/3CWyaHwhVFAIs0RkLA6ODZ/pbJ6H1MxX2uWy
	 YM2J4+fFwx2BiCs19Z1m2wUk8RbeGF4/jXsxJKHSB2T5j1Xzr7PuodvBY2T1rJp+2qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLbzuT8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6056B606A31C;
	Wed, 18 Nov 2026 18:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLbzuT8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68941F000C4;
	Wed, 18 Nov 2026 18:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025019;
	bh=RZZNoyVcNDz7ZxEDG4lkxWhIMCLh9P3W2yro+9QD9dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLbzuT8FdgLYfEMP6hC0Fh8Uo0koqSg8WTXQC6qndS+qf74MN7Uz/BV3ICu9rwbjM
	 F1u+1tvQAorkFwz+GzJSFAPHQzm7yRD/iXWJh7w3XnwyDrzHMLjKmgB5uLoY66msy7
	 erPOZQSKuIxaR5P7mO/Yl+LIgj5FPY721qVLHvoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <sophon@radxa.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0916/2151] drm/msm/dp: Initialize the debugfs connector pointer
Date: Wed, 18 Nov 2026 15:44:11 +0100
Message-ID: <20261118150155.752395783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xilin Wu <sophon@radxa.com>

[ Upstream commit c2f772ec52898a3f6967d17035da7b739465f81c ]

The debugfs cleanup removed the connector assignment from the debug
context, but the video-pattern test files still dereference that pointer
to check connector status. Reading those files can therefore dereference
NULL.

Store the supplied connector before creating the debugfs files.

Fixes: ab8420418c2e ("drm/msm/dp: cleanup debugfs handling")

Assisted-by: LLM
Signed-off-by: Xilin Wu <sophon@radxa.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757261/
Link: https://lore.kernel.org/r/20260930-msm-dp-hdr10-v1-11-dbbf8b2b42bc@radxa.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_debug.c b/drivers/gpu/drm/msm/dp/dp_debug.c
index cf3838fcd154e..00fb1a7ba40ed 100644
--- a/drivers/gpu/drm/msm/dp/dp_debug.c
+++ b/drivers/gpu/drm/msm/dp/dp_debug.c
@@ -216,6 +216,7 @@ int msm_dp_debug_init(struct device *dev, struct msm_dp_panel *panel,
 
 	debug->link = link;
 	debug->panel = panel;
+	debug->connector = connector;
 
 	debugfs_create_file("dp_debug", 0444, root,
 			debug, &msm_dp_debug_fops);
-- 
2.53.0



