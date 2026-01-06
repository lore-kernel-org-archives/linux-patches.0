Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE233612D1;
	Tue,  6 Jan 2026 17:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721793; cv=none; b=czDT6Nbp7iOkuSduyiY6lzh1xUxzf0QRYLN9BoevqHwc10dTnqKcwg8zJAY9Dg+ikWdFu9j/BimCsUpCvUG5xqbQtj4DAQ4M6AAsyJVY9JxvZGq0KDORK091WmzsFuaDE7+7M0FBe1iLyLefHc72uoFSBD1v90mCiBybSg3/FFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721793; c=relaxed/simple;
	bh=1ddhespBC1FIh718LYpECfFzvxtIA4PGXdLaX8eBdIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrfFbmD9pVlX1bf3AyojCBzpOUsdrNLUBX3KFADFoHaquCxXAk62RhwDxF5dSxS401xLrxbN4WzblAlvlKypFs0oXnlBk7K13luAsJkYJ+t/ClyrPOeNaFEJVo2lG5KuQ/1Yzw9p1r2c8lCMlNt0f4czIA4rwgOfiAfR1J6K4z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycN/eHid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycN/eHid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CFFC116C6;
	Tue,  6 Jan 2026 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721792;
	bh=1ddhespBC1FIh718LYpECfFzvxtIA4PGXdLaX8eBdIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycN/eHid9i8epYkmFDTAhFMEQApfrb1WFc2x72rBXus49gILwWfBSYwxdcY+Dt1df
	 6e+JQgBD85EpWCpLGqo6eKdpf9F3e+maIRIHBBaXEGSQd/nBkMPLx22KGwUL10c8mv
	 jdheIzQXmph/voUiSAOakJKf32UGaytazVwoYaOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/312] drm/gem-shmem: Fix the MODULE_LICENSE() string
Date: Tue,  6 Jan 2026 18:02:27 +0100
Message-ID: <20260106170550.487828033@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 3fbd97618f49e07e05aad96510e5f2ed22d68809 ]

Replace the bogus "GPL v2" with "GPL" as MODULE_LICNSE() string. The
value does not declare the module's exact license, but only lets the
module loader test whether the module is Free Software or not.

See commit bf7fbeeae6db ("module: Cure the MODULE_LICENSE "GPL" vs.
"GPL v2" bogosity") in the details of the issue. The fix is to use
"GPL" for all modules under any variant of the GPL.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Fixes: 4b2b5e142ff4 ("drm: Move GEM memory managers into modules")
Link: https://patch.msgid.link/20251209140141.94407-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 5d1349c34afd..365b5737ca2c 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -863,4 +863,4 @@ EXPORT_SYMBOL_GPL(drm_gem_shmem_prime_import_no_map);
 
 MODULE_DESCRIPTION("DRM SHMEM memory-management helpers");
 MODULE_IMPORT_NS("DMA_BUF");
-MODULE_LICENSE("GPL v2");
+MODULE_LICENSE("GPL");
-- 
2.51.0



