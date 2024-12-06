Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBBC1442E8;
	Fri,  6 Dec 2024 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496880; cv=none; b=dS7mgKvhw+ikX8XjMK7AhGS9ZfSfgTZTJt5E4EM6AQGkKZvHknSOpielqi6IOBgjnTx7l7P7C0b2ZVfM+M/vHClbOUurpq2xMc2zqCBNJBgHBM+0BZ+8IFYB3BbQt7YrYZo2nKe/mbT4+KNfeFo6NvZi1ItX0VITsAQF2/Dgphw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496880; c=relaxed/simple;
	bh=14MQ4YPAbDmEeKPXttrIxaZpqYTfEFjEcDfIQ24sp5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESuqr4cQpciBpVD1ZEeqoPo/vdMLMgGnFMiMHIHkCgJxJyd/gG9gK7aj0a0PPP2naweaPBHvcAigczzpr/ZiHP1u6G5i79LYvT6WB6GXOLHhAf+FcMbLsOsvd2UmKZcl75p8RopbpPPNyEPGvEZfk8mHZhMYeq11XeLzxsivlzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ui5uBAaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ui5uBAaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404A1C4CED1;
	Fri,  6 Dec 2024 14:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496879;
	bh=14MQ4YPAbDmEeKPXttrIxaZpqYTfEFjEcDfIQ24sp5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ui5uBAaqcCHHaak+h83QtEPLnBXLIIew3p4IuWkuL4rTTvhhDOmQYSh2LswQ7Kfiw
	 8UzpPq6ts1JjDSjNwiOMh+O7P7lk1mj+VsUGFyavi2N638n0vgVrZWjSTKu8fOzwa3
	 SFpzhVApKjFyDyLH1PuSDhIu5maWUu2RKsAXl0EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/676] arm64: dts: mt8183: fennel: add i2c2s i2c-scl-internal-delay-ns
Date: Fri,  6 Dec 2024 15:29:11 +0100
Message-ID: <20241206143658.512336741@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit c802db127dfb9602aaa9338e433c0553d34f1a9c ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: 6cd7fdc8c530 ("arm64: dts: mt8183: Add kukui-jacuzzi-fennel board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by:
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-1-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
index bbe6c338f465e..f9c1ec366b266 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
@@ -25,3 +25,6 @@ trackpad@2c {
 	};
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <21500>;
+};
-- 
2.43.0



