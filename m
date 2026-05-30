Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42018304BCB;
	Sat, 30 May 2026 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163364; cv=none; b=F4yI8OfF1jEji+kjYe1z2FRO8zyfFandpdztu5nVZOYmtOMyf86gfh5IiKPDnWeVoqpOhTtr+3r3NSQ4eFqAFLhWXq3XRc3tEyt55i+AfqiNF4pL0lq4jYlthF4w8vAi3fuJFy8qFVoCWWvl6Y85DkpZL31CCuiN9Z/UE1LXR9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163364; c=relaxed/simple;
	bh=gfR05gAHAf2KBS8o65aEZoWbNhD5XBjMlXn6d9umaLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llH13JV5W3/okR6XPV9YSumb2nCMnwMoHKOxn54e5K/+jFkPyLRxd0dOLfiI6C/k1oXWJQcfIUsJDwug5nUZJgChAbRRHmUPN4HnQJy+owoimDFeJ5yF6EcnEobK5M+aPVjEwn8Hz8vBa8aETtFHL0HWoiQ6DE3bkOoeGpp1b3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IV7hUc7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IV7hUc7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488421F00893;
	Sat, 30 May 2026 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163362;
	bh=EOvPc/gMqHPf9LyT6Ml/KI39zmlcAjCoBTTxM6e37/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IV7hUc7NNSrtNX0bQ1DuAieE5JnFWNHQN+/essV007K7BKOSCklyTxHsFhtC0YXvV
	 oTvep4wKgc8sKnyHxXjiPKLSn03PbYZP2jAC3m7WkfpcRK+sK1Z2020ub2L3fVfFPy
	 qUkkyQr8CnYdWKBp8vdV8iB9e9qlkJgqAt1KVfqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Bin Lan <lanbincn@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/776] padata: Remove comment for reorder_work
Date: Sat, 30 May 2026 17:58:29 +0200
Message-ID: <20260530160245.545782300@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 82a0302e7167d0b7c6cde56613db3748f8dd806d ]

Remove comment for reorder_work which no longer exists.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 71203f68c774 ("padata: Fix pd UAF once and for all")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/padata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 9ca779d7e310e..6f07e12a43819 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -90,7 +90,6 @@ struct padata_cpumask {
  * @processed: Number of already processed objects.
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
- * @reorder_work: work struct for reordering.
  */
 struct parallel_data {
 	struct padata_shell		*ps;
-- 
2.53.0



