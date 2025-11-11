Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C15253944;
	Tue, 11 Nov 2025 01:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824952; cv=none; b=d2S8deWyRAm03I+MWmXlZrSEb8M6BD7reHlpdYencRiB0NEtG55tISUCwfwavsP1RMc5b2ktni2UU2aOSaPajX6cMpjOvQhtnYC+iXixcs/f4V99hwmS27/TNGUOA1llDnaJLRDe6BOl+DeVXjZ7yF5j6aem8RoxHUhYsEJuwoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824952; c=relaxed/simple;
	bh=nKK7Vspx6XNYVoDT8QPJrf58DwtUIWvW4l4bmKqqPkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtAO8/X2lYFuP6uvwSkEATuXCxtiwAfZMo878B61eVSPcta/m7WdrP1KYVgqj/1ZCzr5SPyFCLQwVdhN3qcr27nnI8i8FZHPzbZTnMxrKQ0p9jlEWIkiexAjerWRvp97biRotf8HOjtQuAllaQ1Pup8qCElvP1hFNH1on2AMJeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+gRYImZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+gRYImZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0486BC116B1;
	Tue, 11 Nov 2025 01:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824952;
	bh=nKK7Vspx6XNYVoDT8QPJrf58DwtUIWvW4l4bmKqqPkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+gRYImZDdSQI7bNFkyFfAUs34+BqgfmJnvZ7kcXv6/L5AcYaj3fNrO93O4ZY0Y68
	 tnbbT0pUQUNP0d/UhuqQZJXHW/vEdHbDIJLTYhSfVXRDOgoCCMXJziPNw87Gn7K8d5
	 DlYpXO8xDZ1iVwZcw0yoV0S1yKUfnL7Ilt4Pjqbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunHao Lin <hau@realtek.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 604/849] r8169: set EEE speed down ratio to 1
Date: Tue, 11 Nov 2025 09:42:54 +0900
Message-ID: <20251111004551.024646572@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



