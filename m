Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FC22581;
	Tue, 23 Jan 2024 00:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969629; cv=none; b=IvCH6KVz15LUwknCkAoX8vweTEsS2NvrXZK4BTF0hy4CwRndMHIx+oP6fhtYpRgv//khyjXJ1a0XurB60blP6AF5lcyVsDFrOgnZuhLDB8ydgsherb3MEvAz2wLeCBKIGyALLQ0KM3YIfjDdvx5CIdRmFEPEUX5OmtvBdGBAwms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969629; c=relaxed/simple;
	bh=q5Hj4yTXIuyYQY2sZ2YExLrx9QOjbH6vxZyyK2CG2aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tf1SBAAf8a48PGQ/HbWa2fMMu+vyJ0nToL7/jCXPEHBs2S+qUjdcVAYmA8xIHitGhq0h6APllsRT/zfKUuNTBIg03B7afiWkQqv1nudoec9plM58cyf8qQH8+MkCfhdSDOAZIl7lvxhL88sCIh8oELiEueK6Zstw0T6T8yd3lws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfyvEZKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfyvEZKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E94FC433F1;
	Tue, 23 Jan 2024 00:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969629;
	bh=q5Hj4yTXIuyYQY2sZ2YExLrx9QOjbH6vxZyyK2CG2aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfyvEZKeQJGG5h+I+tjCkZYub79wJegbcX0AGk+AKt3WIRqeOzDz9UNS8sACY5Ib3
	 Fq1mGLpjnpJsbPwAV0nT75WasM6o2cMs+1blXMxrBq9Ly7zY6a7KwuJOJsbFYjNLG3
	 gXzqXaajSij3ve6bCPHUt7ZtG1rgDgnhbzxuUotc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Guillaume Ranquet <granquet@baylibre.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 345/641] drm/mediatek: dp: Add phy_mtk_dp module as pre-dependency
Date: Mon, 22 Jan 2024 15:54:09 -0800
Message-ID: <20240122235828.721520989@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit c8048dd0b07df68724805254b9e994d99e9a7af4 ]

The mtk_dp driver registers a phy device which is handled by the
phy_mtk_dp driver and assumes that the phy probe will complete
synchronously, proceeding to make use of functionality exposed by that
driver right away. This assumption however is false when the phy driver
is built as a module, causing the mtk_dp driver to fail probe in this
case.

Add the phy_mtk_dp module as a pre-dependency to the mtk_dp module to
ensure the phy module has been loaded before the dp, so that the phy
probe happens synchrounously and the mtk_dp driver can probe
successfully even with the phy driver built as a module.

Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: f70ac097a2cf ("drm/mediatek: Add MT8195 Embedded DisplayPort driver")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Guillaume Ranquet <granquet@baylibre.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20231121142938.460846-1-nfraprado@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index e4c16ba9902d..2136a596efa1 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2818,3 +2818,4 @@ MODULE_AUTHOR("Markus Schneider-Pargmann <msp@baylibre.com>");
 MODULE_AUTHOR("Bo-Chen Chen <rex-bc.chen@mediatek.com>");
 MODULE_DESCRIPTION("MediaTek DisplayPort Driver");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: phy_mtk_dp");
-- 
2.43.0



