Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00EC18B491;
	Tue, 10 Sep 2024 10:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964948; cv=none; b=mCgfAHzWaCE8L7fgkAb361sjhknocbgW6S0IK3FEudEfI4XhfF6mXtgwFOmgXldASu3UcSEI/6rLti+SsTFED5AGcICOiZ23oZ0W1A3DshYyBuCg/NJil4D2E+L72Dk8PAEdQZOpJUlZTxVfA8V8C2GuvYzMxlTrEQ8opc3DCRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964948; c=relaxed/simple;
	bh=1h9uS/MjkXWAccwo+AFZ9NTSVl573UeCHsZQfdOStAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/UMk5LZbVJpJrRBminu8uInnNf7zPk/9ZJUoF9OZFEhGckfgDoCi5E1mDTeeuL5gMJJoqDpURSyVBq9CHlpgfhlgLwOuH9+Y4dhbEAyhbqz7+6yr4shYp9SkifWnVEbfxhjUo7+2H4lr/KPRYNTrlxWG4cnjOkqEZtvgRtGBPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cpjnmdnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cpjnmdnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A67EC4CEC3;
	Tue, 10 Sep 2024 10:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964948;
	bh=1h9uS/MjkXWAccwo+AFZ9NTSVl573UeCHsZQfdOStAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpjnmdnhMg178sdrrE98q1VYEnyqyadmkCtwRg1w8T0+nk9rq5LY+CxICfsASKpuo
	 gt9ub7GzhaEjw3uH6PzZy7cWVCgzwNna202qR/d+tdJjEhBSsKEg1XgCYSZC8AkFbB
	 ZN2CD3WUx0cb5YAzlODrXKgUvBGlZ5eK05eC/Hn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 085/186] NFSD: Rewrite synopsis of nfsd_percpu_counters_init()
Date: Tue, 10 Sep 2024 11:33:00 +0200
Message-ID: <20240910092558.009752724@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5ec39944f874e1ecc09f624a70dfaa8ac3bf9d08 ]

In function ‘export_stats_init’,
    inlined from ‘svc_export_alloc’ at fs/nfsd/export.c:866:6:
fs/nfsd/export.c:337:16: warning: ‘nfsd_percpu_counters_init’ accessing 40 bytes in a region of size 0 [-Wstringop-overflow=]
  337 |         return nfsd_percpu_counters_init(&stats->counter, EXP_STATS_COUNTERS_NUM);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/nfsd/export.c:337:16: note: referencing argument 1 of type ‘struct percpu_counter[0]’
fs/nfsd/stats.h: In function ‘svc_export_alloc’:
fs/nfsd/stats.h:40:5: note: in a call to function ‘nfsd_percpu_counters_init’
   40 | int nfsd_percpu_counters_init(struct percpu_counter counters[], int num);
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: 93483ac5fec6 ("nfsd: expose /proc/net/sunrpc/nfsd in net namespaces")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/stats.c |    2 +-
 fs/nfsd/stats.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -74,7 +74,7 @@ static int nfsd_show(struct seq_file *se
 
 DEFINE_PROC_SHOW_ATTRIBUTE(nfsd);
 
-int nfsd_percpu_counters_init(struct percpu_counter counters[], int num)
+int nfsd_percpu_counters_init(struct percpu_counter *counters, int num)
 {
 	int i, err = 0;
 
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -36,9 +36,9 @@ extern struct nfsd_stats	nfsdstats;
 
 extern struct svc_stat		nfsd_svcstats;
 
-int nfsd_percpu_counters_init(struct percpu_counter counters[], int num);
-void nfsd_percpu_counters_reset(struct percpu_counter counters[], int num);
-void nfsd_percpu_counters_destroy(struct percpu_counter counters[], int num);
+int nfsd_percpu_counters_init(struct percpu_counter *counters, int num);
+void nfsd_percpu_counters_reset(struct percpu_counter *counters, int num);
+void nfsd_percpu_counters_destroy(struct percpu_counter *counters, int num);
 int nfsd_stat_init(void);
 void nfsd_stat_shutdown(void);
 


