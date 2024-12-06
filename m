Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4287E1442E8;
	Fri,  6 Dec 2024 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496883; cv=none; b=PXvmRbf1KHVnBA4Jzy1MdRbmd5aBZRucsXlJcM05x3nvWCn4+azCSXzzQJDXNJ85mlyN1ZkpsgXHgujLZENfDJMunJllMBgZ4fgK+OTvhsAs0QRvYrkX3+C8hJEnMbx00Yfsezq2If2SHZcsJAS3vqgeKe5s1A8P4yAYkiW8W8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496883; c=relaxed/simple;
	bh=1DLbxVmX8DB9jG7L1YKblztb9ZoO7OEdIlRrTEExD68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnJaNycEayW/l3RExQFW+Gb6noEKOK/fAuwKZhk6Q5s2Hn1JRhrjHbzenimOfCvWZTlNGAEEgvuqolWv95tnGkamfzjZ4BBiBTNPX0zroyk7BjC8ZXz175pXLEeNdk0gFZfO+0u7UYSO4ys3cjhPMHnqzZJ3ElX6W6+XPlqbli0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfT+FIXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfT+FIXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7D8C4CED1;
	Fri,  6 Dec 2024 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496883;
	bh=1DLbxVmX8DB9jG7L1YKblztb9ZoO7OEdIlRrTEExD68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfT+FIXMaTfnfWqmSRw1e9xkdySYp+jQPosCkW8cg2uEGnJTz9ZFg8UV7F2+kH4hK
	 2a2wntCT3MfcjPs9R2p0c/5uJMwan6uu3EI3VhevOmNfqYlvBWWZrcobKyUTdsh7Em
	 cw/bO+an9MET+WPDB3E3MaUBZjZZ6w/KPuWu/Y8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/676] arm64: dts: mt8183: burnet: add i2c2s i2c-scl-internal-delay-ns
Date: Fri,  6 Dec 2024 15:29:12 +0100
Message-ID: <20241206143658.551537730@linuxfoundation.org>
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



