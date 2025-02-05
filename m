Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1557E792;
	Wed,  5 Feb 2025 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766306; cv=none; b=N/Z3C30OJ4BuBKGEBl3u/sH8lcMS+2vFh23cvuWvDjeNzjBS/6gRGhK0BAgG/KtnNjihO+k6bri9rZFp9RO1mNpFQB07cHaM1b7mlKi8dQaD44P9qTPWWzgUYYPFgYlHeHszoVuQAv9GlO7AV+H6viLmH+cWWW6frn67w8E/NIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766306; c=relaxed/simple;
	bh=npuT5Cq+rh9SvMvYLQeOVQD/YZuLY8zIgsgSBheDAxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF4hiCaZIRnCNSuC1aRuuOGsSuqHUWjvxw+jVYGlxmA1ilSj0CVNsdM3FlmNiZ3TPgH6IxEt7SFYtj7APVnx8MZPwu7uoCWEAE8g5DMEUXg49wVllqgIr0eWFFLIIAkSmnOImpfW8L7i+iCS2/hC/1YF1ZnlRM1xFJmvbbA2DiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTeIbQ4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTeIbQ4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC870C4CED1;
	Wed,  5 Feb 2025 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766306;
	bh=npuT5Cq+rh9SvMvYLQeOVQD/YZuLY8zIgsgSBheDAxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTeIbQ4HMqgkxt/Jqzsldynnbc9eaNcRjqZFTVe6bbSIUtXr17JienDAfSrL0Bbo0
	 16cpbnHImfMXUhXUA1aFRv2lIrIDxQSc4icDEKkK+hEL3g5UVtzHly2U5YQQ4Ktumf
	 J6FYE+CHu/1vH/p01yZDP+ZTX0THid532DaLXhOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/590] arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A
Date: Wed,  5 Feb 2025 14:41:04 +0100
Message-ID: <20250205134507.097677909@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 2561c7d5d497b988deccc36fe5eac7fd50b937f8 ]

The Android DTB for the related MT8167 reserves 0x30000. This is likely
correct for MT8516 Android devices as well, and there's never any harm
in reserving 64KiB more.

Fixes: 5236347bde42 ("arm64: dts: mediatek: add dtsi for MT8516")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241204190524.21862-5-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index dd17d8a88c190..e30623ebac0e1 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -144,10 +144,10 @@
 		#size-cells = <2>;
 		ranges;
 
-		/* 128 KiB reserved for ARM Trusted Firmware (BL31) */
+		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
 		bl31_secmon_reserved: secmon@43000000 {
 			no-map;
-			reg = <0 0x43000000 0 0x20000>;
+			reg = <0 0x43000000 0 0x30000>;
 		};
 	};
 
-- 
2.39.5



