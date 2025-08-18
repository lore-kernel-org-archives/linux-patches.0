Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04FB320CBA;
	Mon, 18 Aug 2025 12:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521558; cv=none; b=liY6omUgTS3t9xncIM5Shxq9cWepa43vz8noPRscoxHBIZwJE3xUz0Kas2BsFMwbLLaXSxMbfvWrlz2jybTsVPaQbC3JN/l1kSME2wFQx6yjCZ0wV8B0V7asvhoB5vMZ92jOFSvgwo1WvOEIwAvkdvvvuinsv0MSAEuqK/w/MNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521558; c=relaxed/simple;
	bh=gLye1ZNr6bK6UqIqZT+zybdZ8pHdX18fK100TGdoyko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6sA9ozCVKriraSFrujZFTzfUIS3h0Qk0RdYGevdw9D2oVXO+MugS1h+8MseMVim3Vx3D5ER3Sm+4Xw++8WaPu49t16qxxKBdZkWjADLcCouv2X8VosFvdm762bT6KwajQcq6c25obFfv2/lsnz48aeeoYlXDPgBxYALLag/KNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyUigFIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyUigFIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77045C4CEEB;
	Mon, 18 Aug 2025 12:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521557;
	bh=gLye1ZNr6bK6UqIqZT+zybdZ8pHdX18fK100TGdoyko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyUigFIslQhbS717h1+9FGW6KoTZv4kT1wbvbJjWYuZrD7ELKRPylG0oizkGHFB5S
	 K1PIKTbekRmDuR9AdE6DJwQq2ldt/amO+doJjKyapggkdFJ64+6+Gd+w8GWxG0x3j7
	 3G8jJ2bFku0Ot6Z31XaLJgs5/RJA0fMIN1xam1BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/444] net: ti: icss-iep: Fix incorrect type for return value in extts_enable()
Date: Mon, 18 Aug 2025 14:41:23 +0200
Message-ID: <20250818124451.071230171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 5f1d1d14db7dabce9c815e7d7cd351f8d58b8585 ]

The variable ret in icss_iep_extts_enable() was incorrectly declared
as u32, while the function returns int and may return negative error
codes. This will cause sign extension issues and incorrect error
propagation. Update ret to be int to fix error handling.

This change corrects the declaration to avoid potential type mismatch.

Fixes: c1e0230eeaab ("net: ti: icss-iep: Add IEP driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250805142323.1949406-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/icssg/icss_iep.c b/drivers/net/ethernet/ti/icssg/icss_iep.c
index 50bfbc2779e4..d8c9fe1d98c4 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -621,7 +621,8 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 
 static int icss_iep_extts_enable(struct icss_iep *iep, u32 index, int on)
 {
-	u32 val, cap, ret = 0;
+	u32 val, cap;
+	int ret = 0;
 
 	mutex_lock(&iep->ptp_clk_mutex);
 
-- 
2.50.1



