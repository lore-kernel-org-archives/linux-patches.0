Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5862AF0E;
	Thu, 12 Dec 2024 15:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016816; cv=none; b=JVgobDtWC82bREAFuzoVwxrvh55Kv6Db8mhPSz1ic5Ww7Hdf4WHPqLC62KI9pI+JVQ94kvuM/TeEa5RtpVJ8x16U2xs3ADwnXo8+zxxGClL5h0Xf/Trrftp259fQr8Z1e+Dd2X51kqbeyzxhD5CXerHNiwuaoT6bLuHOhSbdHEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016816; c=relaxed/simple;
	bh=nWSgcp1NJpPc9ENsgX5ZhYrQe+TUIFrbtxZoOaqVY0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLxP8tKAvabfzN7RlnR/PYVauv62/vfTaGB1LUL15YdwySTx4OPbKngjKtFYkzBlpnGSJKgLW+oni72LUlFK57CSCg5/iqeYJv1W5g9Z0IJ+MVFkRlmvX8as41gmW0JwmzHiDsoa63X3Xq6YkhiK7jT4+ZmUQO1H+lUQC21vKcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HO+UdIV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HO+UdIV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEA0C4CECE;
	Thu, 12 Dec 2024 15:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016816;
	bh=nWSgcp1NJpPc9ENsgX5ZhYrQe+TUIFrbtxZoOaqVY0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HO+UdIV6lP97HI9Xevo8AJFaC+xOT2IrWtAaCMBr2vPWfm7kMvn+fNwff7ZFDJldH
	 gYmPUUgQIcL5jADKF3n0j/FwD8wB+FX5XEcc6KIbuhxPgs0doSFF95g9YRi7ON220Q
	 OU/ExnNRu9nejksr7GlKbnfBVR7zHkKF5vguVplU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengyu Qu <wiagn233@outlook.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 305/466] net: sfp: change quirks for Alcatel Lucent G-010S-P
Date: Thu, 12 Dec 2024 15:57:54 +0100
Message-ID: <20241212144318.834763591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengyu Qu <wiagn233@outlook.com>

[ Upstream commit 90cb5f1776ba371478e2b08fbf7018c7bd781a8d ]

Seems Alcatel Lucent G-010S-P also have the same problem that it uses
TX_FAULT pin for SOC uart. So apply sfp_fixup_ignore_tx_fault to it.

Signed-off-by: Shengyu Qu <wiagn233@outlook.com>
Link: https://patch.msgid.link/TYCPR01MB84373677E45A7BFA5A28232C98792@TYCPR01MB8437.jpnprd01.prod.outlook.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index a5684ef5884bd..dcec92625cf65 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -466,7 +466,8 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 static const struct sfp_quirk sfp_quirks[] = {
 	// Alcatel Lucent G-010S-P can operate at 2500base-X, but incorrectly
 	// report 2500MBd NRZ in their EEPROM
-	SFP_QUIRK_M("ALCATELLUCENT", "G010SP", sfp_quirk_2500basex),
+	SFP_QUIRK("ALCATELLUCENT", "G010SP", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
 
 	// Alcatel Lucent G-010S-A can operate at 2500base-X, but report 3.2GBd
 	// NRZ in their EEPROM
-- 
2.43.0



