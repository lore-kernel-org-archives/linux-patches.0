Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00384362135;
	Tue,  6 Jan 2026 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721827; cv=none; b=O3tHcj4tPBhymnYpfCbLaKAt+T2GYCUzpPTUPmAAdGdrvB8ifcKw7H0nKBC1rhc1W+wz88rOMtfj985mlTDEjqGBN43ulKzppkVA+8LGpUgYjy4goI6k9D3mOeT1CifQASvKWixFzTkpw2ecBGBqSTbqL2mZ1LJNLhOIfOZbhQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721827; c=relaxed/simple;
	bh=tfjizciqjTAEvxTLmCaOOzjgmfsYHBU+rbAvFpJIj00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJPd2/EAjRKcRHBAl6u2LJ5GM6WazQt/tc7KN7yOhdKaFg04DjXsr2TlQrW4MsoDoDlLxc+4OfAg0QiN9QIQK4EzzgEF57GiOrdE0+nGT63sR7Fikz2jMlsIWIAqpcLAr9/01Ak6UN4YO8jADIXwR44f+pIxRk9xgfFn7vezkqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itIpT2KU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itIpT2KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CAFC116C6;
	Tue,  6 Jan 2026 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721826;
	bh=tfjizciqjTAEvxTLmCaOOzjgmfsYHBU+rbAvFpJIj00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itIpT2KUC+tssSbYoiTvjz/KR8UnJtVrlfnM6n6EnUTB1GAuKoZ5CQyA7rcp3pGa0
	 7ufxTIXbECFL8NenT2c3cvzBpGYLq70wyjCUXmLpi5dCQBnSkFfopQTT5UsqhZJaoD
	 iGcH8UvZarRSjsJAqGKnDuCKP50yfiwitW047nxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/312] drm/xe/guc: READ/WRITE_ONCE g2h_fence->done
Date: Tue,  6 Jan 2026 18:02:36 +0100
Message-ID: <20260106170550.804665535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cavitt <jonathan.cavitt@intel.com>

[ Upstream commit bed2a6bd20681aacfb063015c1edfab6f58a333e ]

Use READ_ONCE and WRITE_ONCE when operating on g2h_fence->done
to prevent the compiler from ignoring important modifications
to its value.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251222201957.63245-5-jonathan.cavitt@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit b5179dbd1c14743ae80f0aaa28eaaf35c361608f)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index b7afe8e983cb..3aac1a7aa2e7 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -106,7 +106,9 @@ static void g2h_fence_cancel(struct g2h_fence *g2h_fence)
 {
 	g2h_fence->cancel = true;
 	g2h_fence->fail = true;
-	g2h_fence->done = true;
+
+	/* WRITE_ONCE pairs with READ_ONCEs in guc_ct_send_recv. */
+	WRITE_ONCE(g2h_fence->done, true);
 }
 
 static bool g2h_fence_needs_alloc(struct g2h_fence *g2h_fence)
@@ -1128,10 +1130,13 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 		return ret;
 	}
 
-	ret = wait_event_timeout(ct->g2h_fence_wq, g2h_fence.done, HZ);
+	/* READ_ONCEs pairs with WRITE_ONCEs in parse_g2h_response
+	 * and g2h_fence_cancel.
+	 */
+	ret = wait_event_timeout(ct->g2h_fence_wq, READ_ONCE(g2h_fence.done), HZ);
 	if (!ret) {
 		LNL_FLUSH_WORK(&ct->g2h_worker);
-		if (g2h_fence.done) {
+		if (READ_ONCE(g2h_fence.done)) {
 			xe_gt_warn(gt, "G2H fence %u, action %04x, done\n",
 				   g2h_fence.seqno, action[0]);
 			ret = 1;
@@ -1375,7 +1380,8 @@ static int parse_g2h_response(struct xe_guc_ct *ct, u32 *msg, u32 len)
 
 	g2h_release_space(ct, GUC_CTB_HXG_MSG_MAX_LEN);
 
-	g2h_fence->done = true;
+	/* WRITE_ONCE pairs with READ_ONCEs in guc_ct_send_recv. */
+	WRITE_ONCE(g2h_fence->done, true);
 	smp_mb();
 
 	wake_up_all(&ct->g2h_fence_wq);
-- 
2.51.0



