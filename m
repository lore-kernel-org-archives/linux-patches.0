Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CAB1F7572;
	Tue,  3 Dec 2024 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238235; cv=none; b=BdlqWpekYoUjhm4k3s+LIiOShHD7Rc5D85XM9374jZ3PbIzuNhgu645PLFk/O/cuJywDFpXy2wQM+83jZ/HQ4Ppyy++YjK58NtVH3a23vYNrVdvB4rebLgJMG6I3T/1FbNcoH+0QgRPFwGHHHnThuoVYZO5NwgUx3K+JbW1wovM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238235; c=relaxed/simple;
	bh=bNYhbPg6pEx1YtzG74xduv4OejjpdLYVBAQBGspBbEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kqpv7FnlfCOkjR0q8KnOAJpc870O+wjIk4/INMwqf93E5urJV/5scsbXQeFQ0iQY7sSiqS0aKNmP1JhwYw5+CdTymk6pu3wRRUgpnMl8o59ydWjIW5sfkVIDcJqxrt3NCpkIwzi/R2BfsN/cLoNbmVQwreMiFJxRx2VkFgsgaAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZT25TgCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZT25TgCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2961FC4CED8;
	Tue,  3 Dec 2024 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238235;
	bh=bNYhbPg6pEx1YtzG74xduv4OejjpdLYVBAQBGspBbEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZT25TgCA8PVycA8vVz0dF523tkFjxLKgD5MdtT6YjOwqv1Wov7ZK3LhlyDpx3nZnd
	 Kvi2+MQpgZMk2+X7l7VDQ2haGyzd7M/hTBY/gRQzvalfI2U3wsnYks8za+GdEqk7oo
	 GFqxjxbZaMVer90ly1HyKHaX8zHGZakE8POT9pRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 177/817] arm64: dts: mt8183: fennel: add i2c2s i2c-scl-internal-delay-ns
Date: Tue,  3 Dec 2024 15:35:49 +0100
Message-ID: <20241203144002.639739721@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



