Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054851;
	b=eW9dUEBGDdrm+GN/DpT1fbywA1JnDgHXQXSO3wglIsNjfnQBLaMNfMCNydSS7yKRGZ0j
	 Jt4EwcpVI3bnHhh+3mst7FBN5yRTGXccSzRPetsSST3coXgojVL3YCNAALwYf/M0goTGY
	 lzexQ5jovlY9NQVLPGrpaIfQM2wCJuxpR94kosYeKm1xbsD882WGM0JfKdtF/VDZF/kJ7
	 sWTKpyI0bjyEgJ2VDXi8W4sVl8e6ElAWDk+6KJia/erC/xJEKxYdXUHuX2BRmmFONmttt
	 g3aibmU3ups79QX/3bnp40pzq/IocOPN9ymqPQk7y5fB00/WoI0xVl+WZQ1EMY1WYBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1QmJ108fJ5EyP+vS6cf+hO6ZIHt3jbWy45QLdHfZ/jI=;
	b=wfEvuhV0Gncaksvx7X1Tbj6yaQ+MTk/Pk0UQWQyraIlPQ7q3ar2LCCYEE6GdZHCjxxAg
	 iT8ymliNnM8XWj7d4kPoJ2YTNsBVnzDbKaKJKrbThZmGEBG19ngrxHuBW0GjAf7QRvaIG
	 hoUjjQGME4oTqzgUaKd9fatYE+z0XJEnNklWbz7xVggxKxbuyiIJQrShHSlad7lwwfN2E
	 cAIYTAT6bxDbfQQ/GbYTBGbwfGs2SKhpF/HpfIP/JUbr2wWGQIZLhDE3F2Uwxd5QRySfS
	 6+kdgFAD9NluP0XGJhv1K+2EOhHbcGBy4lwJ4I3xUd4mh5RANStFbHJlKO8g0eKYIHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRdioSNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97557606A31C;
	Thu, 19 Nov 2026 02:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRdioSNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1E31F000C4;
	Thu, 19 Nov 2026 02:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054851;
	bh=1QmJ108fJ5EyP+vS6cf+hO6ZIHt3jbWy45QLdHfZ/jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRdioSNhz3W1GZnLgf4pXVOyfNwJxQh1HLdyfQhCnfveBWMqpnT2foPA/mOnhrCag
	 jVYEzaKu4h0avXLarOGH1bd2qFiP1digRkQ5VS+V7KBWI1iWJ2TyTtHaj6g7xgGcHb
	 yhf76vBo/O6CAR8GgVqktbWU8ncK0bcgOlqG16Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	"Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1381/2214] clk: Use the generic OF phandle parsing in only one place
Date: Wed, 18 Nov 2026 15:50:57 +0100
Message-ID: <20261118150106.616908583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ea5980206c49e..fbfeb8ad11065 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4966,6 +4966,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
 		 * has a "clock-ranges" property, then we can try one of its
 		 * clocks.
 		 */
+		if (of_property_present(np, "clocks"))
+			break;
 		np = np->parent;
 		if (np && !of_get_property(np, "clock-ranges", NULL))
 			break;
@@ -5111,8 +5113,7 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
 	int count;
 	struct clk *clk;
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_clkspec(np, index, NULL, &clkspec);
 	if (rc)
 		return NULL;
 
-- 
2.53.0



