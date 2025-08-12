Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CDC1A9F9B;
	Tue, 12 Aug 2025 18:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023618; cv=none; b=uqS+DcyKCR0CHXc1UniuT2nr0vjJ+k7Va1TV7uJVjTd8vPMwz85H+whqXmHdDwrIQ2thIEO2dhS0VFVrKIRlGsAX+UHmbqPQjf/WAiWgIjm9VfENRVngvpxuavJi6uYNHDXgAmtiacsO8rCGqVCA9kW8sGWsSUHFb09Rz6JAGI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023618; c=relaxed/simple;
	bh=rkUKkzbN8L06LCkp8YV7GHNz+umQGXOL3ozMjOGixDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxxcvi5YkNSBgF4pf0XCRU66pStr1Iykvu3qzmBUZkG9iPTEbJ1eU4hdYx2YMX9cT35nsOKhCgHjE6xmqzJ77ghV9ww2Ja/Dl0U3vbwCqTJys0txIURzghEzBUgL9JULEGqY6UllwYEgVwGUrx7w44THPBT8QWA9EmHHQyDj1uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJsSeSrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJsSeSrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FB9C4CEF0;
	Tue, 12 Aug 2025 18:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023618;
	bh=rkUKkzbN8L06LCkp8YV7GHNz+umQGXOL3ozMjOGixDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJsSeSrAo/b/vuce5HEi/HkOwndaVuB3SXVKR2ibXISyvyVeGh8fM1SbdJzss8xmX
	 TgtGZ0dTYdSD03L6mR1KPURU6Xuy8ffbb2Y1QEYAhkeCBj+xcua6muVZQZuBwBHXBq
	 3EZWGRhQAX9pv7rSQAl5nFu6l2trZrMeEkBilcik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Delaunay <patrick.delaunay@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 099/627] arm64: dts: st: fix timer used for ticks
Date: Tue, 12 Aug 2025 19:26:34 +0200
Message-ID: <20250812173423.079055841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Delaunay <patrick.delaunay@foss.st.com>

[ Upstream commit 9ec406ac4b7de3e8040a503429d1a5d389bfdaf6 ]

Remove always-on on generic ARM timer as the clock source provided by
STGEN is deactivated in low power mode, STOP1 by example.

Fixes: 5d30d03aaf78 ("arm64: dts: st: introduce stm32mp25 SoCs family")
Signed-off-by: Patrick Delaunay <patrick.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20250515151238.1.I85271ddb811a7cf73532fec90de7281cb24ce260@changeid
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 8d87865850a7..74c5f85b800f 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -150,7 +150,7 @@ timer {
 			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>;
-		always-on;
+		arm,no-tick-in-suspend;
 	};
 
 	soc@0 {
-- 
2.39.5



