Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416688634E;
	Wed,  5 Feb 2025 14:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766263; cv=none; b=Po+ZmPhcpHGcSqxm5u2AvlX+sCfEViZbj64+zJgu8wesIqCrDAnOENba3Eef+kZNHh/DqEm243K5e5DptAwEH14fEKmvufZmgWdGttHd19BYc+g+Fc5bRX9TcQcpGAVee417FT5/zX4PCHLi+2KGQ/lg9IA5LM47/ioYxnU7iyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766263; c=relaxed/simple;
	bh=EfiPe+atpfOkUEtlqvBSxBO1XHJc8E9NoWYMtgu2ZYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK2cmSBkq3SLc3722qFnLyPuePwnDnvDA+tTQxDgabrlTWOz+Au1WR/jr25ZPR2qdLEQnYGtVAx8XSZQn0G9F7tvPC1Y5AjPZfRJ7HoG75Z/sx6f+yILlqSrHJzM+p18XeqKaDcwNNTSogy3v7BG+o01Pf0V7xgfH14ZHMDL3hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hk2XKnVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hk2XKnVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BB8C4CED6;
	Wed,  5 Feb 2025 14:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766261;
	bh=EfiPe+atpfOkUEtlqvBSxBO1XHJc8E9NoWYMtgu2ZYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hk2XKnVurHS4tzpxJVsDiNj9t9VuWjE0hf3HrOLP2nZr5+5f0UdyMp4/tFwdkvfvH
	 cxPOtaFxmYs0jjsQjDVBDURTp40nTxYUU5O7+f9p6E+JaZLVBmDpA3AArkzRKXOedk
	 zdLaf3aIvKWpYEwRFIq7hwrK8UMqFJHdvd5b7J7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 305/590] arm64: dts: mt8183: set DMIC one-wire mode on Damu
Date: Wed,  5 Feb 2025 14:41:00 +0100
Message-ID: <20250205134506.946496265@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 6c379e8b984815fc8f876e4bc78c4d563f13ddae ]

Sets DMIC one-wire mode on Damu.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20241113-damu-v4-1-6911b69610dd@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
index 65860b33c01fe..3935d83a047e0 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
@@ -26,6 +26,10 @@
 	hid-descr-addr = <0x0001>;
 };
 
+&mt6358codec {
+	mediatek,dmic-mode = <1>; /* one-wire */
+};
+
 &qca_wifi {
 	qcom,ath10k-calibration-variant = "GO_DAMU";
 };
-- 
2.39.5



