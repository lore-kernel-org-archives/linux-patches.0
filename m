Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022998;
	b=iWFayjj94Jb+VxlfV7IJA7PAnLEBj5bm4kArEcfcALCt5m8uJjjlRhsGlURvFw/6a8+c
	 oCiQZvVZCyJrP6BWZN4ReLQTDzTE7pOzeyvR6W6MSvcW6SX89yWiLIm7pfpKet5WliONy
	 s8cZc1wCI044APhGolwO6fbOYh+ah6Wr3CLQyMv0ogKH9irGWUCFyTd/CtWdVjTeDqr0g
	 urvL7fHXHuc2sm5LD8sDEfv53hjII7MIYk9zthw+UYH+Ny+rhPXDVHIZaIFw2DgpQ63xu
	 7pz/H2vbsSgeXYyzKALBLjFXbkAz1gsZs7et1iTC8jv8jkfe/9hEqcAqAJ8S3m8F8RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fuUeSoWZZDyBjAlUtwz7l+RJS6EVy77jeNh7M6VNLwM=;
	b=x73UMN+cgMFoCVlaSA2r+XD5BIuW3YTWbrXqBRoGJmQyJZCz9VUHxoPRrNzW1gsStdjE
	 SBIj5xQtI4IyJgoOxXgDQPtq+HzPCNZfOayovSfxV0UI2bQZRcV4r4+udKTgU1LB+cul7
	 MPm70cSzoTtH50lI7hdTRJGMCM3XtyYcv2TTOw3HlleldtZTwy8fcppZ2kuHu+tIrSAs6
	 LyinmyCmn4QhvYkRrqELKceHMvvLEK+vsxHhOLRewRUGZVlneJwnLv+0xhu0Hph36gHFX
	 4V8Tu9LqhoQ4ns9UFbhHGTq8dElxAv+umZApqz+IFXc18zWPiEp5/7LUSvYf9hXh02w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O1fE86Nu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF1A606A740;
	Wed, 18 Nov 2026 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O1fE86Nu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B241F000C4;
	Wed, 18 Nov 2026 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022998;
	bh=fuUeSoWZZDyBjAlUtwz7l+RJS6EVy77jeNh7M6VNLwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1fE86NuqIcZNXThE56slhBloO2zuAm6EdAKBNPxTISeSNeeVRnqB5t30Wi+fGT19
	 mn1d31v0aeAJFbNLdVIHrxCGV70IYGNVCen4mxHCIplaKAYymCnoRrygPaIVXgaovm
	 wvQ1JA9O6msjE0yBwQ33NsAIH8anU9huDyUdtbt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	"Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0212/2151] clk: Use the generic OF phandle parsing in only one place
Date: Wed, 18 Nov 2026 15:32:27 +0100
Message-ID: <20261118150129.504630878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e00b36f5a6cfd..d67bd3a4b47c1 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5236,6 +5236,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
 		 * has a "clock-ranges" property, then we can try one of its
 		 * clocks.
 		 */
+		if (of_property_present(np, "clocks"))
+			break;
 		np = np->parent;
 		if (np && !of_property_present(np, "clock-ranges"))
 			break;
@@ -5380,8 +5382,7 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
 	int count;
 	struct clk *clk;
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_clkspec(np, index, NULL, &clkspec);
 	if (rc)
 		return NULL;
 
-- 
2.53.0



