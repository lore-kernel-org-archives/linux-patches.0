Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F511292C8;
	Tue, 30 Apr 2024 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474105; cv=none; b=cKEWK14ipB4r4eA98Xml14yWQBNXkA2kOb2bserPdODSBxi2xGUS+brDEZKJmwtBRTMvSVZGC8FaDrOlmng4v5t2bUagJnVOHSfUibIAOkfrUQjRmsxVwGXIQlncWExH6djQjPIhxXuB8ABHr2b/YgxPNk7JK/9K6PDgkW/bu2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474105; c=relaxed/simple;
	bh=gMV7VdArtLC4T8PtXq/Kz7Q3Nd35E//yc3wg3QHhHWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7F0QyUhc+CPyRH9wDUv+wcIdXujg4e2qDFfqwxAEIM/Bva1jcV+w39hQttekXIIOcTyYBBE4P/3uMzC+54S8VlKn5HwftqT6Ms6RQfvT9XU9rFyGHufkkHOmCu3uCNUC7getB8ac/5hZYs4jaKSSjKHecr5lz1wc/4kr07N0P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxag6E0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxag6E0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2438CC2BBFC;
	Tue, 30 Apr 2024 10:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474105;
	bh=gMV7VdArtLC4T8PtXq/Kz7Q3Nd35E//yc3wg3QHhHWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxag6E0gu/tTrYkEDaWGF8DGHdZgzpmDW6qXlAcMHltZ5ZaFGvTM9GmpY/IJY9Ykf
	 ei7W7465/vrpS+5WbyZX3LBrABdV8KbKjfNHq6Axwfw0D6XyjreDeuA7Ik/1KOQ9Cr
	 /jc0/hN/BxSKcZtdp/jKEooZTdOnpG0s5lkyA87U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 020/228] arm64: dts: mediatek: mt8183-kukui: Use default min voltage for MT6358
Date: Tue, 30 Apr 2024 12:36:38 +0200
Message-ID: <20240430103104.397462658@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 296118a8dc297de47d9b3a364b9743f8446bd612 ]

The requested voltage could be lower than the minimum voltage on the
GPU OPP table when the MTK Smart Voltage Scaling (SVS) driver is
enabled, so removing the definition in mt8183-kukui to use the default
minimum voltage (500000 uV) defined in mt6358.dtsi.

Fixes: 31c6732da9d5 ("arm64: dts: mediatek: mt8183-kukui: Override vgpu/vsram_gpu constraints")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240315111621.2263159-4-treapking@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index 90c5ad917a9ba..41aef6c3edfc5 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -433,7 +433,6 @@
 };
 
 &mt6358_vgpu_reg {
-	regulator-min-microvolt = <625000>;
 	regulator-max-microvolt = <900000>;
 
 	regulator-coupled-with = <&mt6358_vsram_gpu_reg>;
-- 
2.43.0



