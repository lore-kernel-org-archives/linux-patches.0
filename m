Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015502;
	b=ZaDiv01TbU2TaywpUb81TFpDiJaO+7a1f4TWXYrUAUFMuxJ2BLbZccQVoq4ioRonktfE
	 /RQlqo4m8YulJDJzTJx0nlK4Bq1BhS0OjNgqp7Yv3ydeFrX7HXUcCCRMraIwvGjC9nbEz
	 WPlPHu52X1UIWjk5oNgJZeGskkJ9BCqg+eHYSAWZnjoa05bstWo2fW2oucjoHQDWCywls
	 YNk/jzY52rSzm3kD7wAes2TMcMOyqMbCDIfAKDuiRKBDaxjLaPbej62aZI6vAPAOLbPeJ
	 OR9IDhtbDowWniEpzRjG12qKb0x0j6u7oWPTe/OhuRsNj6WeLDQ5rlH1iYs/C/9wh/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+qpD7PIDOGg45O4hs3/mm6Cg0YpD6AAXXRTP9/Qjyfw=;
	b=GKIATKcckewd+JY7V0Ytp2IiKLZpj/j97L1eqeeq6g5XrvisXrkC+uWtlIIi0lliXhK4
	 YiT5yec5N5OIuiuF2KuxubEE00IqMcy46pEYa4Ld9wPHgm7Nsd01cjbtj9XMOY0WoV4cx
	 sgsdzxTQcYQebhil3hCedpcyqinExX9S0UUHCPfDwueGt5ZWQfhNQkGzvIGN7rImwANjo
	 nXLqnmZmAPXCBTppPcu/3mVm56PCN6vIEREZdGyEr0wKR6amr54OFr9ZxgPvtTh/lxyFo
	 gdB+QzrPiLMubR1ieJ5ez3fGEe3XhpliE3063GFa66LsPDzRB3golcXXoz1yajtIDPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBXITRZ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D24C606A31C;
	Wed, 18 Nov 2026 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBXITRZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3CA1F000C4;
	Wed, 18 Nov 2026 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015502;
	bh=+qpD7PIDOGg45O4hs3/mm6Cg0YpD6AAXXRTP9/Qjyfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBXITRZ4w398WxXYNN83ypinhBAaih15Yfi4849keJw6+UnucGhysq9fYdVOmQ/iQ
	 RnQHoAfIL+1FtMiFX7WtG71nHq+Erisb5SuIeGHpk8WHJTkdhRJ6c15sZDLPABYHl7
	 62kxiiPAXmbEO200onNfNlOk6SnIioBmPAzt/8os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	"Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0195/2651] clk: Use the generic OF phandle parsing in only one place
Date: Wed, 18 Nov 2026 15:23:55 +0100
Message-ID: <20261118150254.879323059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 7fd5bc2a31f68..8cb2c450ebd34 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5320,6 +5320,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
 		 * has a "clock-ranges" property, then we can try one of its
 		 * clocks.
 		 */
+		if (of_property_present(np, "clocks"))
+			break;
 		np = np->parent;
 		if (np && !of_property_present(np, "clock-ranges"))
 			break;
@@ -5464,8 +5466,7 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
 	int count;
 	struct clk *clk;
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_clkspec(np, index, NULL, &clkspec);
 	if (rc)
 		return NULL;
 
-- 
2.53.0



