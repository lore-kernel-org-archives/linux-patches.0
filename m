Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030490;
	b=uX6TiZfgo0dsMZgiK8s+5KkkJ+e45sHY62LYq5zawreklza6udWU/TcnIa2umhwI0DNy
	 NSgyvzlPVfVrJ7qQohFPBd88T52Il/+i1yjcLR1eiNUsnP3Mo6kxNK69uP1fMXooW4SeP
	 szASZxGw53sj643oP6rXtMCOAs3YqwWv5L6YZPnuUALEHycYrQOkFyxaY4pQEr8lzMJ2M
	 fjsSY1uaq3l/58qiVw212MA89pwkC9rRbjzDIvfTxfx0EXDPcz/OC5yKEi75+7XSFxE0F
	 YwkxpT+gwt7OS/iEbiRuqe6TDk2LnPfiMzO+UvUzXN3zWBUkO4VSnuB5XmqQlaIfqHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOaifonBvOCNdoHJJ/GX6HiQX61xnY6BGHc8wSt5QDY=;
	b=cJ20MLQ3dj/SLDjTU6n4lsUfNWJJtzgd1NcPnITTmJvdI/9OZ2wNMIlo9jZpVjxIYOPs
	 3xdmJNclKlFJ1iqIzo+JYLV7jMPkER/JqC/LqQetHyT73dSO6Y6GhbKANjezxi99GOnrd
	 KsZMX4jX/aNxt9LQn02lFfi69ek40+ANSUgd/Gz9Y73GH02IaaWIV5Co+pEEWaPRThCrY
	 cGergQWBFDovoe0hthtFBizUbnH4Qo3FApALW5vB8XJYOx3ywVyZVCJr85ZcWTjvmV3N+
	 8IqEHNIV5J40fONegqL6B83AKG9+jjEM3YrFXn6RFBIxdMBRYgoEX+FxjnB4rT+SPcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Klgie9ee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A60D606BB51;
	Wed, 18 Nov 2026 19:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Klgie9ee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708BB1F000C6;
	Wed, 18 Nov 2026 19:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030490;
	bh=vOaifonBvOCNdoHJJ/GX6HiQX61xnY6BGHc8wSt5QDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Klgie9eeqPI3GekmHB/XeZCRO49eA+ubGU5d8oNaqL5uu89i6Uxj0rA3tgJE5ttQj
	 PIZgPeBTm56ugmZloPAUhWrYpfkXt9J8KP4BtXS0whHGfvlAzRZVxA25GjGrojmHYT
	 LxgxFB3kdAclXUlFi1GjPuPV996zaolIY5mwqRzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0722/1756] drm/msm: Properly handle msm_ioremap() without name
Date: Wed, 18 Nov 2026 15:47:29 +0100
Message-ID: <20261118150038.445429820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 14fe0ea79e0e25efc603f6f4bc81cb5b813f0e69 ]

msm_ioremap() accepts being called without name of the region to map and
in such case maps by index 0.  However error paths still use the name in
error message.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: c8afe684c95c ("drm/msm: basic KMS driver for snapdragon")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752660/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-5-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_io_utils.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_io_utils.c b/drivers/gpu/drm/msm/msm_io_utils.c
index afedd61c3e288..780899c7f6fac 100644
--- a/drivers/gpu/drm/msm/msm_io_utils.c
+++ b/drivers/gpu/drm/msm/msm_io_utils.c
@@ -77,7 +77,8 @@ static void __iomem *_msm_ioremap(struct platform_device *pdev, const char *name
 
 	if (!res) {
 		if (!quiet)
-			DRM_DEV_ERROR(&pdev->dev, "failed to get memory resource: %s\n", name);
+			DRM_DEV_ERROR(&pdev->dev, "failed to get memory resource: %s\n",
+				      (name ?: "#0"));
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -86,7 +87,8 @@ static void __iomem *_msm_ioremap(struct platform_device *pdev, const char *name
 	ptr = devm_ioremap(&pdev->dev, res->start, size);
 	if (!ptr) {
 		if (!quiet)
-			DRM_DEV_ERROR(&pdev->dev, "failed to ioremap: %s\n", name);
+			DRM_DEV_ERROR(&pdev->dev, "failed to ioremap: %s\n",
+				      (name ?: "#0"));
 		return ERR_PTR(-ENOMEM);
 	}
 
-- 
2.53.0



