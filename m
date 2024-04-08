Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AEF3A1C7;
	Mon,  8 Apr 2024 13:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584626; cv=none; b=k84nhYTyr1HP2lXE0CltHC21qCq45hwhx7cvVWQbQ8v674hdMdMR8UDIHkj8f9z1XsFZwdtuItbthKCjMtYIKo/0wo8pYBTla+tzlPEVBefkfZ8wzf3Swvb5DNhLQuvcTWQRVvD0udRlSTN9apEOMIWeau/4zMRn77vgYX9dTq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584626; c=relaxed/simple;
	bh=/jKoPCst/MzWXCktYnYSP1wrvYZ4g4rZu/VSrTyltMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7Iyfqyf98Q88CD1zzbK3kEqVgUBFzGIrzpj18xjebpS9lFu404Xvf3sg56ycXaNNJ6d0fJrOW4EHs0msyZZMTZwM8mDtlXFA8JDL4YCGX0nF6eapIcTwfH0WbT/8jL/4wQV7k5HKSeAh0bb0Rjj2TJAvnIrGGfpZnAZ1XWRQjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXfavVaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXfavVaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076EDC433F1;
	Mon,  8 Apr 2024 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584626;
	bh=/jKoPCst/MzWXCktYnYSP1wrvYZ4g4rZu/VSrTyltMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXfavVaaDinj1O+Z2/d5wJYvgZydeLgmg3bDikY/0wrYYcrC6TqzOPNCPVh3oYKxO
	 x8nuF8eO0u2XhVrtApJ5iTimT+THr++DDDvb6MSwMwc58K0H7Y7SuTc8OG+BFBw7te
	 dFWqHwZ6xOPkqNZ1iEP67OnASGCykAJtefdOcSmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.15 502/690] trace: Relocate event helper files
Date: Mon,  8 Apr 2024 14:56:08 +0200
Message-ID: <20240408125417.827960911@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 247c01ff5f8d66e62a404c91733be52fecb8b7f6 ]

Steven Rostedt says:
> The include/trace/events/ directory should only hold files that
> are to create events, not headers that hold helper functions.
>
> Can you please move them out of include/trace/events/ as that
> directory is "special" in the creation of events.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: 638593be55c0 ("NFSD: add CB_RECALL_ANY tracepoints")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 MAINTAINERS                                           | 7 +++++++
 drivers/infiniband/core/cm_trace.h                    | 2 +-
 drivers/infiniband/core/cma_trace.h                   | 2 +-
 fs/nfs/nfs4trace.h                                    | 6 +++---
 fs/nfs/nfstrace.h                                     | 6 +++---
 include/trace/events/rpcgss.h                         | 2 +-
 include/trace/events/rpcrdma.h                        | 4 ++--
 include/trace/events/sunrpc.h                         | 2 +-
 include/trace/{events => misc}/fs.h                   | 0
 include/trace/{events => misc}/nfs.h                  | 0
 include/trace/{events => misc}/rdma.h                 | 0
 include/trace/{events/sunrpc_base.h => misc/sunrpc.h} | 0
 12 files changed, 19 insertions(+), 12 deletions(-)
 rename include/trace/{events => misc}/fs.h (100%)
 rename include/trace/{events => misc}/nfs.h (100%)
 rename include/trace/{events => misc}/rdma.h (100%)
 rename include/trace/{events/sunrpc_base.h => misc/sunrpc.h} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9216b9c85ce92..6bfc75861c8c0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9200,6 +9200,7 @@ F:	drivers/infiniband/
 F:	include/rdma/
 F:	include/trace/events/ib_mad.h
 F:	include/trace/events/ib_umad.h
+F:	include/trace/misc/rdma.h
 F:	include/uapi/linux/if_infiniband.h
 F:	include/uapi/rdma/
 F:	samples/bpf/ibumad_kern.c
@@ -10181,6 +10182,12 @@ F:	fs/nfs_common/
 F:	fs/nfsd/
 F:	include/linux/lockd/
 F:	include/linux/sunrpc/
+F:	include/trace/events/rpcgss.h
+F:	include/trace/events/rpcrdma.h
+F:	include/trace/events/sunrpc.h
+F:	include/trace/misc/fs.h
+F:	include/trace/misc/nfs.h
+F:	include/trace/misc/sunrpc.h
 F:	include/uapi/linux/nfsd/
 F:	include/uapi/linux/sunrpc/
 F:	net/sunrpc/
diff --git a/drivers/infiniband/core/cm_trace.h b/drivers/infiniband/core/cm_trace.h
index e9d282679ef15..944d9071245d2 100644
--- a/drivers/infiniband/core/cm_trace.h
+++ b/drivers/infiniband/core/cm_trace.h
@@ -16,7 +16,7 @@
 
 #include <linux/tracepoint.h>
 #include <rdma/ib_cm.h>
-#include <trace/events/rdma.h>
+#include <trace/misc/rdma.h>
 
 /*
  * enum ib_cm_state, from include/rdma/ib_cm.h
diff --git a/drivers/infiniband/core/cma_trace.h b/drivers/infiniband/core/cma_trace.h
index e45264267bcc9..47f3c6e4be893 100644
--- a/drivers/infiniband/core/cma_trace.h
+++ b/drivers/infiniband/core/cma_trace.h
@@ -15,7 +15,7 @@
 #define _TRACE_RDMA_CMA_H
 
 #include <linux/tracepoint.h>
-#include <trace/events/rdma.h>
+#include <trace/misc/rdma.h>
 
 
 DECLARE_EVENT_CLASS(cma_fsm_class,
diff --git a/fs/nfs/nfs4trace.h b/fs/nfs/nfs4trace.h
index 635f13a8d44aa..8565fa654f59a 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -9,10 +9,10 @@
 #define _TRACE_NFS4_H
 
 #include <linux/tracepoint.h>
-#include <trace/events/sunrpc_base.h>
+#include <trace/misc/sunrpc.h>
 
-#include <trace/events/fs.h>
-#include <trace/events/nfs.h>
+#include <trace/misc/fs.h>
+#include <trace/misc/nfs.h>
 
 #define show_nfs_fattr_flags(valid) \
 	__print_flags((unsigned long)valid, "|", \
diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index f6013d3b110b8..6804ca2efbf99 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -11,9 +11,9 @@
 #include <linux/tracepoint.h>
 #include <linux/iversion.h>
 
-#include <trace/events/fs.h>
-#include <trace/events/nfs.h>
-#include <trace/events/sunrpc_base.h>
+#include <trace/misc/fs.h>
+#include <trace/misc/nfs.h>
+#include <trace/misc/sunrpc.h>
 
 #define nfs_show_cache_validity(v) \
 	__print_flags(v, "|", \
diff --git a/include/trace/events/rpcgss.h b/include/trace/events/rpcgss.h
index 3ba63319af3cd..b8fd13303ee7e 100644
--- a/include/trace/events/rpcgss.h
+++ b/include/trace/events/rpcgss.h
@@ -13,7 +13,7 @@
 
 #include <linux/tracepoint.h>
 
-#include <trace/events/sunrpc_base.h>
+#include <trace/misc/sunrpc.h>
 
 /**
  ** GSS-API related trace events
diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
index 28ea73bba4e78..513c09774e4f3 100644
--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -15,8 +15,8 @@
 #include <linux/tracepoint.h>
 #include <rdma/ib_cm.h>
 
-#include <trace/events/rdma.h>
-#include <trace/events/sunrpc_base.h>
+#include <trace/misc/rdma.h>
+#include <trace/misc/sunrpc.h>
 
 /**
  ** Event classes
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 68ae89c9a1c20..e8eb83315f4f2 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -14,7 +14,7 @@
 #include <linux/net.h>
 #include <linux/tracepoint.h>
 
-#include <trace/events/sunrpc_base.h>
+#include <trace/misc/sunrpc.h>
 
 TRACE_DEFINE_ENUM(SOCK_STREAM);
 TRACE_DEFINE_ENUM(SOCK_DGRAM);
diff --git a/include/trace/events/fs.h b/include/trace/misc/fs.h
similarity index 100%
rename from include/trace/events/fs.h
rename to include/trace/misc/fs.h
diff --git a/include/trace/events/nfs.h b/include/trace/misc/nfs.h
similarity index 100%
rename from include/trace/events/nfs.h
rename to include/trace/misc/nfs.h
diff --git a/include/trace/events/rdma.h b/include/trace/misc/rdma.h
similarity index 100%
rename from include/trace/events/rdma.h
rename to include/trace/misc/rdma.h
diff --git a/include/trace/events/sunrpc_base.h b/include/trace/misc/sunrpc.h
similarity index 100%
rename from include/trace/events/sunrpc_base.h
rename to include/trace/misc/sunrpc.h
-- 
2.43.0



