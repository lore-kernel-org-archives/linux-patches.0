Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D0244E045;
	Tue, 16 Jun 2026 17:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629989; cv=none; b=mZNfi3DBBRg3H3ctYan8HzrvOiVgG3S+geyOsNWEevFapTWAD2iv16RfsQdHUbUVyyIgWwDtSRQXJKGrlDQSgW0YQqo9b6xMTHmPDBs1g2qRyfuC5CwCY4zjTIbGP6fOrWkEsqbxz2wDMul5w3UF9Pcgz3y8Rx4tHs09DRq1S0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629989; c=relaxed/simple;
	bh=MesTTxGDIHdIQHji1QMlI1V8vzJMVMB780P8lxkACiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8zJNU5JiZwvMmF5mDO5lWJm756aVrHmJzxPASrZxQAoN1qC+Yt6ZttZIaZvo80HbcKRNLw+BctElZMUbaXDKEvh17YbTeWPwox5vIdGY5XTzyHQ/H/MnWpVHb7itUTnTjmfFQcUveN4A3ZywSgnntt6DFnYaDvBc37mAqNZBYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgP3RNii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgP3RNii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A431F000E9;
	Tue, 16 Jun 2026 17:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629988;
	bh=VC/566gNgb8RYtn+yWl/JRVqQ7SDSzGS/OSvVtuEMwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgP3RNiiIqWfVk2bQkOnSM1VoGHfCFRkwa4xDd3WHAtEpZ0m2NMCnqwmO7m9o74/2
	 ZevBLWLvLyU7IXhKu7Iky2qYKmA06XD4f2VOZl3xsjvO0q+rvhd+aw2K8Jig/LUXM9
	 +liCXe+m6FSfTCGuIaOmgftzDrD+FRJJ35HD0FhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.6 373/452] ipmi:ssif: Remove unnecessary indention
Date: Tue, 16 Jun 2026 20:30:00 +0530
Message-ID: <20260616145136.602519367@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1667,6 +1667,7 @@ static int ssif_probe(struct i2c_client
 	int               len = 0;
 	int               i;
 	u8		  slave_addr = 0;
+	unsigned int      thread_num;
 	struct ssif_addr_info *addr_info = NULL;
 
 	mutex_lock(&ssif_infos_mutex);
@@ -1875,22 +1876,17 @@ static int ssif_probe(struct i2c_client
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


