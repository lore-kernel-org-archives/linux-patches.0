Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060326;
	b=41Qh1LHFhAmoZMCxawht3kvWM60PF68VppcDaCjo0EZ5I3v5alyYFOkzhfl1eN87yqBT
	 36yvmCs9NO74BCTjD7jFLmJj5Bst0kAqyF12T8tt84L4ewe9xzAIJrd3BAMB2tYIJxlkH
	 M3PMhB5lWIhs6Dqa/Ttd2HuITEsZoZiAdpoO4Hzux5jTuayDsZbRmYpdPxvyPRr4Qr1J5
	 tDcVWrIbuWuDn+VLE80aEOZyXViMO3vRgiUFGKSgbvoSzkUyOUdg+bj2O10WLDfj1OyZX
	 shG1s6/tjp16mm4joyDTdavLcQWx8qynWBsVq8ZmehJ7tT65oAbwa5yyVVN43x/F2Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtdw1d8HTrit7G/vP1qLSeHYyEAYB7vxURawc28PCk8=;
	b=jwuXCb3akVvOlGuO2uTiyl8ShJmrpomhCYWeWU+wrAEjjqGxOS6PAFlsyiddeLU6Xg0M
	 0rMycTZGlORKfrSq8tTkmo15sUQRoKjHdsWfi/iGYgcRYl14EHS3B6Nm0/7Eya5Q+McGQ
	 B+ojeLfpwDD1oFWAfli3DOaIzyXFnwF5oqGgOAlqcXDlnKCVWe6dKSMK1jv/i7XRW6DDH
	 qIsixbyy7ycBAGqXfyGZc+cP+RHg74gkA8TZXqLBg2ixopfU+cgBu74mCWM+D8iZa/1cI
	 pVuYfjcACTIAkowQkskOlV3EXXQEGJ46NW3hLsGbAq8Q1K1tO04GynM3olCvcKdfmEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWsVpQbC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1928606A325;
	Thu, 19 Nov 2026 03:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWsVpQbC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F111F000C4;
	Thu, 19 Nov 2026 03:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060326;
	bh=dtdw1d8HTrit7G/vP1qLSeHYyEAYB7vxURawc28PCk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWsVpQbCVl8kdnFYcYjqvWZonEn+KS3ggYPGSB9wHeFq5YSlGqduPCBCgQutnbiBD
	 5cLlRxkfllug4gi3O6JzofZt9N/MP9IIdpRWdmO6b5Dkg1obwwotksPVe9pEgr3NW/
	 t37g57pCVcYZtQ106VciS44VMoHmhTpP16aVaPHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	"Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1160/1848] clk: Use the generic OF phandle parsing in only one place
Date: Wed, 18 Nov 2026 15:53:18 +0100
Message-ID: <20261118150008.255829758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>

[ Upstream commit 57d728b4ab15a8af890013bb0f302e7733f7c1c6 ]

Ideally, there should be one single entry in the OF world. This way, the
DT parsing logic is always identical. At this stage, we call
of_parse_phandle_with_args() in:
- of_parse_clkspec()
- of_clk_get_parent_name()
which kinds of defeats the above statement. Furthermore, when this call
is done from of_clk_get_parent_name(), we fail to parse the
'clock-ranges' property.

Make sure DT world is entered only once by calling of_parse_clkspec()
from of_clk_get_parent_name(). Doing so implies that we do not try the
"clock-ranges" path if we already found a "clocks" property.

Suggested-by: Stephen Boyd <sboyd@kernel.org>
Fixes: 4472287a3b2f5 ("clk: Introduce of_clk_get_hw_from_clkspec()")
Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 950dfa059a209..4f380c40db30a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4825,6 +4825,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
 		 * has a "clock-ranges" property, then we can try one of its
 		 * clocks.
 		 */
+		if (of_property_present(np, "clocks"))
+			break;
 		np = np->parent;
 		if (np && !of_get_property(np, "clock-ranges", NULL))
 			break;
@@ -4970,8 +4972,7 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
 	int count;
 	struct clk *clk;
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_clkspec(np, index, NULL, &clkspec);
 	if (rc)
 		return NULL;
 
-- 
2.53.0



