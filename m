Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C8B1946C7;
	Wed,  5 Mar 2025 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197060; cv=none; b=uqsORxlcLywG3hyjWLcoriZXdaJO/K6IvoEJe2gl7WFEcuaPgX0t4tcUdIrkPOYuWBAFk4KRPWVDyUWmoQL8eAqQ6VxwY3joFWWcg3sSErbaXsTv+GqjvoWdaWx8JD1YRw7NBOvt92+YAuDnxKfXHfsIdleMK+xRuHSdsULiJwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197060; c=relaxed/simple;
	bh=dSt8yiiod9ctG7+8Yg5KjaQsPvkMKl40D0yeHEYQJ94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOdYVabSPMyNERaPW3ZdfgB12XJXLEDmul7JQTYrgqMPJT0Fs3qObF4dSTDNO/EPE7UkiFROXhVczDymIj8XTXADAR3NQvbQEr5dmHjvJ54ECfIuDtyOdoS7TxLIiEsWgENEYmaY4NZG3iIUxzFU7XXI5+p+XJ2gAQzP9ZN4q9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06ufZ8xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06ufZ8xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B90C4CED1;
	Wed,  5 Mar 2025 17:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197060;
	bh=dSt8yiiod9ctG7+8Yg5KjaQsPvkMKl40D0yeHEYQJ94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06ufZ8xr1cK5si5tRWoS7R+44aWOho9Ly/nftSosVBxB25P7D0nMuQQhiomJG2VGo
	 4HTi4C5fGit8EcLksUrmgvI7FGs3sY88d8Qg3YFZtaCZ4VAtyTv585yirS4ZimvOKl
	 IyIjdhWFFkAV/2CGnfN3hrsWsNGO9mwLh1nZBh+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/176] arm64: dts: mediatek: mt8183: Disable DSI display output by default
Date: Wed,  5 Mar 2025 18:46:34 +0100
Message-ID: <20250305174506.474118934@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 26f6e91fa29a58fdc76b47f94f8f6027944a490c ]

Most SoC dtsi files have the display output interfaces disabled by
default, and only enabled on boards that utilize them. The MT8183
has it backwards: the display outputs are left enabled by default,
and only disabled at the board level.

Reverse the situation for the DSI output so that it follows the
normal scheme. For ease of backporting the DPI output is handled
in a separate patch.

Fixes: 88ec840270e6 ("arm64: dts: mt8183: Add dsi node")
Fixes: 19b6403f1e2a ("arm64: dts: mt8183: add mt8183 pumpkin board")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20241025075630.3917458-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 2147e152683bf..fe4632744f6e5 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1753,6 +1753,7 @@
 			resets = <&mmsys MT8183_MMSYS_SW0_RST_B_DISP_DSI0>;
 			phys = <&mipi_tx0>;
 			phy-names = "dphy";
+			status = "disabled";
 		};
 
 		mutex: mutex@14016000 {
-- 
2.39.5



