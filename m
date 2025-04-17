Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226868462;
	Thu, 17 Apr 2025 18:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915462; cv=none; b=Vu7ugYCNoafmp90VkUCFWy7br3faBJPhbwbF7K3G3u79NjT++11iubeyeSUxXUgJnpQX31fhfJrljaf+tWys0JrB2pT2TncwH8aIH+GHnRc+ar7LpTc/GDMXSOcuHdk6DlxbS6oHg8S9ZUvNXfUXDFeXUaPokGdCn2e3FUtLdb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915462; c=relaxed/simple;
	bh=N6+NyZeiW00dWBULPPh4kjyXRdr682jMrSOiDzU2iy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEwXTr9nZntLbPQ1++0Jja4FVcgTRyIqdawjRJwaySRKOthrnOJKNieIELp/1PdiR624j1HIoVhzQRg49AspUh85JlZndU6xu9xuBHwsRCYq3n2rCtmJ6o6bWThl+9oa/Ooeqln1ZemFLILKvOBPu7hg6uRtDA62PMxI63/xzk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVQRgIzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVQRgIzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D23C4CEF5;
	Thu, 17 Apr 2025 18:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915462;
	bh=N6+NyZeiW00dWBULPPh4kjyXRdr682jMrSOiDzU2iy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVQRgIzMJApRsqHnrbBlgD8iCtDm9u6ETloIsy6jE0QhhWzE8dz/TBVUNPRxaAIfx
	 LUTmFThKW3VwEwVWQWmHmkm95itCJCwo1gJg7o8fIYSp8tWsb5/bBhHJ7+8GYhY/8T
	 FIhaS07K/tVzaUv3UGL/vvhWxni2aGP4OEJCfHPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/393] drm/debugfs: fix printk format for bridge index
Date: Thu, 17 Apr 2025 19:49:05 +0200
Message-ID: <20250417175113.056385430@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 72443c730b7a7b5670a921ea928e17b9b99bd934 ]

idx is an unsigned int, use %u for printk-style strings.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250214-drm-assorted-cleanups-v7-1-88ca5827d7af@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 9d3e6dd68810e..98a37dc3324e4 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -743,7 +743,7 @@ static int bridges_show(struct seq_file *m, void *data)
 	unsigned int idx = 0;
 
 	drm_for_each_bridge_in_chain(encoder, bridge) {
-		drm_printf(&p, "bridge[%d]: %ps\n", idx++, bridge->funcs);
+		drm_printf(&p, "bridge[%u]: %ps\n", idx++, bridge->funcs);
 		drm_printf(&p, "\ttype: [%d] %s\n",
 			   bridge->type,
 			   drm_get_connector_type_name(bridge->type));
-- 
2.39.5



