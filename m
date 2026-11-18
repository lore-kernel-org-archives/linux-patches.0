Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047865;
	b=u8ooaZORBpGmDGlvbv4tqgVJOMFCLCY9rDA8/9I7N2dS1IoJOZOzxOk3e7dUPbO3BA4U
	 fa/kpEaClTqK/dTQcDxnqqwA3xGBknG7RmdXZKd7viH6rJZi1Zz2/K9hhY6GrnNVIEDTU
	 h0qAqNyi7yHwi6mVszVsEetUzlgNgdxkMbDzSabqulz8A0OYkQN16kWQxi9jt2LWJRBPe
	 GGstOl5pmHagj+C5nWkpkHprTEPsYBXqHLliEtg3YSe6SM7NSSMU93N+aWrGSb4jytxAA
	 lR6ESXuUDc2igj9aPZm6a/hx9iSsfVxZNx4MbVkKFNpmJ4Kw2FyenEzjAHSMeGnYjLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vjgWu7xswHDvqcX6o28/v4m5iKRr9vG7FVPJL71Lu0Y=;
	b=i8MiFgewuN0q8LcKjuRGw+FCbuZv0W4CDgd/6FMoBKPZSycGtFoCa9yTSq/CTBeSn0CJ
	 5222sm2qy3iKy2DSYBRzkRuHGsRp6g83/PQsdDOIccVpUaPK/7zb4HOObGKo3ednvep7U
	 VoR90JUY3PsG4oMegjvJ/GrbWNn2BvanpVVaaZVzrFUFwAUD+SWE+Cbt2zB3PHlQ1QrWq
	 WIQ6IB78z7vgnOdux/Y8MVln7LVT5EzIKbR0jmF1jJXQpmHCmcHy569sucprXxQ5Bt9JV
	 ciip/n3jY+Rvg5y+BcmE/ftW8922m5LgGDnDvwwcIlmBy58g51jI1jkcR1gi4Yjtt0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLPCxwB+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A614606A31C;
	Thu, 19 Nov 2026 00:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLPCxwB+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7D01F000C4;
	Thu, 19 Nov 2026 00:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047865;
	bh=vjgWu7xswHDvqcX6o28/v4m5iKRr9vG7FVPJL71Lu0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLPCxwB+KJKrDRewIcJvPhQS6/uuuE5HOcyoC9cXWj9fUlVkQ0tVrWslAo6NfW4zf
	 RK0DLWkrU80wgV07h7pM7YuY/2Nb0knfno9TDIdtYDGCVUZ96Cm/tKiFtio59u/C/b
	 5LvlIIpaC5PjUnYw34V/SIeXainSeu4moB/fiWgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	"Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1791/2857] clk: Use the generic OF phandle parsing in only one place
Date: Wed, 18 Nov 2026 15:47:05 +0100
Message-ID: <20261118150305.751634627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 060777087d7bb..9fc0cc2a2bdf5 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5101,6 +5101,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
 		 * has a "clock-ranges" property, then we can try one of its
 		 * clocks.
 		 */
+		if (of_property_present(np, "clocks"))
+			break;
 		np = np->parent;
 		if (np && !of_get_property(np, "clock-ranges", NULL))
 			break;
@@ -5246,8 +5248,7 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
 	int count;
 	struct clk *clk;
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_clkspec(np, index, NULL, &clkspec);
 	if (rc)
 		return NULL;
 
-- 
2.53.0



