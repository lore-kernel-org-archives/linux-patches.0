Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5434C29B208;
	Mon, 12 May 2025 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073089; cv=none; b=IFessNuXTzsfuCtTT3V6l21PK9Pjf57VAbXQ82nB9nNzU7l04XzIq3wlzfd34+TpSVJJC095yJzLGK9jYx1z2mNZWtTpX+Tr6ElczXPyY+SRoQm4jTkBDGl+MZdDOQBvNGcfpYkiF/fbWE59UqVyEiBZ/xKOspHCiTYROUEv/Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073089; c=relaxed/simple;
	bh=Xsn7VXA1+qAuRNr2RimgmYykg+ezMNctr/fEL9UZo4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmMf9mAPc8FO9ijPv8MvSQjdN3yP5CW6tqonTtQpCN2ctSwjlojwIguKIrC0X/9e19SA9UUka319QzMoGyJMGF6MBvVOZANnoCF/qhmhJpLUcRlTENwl1wmP547gN13XjCcLRR+SpZ2Vw7C8WiKBKzFF+6YZ5wsY2ao/UN+mDd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djQkr1ex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djQkr1ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9759C4CEEF;
	Mon, 12 May 2025 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073089;
	bh=Xsn7VXA1+qAuRNr2RimgmYykg+ezMNctr/fEL9UZo4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djQkr1exTMqk0+6AwbfGzz8PQmCD8/8CCwpoj3Q6OpftpVGs5EanW59Tcfh2svpNK
	 /bYkeCr+V9+g5ND50GNOuqe/C+/UUAkGw7dVB5ClZiNA3uYA9EWl8z5bN70eYfL1sS
	 0gTGpRrLt1ofV3/bUy8njmzBwY/CrWp/gUslGYJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/184] drm/xe/tests/mocs: Hold XE_FORCEWAKE_ALL for LNCF regs
Date: Mon, 12 May 2025 19:45:51 +0200
Message-ID: <20250512172047.923587570@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 51c0ee84e4dc339287b2d7335f2b54d747794c83 ]

LNCF registers report wrong values when XE_FORCEWAKE_GT
only is held. Holding XE_FORCEWAKE_ALL ensures correct
operations on LNCF regs.

V2(Himal):
 - Use xe_force_wake_ref_has_domain

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/1999
Fixes: a6a4ea6d7d37 ("drm/xe: Add mocs kunit")
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250428082357.1730068-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 70a2585e582058e94fe4381a337be42dec800337)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/tests/xe_mocs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/tests/xe_mocs.c b/drivers/gpu/drm/xe/tests/xe_mocs.c
index 434e7c7e60883..61a7d20ce42bf 100644
--- a/drivers/gpu/drm/xe/tests/xe_mocs.c
+++ b/drivers/gpu/drm/xe/tests/xe_mocs.c
@@ -46,8 +46,11 @@ static void read_l3cc_table(struct xe_gt *gt,
 	unsigned int fw_ref, i;
 	u32 reg_val;
 
-	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FW_GT);
-	KUNIT_ASSERT_NE_MSG(test, fw_ref, 0, "Forcewake Failed.\n");
+	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL);
+	if (!xe_force_wake_ref_has_domain(fw_ref, XE_FORCEWAKE_ALL)) {
+		xe_force_wake_put(gt_to_fw(gt), fw_ref);
+		KUNIT_ASSERT_TRUE_MSG(test, true, "Forcewake Failed.\n");
+	}
 
 	for (i = 0; i < info->num_mocs_regs; i++) {
 		if (!(i & 1)) {
-- 
2.39.5



