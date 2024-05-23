Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A213E14AD25;
	Thu, 23 May 2024 13:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470691; cv=none; b=Fz4dqCFn0rJIra3PXzUE07EblABbCdXXSJR7mjO9b4gZg4KVpUdyedGz66qTiXJ5o/dxQLyrSsA5hTgggw9lOn3D1HDMN2ysV/C4LmwwZWPUiBN9cYvuls8CFdyB6vy3we6kFAIkdBTrbcT/b+11bwoYclYVSFIUhD00t9IreGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470691; c=relaxed/simple;
	bh=NGJukVT2PoHjVSNRACiE0x3mj/yAk/sauawRDqmhJeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVef6RPTcXJ+2eGI3jeYpaG9ZQE59Deh1t5u5LBWPg/0I8BmFRbX55Vt21VmsiSNTMEXC9u7aIGhesF7ps2zk3BIQqX3n0VurbjY/ZnE+eDB/Z3nkmIhiIoStZxpdLHRr/H1B3195pzvQp0KdVLYVJHIcgEFFYxDWuUbkcm6pog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/1a2qQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/1a2qQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2733EC3277B;
	Thu, 23 May 2024 13:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470691;
	bh=NGJukVT2PoHjVSNRACiE0x3mj/yAk/sauawRDqmhJeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/1a2qQWumyhQqsAS+sSd281fs+w6Xys6s8w0Y8ZXPgS3paNEaHV6QrgqJ0mLB3vJ
	 2Csq25laqQiOKumJhuGJ7LgWeggud6MKzUixeKcX4hSJYZny+TPY0E1z4/0Vc21dd5
	 HQCrmvunYhnqsjqCDpmGE4F31Ynq87ePdHA6GcOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/102] cifs: remove unneeded return statement
Date: Thu, 23 May 2024 15:12:48 +0200
Message-ID: <20240523130343.338090328@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit a3f763fdcb2f784c355aed66ddac6748ff8dbfa6 ]

Return statement was not needed at end of cifs_chan_update_iface

Suggested-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 5de32640f0265..3216f786908fb 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -485,8 +485,6 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	ses->chans[chan_index].iface = iface;
 	spin_unlock(&ses->chan_lock);
-
-	return;
 }
 
 /*
-- 
2.43.0



