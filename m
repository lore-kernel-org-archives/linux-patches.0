Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3131233D4E2;
	Thu, 30 Jul 2026 14:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422097; cv=none; b=EOTmpbhQlBKSZzhLlAjBLSgiIREtcHTUC967PQa0KDCL/lqR1Sc7IybbWbfV5wBsdbz+VbzIlJSRkKkEyZQFe5DJcLgEHMBR5hrXTX5QrXQh+Lyjp8dKS/J1N1pJtmgIGPHmGPOI9PAxlCGgNIeqYpw/Qxu+yK8GD1xcYj2b2lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422097; c=relaxed/simple;
	bh=D1vPB3q21UZ9niWY5OytvGuH4lCKZktl1/68xrZ/vXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hm8pSo83m0LTUSC/7SpZlVAHuXJWfx2l7vwdm06lT1//WtSPSU5D0GTmHMmIKV1M/qAZ6HDD7k94ssQT37w2v422drWd4Cqh5aJfrAE5jZjWHiYJb3QiIKtO+jJzV3/Mfc54spxdCSmW7QOoKmaPmo/F8PVvrz6I/5wCZmr+dOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIq8lltJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIq8lltJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517A71F000E9;
	Thu, 30 Jul 2026 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422095;
	bh=O/w4gRTrJ6H9YI6oEOLHciCvjPwlcyBiYT2mFGJPfaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIq8lltJh45yzyHyad/QSsatNwhzeszt0+59XDFFVFGOGUK0a9qlLZnDWZnawNSMl
	 T/R892H3Uvh5sYr9fhKeQAg/pdBpGxxvHi7mF6qwkOtEfRDfAn0xYbyHZaduU2HJq2
	 +eEGTfKljILGKog/m6zsI4/aTqrxcl9HHVxeXFyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 324/744] net: stmmac: reset residual action in L3L4 filters on delete
Date: Thu, 30 Jul 2026 16:09:57 +0200
Message-ID: <20260730141451.171100534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>

[ Upstream commit a448f821289934b961dd9d8d0beb006cc8937ba2 ]

When deleting an L3/L4 flower filter entry, the action field is not
reset. If a filter was previously configured with a drop action, that
action may persist and affect subsequent filter configurations
unintentionally.

Clear the action field when the filter entry is deleted.

Fixes: 425eabddaf0f ("net: stmmac: Implement L3/L4 Filters using TC Flower")
Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Signed-off-by: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260714023716.29865-5-muhammad.nazim.amirul.nazle.asmade@altera.com
Reviewed-by: Jakub Raczynski <j.raczynski@samsung.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 1f8c9f47306b97..14cabe76e53ec8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -661,6 +661,7 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	entry->in_use = false;
 	entry->cookie = 0;
 	entry->is_l4 = false;
+	entry->action = 0;
 	return ret;
 }
 
-- 
2.53.0



