Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E83190477;
	Fri, 21 Nov 2025 13:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731601; cv=none; b=kWySG+9xsL/9PRO5bWO/l7efhtj+cx+XEauRGK2fjvaQ2Ma+tyuiyJXej49Qv86Wr9S2UO7o1IXCaJkfDkVrJK4qrpYy7DXM+KY9YX9uTTTHmXivTh+FOkZkcRGKntuH8tCRefWu9Sd2iQcrgKRwDPDYa7vdHtvp1HiR+qHTEaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731601; c=relaxed/simple;
	bh=JVruydgNVdmh3mj9BF74jUqTDECNrG+JJnH3z4G8bpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvjgLe89DolzpSWCiTSd79i3XdJObBUii6nVV6X/03mZaTJZcwmJ0H08wqkQJ4Fphgdwrz/zk4nzO5LvxfASlz4q7a7wjND1RC3l3Ln9YEp3MtnA+mn8WTjoUlcHXMqkZMGZwhHBPmgaF/NSWt/sh0t80eVPB1U8nt72EbW0Y+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCVIYhJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCVIYhJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41D1C4CEF1;
	Fri, 21 Nov 2025 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731601;
	bh=JVruydgNVdmh3mj9BF74jUqTDECNrG+JJnH3z4G8bpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCVIYhJCakeeYixmeEKIjMiczAJO/1X1wn0zhzgyTbh7blL+YfZ5djEHG/Z2R7Pt1
	 odBHRycepgWwWxeoAqvT9y/aM+VyjjfTHuiTyTjdfy9Z5aTSAmrkwlJxkM5uqp+rds
	 nwFF/WvHd6R8QZs/EMPLeV8yGvEgYsdFx5CXstXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/185] drm/xe: Move declarations under conditional branch
Date: Fri, 21 Nov 2025 14:10:35 +0100
Message-ID: <20251121130144.170171089@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 9cd27eec872f0b95dcdd811edc39d2d32e4158c8 ]

The xe_device_shutdown() function was needing a few declarations
that were only required under a specific condition. This change
moves those declarations to be within that conditional branch
to avoid unnecessary declarations.

Reviewed-by: Nitin Gote <nitin.r.gote@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251007100208.1407021-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 15b3036045188f4da4ca62b2ed01b0f160252e9b)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: b11a020d914c ("drm/xe: Do clean shutdown also when using flr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 2e1d6d248d2e0..3fab4e67ef8c1 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -809,12 +809,12 @@ void xe_device_remove(struct xe_device *xe)
 
 void xe_device_shutdown(struct xe_device *xe)
 {
-	struct xe_gt *gt;
-	u8 id;
-
 	drm_dbg(&xe->drm, "Shutting down device\n");
 
 	if (xe_driver_flr_disabled(xe)) {
+		struct xe_gt *gt;
+		u8 id;
+
 		xe_display_pm_shutdown(xe);
 
 		xe_irq_suspend(xe);
-- 
2.51.0



