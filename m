Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB87343D6A;
	Mon, 18 Aug 2025 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525825; cv=none; b=e9LnVSw433qi3J03REhgk/uj2AgzzLsFpFt/zXmtSBBT5xITh3kPOYT1gVpQoM8SATtd3Yca0UY7D8EVrkIw83oUS5DzFpunAwRXu2gvPIDXD+MAJlQjDsJrTUIEo/kZSwgLpf/UbHffFVazoFxeRwg98oSZ5NOsZxCRKdQZuDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525825; c=relaxed/simple;
	bh=CeioV78zDemNVaQQwmovLEV8fL7CAoKWk9xJopeiXJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPEEY8n2KPDTmh0ljpKxyfkmK9Ae5iH7uRo0bbKQjEw0nAhKwXwciOVAxYCLkxN5kQycskB6Uqar1Mler7RASsuuj/kFKHDW8922WYza8ilBpklVZzx5NdE7Zc86wjNVSmnyr0L30dY3FfOnKmLoeE03ji9uNS3hBWdETuPK3bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2+2fA7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2+2fA7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33571C4CEEB;
	Mon, 18 Aug 2025 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525825;
	bh=CeioV78zDemNVaQQwmovLEV8fL7CAoKWk9xJopeiXJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2+2fA7w7KO+nwwvOqJ80j4+OUKeBtAXnewvqKqCER/zhAwlakhhhWp4Oa57wL+LA
	 E3SlVlpscQasjsgp6inAa0Sn9dBpyF0kmu9vrNBB+IhwndNXOs0+7LL6rt2X0It2t2
	 qp26Bpm7CHqlnMzMKOltPpLc5zgmGi2A6Zi2qgmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 345/570] wifi: rtw89: 8852c: increase beacon loss to 6 seconds
Date: Mon, 18 Aug 2025 14:45:32 +0200
Message-ID: <20250818124519.151232183@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit 4bcef86b13316511bb336a26140fc4130c3a65a2 ]

Intermittent beacon loss from a specific AP causes the connection
to be lost. Increasing the beacon loss count can make the
connection more stable.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250606020302.16873-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index f270d5e2140d..68a937710c69 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -838,6 +838,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8852C, ge, 0, 27, 40, 0, CRASH_TRIGGER),
 	__CFG_FW_FEAT(RTL8852C, ge, 0, 27, 56, 10, BEACON_FILTER),
 	__CFG_FW_FEAT(RTL8852C, ge, 0, 27, 80, 0, WOW_REASON_V1),
+	__CFG_FW_FEAT(RTL8852C, ge, 0, 27, 128, 0, BEACON_LOSS_COUNT_V1),
 	__CFG_FW_FEAT(RTL8922A, ge, 0, 34, 30, 0, CRASH_TRIGGER),
 	__CFG_FW_FEAT(RTL8922A, ge, 0, 34, 11, 0, MACID_PAUSE_SLEEP),
 	__CFG_FW_FEAT(RTL8922A, ge, 0, 34, 35, 0, SCAN_OFFLOAD),
-- 
2.39.5



