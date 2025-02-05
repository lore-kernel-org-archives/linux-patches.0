Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BD01519AA;
	Wed,  5 Feb 2025 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764751; cv=none; b=GHN3WMHuWehtVwvK71R0jC74ifC7KlxBWieXYV88kJVEwb9W3R5caoK7hsX+/oCcJJuyquhvE98UyTAyFJBHu2FEDVjUngLFzrJUkvWICswP8T3govuB9UU9QhaiAsIba0ZwkDF/jIvUw6fMbSzN05yWR8FxWFdseELpyAcesWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764751; c=relaxed/simple;
	bh=ulzquLmNMBv1jMjzoethRy+JUtM37Ttrj/22EJRsBS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hycOS/dMaYL6TMaFqQkEARrMd+Ysr+tTivYL4RBVEqYCmuFGuOTtLjSXfd225A54T4RuzJ+35alXyN5jGfiCaxQrytVB4asoUvljnKh9+Df025Menz/Gx8JySIA3zFYLGzApHRg1BkiWE1qVtDqUVucU14WyIg6zuOX0aNzQD+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ryq3i6yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ryq3i6yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E12CC4CED1;
	Wed,  5 Feb 2025 14:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764751;
	bh=ulzquLmNMBv1jMjzoethRy+JUtM37Ttrj/22EJRsBS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ryq3i6yxbHXr4DB9w3Ag6zvkhhKjrQHDpcoGo3y/PF3D3HvYSWB2P+e+Bqld9kdeo
	 zroQ/krq8x9H3iFesy6Ba7P7U9zBhjTyzPL8viYedwANIwolAUReIgXAqzCtXo8z3x
	 wA6LoHModdgkdgzGG8zZj+8UPzFJYgL1P5rHtiyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/393] arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A
Date: Wed,  5 Feb 2025 14:42:00 +0100
Message-ID: <20250205134427.992654450@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1ca1393fcc593..6b89505a64379 100644
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



