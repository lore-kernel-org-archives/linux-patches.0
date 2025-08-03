Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D572205E3E;
	Sun,  3 Aug 2025 21:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256153; cv=none; b=s826KUYa0I5cKqFvzDWkP6TivTO4uybL+eNQWagr5b3LCKPQlOhNm+MnrCPfiucgVpiEiHxE40tdPRKW7abdm1/krtNWqp4jgDgBPMJB5NzJhtHrmbYSPcjj7U4hKWSHavKejbU6u+hA8/GJT6R+zQi8o9WD2vu4Qz4OwJuKvZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256153; c=relaxed/simple;
	bh=M/YmTmRT0cFGERkQFbGG/93lFKkmxKPNZ/Qnu/hynVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L4XsmXnoPX3mABt2tY9GSPNT1UL5NLVXzfYDYyG1RtjxShA5+kZ35FtY5Wn2fLV65d00Yclpyx8s5WYUGpvZq+NJYWojg+/0DqwOcc/jMMMxjF1TXMVyNQKNiT1iBBPM0P9pjBhExDJ1vU+yHAPw7zDpDuRIlsRLRUs9k8K349M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jULS1XdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jULS1XdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8178EC4CEEB;
	Sun,  3 Aug 2025 21:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256152;
	bh=M/YmTmRT0cFGERkQFbGG/93lFKkmxKPNZ/Qnu/hynVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jULS1XdHViowxlko5QMCoBr0iR5MpBwaR/X6ZqsxI/Ao+U9iVtq36RTwZeqkK7cvv
	 YBFHinzvhnrZZHdpBCWYSM4DR9UeTj0K2jvo+HhjIzeX5atRbDbo2LvFdnBNUqQV1R
	 /9FmJIaQhF+0EAzioFOgEEjsTTECZibl8zLwKrAJ6twgtkgKFzglO/t5N02Qhor1fe
	 I5YicYtrAt3JQiJBZ8BsbgfNeYyu+Ee/zNcKD74NExFw7OF2Knc9k9mefa7Zsx9I7W
	 0pR+OO0xobTD7X8i6vJDYlkANIM0E0VKDtN7fbRLWf3mm6eNQQzX7yLcmeD6YuzvPH
	 xJO45GccJQ71A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/15] ata: libata-sata: Disallow changing LPM state if not supported
Date: Sun,  3 Aug 2025 17:22:01 -0400
Message-Id: <20250803212206.3548990-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212206.3548990-1-sashal@kernel.org>
References: <20250803212206.3548990-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 413e800cadbf67550d76c77c230b2ecd96bce83a ]

Modify ata_scsi_lpm_store() to return an error if a user attempts to set
a link power management policy for a port that does not support LPM,
that is, ports flagged with ATA_FLAG_NO_LPM.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250701125321.69496-6-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the surrounding code context,
here's my determination:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a clear bug**: Without this check, users can attempt to
   change LPM policy on ports that don't support LPM (flagged with
   ATA_FLAG_NO_LPM), which could lead to undefined behavior or system
   issues. The code already prevents setting the policy but doesn't
   inform the user that the operation failed.

2. **User-visible issue**: The bug allows sysfs writes to succeed
   silently when they should fail with an error. This violates the
   principle of least surprise - users expect operations to either
   succeed or return an error, not silently fail.

3. **Small and contained fix**: The patch adds just 5 lines of code
   (lines 927-930) that perform a simple flag check and return
   -EOPNOTSUPP if the port doesn't support LPM. This is a minimal change
   with low risk of regression.

4. **Consistency with existing checks**: The function already has
   similar validation for device-level quirks (ATA_QUIRK_NOLPM at lines
   934-937). This patch adds the missing port-level validation, making
   the code more consistent and complete.

5. **Related to recent fixes**: Looking at recent commits (65b2c92f69d3,
   4edf1505b76d), there's been work to properly handle ports that don't
   support LPM. This patch completes that work by ensuring the sysfs
   interface properly rejects invalid operations.

6. **Prevents potential hardware issues**: Attempting to set LPM
   policies on hardware that doesn't support them could potentially
   cause hardware malfunctions or unexpected behavior. This fix prevents
   such attempts at the sysfs interface level.

The fix follows stable kernel rules: it's a clear bug fix, minimal in
scope, doesn't introduce new features, and addresses a real user-facing
issue where invalid operations appear to succeed when they should fail
with an appropriate error code.

 drivers/ata/libata-sata.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 04bdd53abf20..7cacb2bfc360 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -815,6 +815,11 @@ static ssize_t ata_scsi_lpm_store(struct device *device,
 
 	spin_lock_irqsave(ap->lock, flags);
 
+	if (ap->flags & ATA_FLAG_NO_LPM) {
+		count = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, &ap->link, ENABLED) {
 			if (dev->horkage & ATA_HORKAGE_NOLPM) {
-- 
2.39.5

