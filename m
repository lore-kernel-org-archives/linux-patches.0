Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D5912C462;
	Tue, 30 Apr 2024 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475168; cv=none; b=gc5pJ6pXwCj3EGUR7zwvgmPYdLloZCnDqicDE/9fFuEILPu7JXtA4bdxTxwU0rHU2MPsZZoH1B2khZ6fYuCiIQF+icQWElnd+LnXZpgjY/7R2RfjyFnzPAk8HhkOZou+CQ4EKkWvuuIWrJoZTJOu9gTQacjGq+8DaUnZ79FTYPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475168; c=relaxed/simple;
	bh=ZTS0vDH/S2dfaLlU9vKOyDhrfWWNZKsf0hpjiLatg6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1Ckic8GVB7NkPYIfqXbXViZWcHTeBiW0YTWOV12jKAVv4cyqaohaRczOgOyOPK8dlYe/5hjrLr6CoGmXH0jbvQ8/hegmhE9oaxi3JIBrIsjYA6MlKQ+/MZ9m2w4/S8Ynf/aSb9yM+8iRS6Oqxze/bcupOVIcQ+VGLe63NRlEw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoFy+Ssy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoFy+Ssy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68ABC2BBFC;
	Tue, 30 Apr 2024 11:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475168;
	bh=ZTS0vDH/S2dfaLlU9vKOyDhrfWWNZKsf0hpjiLatg6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoFy+SsyvhjNtW9xPnczHpqt76u79mMWcOmhakljzV7FSqS8xYSCj9zrD0V/HDmeD
	 K3JoJPk6R8hZfCpnNT/wWxQSjnRXpK3XZKcJbWdJr9W6Xyp/K+ErsCSTEkdfxFDEA3
	 6UmekuP2HOGPOvtf2VElBlmCkuvtkgQolH3KB7ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/186] arm64: dts: mediatek: mt8195: Add missing gce-client-reg to mutex1
Date: Tue, 30 Apr 2024 12:37:47 +0200
Message-ID: <20240430103058.463640978@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 58f126296c3c52d02bf3fad1f68c331d718c4a9b ]

Add the missing mediatek,gce-client-reg property to the mutex1 node to
allow it to use the GCE. This prevents the "can't parse gce-client-reg
property" error from being printed and should result in better
performance.

Fixes: 92d2c23dc269 ("arm64: dts: mt8195: add display node for vdosys1")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240229-gce-client-reg-add-missing-mt8192-95-v1-4-b12c233a8a33@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 884e56f4a93bb..2bb9d9aa65fed 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -2850,6 +2850,7 @@
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
 			clocks = <&vdosys1 CLK_VDO1_DISP_MUTEX>;
 			clock-names = "vdo1_mutex";
+			mediatek,gce-client-reg = <&gce0 SUBSYS_1c10XXXX 0x1000 0x1000>;
 			mediatek,gce-events = <CMDQ_EVENT_VDO1_STREAM_DONE_ENG_0>;
 		};
 
-- 
2.43.0



