Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CCD3264E7;
	Sat, 17 Oct 2026 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259293; cv=none; b=mnc+x9HyqKLba4ggECX7+fW2GfK4rLXLlTWU8/b5B943sN3KNnR7eAnOJ+Ns8OFbTioLD7oLs6JGpsqhF6o5THQ4J4nve264OqwyyjoM0HaRRKpZBbaa85pEpgUh3WsvAf59x8lEaB4UoIJxYXN+Acc81m3IascfqYg6Lqu1kpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259293; c=relaxed/simple;
	bh=0sOfrSa6E16FCRkimzy8vdnUiqKBuiYCMUteJa8B4lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFeofQBUuLvnRHWQxDNi892s8y90+gQMIZ4lImE1gQBV4AmLAqDqvOgeA0aWF3eq1qNf1nlWNhLW9Dq3YCHwBAsK7MasET7qznqUFJRzgM78c1L608Cw7hjtczv/grJDcQ5pAeOv9zY0dLwrA/JydKH/JteZ/tB7RftRnKDNmG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGQq7Ky4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGQq7Ky4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE01B1F000C4;
	Sat, 17 Oct 2026 17:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259292;
	bh=0LHXlw12TFOMwvHzhHVa1Fql28pPhMlV7/bmE8D2l9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGQq7Ky4NtDGoc91SudxwqR3LlotgEG6tGtxxPGgJ4fREtYJ4YAwIJhtglF/lOSkc
	 JpR8+nF29JOBEuxolll5ER62PQuZZ1J237tx//it2D4+mat0nLzueQqqTeguj43gKS
	 9JOCeu6Sj9H0yAt1ykLkZmAnVO9ldBRTOD9cnxh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1165/1674] RDMA/siw: Introduce siw_destroy_cep_sock
Date: Sat, 17 Oct 2026 17:57:17 +0200
Message-ID: <20261017160501.048937758@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit d9a5b48681315a5881cea24bc8f384da02828e88 ]

Add one helper to simplify code a bit.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310091735.oG7bTvLR-lkp@intel.com/`
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20231113115726.12762-17-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: ea4f6f6c5357 ("RDMA/siw: Fix endpoint/socket association handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 565fe7bd5a2d5..fde971c80d572 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -373,6 +373,15 @@ static void siw_free_cm_id(struct siw_cep *cep)
 	cep->cm_id = NULL;
 }
 
+static void siw_destroy_cep_sock(struct siw_cep *cep)
+{
+	if (cep->sock) {
+		siw_socket_disassoc(cep->sock);
+		sock_release(cep->sock);
+		cep->sock = NULL;
+	}
+}
+
 /*
  * siw_qp_cm_drop()
  *
@@ -430,14 +439,7 @@ void siw_qp_cm_drop(struct siw_qp *qp, int schedule)
 		}
 		cep->state = SIW_EPSTATE_CLOSED;
 
-		if (cep->sock) {
-			siw_socket_disassoc(cep->sock);
-			/*
-			 * Immediately close socket
-			 */
-			sock_release(cep->sock);
-			cep->sock = NULL;
-		}
+		siw_destroy_cep_sock(cep);
 		if (cep->qp) {
 			cep->qp = NULL;
 			siw_qp_put(qp);
@@ -1703,9 +1705,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 error_unlock:
 	up_write(&qp->state_lock);
 error:
-	siw_socket_disassoc(cep->sock);
-	sock_release(cep->sock);
-	cep->sock = NULL;
+	siw_destroy_cep_sock(cep);
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
@@ -1750,9 +1750,7 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 		cep->mpa.hdr.params.bits |= MPA_RR_FLAG_REJECT; /* reject */
 		siw_send_mpareqrep(cep, pdata, pd_len);
 	}
-	siw_socket_disassoc(cep->sock);
-	sock_release(cep->sock);
-	cep->sock = NULL;
+	siw_destroy_cep_sock(cep);
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
-- 
2.53.0



