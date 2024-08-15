Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844A81991D0;
	Thu, 15 Aug 2024 14:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730735; cv=none; b=QXqjMnrjQUvdPBjvSSLb3zbe3E6R0DWilDgrJlqMVAsrfTikznieeOjSlb+L/wWiatCJtpIMZaVshM/4hxMYCYvK9AaO+Hx6kuAW6VXejBhy0MPfVglBzHEV5pToCDmgKVm0403bJczPy41UvHwT9pRCTZSZ9r3tzSgcRTsBFkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730735; c=relaxed/simple;
	bh=Uq+SNVoBzIoGRhIaf5VeM3oGY0CsXSZzbJXKodUYw0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IENF3w7JOyTDNidipOXXhQcfHQ1P9ghu6ctpmjO6qAaStPF8m81OtCBr9c+vgaT5ZA7IrWXmxkKbCeM67c40JSrcxzQKjfwa5itVTUJkAFsE41aBWsBxO5HpdhFVU8t1OeSA7YZyFH26MhGbclul2g5ReyDBACoyQteoExVVHms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uet7UDm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uet7UDm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D73C32786;
	Thu, 15 Aug 2024 14:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730735;
	bh=Uq+SNVoBzIoGRhIaf5VeM3oGY0CsXSZzbJXKodUYw0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uet7UDm425EjuFDQSj370KfpKQIVjzKchUSDQxz/Uzf6lt55siROPWk1+RJhCl2nb
	 QEkHFUksXrChWoKn01sE6dHSQ9yBfeZjuRK82fslwtd052Won7saq6YNFA2dMNba44
	 rlorsHiBVZjjtk/nVKse11lYrgySB9sjtNbf+ltw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 16/38] NFSD: Rewrite synopsis of nfsd_percpu_counters_init()
Date: Thu, 15 Aug 2024 15:25:50 +0200
Message-ID: <20240815131833.576192459@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


