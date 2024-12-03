Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BCC1F8911;
	Tue,  3 Dec 2024 15:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240571; cv=none; b=aNCyVvxD0jsNSSaH0s4l3/ny9TugbhPn2/h6ljBeYStnDdkVG5GpVsx/4A9oO8dmhIjQ+4mIIv/z/+uMBjb0yjQ2bnT0hvvBQfyil1mRr6vag3vwhSOJ9QOgE5GIozsY5s7UpQgFOCO0JaST5HY/BSeB2a3WjOw/NBMVbtu8j4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240571; c=relaxed/simple;
	bh=rvKNIYjkmjG+INiOlPa0lz8r4+nUL8Bryzj60zJ4ImE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT+X6nqpBqfDIMOQS8MjR+jSRy7d53FJO5yLChp9ceYK0jleoLDx6CC0dFZzJkqafx2QZV71QDvvuj4yVmhn7tnMOqhsXcgOh9/2VOoHnDHXADXmtbGD5ZCDokNQs0jE3UMFbcQMoHbKZ+gQnigFnegg0NKyMLT0b2a93utd9xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhI9tGvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhI9tGvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CC5C4CED6;
	Tue,  3 Dec 2024 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240571;
	bh=rvKNIYjkmjG+INiOlPa0lz8r4+nUL8Bryzj60zJ4ImE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhI9tGvBwUhsEm0H5epIlC++73OWjAdprIC6JYBWVsG1HTazvYIYCERgESkEhdSev
	 OJpr763SHaILcABfd0h41lQATd7OZtj9zqC/tiETkeSb8ddUdyMVI6mqM/6cdxJyXc
	 O+B8BMFq6XCX2gXKw0D+Djidu8EbOtPGUjbXDwAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/826] arm64: dts: mt8183: Damu: add i2c2s i2c-scl-internal-delay-ns
Date: Tue,  3 Dec 2024 15:37:51 +0100
Message-ID: <20241203144749.364097805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit 6ff2d45f2121c698a57c959ae21885a048615908 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-4-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
index 0b45aee2e2995..65860b33c01fe 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
@@ -30,3 +30,6 @@ &qca_wifi {
 	qcom,ath10k-calibration-variant = "GO_DAMU";
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <20000>;
+};
-- 
2.43.0



