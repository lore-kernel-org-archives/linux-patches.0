Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1083A261B9E;
	Sat, 30 May 2026 17:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163536; cv=none; b=qNbAVZYQccZ2rXRSy9uAWCQpieGqeK2t6x93wHgC62oLxpYxq4FGYmQySrA4CUWh4M6CyDbQSn856jmn3xTd4cMLmFCO5ZCzMXikBtNaqUSimnXPADZQBHhgcog0yFTRXRNfGz0Vo76lwmumaOWi60hV6QUPkxabNAh7gje6bfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163536; c=relaxed/simple;
	bh=vYb5OM1hllZsEVasZfn+2uvLenyoT7mZlOrFDwQsAhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzBfWb0MPlaL5PhBAoikppBiE7l/2r0DFOLH93x4z58zuVxiuBYBmn7f3ywaOKsxKQ/zxiFP66aREXyJbcTsP0vryHJX9YJ8bFzNhco8sAEt/XpUNt0mm6rVjgMRG97y2RhUweq5/BkMtORvkxNecrBvDf38hkQermSUse0FeWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFvfbM2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFvfbM2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AF71F00893;
	Sat, 30 May 2026 17:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163535;
	bh=eKBZSZ6gnD3xEjrNkWH2l0QE+h2/7lEZwpbu3AbuHz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFvfbM2M2bFrpkannyBZm9wcqFdWJAOF7qSbn0Xw4KcHAjEO/aUGHiefxMsjtZovf
	 gxmII5yPSrUzixSRaz7UYhRENExzijQyNTbAazdHAqW8ptQRCWoPMit6OZBOEBm5LJ
	 KnG1oxEhuQI6wQyNQaXt/nN3y7zWCY2YjXkYIv6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 287/776] ipmi:ssif: Remove unnecessary indention
Date: Sat, 30 May 2026 18:00:01 +0200
Message-ID: <20260530160247.974990025@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit 91eb7ec7261254b6875909df767185838598e21e upstream.

A section was in {} that didn't need to be, move the variable
definition to the top and set th eindentino properly.

Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 55ebe1d31766b..e93846f8f2352 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1694,6 +1694,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	int               len;
 	int               i;
 	u8		  slave_addr = 0;
+	unsigned int      thread_num;
 	struct ssif_addr_info *addr_info = NULL;
 
 	mutex_lock(&ssif_infos_mutex);
@@ -1902,22 +1903,17 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
-- 
2.53.0



