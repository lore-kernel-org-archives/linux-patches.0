Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06584596E;
	Mon,  1 Apr 2024 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988417; cv=none; b=iWwS1aRJBVHCNmLAamJYuxwXqGD1VqgGtQauAI886vJhetfxUOu73QwQ9gNtet2vOwjSFaV/wdxHfcmcMmT1WYbiNI4CRo4m2oXH4MZZ3WTLJlR3iM8V/BgjzjivRoPmzejDITNXmzXdwPAjGf5AFQbSjbVct7Fg3njM3jMvVGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988417; c=relaxed/simple;
	bh=k0tVhb2mQyOTCcpxlreyQH7S28zQdrGo35hBFviBM9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJCvkGQD/U5yuwVFmgibxGECETNtYM5JW0GYbhuMmXQKsMCMvDA9ZJs1vn4eID9mZ5Qk9l50NdNZKUBlAO3Ga4uNYyGCZmXhAscsOHDBfzvuM2xOQwblnfFp3aJyvljqBeJXdsAkBGBEHW01BAFtKClQbe2KoWov4frbjSP4znw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZG1fpqXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZG1fpqXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E13C433F1;
	Mon,  1 Apr 2024 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988417;
	bh=k0tVhb2mQyOTCcpxlreyQH7S28zQdrGo35hBFviBM9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG1fpqXVHmxTj3iHQnIMEfnxPthPqf9IxMFHppcwTVWbVNcES477Y1OQlaGG0Lqph
	 5uZVzv+pFNP+HxTjEMJIug7JNuNl0pkGyLWGwAs5KJYN6ZVbwOQWvxqNhRNTFWV0AD
	 WFZbbZuIas51wZkntXEZfQhcXiOa7qEtRvI6w3mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 179/432] cifs: make cifs_chan_update_iface() a void function
Date: Mon,  1 Apr 2024 17:42:46 +0200
Message-ID: <20240401152558.484266290@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8d606c311b75e81063b4ea650b301cbe0c4ed5e1 ]

The return values for cifs_chan_update_iface() didn't match what the
documentation said and nothing was checking them anyway.  Just make it
a void function.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 16a57d768111 ("cifs: reduce warning log level for server not advertising interfaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  2 +-
 fs/smb/client/sess.c      | 17 +++++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 6945551ea166d..13131957d9616 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -654,7 +654,7 @@ cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server);
 void
 cifs_disable_secondary_channels(struct cifs_ses *ses);
-int
+void
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int
 SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_mount);
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 0c2ac8d929a26..f8f4e7fc05dae 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -361,10 +361,9 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 
 /*
  * update the iface for the channel if necessary.
- * will return 0 when iface is updated, 1 if removed, 2 otherwise
  * Must be called with chan_lock held.
  */
-int
+void
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 {
 	unsigned int chan_index;
@@ -373,20 +372,19 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	struct cifs_server_iface *old_iface = NULL;
 	struct cifs_server_iface *last_iface = NULL;
 	struct sockaddr_storage ss;
-	int rc = 0;
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
 	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
 		spin_unlock(&ses->chan_lock);
-		return 0;
+		return;
 	}
 
 	if (ses->chans[chan_index].iface) {
 		old_iface = ses->chans[chan_index].iface;
 		if (old_iface->is_active) {
 			spin_unlock(&ses->chan_lock);
-			return 1;
+			return;
 		}
 	}
 	spin_unlock(&ses->chan_lock);
@@ -399,7 +397,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	if (!ses->iface_count) {
 		spin_unlock(&ses->iface_lock);
 		cifs_dbg(VFS, "server %s does not advertise interfaces\n", ses->server->hostname);
-		return 0;
+		return;
 	}
 
 	last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
@@ -439,7 +437,6 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	}
 
 	if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
-		rc = 1;
 		iface = NULL;
 		cifs_dbg(FYI, "unable to find a suitable iface\n");
 	}
@@ -454,7 +451,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		}
 
 		spin_unlock(&ses->iface_lock);
-		return 0;
+		return;
 	}
 
 	/* now drop the ref to the current iface */
@@ -483,13 +480,13 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	chan_index = cifs_ses_get_chan_index(ses, server);
 	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
 		spin_unlock(&ses->chan_lock);
-		return 0;
+		return;
 	}
 
 	ses->chans[chan_index].iface = iface;
 	spin_unlock(&ses->chan_lock);
 
-	return rc;
+	return;
 }
 
 /*
-- 
2.43.0



