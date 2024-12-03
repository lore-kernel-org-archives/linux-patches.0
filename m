Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F491F76AE;
	Tue,  3 Dec 2024 15:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240565; cv=none; b=LRY4nP+ncnNkbsrTkbEcd1ycpcgTI8/sI6bvMvztpb+H2mLPmtHIN0rxjhUOiYPmDt+pSTARhMCMqmb1FltS2xtODvF9cS3Nej9QDHG08hZby18vrulgbFGR1Y8aHqRVtSKnzPSaYuLZmYkYpNp04INF+YN0VBNSUySQYr4YOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240565; c=relaxed/simple;
	bh=O9MheZyEQOazxqcXXph5zTIrRyb44oox/3COodhvSo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkYX0tWe5kbsyaIgvyrvQ5Bbdy7lfhWiXcKntitUJIMDXdAO3YNJvv84GwD0E5Ek4paUmBuipP9iuUy7YCdET8dWooTWjIls7vanwB2PIfUUkqL8GJOxT71kFRGkJwH70Iea1iR7YVd57EWfJyvWCzXfbM7oHVIzOEejsDHO51Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhoe+Tcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhoe+Tcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79811C4CECF;
	Tue,  3 Dec 2024 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240565;
	bh=O9MheZyEQOazxqcXXph5zTIrRyb44oox/3COodhvSo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhoe+TcfrHRniCU8vIkr5dS5KS9a3UEQRy7FET5Bot37g/+Fw33xd4egy8HXS2Ko7
	 ZiygUDZALVNa9dbV0Pvn1sif8G76GpTIBVzM9YxPicaKtqL8kaOThY7EgPLWForOp0
	 j9Bp60A+d9wNF60JKPkKIjQTCT/zkc5DsSBsLY38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/826] arm64: dts: mt8183: burnet: add i2c2s i2c-scl-internal-delay-ns
Date: Tue,  3 Dec 2024 15:37:49 +0100
Message-ID: <20241203144749.286228770@linuxfoundation.org>
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

[ Upstream commit 85af64983889c621e8868b744c8ca03bd5038c02 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: dd6e3b06214f ("arm64: dts: mt8183: Add kukui-jacuzzi-burnet board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-2-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
index 19c1e2bee494c..20b71f2e7159a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
@@ -30,3 +30,6 @@ touchscreen@2c {
 	};
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <4100>;
+};
-- 
2.43.0



