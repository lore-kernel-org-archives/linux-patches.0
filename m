Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063845;
	b=otfo5q5qfNSdU9/FTRWk1fP5OpHh0anm3FCzdwpTv34lqIVOSfItZMT6WewCxr6pHOp+
	 uE2vudRbo7BWxrZTBUwyfF5wF3iUnMvT8x9I+mzplw1iQqYQ5f/yckfIP1Eq3S5KI5yIn
	 ISebvs+DRJLtdokWChxWVZkxRseA998LeVSyXHSgyGbHfVt7V9EHBcJstX7AQcL8dz3fO
	 gETn1vkQ1EMtogIfdTpEz5wuV2pDznpGMPgc5DhbKE8rrbsjQBA2IDCL2DeL+zzvrvdho
	 uWMDieut0510WhjdkhaPszYtY/RV+UMEAafR+FKOaqKGRlRoUwLDqnEE56EUhoV1JPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHUiyrK2kSnpv+so02BwDDnLEmHOodPKyDwgoqh60Dk=;
	b=CtKwGqSaglSHJcYyxChAtXYiLP/QUhKu7vobf1m3AxTkHrsyEDzQyYROJi0cSzlZSaNB
	 796dp76uO7OXC9DUUcxbq62yEG2pQxak1AgwDh5wxT2L6VqBP5xqgZlMPB7SBF30pZh7w
	 ggZdP0IftobkQ2HxwVpAEBij+ybb4u/zi8C+69RHarOPTUmSsaLFsXFYlXx2GQU+qqSW4
	 R+SnFpHlKCAKYaF6z5OkSZp/7G/7npK1LcGbNM8MY9cwG/3ymcmgSnJ5aW0+DKFRcnuqY
	 PK2UfgfDp/x5MZscfNKho4v8u0GRmml9pA6R5stYfqq93TESQl/lmOWGOMqCcgbW0Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEmf1XWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3D4606A9D0;
	Sat,  7 Nov 2026 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEmf1XWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B961F008A2;
	Sat,  7 Nov 2026 15:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063844;
	bh=ZHUiyrK2kSnpv+so02BwDDnLEmHOodPKyDwgoqh60Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEmf1XWc/dekWadnMS1ZpSOcbxfG7iRRk7CfgyGRA3/I4OJ1ovW/6eiuG40+f31sJ
	 F2hfCc2vr2kbpHhH40I+6QSxmXEY1eL76wHZwEeynR3bXDwUhgw+BUKfpqhWDxceCY
	 jtOVBardClwfjgs1wGwz3iLS5OXBJfe0/itzov6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0056/1257] memory: renesas-rpc-if: Mark XSPI_CDD1BUF0 as volatile
Date: Sat,  7 Nov 2026 08:39:12 -0500
Message-ID: <20261107134940.950986541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 3db1fb5e1bb4c9eefc554f985f6f3316fa1292e5 ]

Add XSPI_CDD1BUF0 to the xSPI regmap volatile register table.

XSPI_CDD1BUF0 is a data buffer register used during manual transfers and,
like XSPI_CDD0BUF0, its contents are transient and should not be cached
by regmap. Mark it as volatile so reads always access the hardware
register.

Fixes: 687cac9559d8 ("memory: renesas-rpc-if: Add RZ/G3E xSPI support")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/20260727103449.3188105-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 3755956ae9065..104c28532c202 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -34,6 +34,7 @@ static const struct regmap_access_table rpcif_volatile_table = {
 
 static const struct regmap_range xspi_volatile_ranges[] = {
 	regmap_reg_range(XSPI_CDD0BUF0, XSPI_CDD0BUF0),
+	regmap_reg_range(XSPI_CDD1BUF0, XSPI_CDD1BUF0),
 };
 
 static const struct regmap_access_table xspi_volatile_table = {
-- 
2.53.0



