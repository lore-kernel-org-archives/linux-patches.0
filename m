Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740BC3BF30A;
	Thu, 15 Jan 2026 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498533; cv=none; b=PcMIwpoHJeEDdqe+ow57NU4Xj701gJmGItDBFNOv9gTqkBe13iWHG3N2ljy0TbNZP7RoRuwyLZiVP16gZIQ3cN/fNiXTGtPoMUpgn2gpMMzcrzRPyWeWE77XLV9z42S4AcV9W/u1WzecdpiDRtj9AnbZttqAGJcrtLlhaLN+OeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498533; c=relaxed/simple;
	bh=rL6cJH0ejIMYlgZ+KQAoUG9ijUgPLA8R/mRRnJqmbBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XzlscNGVLL78CNekHC4CkobpOdL1muqVRhnXT/mrEdSx8TGGXvvqrxt9YKE8z3MRCB9gS9F8s9Iqg1RuIPwQAsMnivt9nLmFb08ZTlUzFzIC+jIUzFZCtpn3uNF7zYRI7ksA5rST3GQoAw7eCg7FQwJrGTmEe98ayhygVa0DdRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zld9ltcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zld9ltcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62A4C16AAE;
	Thu, 15 Jan 2026 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498533;
	bh=rL6cJH0ejIMYlgZ+KQAoUG9ijUgPLA8R/mRRnJqmbBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zld9ltcUYkvzPnKWk28q9yCR8ZfzTfboXpiXkYj0T/Dk4GTV0JHQ3Q/5YTopF3CQO
	 OR9mYSo4ystc2EuzHgmbcydD256hc8cB9OngJlLNx4IS3uTNX8bqQ3Kt1iXyJmDpQR
	 2SBEfK+48fL2RIwcOUA4TWXU1rHj2ejWT9NAa8Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 466/554] r8169: fix RTL8117 Wake-on-Lan in DASH mode
Date: Thu, 15 Jan 2026 17:48:52 +0100
Message-ID: <20260115164303.155385574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

[ Upstream commit dd75c723ef566f7f009c047f47e0eee95fe348ab ]

Wake-on-Lan does currently not work for r8169 in DASH mode, e.g. the
ASUS Pro WS X570-ACE with RTL8168fp/RTL8117.

Fix by not returning early in rtl_prepare_power_down when dash_enabled.
While this fixes WoL, it still kills the OOB RTL8117 remote management
BMC connection. Fix by not calling rtl8168_driver_stop if WoL is enabled.

Fixes: 065c27c184d6 ("r8169: phy power ops")
Signed-off-by: René Rebe <rene@exactco.de>
Cc: stable@vger.kernel.org
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20251202.194137.1647877804487085954.rene@exactco.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted tp->dash_enabled check to tp->dash_type != RTL_DASH_NONE comparison ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2513,9 +2513,6 @@ static void rtl_wol_enable_rx(struct rtl
 
 static void rtl_prepare_power_down(struct rtl8169_private *tp)
 {
-	if (tp->dash_type != RTL_DASH_NONE)
-		return;
-
 	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_33)
 		rtl_ephy_write(tp, 0x19, 0xff64);
@@ -4763,7 +4760,7 @@ static void rtl8169_down(struct rtl8169_
 
 	rtl_prepare_power_down(tp);
 
-	if (tp->dash_type != RTL_DASH_NONE)
+	if (tp->dash_type != RTL_DASH_NONE && !tp->saved_wolopts)
 		rtl8168_driver_stop(tp);
 }
 


