Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAFA2F1FEF;
	Thu, 28 May 2026 20:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001138; cv=none; b=fHgJ2Tq//N9DKWsfrsfncCDcuGjzXelWwsgxCyRxZKojxCqxkkYLnzrDXjRUNJe/rWlaMQZSMbNwYHJupTP9fEOzqL3HHjOLskf/zoWVjdao63f07cRcsRT2kkMBFfDzV34luJ7ym6s2DmEcoUqDW9qaWCV8rroH6vrFMyJQiw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001138; c=relaxed/simple;
	bh=tC2QxwobzP8Gu0hEaWa8Lqc5y9y7Qgdm4o4iFdbRK0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfXEPHPh9WVdsEoEoe1eVtNW0nDx+8xHMrOoLgzhnVIN3eD6rTg/5AeGQbdFNPhi+ZI8a30p69UuAkUhjQEB/nEQH17w6igDEpHbnS0s1kJBCsEzVzO7fwHNsprniyRN8Y6JFp4OtrNZb9yW9dv8R4I9ksZy5vWx3qQb5LzLhGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXxTwt/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXxTwt/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAE01F000E9;
	Thu, 28 May 2026 20:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001136;
	bh=pNad2m4uOY5wJ40FuF0wGdae5NYAOpBN95V+RPe7tdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXxTwt/x2oAvKSKZHKwfqGpdfy4fbWyI1CbeHzy9ZCRsgVdOsAFCMEaib30tUtHUA
	 NflHWk8nSKGBC2pDF3jEkOWecsyevNb5AryIExdMW8bat20sRElTpLAKRSkJn/vWNR
	 Scm+EtC180fFXYCIou1ZJu1uUd1A2b7HYKV1xHlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/186] Revert "af_unix: Reject SIOCATMARK on non-stream sockets"
Date: Thu, 28 May 2026 21:48:20 +0200
Message-ID: <20260528194929.503185964@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

This reverts commit 0d7e7235bc543c6ed7b873e3015db814d8e8c414.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c621f00902752..8f785b2600ae4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2809,9 +2809,6 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				goto out;
 			}
 
-			if (sk->sk_type != SOCK_STREAM)
-				return -EOPNOTSUPP;
-
 			mutex_lock(&u->iolock);
 			goto redo;
 unlock:
-- 
2.53.0



