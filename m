Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018089;
	b=M03Hmrg+dDG+M3KvYFMx0M5vmICzWjkUJvqqkrHjMZRSdMoUuu3goQBhMQ1I1oMyJXoE
	 vlKc48D9OCHQRY2ceUaX949n0Jvaiih00es3pkdd7rjVAeYy4quz5tYMYe+brI1Rf4A+B
	 pF4Jk68bOjqnIVoU2wGicD6AScnyn8g8hcDwTSfBwXyuyeWOCvXKce3liAbBYQsqqrDtz
	 qXvlvGd2oq47NpzzTO9PD7YTbhji20wpZUOSmsg1XqiiOu9Sa/raGVSG4DNJNWdH3HZWr
	 0YcfXP+76wCiL10ffrcpaf6yauxDeKj3pBSHZOcn7/LXa+1u+uGNtVpfK45xxv+atjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qchp5upPDcy2DB4mARjg+jQctXfMl74B5+png80z3do=;
	b=gjTSp9lGQ6bFUZUstOP5U7Zy8bP9beyZMZuKV6TrqHjmHlrItGXkmiSALyZgeXTdaeWA
	 jtDXm+EArc+sVYytXwgqjG585PIgw9JqNDfkqKeYeL6Jfq9pmZmz9gMW8niREkK/yvB71
	 +tfU+teF8FZIkDkSBH638NAEdc0s7Ly8pLBw/7cJaOLvYHM5g8a+l152i0Xp3Qw2+ipiV
	 bH3JUhPDW8AKjpLAIzhAPQ2E+XRIM+2UYc8hEKXCb4q5NDvSASo8HwF3X/r3Txwq8db/z
	 zVke2vPwM7KC9R5oR60F15RANXbRj62j3jFgYcSeQJOuCwNYcldnaBXFG8M3ehZpcAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUe4DBlU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA06F606A330;
	Wed, 18 Nov 2026 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUe4DBlU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B511F000C4;
	Wed, 18 Nov 2026 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018089;
	bh=Qchp5upPDcy2DB4mARjg+jQctXfMl74B5+png80z3do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUe4DBlUH+vbuYkx/47oZZmzSKVF2wNnvCUP/ezWBFoRwOxric8drrJIjOlmiqOxq
	 rmjbJRkQB/SAAZcM9SlNrooMaASQFW9blw1Z+3RcMna12gKG9FKczMVJtWmlVdmNVL
	 ZnG0UWL5CD7N3niCaT1iM5aKkQg0c/Q2lBwpPARU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1092/2651] drm/msm: Properly handle msm_ioremap() without name
Date: Wed, 18 Nov 2026 15:38:52 +0100
Message-ID: <20261118150327.311874218@linuxfoundation.org>
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
index a6efe1eac2712..99221b0d7e3f0 100644
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



