Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02AB2D5426;
	Tue, 15 Jul 2025 13:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585678; cv=none; b=dn0m5ltGuVS2z7VmE6Jbh7sxo8cGR3Ji+tRnLh5Xh4hjHKEbgUDTGdJQHKL0xRziKYAA2sQHvIFJSpteFp1Ig8eij0BU1UfuXwAE2DqSZEACBBcYf9MLY+bG7/W6EBsL6ZwTk0wqMIhHFSYBnkFgucuVlYP9NwLjp0EBrgcoQqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585678; c=relaxed/simple;
	bh=nOYq02Ef2PDWXgbzr4v45ARDJjoyuQSlu9+GZOncx4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iASv6J5DrrXztnJV/Q+u2mJ2NswOkRksgloTnpAIlySwnFe/OLr7bDocT5v3odbNSqZ8Bu/0llWHRboqmmq3WBfvGpupXJZKdtcbu4bMVzVAyX72wS0ZU7amlTaTPXCxQCVUUREqapIYJ/0CT8r31OAqbmogJYC+5/YKqEyALlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZUubKrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZUubKrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7583DC4CEE3;
	Tue, 15 Jul 2025 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585677;
	bh=nOYq02Ef2PDWXgbzr4v45ARDJjoyuQSlu9+GZOncx4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZUubKrcvr8huNGESKJdreWU+5OWcPube7715nP84EnA1pfRIJyHFzE1dbRj3LrkK
	 XFp+TBgLPC81Uc5stBe5o5HNVMSJ10R2eVelN8EeU7/f3Luk/ogZguj3FAS7YJQJfg
	 Y6NGJbl0uLfwrvjO+wYkSG+Dsla/Rl1GxY373Bi8=
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
Subject: [PATCH 6.12 131/163] drm/xe/pm: Correct comment of xe_pm_set_vram_threshold()
Date: Tue, 15 Jul 2025 15:13:19 +0200
Message-ID: <20250715130814.095128863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 06f50aa313267..46c73ff10c747 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -682,11 +682,13 @@ void xe_pm_assert_unbounded_bridge(struct xe_device *xe)
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



