Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FBA1C1F0F;
	Wed, 19 Mar 2025 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394918; cv=none; b=M+LUn0GrOTFINWYCqIPOmCYRmQaWqzkIuEQINZcWcMnzs8/RkpGUPL5RXX3weRNlLdH4APKI+7xlX7Bwui0zmZarBZEexe7fCNIEJupT0GjgBta60ehatqoHbRJBF1+7SIRPizbCQaDBi9l/GeVPbhb9YMB4YnZt1Tt0cA34yBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394918; c=relaxed/simple;
	bh=dQ53vVGjPVNfA/IvtDfZjyyIPdmZYdCw68SB3f9KhGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ielUZL24jiih2/EgpbA/drZQ0VZo3Ek2QUEcwso/3RohSLDFfYfBdDnZb20rkub4IVQRxhbVcAS+DUAHfFXe4akz3lmhZr7XmsjkD33v7QOkUp30OR+UOln3gqCR+b3e57ucr24lnAnBhe2UjLGiHMGqmA+Iprn2RILzi0ybKaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIi+PB6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIi+PB6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A02C4CEE4;
	Wed, 19 Mar 2025 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394918;
	bh=dQ53vVGjPVNfA/IvtDfZjyyIPdmZYdCw68SB3f9KhGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIi+PB6iSXcqySK+PU4ZyU/tjb7sh/6j1wqnWU17Bata0Q5WuPr6XYvCWs+5aB99f
	 vH+LvkC3+p+4cnF4IGl4BswAzbt2fWAVhtgXLVYwxtDDepCpKu5wk8IiLC7/6+VV84
	 ssRc2GbdoGQtExbi/de2lB1hBlU2fVGMePDjmL+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 128/241] drm/xe: Make GUC binaries dump consistent with other binaries in devcoredump
Date: Wed, 19 Mar 2025 07:29:58 -0700
Message-ID: <20250319143030.891753419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit 643f209ba3fdd4099416aaf9efa8266f7366d6fb ]

All other(hwsp, hwctx and vmas) binaries follow this format:
[name].length: 0x1000
[name].data: xxxxxxx
[name].error: errno

The error one is just in case by some reason it was not able to
capture the binary.

So this GuC binaries should follow the same patern.

v2:
- renamed GUC binary to LOG

Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250123202307.95103-3-jose.souza@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit cb1f868ca13756c0c18ba54d1591332476760d07)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c  | 6 ++++--
 drivers/gpu/drm/xe/xe_guc_log.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 6eabf7a9d3b07..b527f34b979be 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -1699,9 +1699,11 @@ void xe_guc_ct_snapshot_print(struct xe_guc_ct_snapshot *snapshot,
 		drm_printf(p, "\tg2h outstanding: %d\n",
 			   snapshot->g2h_outstanding);
 
-		if (snapshot->ctb)
-			xe_print_blob_ascii85(p, "CTB data", '\n',
+		if (snapshot->ctb) {
+			drm_printf(p, "[CTB].length: 0x%lx\n", snapshot->ctb_size);
+			xe_print_blob_ascii85(p, "[CTB].data", '\n',
 					      snapshot->ctb, 0, snapshot->ctb_size);
+		}
 	} else {
 		drm_puts(p, "CT disabled\n");
 	}
diff --git a/drivers/gpu/drm/xe/xe_guc_log.c b/drivers/gpu/drm/xe/xe_guc_log.c
index 2baa4d95571fb..2457572ed86ad 100644
--- a/drivers/gpu/drm/xe/xe_guc_log.c
+++ b/drivers/gpu/drm/xe/xe_guc_log.c
@@ -208,10 +208,11 @@ void xe_guc_log_snapshot_print(struct xe_guc_log_snapshot *snapshot, struct drm_
 	drm_printf(p, "GuC timestamp: 0x%08llX [%llu]\n", snapshot->stamp, snapshot->stamp);
 	drm_printf(p, "Log level: %u\n", snapshot->level);
 
+	drm_printf(p, "[LOG].length: 0x%lx\n", snapshot->size);
 	remain = snapshot->size;
 	for (i = 0; i < snapshot->num_chunks; i++) {
 		size_t size = min(GUC_LOG_CHUNK_SIZE, remain);
-		const char *prefix = i ? NULL : "Log data";
+		const char *prefix = i ? NULL : "[LOG].data";
 		char suffix = i == snapshot->num_chunks - 1 ? '\n' : 0;
 
 		xe_print_blob_ascii85(p, prefix, suffix, snapshot->copy[i], 0, size);
-- 
2.39.5



