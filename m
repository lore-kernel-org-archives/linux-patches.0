Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA1761675;
	Mon,  4 Mar 2024 21:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588784; cv=none; b=tl5I6r6VT0UTN0oP7BqfcOz37skC0qgR9HaTfxf9rY0x1pPfXYzRmc7BNggpX2gmj3bVHwbn8VIX3nVsJtDr09lq2+ke2OtZ30Q2/tyvVNvSLff0pppjeZVsaZDQMpRCULiHRQu3ulNguZkh9xGFkggC+1Zp9dzSawU0yZ6MkxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588784; c=relaxed/simple;
	bh=/M08V7ypiaVQXObtpKoKIpbgmZX0mpYx0J+1S78BAck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzVospiN+h09aV8ivXcMIcmlhQU5jYjZ/CpAmg9skyaL0rlJOyhPaow8HwMmSaNyg6RnFUpNzwePQfKIrVHJYQkrcEScpugp+nuX0JjPbFpZD4ljBZ7swCO8jb3Bt4qmup98+FhZ5eIJ9FqIFe1i7bmGiiqgaX1P4uwaI16C4E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEzwmfal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEzwmfal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6CCC433F1;
	Mon,  4 Mar 2024 21:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588784;
	bh=/M08V7ypiaVQXObtpKoKIpbgmZX0mpYx0J+1S78BAck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEzwmfal7x7Yi8ENZTWWldVYU8dP5v0T7nw/a3t73hEqXDNxaPE5tX4vq/2bSj+Du
	 wVsDHwigVeGii8ss4oLtx1UZxGflphF/UKMhE5CTuUgMDQdQLdV2kteGnnxszO5FNv
	 w/B8WahhXI5yLq19+mrmgb9xwPOXFybJB71s27OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Saravana Kannan <saravanak@google.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/215] of: property: fw_devlink: Fix stupid bug in remote-endpoint parsing
Date: Mon,  4 Mar 2024 21:22:14 +0000
Message-ID: <20240304211559.233592708@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 7cb50f6c9fbaa1c0b80100b8971bf13db5d75d06 ]

Introduced a stupid bug in commit 782bfd03c3ae ("of: property: Improve
finding the supplier of a remote-endpoint property") due to a last minute
incorrect edit of "index !=0" into "!index". This patch fixes it to be
"index > 0" to match the comment right next to it.

Reported-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/lkml/20240223171849.10f9901d@booty/
Fixes: 782bfd03c3ae ("of: property: Improve finding the supplier of a remote-endpoint property")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20240224052436.3552333-1-saravanak@google.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 33d5f16c81204..da5d712197704 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1332,7 +1332,7 @@ static struct device_node *parse_remote_endpoint(struct device_node *np,
 						 int index)
 {
 	/* Return NULL for index > 0 to signify end of remote-endpoints. */
-	if (!index || strcmp(prop_name, "remote-endpoint"))
+	if (index > 0 || strcmp(prop_name, "remote-endpoint"))
 		return NULL;
 
 	return of_graph_get_remote_port_parent(np);
-- 
2.43.0



