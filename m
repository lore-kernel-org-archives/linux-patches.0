Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9593A1E92;
	Sat, 17 Oct 2026 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259587; cv=none; b=SkN/rFxL85lcoUpbYJCedwJUsXT6fR98JXK890JdMEQw5EESr3lxqVPN++Yie0SRBUXdY/U61XsQ4YSVOJmmMJntSS6a4Cimux9oSD/S7rqzu8Ud6pWDjDqPgwoX3TSPmYNZfdYQGoTsgcCn1fOvWClfKDCdVecTFhlkGMf/kjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259587; c=relaxed/simple;
	bh=NhKGQ7AlnjQT/F3kaATJjf+T96PaiGw5w8sGWRsR21A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIkjuK21iYC34V1bVxBOIO5D2QNjLuU/B2JT3LMJoW0rVdEZwWT2V2z4IaZAWL9cR0m6sCbdyEQ76cDnpicwtAilwpViL519WZn5Br1s85DcTlYelZYxkL/LQrFKpXAmmzbVGL+ixa2R02xeI2KjFMmfz3rtsNEdnBKTV5Blfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAzQFrLa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAzQFrLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7D81F000C4;
	Sat, 17 Oct 2026 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259586;
	bh=0t66g7Npj/KiyTqn4BaMQoAdJiJsOrzIMPfsuQJifPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAzQFrLaDjh51sPAA9h2tG8ezSTbnRGlXNOTpF4qfSNdkZ2aUNCax8EjWYxaO1o1m
	 4daOCkf7fQFdY1CPZHyWTuy2yh026y5ZI6i1ahNDjL0WGSpsz2BXIUwYEm51TGhtRM
	 MC0aBvZkkUCwtK5B8MJoF+UJZ7KWvLoa+I33Zu2Q=
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
Subject: [PATCH 6.6 1262/1674] net/smc: Address spelling errors
Date: Sat, 17 Oct 2026 17:58:54 +0200
Message-ID: <20261017160503.535748307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
---
 net/smc/smc.h      | 2 +-
 net/smc/smc_clc.h  | 2 +-
 net/smc/smc_core.c | 2 +-
 net/smc/smc_core.h | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index 49bf6971610df..366cd1a0b950e 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -239,7 +239,7 @@ struct smc_connection {
 						 */
 	u64			peer_token;	/* SMC-D token of peer */
 	u8			killed : 1;	/* abnormal termination */
-	u8			freed : 1;	/* normal termiation */
+	u8			freed : 1;	/* normal termination */
 	u8			out_of_sync : 1; /* out of sync with peer */
 };
 
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 6e24d44de4a7b..fc31eeb586b80 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -150,7 +150,7 @@ struct smc_clc_msg_proposal_prefix {	/* prefix part of clc proposal message*/
 } __aligned(4);
 
 struct smc_clc_msg_smcd {	/* SMC-D GID information */
-	struct smc_clc_smcd_gid_chid ism; /* ISM native GID+CHID of requestor */
+	struct smc_clc_smcd_gid_chid ism; /* ISM native GID+CHID of requester */
 	__be16 v2_ext_offset;	/* SMC Version 2 Extension Offset */
 	u8 vendor_oui[3];	/* vendor organizationally unique identifier */
 	u8 vendor_exp_options[5];
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 3694a5a5918ab..5a39031611b68 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2275,7 +2275,7 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 		}
 		if (lgr->buf_type == SMCR_PHYS_CONT_BUFS)
 			goto out;
-		fallthrough;	// try virtually continguous buf
+		fallthrough;	// try virtually contiguous buf
 	case SMCR_VIRT_CONT_BUFS:
 		buf_desc->order = get_order(bufsize);
 		buf_desc->cpu_addr = vzalloc(PAGE_SIZE << buf_desc->order);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index de001f4b46c7d..3694949b243db 100644
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
 
-- 
2.53.0



