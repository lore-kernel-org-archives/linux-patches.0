Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D74520AF8E;
	Wed, 19 Mar 2025 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394998; cv=none; b=CllSJul5eHAy5gNY7thdAhNTfDrLUxX/xyMXsu3FVgYFyp6bH35m3h2zersOETJefq4oTvn6UxgNqXfJBurYGdioxSVvBHrCJooC/5vmRrzJ6XhjYuAg6wVfm78YOKR7+PyvWYCdqdoj8QA//Nvco6CLbncs/zAkQRVKEbS2wh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394998; c=relaxed/simple;
	bh=D+ly6aE25l6GHtaHRuRVa+OVvvGEExQJxe4El1AGkdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bijcBu1p7ayW8G17jZMMMdJt67qLaHMA3Exp3zFQ7Zq2dOpEracbeNhJNpFWATfT0yP4xaBL4WCr9wtmwjcDqceKeWKAvxWCYVGp10w88/dMzQYRoA8YKW6Lv56t14mrRqYLsvcesOSXepXUNzUGg0Vc6bHDg9avOo5Dxu5hwBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/sg7PHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/sg7PHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A6CC4CEE4;
	Wed, 19 Mar 2025 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394998;
	bh=D+ly6aE25l6GHtaHRuRVa+OVvvGEExQJxe4El1AGkdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/sg7PHwJChkSNkhNpMj4fPf4EBdzsARLPQgrpINbnr80yW0EEbiiMd9XwvyzyP6r
	 o+WRI0ywCZKZQ8voaxd2Jz3tj1xPpi14TkYfwZBDPM0kJ3qR5QdaQ+GfF/7ORW12h0
	 m4XeeBni6PaFr/FAhsdOqXjVUW0pdrdsoOkpheqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	kernel test robot <lkp@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.13 237/241] drm/xe/guc: Fix size_t print format
Date: Wed, 19 Mar 2025 07:31:47 -0700
Message-ID: <20250319143033.602371289@linuxfoundation.org>
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

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit 213e24250feed3bcf58d7594298df2d7e78a88ab upstream.

Use %zx format to print size_t to remove the following warning when
building for i386:

>> drivers/gpu/drm/xe/xe_guc_ct.c:1727:43: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    1727 |                         drm_printf(p, "[CTB].length: 0x%lx\n", snapshot->ctb_size);
         |                                                        ~~~     ^~~~~~~~~~~~~~~~~~
         |                                                        %zx

Cc: José Roberto de Souza <jose.souza@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501281627.H6nj184e-lkp@intel.com/
Fixes: 643f209ba3fd ("drm/xe: Make GUC binaries dump consistent with other binaries in devcoredump")
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250128154242.3371687-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 7748289df510638ba61fed86b59ce7d2fb4a194c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c  |    2 +-
 drivers/gpu/drm/xe/xe_guc_log.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -1700,7 +1700,7 @@ void xe_guc_ct_snapshot_print(struct xe_
 			   snapshot->g2h_outstanding);
 
 		if (snapshot->ctb) {
-			drm_printf(p, "[CTB].length: 0x%lx\n", snapshot->ctb_size);
+			drm_printf(p, "[CTB].length: 0x%zx\n", snapshot->ctb_size);
 			xe_print_blob_ascii85(p, "[CTB].data", '\n',
 					      snapshot->ctb, 0, snapshot->ctb_size);
 		}
--- a/drivers/gpu/drm/xe/xe_guc_log.c
+++ b/drivers/gpu/drm/xe/xe_guc_log.c
@@ -208,7 +208,7 @@ void xe_guc_log_snapshot_print(struct xe
 	drm_printf(p, "GuC timestamp: 0x%08llX [%llu]\n", snapshot->stamp, snapshot->stamp);
 	drm_printf(p, "Log level: %u\n", snapshot->level);
 
-	drm_printf(p, "[LOG].length: 0x%lx\n", snapshot->size);
+	drm_printf(p, "[LOG].length: 0x%zx\n", snapshot->size);
 	remain = snapshot->size;
 	for (i = 0; i < snapshot->num_chunks; i++) {
 		size_t size = min(GUC_LOG_CHUNK_SIZE, remain);


