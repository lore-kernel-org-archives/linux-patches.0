Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9963B200112;
	Tue, 26 Aug 2025 11:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208908; cv=none; b=sjHwadYPwY/WPOS/33SDPNb8Bgu+4nB4ODATg7zCPB2j7j3RVxUs54aH+d3Cb/Pj9kmcld+4PVNGjDOE60NFQsG6fGNcYiqh/hkQkpqIuwOZ7NPTgpWfkGiTHxr91LjrvC7GkqD1VYCM2nw1RS0iS9GUTPBYqaFUzmKy3ry0MT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208908; c=relaxed/simple;
	bh=/VnG7mvalEkmzMb4sy8CgTgjVNABZFFWdCL4ojGUQcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Md+E22rdvpwKDniKHDQbJrUXBP7mxNFHfGRQuhZnoq6a9FRx+uz8zDPtDpGmTZmhSbv7/HiwaXl2wPuC6gN41xLNW/GiJuJnMs9RMgWPLRncangsHIPKOtRx3jDMZI02pEEsuwoP9jruR81hxgKWNMeJYlf/muxJ/lLQD2Ldv9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0FIp0w3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0FIp0w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2625DC4CEF1;
	Tue, 26 Aug 2025 11:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208908;
	bh=/VnG7mvalEkmzMb4sy8CgTgjVNABZFFWdCL4ojGUQcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0FIp0w3tltjzT79APaOqSyzy4Z0HPZltMNqWGuRy7W6+Hl7RmLWjYB+TRngozPxV
	 tzicbHFBiFbqox8ZBl9jyvucjLr8/rRpj75DQn6v1PuAnsR2wae1kNZPXAdZ1azWJn
	 TJ4CkVXg3XEYfmbndj5+jm9jy/oznM/EQYobpu6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/322] rtase: Fix Rx descriptor CRC error bit definition
Date: Tue, 26 Aug 2025 13:11:29 +0200
Message-ID: <20250826110922.690764691@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit 065c31f2c6915b38f45b1c817b31f41f62eaa774 ]

The CRC error bit is located at bit 17 in the Rx descriptor, but the
driver was incorrectly using bit 16. Fix it.

Fixes: a36e9f5cfe9e ("rtase: Add support for a pci table in this module")
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Link: https://patch.msgid.link/20250813071631.7566-1-justinlai0215@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase.h b/drivers/net/ethernet/realtek/rtase/rtase.h
index 4a4434869b10..b3310e342ccf 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase.h
+++ b/drivers/net/ethernet/realtek/rtase/rtase.h
@@ -239,7 +239,7 @@ union rtase_rx_desc {
 #define RTASE_RX_RES        BIT(20)
 #define RTASE_RX_RUNT       BIT(19)
 #define RTASE_RX_RWT        BIT(18)
-#define RTASE_RX_CRC        BIT(16)
+#define RTASE_RX_CRC        BIT(17)
 #define RTASE_RX_V6F        BIT(31)
 #define RTASE_RX_V4F        BIT(30)
 #define RTASE_RX_UDPT       BIT(29)
-- 
2.50.1



