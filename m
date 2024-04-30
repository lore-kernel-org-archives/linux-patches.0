Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA65712C54B;
	Tue, 30 Apr 2024 11:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475158; cv=none; b=s5peMAF6ZbiQTx+/EN3rz2AYk76ASi7mmMFnGaKthPl8ysXn86J9DrmH+OVczopQZ0Xayy5s7QsnMd9teE1mCb7nk6V9j+DzEpR/tVSKpm/MhFewr34s/kruN+GRY7jaqtPQN6GxtAw7oMIzI3H9LiYsawPixZHyafeomDndRGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475158; c=relaxed/simple;
	bh=gOEQFUX8Y9QlZSS9gbo6GFwz/oiLzDGOaWC4woxRRa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPY3MLZ8d7vlWWwRlKUgbOtz8RZcAh7+yeD+ozHHf0LQ+dhn+DKyrN5tjbgPxwNb0jWJSP+dbJffuFWEWlEzm8jLAxTk9Wwug2bbZUgm2t+K3HqBZnkgOEOU8XDjnaDeg2nNAnxeqXIBYI/J2Mh3mpAPCrxbxPNqTVE/On3DZE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByDvRHI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByDvRHI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC39C2BBFC;
	Tue, 30 Apr 2024 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475158;
	bh=gOEQFUX8Y9QlZSS9gbo6GFwz/oiLzDGOaWC4woxRRa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByDvRHI8Kq/Eib40qM8jQ7HVnnRx+bh/1qcRdNSEUDh+9I3/FWCjb0GACwjI/Hfte
	 PQ+YRkdWxHygnJpgkI/LjCkI6OXtY+zgPUcq4odgbfbE1E9Z4IX/hj9u6AbXODsM69
	 mJlTnb53CjgMMKL77+QPxvaHU0MDDHWnmeKwyRx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/186] arm64: dts: mediatek: mt8192: Add missing gce-client-reg to mutex
Date: Tue, 30 Apr 2024 12:37:44 +0200
Message-ID: <20240430103058.376950966@linuxfoundation.org>
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

[ Upstream commit 00bcc8810d9dd69d3899a4189e2f3964f263a600 ]

Add the missing mediatek,gce-client-reg property to the mutex node to
allow it to use the GCE. This prevents the "can't parse gce-client-reg
property" error from being printed and should result in better
performance.

Fixes: b4b75bac952b ("arm64: dts: mt8192: Add display nodes")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240229-gce-client-reg-add-missing-mt8192-95-v1-1-b12c233a8a33@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index f1fc14e53f8c7..b1443adc55aab 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -1412,6 +1412,7 @@
 			reg = <0 0x14001000 0 0x1000>;
 			interrupts = <GIC_SPI 252 IRQ_TYPE_LEVEL_HIGH 0>;
 			clocks = <&mmsys CLK_MM_DISP_MUTEX0>;
+			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x1000 0x1000>;
 			mediatek,gce-events = <CMDQ_EVENT_DISP_STREAM_DONE_ENG_EVENT_0>,
 					      <CMDQ_EVENT_DISP_STREAM_DONE_ENG_EVENT_1>;
 			power-domains = <&spm MT8192_POWER_DOMAIN_DISP>;
-- 
2.43.0



