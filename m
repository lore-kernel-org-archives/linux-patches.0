Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEEC1EB5A;
	Mon,  4 Mar 2024 21:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587740; cv=none; b=NWeETvLdQbgjKrs0UNEv8Xu5W94G5iEP83i0+KaGdu0G4SA2g308mEJdANUCJpQ80kPy4zQIuSZW801I0J4KDFUMvJltD9jqew6chMML2g5WxfU9QNI96ECKas288YsZqoFiRdnh65taSgGJ1hNAQPQEfC3NQHZuu8ZYtoSCxq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587740; c=relaxed/simple;
	bh=+CuEoE4rIrKTqsNvObVCNo6MO+gqlavnz82tg6IR1Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuJCGEhk9vc4hU6AH/xTQVHc3YQVtsfDi254eZHbnEhw6++0iN7GmlUY+zRJNU7uiuqpAzh9+yTVSykRes213i2TFvog3D9TW23bii5jM2MWLzb8ZHvRGLmT4PN7QzvtRjvOvHlQy6YTCrxxtJnfq5g8vYznltpOm2nnCn2xWuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9jNrgkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9jNrgkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAA4C433F1;
	Mon,  4 Mar 2024 21:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587740;
	bh=+CuEoE4rIrKTqsNvObVCNo6MO+gqlavnz82tg6IR1Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9jNrgkIifVj/FbBO3p2/ZL1w3rWmHVpQt0fILMi4HtbdtDgVLqvBh2CJ3T1sUQ5Z
	 gXCfIBN9BvG7IV258BlTFcsOry1vRK1lxInaIVZRhmMueNSH3I/4GmT13wNQsUHI6L
	 b4wuJ/HDyUiXaYbxurlxhCrlK6o6BuVUMbuLawjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Saravana Kannan <saravanak@google.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 072/162] of: property: fw_devlink: Fix stupid bug in remote-endpoint parsing
Date: Mon,  4 Mar 2024 21:22:17 +0000
Message-ID: <20240304211554.162740231@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 885ee040ee2b3..15d1156843256 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1303,7 +1303,7 @@ static struct device_node *parse_remote_endpoint(struct device_node *np,
 						 int index)
 {
 	/* Return NULL for index > 0 to signify end of remote-endpoints. */
-	if (!index || strcmp(prop_name, "remote-endpoint"))
+	if (index > 0 || strcmp(prop_name, "remote-endpoint"))
 		return NULL;
 
 	return of_graph_get_remote_port_parent(np);
-- 
2.43.0



