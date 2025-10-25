Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB3030E0CB;
	Sat, 25 Oct 2025 16:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409159; cv=none; b=gP4EHFa7i8U9VXpLytKflT3RnlbXJI/sKyYHpmCmYvimKUeGnK1/MPiKp3mZL1KK3y/nBGeWjXGH1DaJtSiwh/iU9qX4nvE2B/6/Q5D/ls74mxP9kpSPTJkZWzF4zLEXE1+SruJwep5EK53QsR5mC/MoPsKwupm34ft2zsQnNHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409159; c=relaxed/simple;
	bh=Wsu6QKwI0DSKEq3fPE6CqLzeTU6vyFmCP+L2tVWEmp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z1+oYZDGpJ4cpfOm/B/XQ1dn9DvL5wIeJ/aNe7++Y56OupUC7KZ1bQ3VqYgz3+RoGniZ26sRsLrm/3SZbxw0DuuAITYaHo6ezHJZn5p7l9xqEqMA32XuqDbj6xjoB9UlYGHQyJZZyOhZSWSa4H7s+t0arJBQnD/fN+xVdDHLp+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFeiK2q2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFeiK2q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F31BC4CEF5;
	Sat, 25 Oct 2025 16:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409159;
	bh=Wsu6QKwI0DSKEq3fPE6CqLzeTU6vyFmCP+L2tVWEmp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFeiK2q2suH9AxEw2HdE/JwAtVcCr8RV7wV29D8NWunQlFhMy30U3/T2j4E+zcO2H
	 ncMflSRPvewTCIeQJEuuFwwHI160YHE7m0gHpItAkEW2j3mKlK877vg0Mu685Oxe+a
	 XUO1h0v2SuqzMvtE1r8z1FfjpXogbvzHlFzCD+kCUDY78/O9uvuTfdIkkvxi23F9GG
	 YytcsW73SEp4DvtKXVOqLFcOJKnOzWqw3qkUCPvceVYu9dXEsWM5ue9+wUBGOpbkCf
	 STLLEi3TiLTyzpFpZvmqutJF1P0Hd4e6uBCcSBJQed8YkrbLdrz7GXlFGomAlLBt/4
	 F36/yPW6ZP5Cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ChunHao Lin <hau@realtek.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nic_swsd@realtek.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.10] r8169: set EEE speed down ratio to 1
Date: Sat, 25 Oct 2025 11:57:34 -0400
Message-ID: <20251025160905.3857885-223-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChunHao Lin <hau@realtek.com>

[ Upstream commit bf7154ffb1c65a201906296a9d3eb22e9daa5ffc ]

EEE speed down means speed down MAC MCU clock. It is not from spec.
It is kind of Realtek specific power saving feature. But enable it
may cause some issues, like packet drop or interrupt loss. Different
hardware may have different issues.

EEE speed down ratio (mac ocp 0xe056[7:4]) is used to set EEE speed
down rate. The larger this value is, the more power can save. But it
actually save less power then we expected. And, as mentioned above,
will impact compatibility. So set it to 1 (mac ocp 0xe056[7:4] = 0)
, which means not to speed down, to improve compatibility.

Signed-off-by: ChunHao Lin <hau@realtek.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20250918023425.3463-1-hau@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The change simply clears the EEE speed-down ratio bits during MAC init
  for the affected chip families—`rtl_hw_start_8168h_1`
  (drivers/net/ethernet/realtek/r8169_main.c:3412), `rtl_hw_start_8117`
  (drivers/net/ethernet/realtek/r8169_main.c:3517), and
  `rtl_hw_start_8125_common`
  (drivers/net/ethernet/realtek/r8169_main.c:3718)—so those NICs stop
  lowering their MAC MCU clock when EEE is active.
- Realtek’s changelog explains the existing register settings
  (0x70/0x30) are not from the Ethernet spec and have been seen to
  trigger packet drops and lost interrupts; clearing the bits (ratio =
  1) removes that Realtek-specific power-saving mode to restore
  reliability.
- The tweak is tiny and localized to the start-up sequences selected for
  the relevant MAC versions (e.g. RTL_GIGA_MAC_VER_46/48/52/63/70/80),
  with no knock-on effects elsewhere; the only behavioral trade-off is a
  modest loss of power savings, which is acceptable compared to fixing
  data loss.
- Because it addresses a user-visible reliability bug, carries minimal
  regression risk, and doesn’t alter driver architecture, it satisfies
  the stable backport guidelines.

 drivers/net/ethernet/realtek/r8169_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4b0ac73565ea9..bf79e2e9b7ecb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3409,7 +3409,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 		r8168_mac_ocp_modify(tp, 0xd412, 0x0fff, sw_cnt_1ms_ini);
 	}
 
-	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0070);
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0000);
 	r8168_mac_ocp_modify(tp, 0xe052, 0x6000, 0x8008);
 	r8168_mac_ocp_modify(tp, 0xe0d6, 0x01ff, 0x017f);
 	r8168_mac_ocp_modify(tp, 0xd420, 0x0fff, 0x047f);
@@ -3514,7 +3514,7 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 		r8168_mac_ocp_modify(tp, 0xd412, 0x0fff, sw_cnt_1ms_ini);
 	}
 
-	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0070);
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0000);
 	r8168_mac_ocp_write(tp, 0xea80, 0x0003);
 	r8168_mac_ocp_modify(tp, 0xe052, 0x0000, 0x0009);
 	r8168_mac_ocp_modify(tp, 0xd420, 0x0fff, 0x047f);
@@ -3715,7 +3715,7 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 	r8168_mac_ocp_modify(tp, 0xc0b4, 0x0000, 0x000c);
 	r8168_mac_ocp_modify(tp, 0xeb6a, 0x00ff, 0x0033);
 	r8168_mac_ocp_modify(tp, 0xeb50, 0x03e0, 0x0040);
-	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0030);
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0000);
 	r8168_mac_ocp_modify(tp, 0xe040, 0x1000, 0x0000);
 	r8168_mac_ocp_modify(tp, 0xea1c, 0x0003, 0x0001);
 	if (tp->mac_version == RTL_GIGA_MAC_VER_70 ||
-- 
2.51.0

