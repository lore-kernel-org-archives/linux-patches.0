Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0B87E11E;
	Mon,  8 Apr 2024 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581922; cv=none; b=gGo+IHBCfqwUJsdWWawbGYJKkw3tMe0osvHxQhceKhhwjWP+xg6R529zLnqpWV9/zd1oGz7cJWzjnYhlQggb6MdsTF26akRReAurXRAdLf0BUPQNHgjF5fD7uOlXEA54WK9oXQUdWs3afvEUwrFfjPIiudLCnPspsEUZfVa2GgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581922; c=relaxed/simple;
	bh=aFcEpAqDME5lFk1/O09E+oOpscHmyy/4httspKCHPEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7QY9W4fErybUwESQin0Bx/g+F8Quk+/zi1zHwHqUZqJpRBqG7Ya+kmDSIIHU51su8o3R7c3zmCZUWYBhqt6a3tST0bQENcShl1CZBbpo8AuAxLGjJNBiQpVlXAJ78RjxdJfunvknVGOxrr/p9pVR4TGkr7su5ayviGI+0vPfYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLy0Tfhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLy0Tfhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C00C433F1;
	Mon,  8 Apr 2024 13:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581922;
	bh=aFcEpAqDME5lFk1/O09E+oOpscHmyy/4httspKCHPEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLy0TfhqFHUGp0Qii/+Chi+a9wjRkfw9XCNQcDW6yIxgnJbW1bCGnmfm/vSeiEBvZ
	 9mQLMJZ1r+Ea7WAsXARG+HfRK6Evs1EwtyAJcWsmUXoL8FrReuJEqjSjYSU5cJdUIw
	 vd4bHskcRmy32zutaEkJ6B5GsupXbLhKgD1kg/w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/252] drm/i915/mtl: Update workaround 14018575942
Date: Mon,  8 Apr 2024 14:55:49 +0200
Message-ID: <20240408125308.190532657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 186bce682772e7346bf7ced5325b5f4ff050ccfb ]

Applying WA 14018575942 only on Compute engine has impact on
some apps like chrome. Updating this WA to apply on Render
engine as well as it is helping with performance on Chrome.

Note: There is no concern from media team thus not applying
WA on media engines. We will revisit if any issues reported
from media team.

V2(Matt):
 - Use correct WA number

Fixes: 668f37e1ee11 ("drm/i915/mtl: Update workaround 14018778641")
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240228103738.2018458-1-tejas.upadhyay@intel.com
(cherry picked from commit 71271280175aa0ed6673e40cce7c01296bcd05f6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 37b2b0440923f..0ea52f77b4c72 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1644,6 +1644,7 @@ static void
 xelpg_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 {
 	/* Wa_14018575942 / Wa_18018781329 */
+	wa_mcr_write_or(wal, RENDER_MOD_CTRL, FORCE_MISS_FTLB);
 	wa_mcr_write_or(wal, COMP_MOD_CTRL, FORCE_MISS_FTLB);
 
 	/* Wa_22016670082 */
-- 
2.43.0



