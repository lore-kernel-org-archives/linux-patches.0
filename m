Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8640B35DA6A;
	Tue, 16 Jun 2026 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627887; cv=none; b=O5/brf5/CUdb9FTBs8XUasPLlLl9sT+8T8VGbE7cuiPC4U7hFTJlI/MUW5B9mZGWH4RbUsklEsdbJsdXHYH29L0w+nv40X+fuwFQpoPXJPhyApp4WeBiAJ058f5eqyNxmqnwjSoCddfuZphxboYKiqbvmsVSA6ZG6LMPe2PqRik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627887; c=relaxed/simple;
	bh=GvPE2gly/RpnKS3ZH7lIH66c4g6A6BWQ1MBpFzGo3Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtn0HCUr070TbhALff7PTNZHwI9VrnQf1SYU0ELant/AIpqRzEVVfc7ZcMjkAOHuemPsfcfJ+vXSO3DC0IK6DC4dmNEGMf6P3wvXgBtWlUFPsHPHZyE0XfPbydL4fS2YfXJfA3ppCysXAZesR5lr/fiLVEJoTKohNsSicgrlsfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anVwXzvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anVwXzvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA301F000E9;
	Tue, 16 Jun 2026 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627886;
	bh=o6FD8TOyk6ENNHQUSt7U5Nu3Xh2lurQ4vK42H1415YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anVwXzvYuQqXck9IHVnuKJqKubY+IVW5ENmt3AzSCC4kVkPuhb1Y6pR1gPLS0Qj43
	 REw6F20VkNYkStAK+D3FaluBmbpX5g4FKiPr/db3MRD3Vej/ba/QURFus1WjSli9JK
	 78ERdQIy6zOAZUsvUD22OgxxX3AYyJVojoR6vRDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.12 245/261] ipmi:ssif: Remove unnecessary indention
Date: Tue, 16 Jun 2026 20:31:23 +0530
Message-ID: <20260616145056.438078431@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit 91eb7ec7261254b6875909df767185838598e21e upstream.

A section was in {} that didn't need to be, move the variable
definition to the top and set th eindentino properly.

Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1681,6 +1681,7 @@ static int ssif_probe(struct i2c_client
 	int               len = 0;
 	int               i;
 	u8		  slave_addr = 0;
+	unsigned int      thread_num;
 	struct ssif_addr_info *addr_info = NULL;
 
 	mutex_lock(&ssif_infos_mutex);
@@ -1899,22 +1900,17 @@ static int ssif_probe(struct i2c_client
 	ssif_info->handlers.request_events = request_events;
 	ssif_info->handlers.set_need_watch = ssif_set_need_watch;
 
-	{
-		unsigned int thread_num;
-
-		thread_num = ((i2c_adapter_id(ssif_info->client->adapter)
-			       << 8) |
-			      ssif_info->client->addr);
-		init_completion(&ssif_info->wake_thread);
-		ssif_info->thread = kthread_run(ipmi_ssif_thread, ssif_info,
-					       "kssif%4.4x", thread_num);
-		if (IS_ERR(ssif_info->thread)) {
-			rv = PTR_ERR(ssif_info->thread);
-			dev_notice(&ssif_info->client->dev,
-				   "Could not start kernel thread: error %d\n",
-				   rv);
-			goto out;
-		}
+	thread_num = ((i2c_adapter_id(ssif_info->client->adapter) << 8) |
+		      ssif_info->client->addr);
+	init_completion(&ssif_info->wake_thread);
+	ssif_info->thread = kthread_run(ipmi_ssif_thread, ssif_info,
+					"kssif%4.4x", thread_num);
+	if (IS_ERR(ssif_info->thread)) {
+		rv = PTR_ERR(ssif_info->thread);
+		dev_notice(&ssif_info->client->dev,
+			   "Could not start kernel thread: error %d\n",
+			   rv);
+		goto out;
 	}
 
 	dev_set_drvdata(&ssif_info->client->dev, ssif_info);


