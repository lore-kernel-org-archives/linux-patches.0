Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD5A1DF75B;
	Tue, 16 Dec 2025 12:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888374; cv=none; b=aGkQfMdDsO2ezd5xe6ZccVD4jjFPIj1tHWN9tbQnxWi1DlTiZF9IIXsp84qf/R+zguup5g4uoX+aaFn4ka4unEavxxdvUpl2hmqzLaYfcsNoHfHXt8MwOn08hH8sOKLXX8sx6zNU18yp3q9mhNt4ErwuUZjBv8BSoDWNq9PhVzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888374; c=relaxed/simple;
	bh=onme7fhlEm9XHEV8Emd0QOkfHjinO+Ue0p33cQjUD+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xqk55GDLvB0de3rh0d9WwUSrtVsnxdPZzOFN1hYgWvpJl284uHh6PUSz0fhBGKsjHywoqn7WB0zlBrdt11eqtKnBX3u5G1COFOU5THoKoFVm2pQvoSAQ51BVIC95914JBSQDNQlfq1VFeLXYpIEYh9Gq9ScXdVB/uS5NdwczYnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZYgmMa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZYgmMa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3540C4CEF1;
	Tue, 16 Dec 2025 12:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888374;
	bh=onme7fhlEm9XHEV8Emd0QOkfHjinO+Ue0p33cQjUD+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZYgmMa2CY6OZzUERbzGWOGRdvJjr3A85m14P0HrZKTGEJ63jTJdi77+XAe+ZtFt4
	 IMh9+udlnriJ1sOQ4W9QGeDyR+Tvv/YWqyPwSe2vivuOPIZSwGB+QowPrL/YHN46je
	 KFzwIFgiTcVnX7fiQSDosNytRh51ArWeWmdH6r2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 515/614] net: dsa: b53: use same ARL search result offset for BCM5325/65
Date: Tue, 16 Dec 2025 12:14:42 +0100
Message-ID: <20251216111420.028193382@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 8e46aacea4264bcb8d4265fb07577afff58ae78d ]

BCM5365's search result is at the same offset as BCM5325's search
result, and they (mostly) share the same format, so switch BCM5365 to
BCM5325's arl ops.

Fixes: c45655386e53 ("net: dsa: b53: add support for FDB operations on 5325/5365")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20251128080625.27181-4-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 18 +-----------------
 drivers/net/dsa/b53/b53_regs.h   |  4 +---
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index dedbd53412871..68e9162087ab4 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2093,16 +2093,6 @@ static void b53_arl_search_read_25(struct b53_device *dev, u8 idx,
 	b53_arl_to_entry_25(ent, mac_vid);
 }
 
-static void b53_arl_search_read_65(struct b53_device *dev, u8 idx,
-				   struct b53_arl_entry *ent)
-{
-	u64 mac_vid;
-
-	b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL_0_MACVID_65,
-		   &mac_vid);
-	b53_arl_to_entry_25(ent, mac_vid);
-}
-
 static void b53_arl_search_read_89(struct b53_device *dev, u8 idx,
 				   struct b53_arl_entry *ent)
 {
@@ -2699,12 +2689,6 @@ static const struct b53_arl_ops b53_arl_ops_25 = {
 	.arl_search_read = b53_arl_search_read_25,
 };
 
-static const struct b53_arl_ops b53_arl_ops_65 = {
-	.arl_read_entry = b53_arl_read_entry_25,
-	.arl_write_entry = b53_arl_write_entry_25,
-	.arl_search_read = b53_arl_search_read_65,
-};
-
 static const struct b53_arl_ops b53_arl_ops_89 = {
 	.arl_read_entry = b53_arl_read_entry_89,
 	.arl_write_entry = b53_arl_write_entry_89,
@@ -2761,7 +2745,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_buckets = 1024,
 		.imp_port = 5,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
-		.arl_ops = &b53_arl_ops_65,
+		.arl_ops = &b53_arl_ops_25,
 	},
 	{
 		.chip_id = BCM5389_DEVICE_ID,
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index d9026cf865549..f2a3696d122fa 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -370,10 +370,8 @@
 #define B53_ARL_SRCH_RSTL_0_MACVID	0x60
 #define B53_ARL_SRCH_RSLT_MACVID_89	0x33
 
-/* Single register search result on 5325 */
+/* Single register search result on 5325/5365 */
 #define B53_ARL_SRCH_RSTL_0_MACVID_25	0x24
-/* Single register search result on 5365 */
-#define B53_ARL_SRCH_RSTL_0_MACVID_65	0x30
 
 /* ARL Search Data Result (32 bit) */
 #define B53_ARL_SRCH_RSTL_0		0x68
-- 
2.51.0



