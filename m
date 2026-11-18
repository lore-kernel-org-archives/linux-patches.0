Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054868;
	b=Kv0XTy0Jz+Yq6KD7wLwYylxB4yJ14b0ThaMaoVA4C6DYAK0ccV77l/0LkI/eTzU1RlcA
	 fiRpSLKHqkf6MnkityDz6jPPEpgtUpYKsZI2sZIydqKVkv+sclP8Ita/JoZQ1tQYV/bSI
	 0VMx/zQRLatxv7fQ3uN/7ARNzKDmNBjX5TvoYVt1nOTxkoskn0xafh0bfyikd/owhh6zR
	 2r344BOHXLI+7wKIBM15RzQ8OUgmlN5MZvb9c2WC9CtOpOOLFce+N1PLIX1gklm9//YtJ
	 pQ6kNsEXLBIscSlLxQtPiRnEcT41I9rMnqfjy1ChuG4NrBBC8cXac8FvAh23WYBdjMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sI+Uq34tqDHzoOHKyZaMEQrQAlU9X8aySLOX4+M8q2o=;
	b=TEpdGxdyNJ2kZZ1Wb6oP8146SjSvX1BhWDDSrcTzdMI3u/JhMM0eC/aP8/PC2UvNNgIV
	 51DeJDuIDZ68UZkQqM826dT8sLgh3P8v6kM0jN0gtwc00VVUndiLo3z6D0nLx8xJIAlu+
	 ySUifP1qzSYxlb9YernxdydCclGLqCOYuEtiVqWc5i/McpTk3Gmd0iGk3vbU/EltlccGX
	 LD/wOOv+kcJn9iFJVZM/Bxipy1np4YdZ3akVeu5jroz07ou9ZXPJRulb2wTQHaznMp0T9
	 5kZuZO6omFEaZiQo/0e9uuprBBVts449bFD2kSx1aJkPV/RjM50ZYCc6iPR3HPtWn9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5QOATOG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33429606A31C;
	Thu, 19 Nov 2026 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5QOATOG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BF31F000C4;
	Thu, 19 Nov 2026 02:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054868;
	bh=sI+Uq34tqDHzoOHKyZaMEQrQAlU9X8aySLOX4+M8q2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5QOATOG5aLz3oomaoNR8eypYr/ojCpfMkRhJiII8r3MFDBhjOeHEclne9aBnAD3t
	 V9V/4QOC3TZRS0boNaCHTh5sbslhwxQ9nPf0Rr9it2jpUKY63pQso99mWS2Nxxs4c1
	 ZULTDyreY7MzaXW9KbUpg4tc6YyyfRNn/bBM8Yk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1429/2214] scsi: mpi3mr: Add debug APIs based on logging_level bits
Date: Wed, 18 Nov 2026 15:51:45 +0100
Message-ID: <20261118150108.346242725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 9cf0666f34b1991d73db8b19dc53387724aaefae ]

Add debug print functions which will print messages based on logging_level
bits enabled.

Link: https://lore.kernel.org/r/20211220141159.16117-2-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bcf0a5bed59a ("scsi: mpi3mr: Fix out-of-bounds reply frame access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_debug.h | 133 +++++++++++++++++++++++------
 1 file changed, 109 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi3mr_debug.h
index c085bb048d416..cef61c5d59d39 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
+++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
@@ -14,27 +14,20 @@
 /*
  * debug levels
  */
-#define MPI3_DEBUG			0x00000001
-#define MPI3_DEBUG_MSG_FRAME		0x00000002
-#define MPI3_DEBUG_SG			0x00000004
-#define MPI3_DEBUG_EVENTS		0x00000008
-#define MPI3_DEBUG_EVENT_WORK_TASK	0x00000010
-#define MPI3_DEBUG_INIT			0x00000020
-#define MPI3_DEBUG_EXIT			0x00000040
-#define MPI3_DEBUG_FAIL			0x00000080
-#define MPI3_DEBUG_TM			0x00000100
-#define MPI3_DEBUG_REPLY		0x00000200
-#define MPI3_DEBUG_HANDSHAKE		0x00000400
-#define MPI3_DEBUG_CONFIG		0x00000800
-#define MPI3_DEBUG_DL			0x00001000
-#define MPI3_DEBUG_RESET		0x00002000
-#define MPI3_DEBUG_SCSI			0x00004000
-#define MPI3_DEBUG_IOCTL		0x00008000
-#define MPI3_DEBUG_CSMISAS		0x00010000
-#define MPI3_DEBUG_SAS			0x00020000
-#define MPI3_DEBUG_TRANSPORT		0x00040000
-#define MPI3_DEBUG_TASK_SET_FULL	0x00080000
-#define MPI3_DEBUG_TRIGGER_DIAG		0x00200000
+
+#define MPI3_DEBUG_EVENT		0x00000001
+#define MPI3_DEBUG_EVENT_WORK_TASK	0x00000002
+#define MPI3_DEBUG_INIT		0x00000004
+#define MPI3_DEBUG_EXIT		0x00000008
+#define MPI3_DEBUG_TM			0x00000010
+#define MPI3_DEBUG_RESET		0x00000020
+#define MPI3_DEBUG_SCSI_ERROR		0x00000040
+#define MPI3_DEBUG_REPLY		0x00000080
+#define MPI3_DEBUG_IOCTL_ERROR		0x00008000
+#define MPI3_DEBUG_IOCTL_INFO		0x00010000
+#define MPI3_DEBUG_SCSI_INFO		0x00020000
+#define MPI3_DEBUG			0x01000000
+#define MPI3_DEBUG_SG			0x02000000
 
 
 /*
@@ -50,11 +43,103 @@
 #define ioc_info(ioc, fmt, ...) \
 	pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
 
+#define dprint(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_event_th(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_EVENT) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_event_bh(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_EVENT_WORK_TASK) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_init(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_INIT) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_exit(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_EXIT) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_tm(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_TM) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_reply(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_REPLY) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_reset(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_RESET) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_scsi_info(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_SCSI_INFO) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_scsi_err(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_SCSI_ERROR) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_scsi_command(ioc, SCMD, LOG_LEVEL) \
+	do { \
+		if (ioc->logging_level & LOG_LEVEL) \
+			scsi_print_command(SCMD); \
+	} while (0)
+
+
+#define dprint_ioctl_info(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_IOCTL_INFO) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
 
-#define dbgprint(IOC, FMT, ...) \
+#define dprint_ioctl_err(ioc, fmt, ...) \
 	do { \
-		if (IOC->logging_level & MPI3_DEBUG) \
-			pr_info("%s: " FMT, (IOC)->name, ##__VA_ARGS__); \
+		if (ioc->logging_level & MPI3_DEBUG_IOCTL_ERROR) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
 	} while (0)
 
 #endif /* MPT3SAS_DEBUG_H_INCLUDED */
+
+/**
+ * dprint_dump_req - print message frame contents
+ * @req: pointer to message frame
+ * @sz: number of dwords
+ */
+static inline void
+dprint_dump_req(void *req, int sz)
+{
+	int i;
+	__le32 *mfp = (__le32 *)req;
+
+	pr_info("request:\n\t");
+	for (i = 0; i < sz; i++) {
+		if (i && ((i % 8) == 0))
+			pr_info("\n\t");
+		pr_info("%08x ", le32_to_cpu(mfp[i]));
+	}
+	pr_info("\n");
+}
-- 
2.53.0



