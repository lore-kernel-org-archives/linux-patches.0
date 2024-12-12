Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF8A215774;
	Thu, 12 Dec 2024 15:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017618; cv=none; b=ZsDfGONhqKCVhcOOSuSPtX+B3DshSlnsymixVTqvDSYn8AyZaGSqSWyJqXXmuYc+KdWTdnnWqBpQ16Kz0IqZ3nJo28ZJ1WqbgFUe0jb2xMtjXB0yi4GBuONQUqHcYoUprXNYsbOBoUy5bZx7CfNF7rdFPgz69cjuk1F15LNzVuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017618; c=relaxed/simple;
	bh=CgcLavHJlRrQqq4fxqtk9AaBHyCCzhREU9yPltuRlH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BG+DoHvIhpbprOp5h7c/kJZOea+1I/taOYFu0otPL+lA+wQJKTbeD2/Whsf/mnsBj2RiwQGtvbMUz3PHpyH3d74iOF8J+02+9pO1cJuWyg6Uqq5KOmo/cN0HWlbiWFL+eo0QrPJDBa5nUmkApU+y4ZKlP2lhdveeUaaUXTc2Tns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh2fRy3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh2fRy3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B417C4CED0;
	Thu, 12 Dec 2024 15:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017618;
	bh=CgcLavHJlRrQqq4fxqtk9AaBHyCCzhREU9yPltuRlH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh2fRy3EuuJcK6IQJScYkDysXy20V+X8bbVWnDcLLwQIEf5QBrkof18bA/yP+ic/l
	 sgnu0IcXLYEUPgIWeSyCzEl0tGbH/6eJUYHySPkp9s23+at3UCfewPYHDRqPw7W9uD
	 NEzqrZRtj9O1mC1h+Luvz81Z9UMS0Ns5Q22Z3Vp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/356] net/smc: rename some fce to fce_v2x for clarity
Date: Thu, 12 Dec 2024 15:55:53 +0100
Message-ID: <20241212144245.972492022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit ac053a169c71ceb0f25f784fce9ea720455097b4 ]

Rename some functions or variables with 'fce' in their name but used in
SMCv2.1 as 'fce_v2x' for clarity.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0541db8ee32c ("net/smc: initialize close_work early to avoid warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 1489a8421d786..b34aff73ada4c 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -428,15 +428,16 @@ smc_clc_msg_decl_valid(struct smc_clc_msg_decline *dclc)
 	return true;
 }
 
-static int smc_clc_fill_fce(struct smc_clc_first_contact_ext_v2x *fce,
-			    struct smc_init_info *ini)
+static int smc_clc_fill_fce_v2x(struct smc_clc_first_contact_ext_v2x *fce_v2x,
+				struct smc_init_info *ini)
 {
-	int ret = sizeof(*fce);
+	int ret = sizeof(*fce_v2x);
 
-	memset(fce, 0, sizeof(*fce));
-	fce->fce_v2_base.os_type = SMC_CLC_OS_LINUX;
-	fce->fce_v2_base.release = ini->release_nr;
-	memcpy(fce->fce_v2_base.hostname, smc_hostname, sizeof(smc_hostname));
+	memset(fce_v2x, 0, sizeof(*fce_v2x));
+	fce_v2x->fce_v2_base.os_type = SMC_CLC_OS_LINUX;
+	fce_v2x->fce_v2_base.release = ini->release_nr;
+	memcpy(fce_v2x->fce_v2_base.hostname,
+	       smc_hostname, sizeof(smc_hostname));
 	if (ini->is_smcd && ini->release_nr < SMC_RELEASE_1) {
 		ret = sizeof(struct smc_clc_first_contact_ext);
 		goto out;
@@ -444,8 +445,8 @@ static int smc_clc_fill_fce(struct smc_clc_first_contact_ext_v2x *fce,
 
 	if (ini->release_nr >= SMC_RELEASE_1) {
 		if (!ini->is_smcd) {
-			fce->max_conns = ini->max_conns;
-			fce->max_links = ini->max_links;
+			fce_v2x->max_conns = ini->max_conns;
+			fce_v2x->max_links = ini->max_links;
 		}
 	}
 
@@ -1012,8 +1013,8 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 				       int first_contact, u8 version,
 				       u8 *eid, struct smc_init_info *ini)
 {
+	struct smc_clc_first_contact_ext_v2x fce_v2x;
 	struct smc_connection *conn = &smc->conn;
-	struct smc_clc_first_contact_ext_v2x fce;
 	struct smcd_dev *smcd = conn->lgr->smcd;
 	struct smc_clc_msg_accept_confirm *clc;
 	struct smc_clc_fce_gid_ext gle;
@@ -1045,7 +1046,7 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 				memcpy(clc_v2->d1.eid, eid, SMC_MAX_EID_LEN);
 			len = SMCD_CLC_ACCEPT_CONFIRM_LEN_V2;
 			if (first_contact) {
-				fce_len = smc_clc_fill_fce(&fce, ini);
+				fce_len = smc_clc_fill_fce_v2x(&fce_v2x, ini);
 				len += fce_len;
 			}
 			clc_v2->hdr.length = htons(len);
@@ -1091,9 +1092,10 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 				memcpy(clc_v2->r1.eid, eid, SMC_MAX_EID_LEN);
 			len = SMCR_CLC_ACCEPT_CONFIRM_LEN_V2;
 			if (first_contact) {
-				fce_len = smc_clc_fill_fce(&fce, ini);
+				fce_len = smc_clc_fill_fce_v2x(&fce_v2x, ini);
 				len += fce_len;
-				fce.fce_v2_base.v2_direct = !link->lgr->uses_gateway;
+				fce_v2x.fce_v2_base.v2_direct =
+					!link->lgr->uses_gateway;
 				if (clc->hdr.type == SMC_CLC_CONFIRM) {
 					memset(&gle, 0, sizeof(gle));
 					gle.gid_cnt = ini->smcrv2.gidlist.len;
@@ -1120,7 +1122,7 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 						SMCR_CLC_ACCEPT_CONFIRM_LEN) -
 				   sizeof(trl);
 	if (version > SMC_V1 && first_contact) {
-		vec[i].iov_base = &fce;
+		vec[i].iov_base = &fce_v2x;
 		vec[i++].iov_len = fce_len;
 		if (!conn->lgr->is_smcd) {
 			if (clc->hdr.type == SMC_CLC_CONFIRM) {
-- 
2.43.0



