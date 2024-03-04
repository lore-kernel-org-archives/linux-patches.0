Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1BF8F58;
	Mon,  4 Mar 2024 21:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588333; cv=none; b=t4WqXQ55mDs4DkcDM9gnZ2imGPQdyS6pbyjcbzLfR2xYduKU088QX9PsbAHJW+U2dprUYdhAefO9N0iUCcWQLAAb4TPnS0i1kvyX8ZotMFXIPzYHxhUAz2FplxNap07qhoDzkxHnd70jpKVse5UzvyEPNKyggjU1XQ6frYWVOLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588333; c=relaxed/simple;
	bh=nrWwadAYkua6Vc42mguv53ROZW32zvtSy8fu5VL9Vn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gyso6ynFzlUIDJwy3O5qJB/fR1yyLRxIAgojh2psCxWsJcMU9A8NC+Xi9ITUuDlkoXmS3+dKthtEvfNWDA05OpGEhEp9rndXZI/j2TLt+I6yU40CLHwoHxVGeBZQ/n+bCZMZ7rJtzSRQV2XLKBuPvsjJpJ1qrFj0ZPVsdwSfPng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdhC9gVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdhC9gVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21694C433F1;
	Mon,  4 Mar 2024 21:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588333;
	bh=nrWwadAYkua6Vc42mguv53ROZW32zvtSy8fu5VL9Vn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdhC9gVJc224K91eeI5hTqasMHA9IRdEffnhRMRKX4m5we3uM4+f8cWCoZtjo2QGO
	 PstGlb1M8HxN7ZwHrbxxlVNzV1UBptMgQ4pwO5aSwnUr1jI97816Z5RsiRFwB6YlBM
	 bo2g614YiOSzqSEko/2kqb8J6L4Pq5wN4OzdRFCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Saravana Kannan <saravanak@google.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/143] of: property: fw_devlink: Fix stupid bug in remote-endpoint parsing
Date: Mon,  4 Mar 2024 21:23:07 +0000
Message-ID: <20240304211552.067020981@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e1a2cb5ef401c..b3f0285e401ca 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1302,7 +1302,7 @@ static struct device_node *parse_remote_endpoint(struct device_node *np,
 						 int index)
 {
 	/* Return NULL for index > 0 to signify end of remote-endpoints. */
-	if (!index || strcmp(prop_name, "remote-endpoint"))
+	if (index > 0 || strcmp(prop_name, "remote-endpoint"))
 		return NULL;
 
 	return of_graph_get_remote_port_parent(np);
-- 
2.43.0



