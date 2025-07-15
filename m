Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42B2EBBB7;
	Tue, 15 Jul 2025 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587150; cv=none; b=sDepC0EBeDMvEyWwIJ4iUidHEDL4vxNQGbMfi/OsrTYdj7DJz/NLQgF2BFPRO0DVM0n8RLrLab2EYpDQZCJ6r6EIFKgbqa5rNOiIeSVg2MWmgmM9llFHEDWdf3vE/iAidEWa1VsM+6y99ibXYSljxEBViKTfX6VLP3Q4EOSJog0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587150; c=relaxed/simple;
	bh=rOreEbJ29TbA0b0x/9aVi6NrOBuzNihHzU/5pYL8PTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2uTG3TAGgeIHDU6iwRt8YYSPRthdNHkpR327g85O0zWf3jTqrAgTs794P68ys/n3GthuQtBwBeCsIAMRQROqYf1sL9QBwGtJ9J34qVnUcM+fumCG6uLV+9X2+Ehklw9phBwBmL8pngH3Xi0zZpIv4r7XkQStZfs5lIHs1EH+lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+UszwiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+UszwiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25055C4CEF1;
	Tue, 15 Jul 2025 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587150;
	bh=rOreEbJ29TbA0b0x/9aVi6NrOBuzNihHzU/5pYL8PTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+UszwiXBwTLyOkUfNvcgOrGG8d1ly75yROv/+zajOTRCGjbOsp/akxLaJhK8oplf
	 KCg3z5yRcHLy3CC7mJ90iz7+7M3ePHJctnlmoEHZfIvMV2HQTSv+nQBLD1PAwCDM2q
	 G16Fzellc47zc/b7OmBJqxEEaouK5AK2g/jCRK0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 158/192] drm/xe/pm: Correct comment of xe_pm_set_vram_threshold()
Date: Tue, 15 Jul 2025 15:14:13 +0200
Message-ID: <20250715130821.258388634@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 0539c5eaf81f3f844213bf6b3137a53e5b04b083 ]

The parameter threshold is with size in MiB, not in bits.
Correct it to avoid any confusion.

v2: s/mb/MiB, s/vram/VRAM, fix return section. (Michal)

Fixes: 30c399529f4c ("drm/xe: Document Xe PM component")
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://lore.kernel.org/r/20250708021450.3602087-2-shuicheng.lin@intel.com
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 0efec0500117947f924e5ac83be40f96378af85a)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index c499c86382858..20f8522bb04a5 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -706,11 +706,13 @@ void xe_pm_assert_unbounded_bridge(struct xe_device *xe)
 }
 
 /**
- * xe_pm_set_vram_threshold - Set a vram threshold for allowing/blocking D3Cold
+ * xe_pm_set_vram_threshold - Set a VRAM threshold for allowing/blocking D3Cold
  * @xe: xe device instance
- * @threshold: VRAM size in bites for the D3cold threshold
+ * @threshold: VRAM size in MiB for the D3cold threshold
  *
- * Returns 0 for success, negative error code otherwise.
+ * Return:
+ * * 0		- success
+ * * -EINVAL	- invalid argument
  */
 int xe_pm_set_vram_threshold(struct xe_device *xe, u32 threshold)
 {
-- 
2.39.5



