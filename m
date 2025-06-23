Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465382192EC;
	Mon, 23 Jun 2025 22:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717453; cv=none; b=fJxYCUCEGJV8gGELTwu/kDSc40zZumfgqXAfsdc8kGvl4FbbzvaGEEy+4l/jLBpyFfqia/SbWxlZP5REBwUgVEHCvoD7igYppSVSDrP96vUaMYkFfckAZ110745bHsNXMm0eQxYvzH4G47EYNWBF+eouyzdT20D4hQx1qOkokDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717453; c=relaxed/simple;
	bh=CC7jNw0J767dTgjthMI6sPU0jSsHD0sVESN13eDLCTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8sG7yerbXvvy/kzk0atVTfUk6t8McFjGiH9zqvV31fWDzYDKXgBrlgME2fOZ8lN3TSRBJtBPD7AGr9ICdeghda0hj999mdZguKUJdmBLoLwtNfUX1+cQoWQgD8+x2Xtwopjw0bDHFNpwudVMy98au5/Nz03oAsK0o+c4zY5S+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+fzYFAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+fzYFAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E66C4CEEA;
	Mon, 23 Jun 2025 22:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717453;
	bh=CC7jNw0J767dTgjthMI6sPU0jSsHD0sVESN13eDLCTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+fzYFAx5nYv9DtaQvx9GV4PGX5M9cwD6vcS7j35KTVM6i8Apxw1oO/OFKyqPNOwo
	 lhP2Q0F02H5TCzBfbbQbAn68eIFCNfBn6d1/aeUFSp5TuOjymCgHjGwulf/fXM09zr
	 /VbdFesqht6GpPzb85vJtxcJGHEMdWpBAVKoaWMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 390/414] drm/xe/bmg: Update Wa_16023588340
Date: Mon, 23 Jun 2025 15:08:47 +0200
Message-ID: <20250623130651.694804352@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 16c1241b08751a67cd7a0221ea9f82b0b02806f4 ]

This allows for additional L2 caching modes.

Fixes: 01570b446939 ("drm/xe/bmg: implement Wa_16023588340")
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://lore.kernel.org/r/20250612-wa-14022085890-v4-2-94ba5dcc1e30@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 6ab42fa03d4c88a0ddf5e56e62794853b198e7bf)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 335548e3b6b9c..231ed53cf907c 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -114,7 +114,7 @@ static void xe_gt_enable_host_l2_vram(struct xe_gt *gt)
 		xe_gt_mcr_multicast_write(gt, XE2_GAMREQSTRM_CTRL, reg);
 	}
 
-	xe_gt_mcr_multicast_write(gt, XEHPC_L3CLOS_MASK(3), 0x3);
+	xe_gt_mcr_multicast_write(gt, XEHPC_L3CLOS_MASK(3), 0xF);
 	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 }
 
-- 
2.39.5



