Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FE051AFF6;
	Wed, 30 Sep 2026 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789903; cv=none; b=AnNQJBY/rN8fYFVKYI85hXta9UTU2FXPC/rrjxlUFBlE7Y2MdtTZKqjUjS6usMbsJrKzZg4U5x1YqOpcPJtOd73f8u/+v6ljG5NoOoT9Y0ymPsB4Pn2/bE9o/KzIfKDe0HVXnDOOTE2fxKajSDV8YIWVqJEI/lmeFetm5QUzyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789903; c=relaxed/simple;
	bh=P/MNR1F2OtPtAxAEd9uxmXqrxlh8fZzugBSGIB5WNRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsF5AoiQwsJ2F5elwGxTHnpXxooyVoMoVVLGLEkL4qcnoZdEP0jBfIRUCXETZp3KfDTFKyBwGpJ8VQVnDPLjRWiLWbp4OhO2Lvs2lsxpicCiniqgElwiKbHQxe+KpXrhxiu7grZ4Tsj5HQ1vJs2cYmeW+9PLzJUwai9aDbocVgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDKTuqqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDKTuqqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004BA1F000FF;
	Wed, 30 Sep 2026 17:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789902;
	bh=U79UX48lKgrVoPQxBHYMrVsgVtC+HPtV4m7yyc3J9eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDKTuqqj4KcUzOWkaN/JiLfUk9BMxfQbjuyd0MxcwZUFspNrkeCp32/XeGycXRRUb
	 S3T6BXfkbIpaPtslzybNn3zAwXrAxMjyGmtQkUOXwqGFlMByKk728Y3g8zEB3jdW6S
	 oJAvKnabTuhA84d/LKw4RNTo1EyObkx2YkU/fra0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 597/877] net/smc: Address spelling errors
Date: Wed, 30 Sep 2026 17:25:08 +0200
Message-ID: <20260930152427.536314929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit cd959bf7c3bbaf64a29750c5e36776078a18a8fe ]

Address spelling errors flagged by codespell.

This patch is intended to cover all files under drivers/smc

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://patch.msgid.link/20241009-smc-starspell-v1-1-b8b395bbaf82@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: db51a8658c11 ("net/smc: stop killed, freed and out_of_sync sharing a byte")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc.h      |    2 +-
 net/smc/smc_clc.h  |    2 +-
 net/smc/smc_core.c |    2 +-
 net/smc/smc_core.h |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -278,7 +278,7 @@ struct smc_connection {
 						 */
 	u64			peer_token;	/* SMC-D token of peer */
 	u8			killed : 1;	/* abnormal termination */
-	u8			freed : 1;	/* normal termiation */
+	u8			freed : 1;	/* normal termination */
 	u8			out_of_sync : 1; /* out of sync with peer */
 };
 
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -156,7 +156,7 @@ struct smc_clc_msg_proposal_prefix {	/*
 } __aligned(4);
 
 struct smc_clc_msg_smcd {	/* SMC-D GID information */
-	struct smc_clc_smcd_gid_chid ism; /* ISM native GID+CHID of requestor */
+	struct smc_clc_smcd_gid_chid ism; /* ISM native GID+CHID of requester */
 	__be16 v2_ext_offset;	/* SMC Version 2 Extension Offset */
 	u8 vendor_oui[3];	/* vendor organizationally unique identifier */
 	u8 vendor_exp_options[5];
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2326,7 +2326,7 @@ static struct smc_buf_desc *smcr_new_buf
 		}
 		if (lgr->buf_type == SMCR_PHYS_CONT_BUFS)
 			goto out;
-		fallthrough;	// try virtually continguous buf
+		fallthrough;	// try virtually contiguous buf
 	case SMCR_VIRT_CONT_BUFS:
 		buf_desc->order = get_order(bufsize);
 		buf_desc->cpu_addr = vzalloc(PAGE_SIZE << buf_desc->order);
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -30,7 +30,7 @@
 					 */
 #define SMC_CONN_PER_LGR_PREFER	255	/* Preferred connections per link group used for
 					 * SMC-R v2.1 and later negotiation, vendors or
-					 * distrubutions may modify it to a value between
+					 * distributions may modify it to a value between
 					 * 16-255 as needed.
 					 */
 
@@ -181,7 +181,7 @@ struct smc_link {
 					 */
 #define SMC_LINKS_PER_LGR_MAX_PREFER	2	/* Preferred max links per link group used for
 						 * SMC-R v2.1 and later negotiation, vendors or
-						 * distrubutions may modify it to a value between
+						 * distributions may modify it to a value between
 						 * 1-2 as needed.
 						 */
 


