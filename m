Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CD61C860A;
	Tue, 26 Aug 2025 12:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212712; cv=none; b=EIDofYIPy33zWBA4jhmZHK1BtklP64RMQW/AlLUAPlbCQLvZml2OFhWcUjDeUL5x/DbznfYLu11iLviO84gb/kTkC4MxEHN3ELsiA/3bJrQWhnr6dKyeACExI7KVQICpMaffwwZ9mw6ovKABUxRU/VimmsjHVdt9AnxpjbqtE90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212712; c=relaxed/simple;
	bh=Oe2dP++GyojWMjza0giB+rnpW/cXlRRyFGsp9yxpEaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9pVPcMPsidX2BRSewpocrxQIzFcWHzKm5MRDuUOAk3DaMESy6xQ/wIOvPNxKbugYam6/HAQu8/tRL6vtaqQRvbOlcupFE1v4gizZf2BHrF6wpXq6t3QvZDNMTMyxC1Wa5Ixy17n6sJOaedr9XppIHA4jKAwtjunyqGUW3cyuR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHJC4IZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHJC4IZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5327C4CEF1;
	Tue, 26 Aug 2025 12:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212712;
	bh=Oe2dP++GyojWMjza0giB+rnpW/cXlRRyFGsp9yxpEaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHJC4IZZd13eNRWFCgzVm9Lk9WIihjhVgImdZMw5FZm6qef4sXIgv9K1WU1Ji9jYy
	 ukveSCmduhe3IVjl3QAR8hScvg6SJzsV50z1giuWSmaX0ha8W+Q+ZjmJ8Qa+clVEiE
	 Up1aJnlRfB/pvmMcNti13M/G5rzPoewXEyCROR2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/587] net: ti: icss-iep: Fix incorrect type for return value in extts_enable()
Date: Tue, 26 Aug 2025 13:03:25 +0200
Message-ID: <20250826110954.365529501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8ed72c8b210f..e7306ed52922 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -638,7 +638,8 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 
 static int icss_iep_extts_enable(struct icss_iep *iep, u32 index, int on)
 {
-	u32 val, cap, ret = 0;
+	u32 val, cap;
+	int ret = 0;
 
 	mutex_lock(&iep->ptp_clk_mutex);
 
-- 
2.50.1



