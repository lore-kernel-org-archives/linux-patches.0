Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03704052DC;
	Thu, 30 Jul 2026 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424151; cv=none; b=PqZkw3R2YcmdV+EdAeCJKk/eT2X9Y4cNX2lwXiPfu65SRLrk7WO7aUaIVWkXvjgNwDbDWhUWgdxvoNFmCFox1IOFYBvjPrVF9E38PIWfst+ldjI9xWGgHEpo3Vx8JqPAnN1FhZMsWZv+fl+fDW+ZYg3QOFKE1Oiy3Q0kpN+bT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424151; c=relaxed/simple;
	bh=0ceFWS20HmqjGv8+bq7xjwtAfvD43AtYwDI2RN++7SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/9Y42SBEU5IsJaQr9WWlB6ecD+sBqnBn2jqsgDhbxvc7k2lQnmsGDndQc63jwUoYU2vf+wNzastLj2NIMlpWeY6/BeGbpkE+/7V+L30lPRrH2jGNL5UpkA8GEA4/APPLRTOl2q8OtMtkza0n5ILf1/Pusc4reXVJev+f5nYSu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVo9UPfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVo9UPfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4E71F000E9;
	Thu, 30 Jul 2026 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424150;
	bh=te4AhRN7bzClX2KteeLsF6ZWsh9O5/D7HmgLvC7RzU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVo9UPfHf2+pwwRkYLKPHD7ZUO9MXBmTNBzjDxiRPXCwiLc27oZtc37wTzzf+Onyt
	 pS9ubQLLIS1OGAVVEqxXdTaMGNZSzX/3LCoOwTj19qbx9QswLOqrWqC5ITkk/0m9p3
	 n1ZR6UeCKpxIbQvvbEFtczusiTpHmo8pZ+KtD5Hg=
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
Subject: [PATCH 6.18 293/675] net: stmmac: reset residual action in L3L4 filters on delete
Date: Thu, 30 Jul 2026 16:10:23 +0200
Message-ID: <20260730141451.351023393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2050f1fa9f44cb..0119b4b89fc0a0 100644
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



