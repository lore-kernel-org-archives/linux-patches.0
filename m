Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F04E47A76;
	Mon,  1 Apr 2024 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989806; cv=none; b=EiTYIslT5mNHAdgJ2b+7JAN5qj5JWTIXs3e0MVERaTS+jU7JOUmzQ12o5tJv4/AARpndE5JBefu8x7gsMPB1WM1FeEE1PLG/S1Iv0HMhMsY9r1fsNmiktT7/Dc2QbEmMJ0YQVI+H6WrgDi/cfFOG371e2AgszC4RoLTi9uuWH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989806; c=relaxed/simple;
	bh=/Ji4Eur922rMJ30Oa18uYyvW/dXSKtWN4tCBkmB6b60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKB2H7NAlp4rkpcrIRIZR+kVPmZSwOg7VihK++I69Qa/cexK2r+aMCgT7tC7aywT6Xu60lKhBbHptWpzmKtCoyptVUQButltyP0WyiuoRWSDcL6P4JPdWEgWHNWixMhKmidadNzN1Pz1lJl9nsd215wItmcrL9f0thWJMRvc1G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5ap9f+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5ap9f+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C9C433F1;
	Mon,  1 Apr 2024 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989806;
	bh=/Ji4Eur922rMJ30Oa18uYyvW/dXSKtWN4tCBkmB6b60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5ap9f+blqUQK8W9yz3/jc59g/VDESYeVC/jJ20JDD5YbrPS9pscKA++1jrBsH8NK
	 dGc3PoYimzMSpbwMXFmgZbpKKuV9bfm6x74Gv43AzPg7CVgmfp5ceNC7KlQL2XTjbH
	 qf+v4f2jWr0sroeNThHXXWFh/kj9f/ld1XhKY5Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/396] cifs: delete unnecessary NULL checks in cifs_chan_update_iface()
Date: Mon,  1 Apr 2024 17:43:28 +0200
Message-ID: <20240401152552.683095555@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c3a11c0ec66c1e0652e3a2bb4f5cc74eea0ba486 ]

We return early if "iface" is NULL so there is no need to check here.
Delete those checks.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 16a57d768111 ("cifs: reduce warning log level for server not advertising interfaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 0d76757528e49..8dadb21292d16 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -464,27 +464,23 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 			 &old_iface->sockaddr);
 	} else if (!chan_index) {
 		/* special case: update interface for primary channel */
-		if (iface) {
-			cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
-				 &iface->sockaddr);
-			iface->num_channels++;
-			iface->weight_fulfilled++;
-		}
+		cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
+			 &iface->sockaddr);
+		iface->num_channels++;
+		iface->weight_fulfilled++;
 	}
 	spin_unlock(&ses->iface_lock);
 
-	if (iface) {
-		spin_lock(&ses->chan_lock);
-		chan_index = cifs_ses_get_chan_index(ses, server);
-		if (chan_index == CIFS_INVAL_CHAN_INDEX) {
-			spin_unlock(&ses->chan_lock);
-			return 0;
-		}
-
-		ses->chans[chan_index].iface = iface;
+	spin_lock(&ses->chan_lock);
+	chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
 		spin_unlock(&ses->chan_lock);
+		return 0;
 	}
 
+	ses->chans[chan_index].iface = iface;
+	spin_unlock(&ses->chan_lock);
+
 	return rc;
 }
 
-- 
2.43.0



