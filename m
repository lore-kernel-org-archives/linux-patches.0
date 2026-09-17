Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4952B4E36F7;
	Thu, 17 Sep 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668995; cv=none; b=OfD8y/SSXFGANtJJsC3u9vg3kke8RRLAEOiGZdHx/z9ALgFBKwQJklLq/15lSN7Gm43HrKk3HSYhY5xDA9l2LXGCc85bXgrTKNp/p0RJ1EmbUjWj+j7fALvYt1RJbd9KZJCD1figyW4P2DOT8tkHQdokW3bpdZsw9fSTLbS6Yfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668995; c=relaxed/simple;
	bh=HNYP/xjN7uT50QNL5yF82aqJPyRfRlY/bAecPPOWbxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5XEAx+JeOJIG40WKSkMTtWl+mkTIj3eLPWQwsP1iz4dbj1sUw7bh33YEpbwAKG8s8Th5OBANWhAbyzJRq2nWx4F8vaVoHIARn34ykd/k4brTdrNhYQKiYB2anbuJxQNcXAQZfM992pAGf8+l0/fCGYSsN0Bdcq4VvZIOqYptGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0ZGqAAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0ZGqAAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3191F000FF;
	Thu, 17 Sep 2026 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668994;
	bh=2yHX2BGkjzJ5jDt5KJE8eKtxFvzTX6VQoFdlx711Fl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0ZGqAAlhF81zjoGQ4pjJlHWD9xlV1ZKdrTISieceKYn2PB0GSuuXJl6f+x7PO/bK
	 cx6UG4p+UJFHPETdFCtdPAPkwCWllF8ZFOrsF2vdr1wj844SLG/KOP3NeygslCshqf
	 tIXdB+56MCcNRYM578HHHPcWDCjKIzdy9glRJHfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0610/1102] mfd: db8500-prcmu: Remove needless return in three void APIs
Date: Thu, 17 Sep 2026 16:09:13 +0100
Message-ID: <20260917151555.346052585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit c105c555f8b4fd57b09439806b43b97ebc240ee2 ]

Remove needless 'return' in the following void APIs:

 prcmu_early_init()
 prcmu_system_reset()
 prcmu_modem_reset()

Since both the API and callee involved are void functions.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250221-rmv_return-v1-15-cc8dff275827@quicinc.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 66ec63e7a90b ("ASoC: ux500: Deassert the MSP reset during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/dbx500-prcmu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index dd0fc891b2289..98567623c9df6 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -215,7 +215,7 @@ struct prcmu_fw_version {
 
 static inline void prcmu_early_init(void)
 {
-	return db8500_prcmu_early_init();
+	db8500_prcmu_early_init();
 }
 
 static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
@@ -302,7 +302,7 @@ static inline int prcmu_request_ape_opp_100_voltage(bool enable)
 
 static inline void prcmu_system_reset(u16 reset_code)
 {
-	return db8500_prcmu_system_reset(reset_code);
+	db8500_prcmu_system_reset(reset_code);
 }
 
 static inline u16 prcmu_get_reset_code(void)
@@ -314,7 +314,7 @@ int prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
 static inline void prcmu_modem_reset(void)
 {
-	return db8500_prcmu_modem_reset();
+	db8500_prcmu_modem_reset();
 }
 
 static inline bool prcmu_is_ac_wake_requested(void)
-- 
2.53.0



