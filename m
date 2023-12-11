Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8CE5102A;
	Mon, 11 Dec 2023 18:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztevx9is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E11C433C8;
	Mon, 11 Dec 2023 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320636;
	bh=q5q1MgThXR2Uq0M8puU6pCgNV8vO6RLzO/aA8nVW6po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztevx9isvZHyG40eC7qXgxqicUAEoJ1Dmrd0ORDvfpDvw3tH+GR5pKzeAnVpa2BID
	 fYYZSgXWENwlNkv39gq8lc6L3C3hJCgdFtRYBnnRk3F3UJZqUQeD6Zt+7mczSobjmb
	 H/B+7yBYpUJgY9pDTdZAAqp7L2p7F1m4wbn4hSuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.1 134/194] arm64: dts: mediatek: mt8183-evb: Fix unit_address_vs_reg warning on ntc
Date: Mon, 11 Dec 2023 19:22:04 +0100
Message-ID: <20231211182042.590521170@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit 9dea1c724fc36643e83216c1f5a26613412150db upstream.

The NTC is defined as ntc@0 but it doesn't need any address at all.
Fix the unit_address_vs_reg warning by dropping the unit address: since
the node name has to be generic also fully rename it from ntc@0 to
thermal-sensor.

Cc: stable@vger.kernel.org
Fixes: ff9ea5c62279 ("arm64: dts: mediatek: mt8183-evb: Add node for thermistor")
Link: https://lore.kernel.org/r/20231025093816.44327-7-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-evb.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8183-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-evb.dts
@@ -37,7 +37,7 @@
 		};
 	};
 
-	ntc@0 {
+	thermal-sensor {
 		compatible = "murata,ncp03wf104";
 		pullup-uv = <1800000>;
 		pullup-ohm = <390000>;


