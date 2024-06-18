Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDAA1A8C12;
	Tue, 18 Jun 2024 13:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716470; cv=none; b=qXVqURk4pZ9G1puzkiNnFOnUNcg4h0jrExDpMsm1BCbha1nfIJFXj6vXk1rWdkiMOja2SxxWkgYRd1XfENErZjMWKHkmqMrDZuohLFHLUZVxvM+ZjXItHO5eYVzc1Pa3pWaM+/QbCEas93BuLBlW4/4TtXJykKE+MLmAx1lY+GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716470; c=relaxed/simple;
	bh=ODRhUsjpQ1+qGEVoBLqez4q1WDZ6kHyiyjvWOeHvSTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+yKsTBjQK+dgNnWX/QItHO1/zKofOd842bTcYA20zEhNeS9b4mRRFCo3BmlgtSIYGgB7NPbELVWlmUp7ZKRVPDgUb5cwzaHYFDwDfFy+lfbVjmHYZmApA7WsMdKIVqr0j2anR9E11BEY0kQ3liXadbIJMJCVbE9Uz9S42T+p9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3PQrlq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3PQrlq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE97C4AF1D;
	Tue, 18 Jun 2024 13:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716470;
	bh=ODRhUsjpQ1+qGEVoBLqez4q1WDZ6kHyiyjvWOeHvSTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3PQrlq+p3fdeWU2XeVouvtUzic3P5MvgVKprA8UO6DVFTSFqWLmbEmETuUIR3Z1k
	 eqi5YcbBGZ1euidF+WxbSsufvdq/W0jTHKkg2EbTmj3Rc1RH6qjVuN0Qb4G7No2zpj
	 XAVKOafwqA56uJd9OEwJ4Q6x8V/JiC8CVDA9enyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 658/770] nfsd: use DEFINE_PROC_SHOW_ATTRIBUTE to define nfsd_proc_ops
Date: Tue, 18 Jun 2024 14:38:31 +0200
Message-ID: <20240618123432.685852744@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit 0cfb0c4228a5c8e2ed2b58f8309b660b187cef02 ]

Use DEFINE_PROC_SHOW_ATTRIBUTE helper macro to simplify the code.

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/stats.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/stats.c b/fs/nfsd/stats.c
index a8c5a02a84f04..777e24e5da33b 100644
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -32,7 +32,7 @@ struct svc_stat		nfsd_svcstats = {
 	.program	= &nfsd_program,
 };
 
-static int nfsd_proc_show(struct seq_file *seq, void *v)
+static int nfsd_show(struct seq_file *seq, void *v)
 {
 	int i;
 
@@ -72,17 +72,7 @@ static int nfsd_proc_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int nfsd_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nfsd_proc_show, NULL);
-}
-
-static const struct proc_ops nfsd_proc_ops = {
-	.proc_open	= nfsd_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
-};
+DEFINE_PROC_SHOW_ATTRIBUTE(nfsd);
 
 int nfsd_percpu_counters_init(struct percpu_counter counters[], int num)
 {
-- 
2.43.0



