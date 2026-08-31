Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0FF47D447;
	Mon, 31 Aug 2026 13:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184772; cv=none; b=OZoN6DVsd8tVm6pI3eO0zW7OGxds6QCnZqQD/AP652pf2a8dngncekVFIxGuJa6FxBJWnkC90moyGu5rwDzsFyOZqz6J0N/TviMH1m1hxbz42IthJFcVek1dfSuZVAvYXHmGIRYMgen3Jlbkr2LKm/CIVlJzJoLb+TBJsflWgtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184772; c=relaxed/simple;
	bh=dYb6Dv9HJUKSm/X8wTYQrwde+Klqk3q8VsY5c1Wt06g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwyQgUCXXHF+NgMqQu3gPnvHZyqc+cc8I6EPPYtVDDv/lxhxf8Xn1I5Qj0LDsnNTkafVOY82x+WCilh6952kyAjH95RUXF/KEDutkLH0k8hQp9ytMKJuJ6J6GoKky6AHCXskEbzORA7W1qD3wbhXCTJz6gLA6CaKBOU91yHZWGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2+ESsdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2+ESsdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515881F000E9;
	Mon, 31 Aug 2026 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184770;
	bh=2Np2ozRhIV9fqAcI7n2JSShNVgg4DVldA7Pxdts1MAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2+ESsdYTrqyWPCEsAuRz0v8bxFNQMd9j0eZ8kVUgFy9c2XEp425WqJtooW0JrW1M
	 i4WwQcDwj9nU06aVUDVcuurY5sdlKawAwIwhW/nvOxRgRc+gG/UA3wtOpkdXIwlvao
	 ywKkv/3d5BopogSUSH5+StMk8/udulHm6uugL1+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/92] Revert "smb: client: use kvzalloc() for megabyte buffer in simple fallocate"
Date: Mon, 31 Aug 2026 15:34:31 +0200
Message-ID: <20260831133401.406419869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 1233c883cceb2e859b14abef4087f400e92490c7.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 05b7b02a6b035..2b38e8e7efd4e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3670,7 +3670,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3737,7 +3737,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 
  out:
 	kfree(out_data);
-	kvfree(buf);
+	kfree(buf);
 	return rc;
 }
 
-- 
2.53.0



