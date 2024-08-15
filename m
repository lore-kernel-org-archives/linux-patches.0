Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B693A1A2570;
	Thu, 15 Aug 2024 14:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730872; cv=none; b=bpzZDVKhdcYVjQw6dNHBtDmk8VlWeky2gaOO2XzBCiEA5zcZ6kuvDrBLVe5BUXun6tCqjQAzszFrzKscsEZs5nCTTGisWLoZdW+8oNhROoAbV+UgdoMitH/jlsrUUYmSE+SjrjZNB64SyIkswyNhU9gM34fbLelPAUJX3lMyP9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730872; c=relaxed/simple;
	bh=WHpvYB7wKGMkAXy8ZJzYGRiqjcWrPD54mRz5OO5e0NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZzh82kC2h7d4lS2b0ewnxaizczeFEOLDLJsPxcfAmiUopJNvYDuQbljYjP8kQkxlnUiZyStchB0GyzUGZvKvHR+KZn1o/6My4j7FCYKEd3FqYGTJRtHsIQGem0mMJjEKyXZPioj/KppbRmC/MX+qUea9zsN8eQdxhvmOuN+Xtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efOta9f3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efOta9f3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2543AC32786;
	Thu, 15 Aug 2024 14:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730872;
	bh=WHpvYB7wKGMkAXy8ZJzYGRiqjcWrPD54mRz5OO5e0NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efOta9f3s+tSklraDPn+xelpiMf+uUR65vjOU3hindqE7wZHngWxAwGTfCZ8I16mK
	 F7/8dBPzHJkN5/U4kzDuZretdrpVap870Dx0BUR9QV9oZl3AlentLRJhxDp3YWWO72
	 GxC0Xa4uKh/9AVsUY/Mnvtl/04fsKT6sm5pe9jtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 05/67] NFSD: Rewrite synopsis of nfsd_percpu_counters_init()
Date: Thu, 15 Aug 2024 15:25:19 +0200
Message-ID: <20240815131838.523984124@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -76,7 +76,7 @@ static int nfsd_show(struct seq_file *se
 
 DEFINE_PROC_SHOW_ATTRIBUTE(nfsd);
 
-int nfsd_percpu_counters_init(struct percpu_counter counters[], int num)
+int nfsd_percpu_counters_init(struct percpu_counter *counters, int num)
 {
 	int i, err = 0;
 
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -37,9 +37,9 @@ extern struct nfsd_stats	nfsdstats;
 
 extern struct svc_stat		nfsd_svcstats;
 
-int nfsd_percpu_counters_init(struct percpu_counter counters[], int num);
-void nfsd_percpu_counters_reset(struct percpu_counter counters[], int num);
-void nfsd_percpu_counters_destroy(struct percpu_counter counters[], int num);
+int nfsd_percpu_counters_init(struct percpu_counter *counters, int num);
+void nfsd_percpu_counters_reset(struct percpu_counter *counters, int num);
+void nfsd_percpu_counters_destroy(struct percpu_counter *counters, int num);
 int nfsd_stat_init(void);
 void nfsd_stat_shutdown(void);
 


