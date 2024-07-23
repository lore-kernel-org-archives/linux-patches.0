Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB78F1581F4;
	Tue, 23 Jul 2024 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760213; cv=none; b=kBjrOHBqy3I0PCV0V5I8QffmKTF+Y061Lzz+wg/wOzpAK4ZrLZwEjZAZDiucP9+KqNpj6pAryFgQE9mkETuGYJdkiyXUoV49VpAYQpPAuuHISghD3zoNkx6nN1dEOLUx6QdH8AtoRfaDa9oid4Ost1wppg91JJiY8exl0GLnOq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760213; c=relaxed/simple;
	bh=PhR4Xn9GSvwS+IeGBgWy0vNFgV1ipsCpx65HWnLqSCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRJmOQRPkVk/kJRGqX2iwWFMa6WiaDPVmKG/B38684nZfAO2ftZ/Pg36HGf9MyXoLBvDR6oFIfKUHdjbn3x+WyTSwaP3BLftkck4wUEPkHBPhGXwCXp/u/RGEG6PcwNHO5LH121kbgkop1pPmxayLf7rem7l5NffOPqC3Hi4DoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmGU7ynU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmGU7ynU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D24C4AF09;
	Tue, 23 Jul 2024 18:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760213;
	bh=PhR4Xn9GSvwS+IeGBgWy0vNFgV1ipsCpx65HWnLqSCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmGU7ynUYIptnEKWqZctZlcE/e6YJtGsYNi9HuBXu+MJ1Oow4salgeP1i0ir4wiJl
	 20MICs83SDii/pXVyG/VRYsysVfH3MujDyDr0oCmulIoHOvkhiE4x1ARffxh06uiMM
	 FQEob2VO5U3YfNS0XKUIb+T3+5oRc25Z6E6vMh08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 100/163] ASoC: rt722-sdca-sdw: add debounce time for type detection
Date: Tue, 23 Jul 2024 20:23:49 +0200
Message-ID: <20240723180147.339912698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit f3b198e4788fcc8d03ed0c8bd5e3856c6a5760c5 ]

Add debounce time in headset type detection for better performance.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://lore.kernel.org/r/7e502e9a9dd94122a1b60deb5ceb60fb@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index 0a14198f8a424..543a3fa1f5d3c 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -352,7 +352,7 @@ static int rt722_sdca_interrupt_callback(struct sdw_slave *slave,
 
 	if (status->sdca_cascade && !rt722->disable_irq)
 		mod_delayed_work(system_power_efficient_wq,
-			&rt722->jack_detect_work, msecs_to_jiffies(30));
+			&rt722->jack_detect_work, msecs_to_jiffies(280));
 
 	mutex_unlock(&rt722->disable_irq_lock);
 
-- 
2.43.0



