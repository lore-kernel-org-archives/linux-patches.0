Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F9C1714A8;
	Thu, 15 Aug 2024 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729329; cv=none; b=qfQNJkpuA2kDkYy5GO3+zBN8N8iVt2AoNPok0yt1EW+D/6lV7o9QDhhKAXme4DS8zMb2eJygITmRO9S6gGgz5ylIe7gEtEjtTszL8g1xUjfxAX8xZi01cu0a9y7JNwLbwH+uj3Ucixtnm8va7No7MoTAbyGUFCbxUP+n+D5R+TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729329; c=relaxed/simple;
	bh=CfmwzEUw8rmiXiRYhJWFSIF0QpTPsuoNNbkcrasM6vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1tWG4xaB6hPoVwMlp+B0KDSRLSj59y1dKGcK7pLFcFMSD4zGD2//YUK2/xqKceQHHI5FeMveAP7Vl/QWv/wV5U3ETD1tenQ63bL28oJp6ZdyrOGvUyT/G8HiLnfXlNVXOdTLjLe2ZjhzlmzLIhxXQVIypRBlCEztFsqVsL0zqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xG1uPy2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xG1uPy2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ADBC32786;
	Thu, 15 Aug 2024 13:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729328;
	bh=CfmwzEUw8rmiXiRYhJWFSIF0QpTPsuoNNbkcrasM6vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xG1uPy2MpxVU0ne+/PNfLODvHR6ibDE3XSeIONPyA0rNX0LKMALL7EtxgDcbEqMhV
	 zrtHrF/EBp5P5sji8iFmzC8KBP/69M8ftFafPps1C9sjJA+6cdcKCAX4ZEpEQ9rRGL
	 6WANR5SJnuXo0LgBXZPHqQJ0Bvg9VO5E8yUpKm5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/484] arm64: dts: mediatek: mt8183-kukui: Drop bogus output-enable property
Date: Thu, 15 Aug 2024 15:18:10 +0200
Message-ID: <20240815131942.515688618@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit e9a9055fdcdc1e5a27cef118c5b4f09cdd2fa28e ]

The "output-enable" property is set on uart1's RTS pin. This is bogus
because the hardware does not actually have a controllable output
buffer. Secondly, the implementation incorrectly treats this property
as a request to switch the pin to GPIO output. This does not fit the
intended semantic of "output-enable" and it does not have any affect
either because the pin is muxed to the UART function, not the GPIO
function.

Drop the property.

Fixes: cd894e274b74 ("arm64: dts: mt8183: Add krane-sku176 board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240412075613.1200048-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index 22a1c66325c29..5e77f3b1b84be 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -703,7 +703,6 @@ pins-tx {
 		};
 		pins-rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins-cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
@@ -722,7 +721,6 @@ pins-tx {
 		};
 		pins-rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins-cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
-- 
2.43.0



