Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C15714AD35;
	Thu, 23 May 2024 13:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470608; cv=none; b=UiooFJZcRb329LgVZQBcVeMGqtaf3IeJR3s9RcsLcpL12tNb5ZKqgV6e/CrJQOa9VpIfxLd4S8BVlrFi+hqMU8pQ+1+EPtYxqpYJPv90KEo27hLxKsP0bkQJY9/s+AtQSjsLtsW/831/44OTNUvIX7FPxQVxWCuFZIucTj/nGrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470608; c=relaxed/simple;
	bh=KIHJdVIrbMiN0CALy7fiE+C73CROxUNKKOc2u9NiC+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ul7X0Ljm8C4SXZcUdGeaiqekRHTGmANNvqR9JEyOPh4ET3xlSRlHfEqgSPxtB197XomI2kpFAWBRr8kkuHwYv2kHqmKKW9I0KF0N9XtOBvwTNEkNYo/6N1UctbaBv7/b0Ko7h8mzhlqx0KsnvPHHH+Y1iJt7vlvhmOFSZgGWhFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBwRIIwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBwRIIwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7792CC2BD10;
	Thu, 23 May 2024 13:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470607;
	bh=KIHJdVIrbMiN0CALy7fiE+C73CROxUNKKOc2u9NiC+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBwRIIwCBBgHHZ37BMeJAJJQwPSTJ5EdPBcjOTDHkRa1p/BCVACr2XOH+u2idnTau
	 JjWn4icS4cjfQAybn549Qx8MpvXz/fjeyoGBgWzu2HojCp/I6xJFNhlj33/y/qBZ2M
	 uIea2wOppZbRyybXYjCn2aBuf6cRs4F5po1wGcyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/102] cifs: remove redundant variable tcon_exist
Date: Thu, 23 May 2024 15:12:51 +0200
Message-ID: <20240523130343.450212904@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 8ca5d2641be217a78a891d4dbe2a46232d1d8eb9 ]

The variable tcon_exist is being assigned however it is never read, the
variable is redundant and can be removed.

Cleans up clang scan build warning:
warning: Although the value stored to 'tcon_exist' is used in
the enclosing expression, the value is never actually readfrom
'tcon_exist' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 51ff9a967c503..3f9448b5ada9b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3979,7 +3979,7 @@ void smb2_reconnect_server(struct work_struct *work)
 	struct cifs_ses *ses, *ses2;
 	struct cifs_tcon *tcon, *tcon2;
 	struct list_head tmp_list, tmp_ses_list;
-	bool tcon_exist = false, ses_exist = false;
+	bool ses_exist = false;
 	bool tcon_selected = false;
 	int rc;
 	bool resched = false;
@@ -4025,7 +4025,7 @@ void smb2_reconnect_server(struct work_struct *work)
 			if (tcon->need_reconnect || tcon->need_reopen_files) {
 				tcon->tc_count++;
 				list_add_tail(&tcon->rlist, &tmp_list);
-				tcon_selected = tcon_exist = true;
+				tcon_selected = true;
 			}
 		}
 		/*
@@ -4034,7 +4034,7 @@ void smb2_reconnect_server(struct work_struct *work)
 		 */
 		if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect) {
 			list_add_tail(&ses->tcon_ipc->rlist, &tmp_list);
-			tcon_selected = tcon_exist = true;
+			tcon_selected = true;
 			cifs_smb_ses_inc_refcount(ses);
 		}
 		/*
-- 
2.43.0



