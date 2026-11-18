Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039288;
	b=OD1UFGg0fRyXHDovP18PlL15axFprEFRedEJaLK5U8dJrBb4dg+z5wN447aXa+5uzAEH
	 smwG6irbdX0MkClKxbIVbBp8LHfqQknd9BpxvrbV8ldPFeDDWk4luLoHg5fqYRB9aWXqS
	 Wv93kZnDTmM9YzrVzboZHqv5+yENUfgl6heuyp2O4jf74LEPJCLfmD/rB0J0oeKp+MyjF
	 mdn4O17eY8ELWYRPbKOIHZR1hsy8CHfAsSis4NG6oZjpA+G+YXF2O/k2PX4kC/35buXQc
	 4fZzArwQzUoN4dIScRBt2A/tVqxnN4PD3FOk93RSJdiWLVywmVNwNrIE0UPimNE2Y3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=quN0HdrfzjC48BNZUl6WbvGBMJNb+/CUk2sdCPpcELE=;
	b=xMJTpBtEqaHA4afjoC8irQkTwFmEKkKzp8cOm9DkZ00CcZwDFuUjACWZayva0TRzniiH
	 1yf7l2J8Rvo/VMZs9aAR3Cah8IxJYYw0zMzhRIGtA2oBEvpaCVUPSGJr3RIXctFi0XKPa
	 pXSFyW14i+9NpB4ytVN/rEsUwVMFSOoBv58FBTSbutC7nEx7Wp/CgfodZH5w9/4MYgqGJ
	 2Wm+sqds8ZlplPJHTtlLh9R5OqW4B5nynx1sp8+wcwi1GkNggSJeJZa7OKX3u86LUuM68
	 hoztwlfdH/dbeXt9BjFskyfs8WVcgaGdl8eq4PmpegsWUTz5f9Jgy7hOkZec3yuLCyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QPYS04e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACFE606A325;
	Wed, 18 Nov 2026 22:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QPYS04e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF9F1F000C5;
	Wed, 18 Nov 2026 22:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039288;
	bh=quN0HdrfzjC48BNZUl6WbvGBMJNb+/CUk2sdCPpcELE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QPYS04ezIyt+vz/JW31E15D6PlzajvwpRoc8ANhwZbhG22dq6hdoahemQGuQl6f+
	 eDGjEs9K7A+Plnk72bvDtP4T9Iqf++klE4O89MJVlwdT1joBpBhGon2NbZbPTTYlQv
	 Dmr+05hSsR4B+Sk4ZVF1cevr2R0w18Iie0azdezA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	"Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2045/3318] clk: Use the generic OF phandle parsing in only one place
Date: Wed, 18 Nov 2026 15:44:27 +0100
Message-ID: <20261118150423.393560236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 50054c7f5c25c..c4772f1858f49 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5189,6 +5189,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
 		 * has a "clock-ranges" property, then we can try one of its
 		 * clocks.
 		 */
+		if (of_property_present(np, "clocks"))
+			break;
 		np = np->parent;
 		if (np && !of_get_property(np, "clock-ranges", NULL))
 			break;
@@ -5333,8 +5335,7 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
 	int count;
 	struct clk *clk;
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_clkspec(np, index, NULL, &clkspec);
 	if (rc)
 		return NULL;
 
-- 
2.53.0



