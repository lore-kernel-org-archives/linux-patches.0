Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF394DDB5A;
	Thu, 17 Sep 2026 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668869; cv=none; b=T13tfjKDKVDsOnXo67ElhzdPXX1NF1E9iRG0qTSHSoue2WB5FfUwYAU5oIgmK21El7ORPVYnC0VJUZs6lM0vahebOPZNfdShkR+6eUcVow9iq7wbF7pasSbgaKK0fj4PMzDwdKFQ1VV1whx7CbF4zoU7pQ8KEMwgumoAfrvn6RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668869; c=relaxed/simple;
	bh=+msdwHpTK+z8GjaaRXrQ2JrRwmM7qtxpb6ZCGP1PcAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1MEuCW/Aa0JCutjXaTIG4Rg/t5zKppMtmiEQaoBv9WhqG9hsdGwuxaDNJWFzy0+ZqQnAvRvMiEbsxI+YYwFp6ejlF4NttRHQnRTCUHYXyLy11BqzRREGkrIPAJ9Wxedmvqo1EVvj6tyHl36/FMctITmcfuI+i/beIjPAEhoaHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0L6Dcb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0L6Dcb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DBE1F000FF;
	Thu, 17 Sep 2026 18:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668868;
	bh=jwlMynfhbiK0TYFXwKR62XsZdElJHMRS0yjLbspgn40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0L6Dcb3WIygRrwcljcm5Fi+GEf3YTxUd+5Z47EMOwoVIL/ZLXbqad71qU2DeIKZW
	 /Ddh5MAA53eqkBthcoAMmzHuSZ/6qOKQ/WufhDAGecGmeF1yCC8a/HWznlLkWl+mg1
	 XHVYqlME1auVeaFb0gyxP/qcAvsE5tlLjAUEyre0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0568/1102] net: ethernet: oa_tc6: Fix for the wrong data type
Date: Thu, 17 Sep 2026 16:08:31 +0100
Message-ID: <20260917151554.168018807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit 3cc2aa96b97184abd6fc106aac626ddf14389813 ]

Inadvertently bool data type is used where int is supposed to
be used. This might turn a negative error code into true or
false and sign of the return code would be lost.

Fixes: 8f9bf857e43b ("net: ethernet: oa_tc6: implement internal PHY initialization")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260824-fix-race-condition-and-crash-v7-4-4323279b18f2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index e4949a310af2f..b6743710608fe 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -411,7 +411,7 @@ static int oa_tc6_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
 {
 	struct oa_tc6 *tc6 = bus->priv;
 	u32 regval;
-	bool ret;
+	int ret;
 
 	ret = oa_tc6_read_register(tc6, OA_TC6_PHY_STD_REG_ADDR_BASE |
 				   (regnum & OA_TC6_PHY_STD_REG_ADDR_MASK),
-- 
2.53.0



