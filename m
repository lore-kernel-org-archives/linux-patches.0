Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADBA1DE3A3;
	Tue,  8 Oct 2024 12:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392009; cv=none; b=uVsRR0MtrrszNaR60oIWTdth7Tmw1FLcnsJZdTRZuMuglp9lZLzefhMaz5diPFEGOS1Kh1ZdYhhY422LpU74Ee5jmwi/AQWoj7pBFVDDxuOjfMP22acZx47G6KDsH3fH+J8c8lA0G4YuUyWf1iGVLkxfQm1btdRtPB9DSjSzA2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392009; c=relaxed/simple;
	bh=tA26D4dCTuNRZgqHFeb+RMNGo9g4stKw5un/MlyGoWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo4BhAXFuqnpIzdg5lxjl8mOBUFYYdj8dMispgega2omzfxWLQR/otKZ+eZTnGviP7KSksyqzRdqdQRZDArSTsAv4kduoftU4XxMWghoADUgM2EJL305/ySbA0f8xpb0dj8LOqslBR9OsiK/WCt7mMLNRbGAQdvB2aJtp1xWXg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwqfGt0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwqfGt0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50309C4CECC;
	Tue,  8 Oct 2024 12:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392009;
	bh=tA26D4dCTuNRZgqHFeb+RMNGo9g4stKw5un/MlyGoWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwqfGt0jJVX2WnDVGxchiJTarQ6lfvq0pZkJpZ8QMedWSVY/JN57BDNCvt47oz15V
	 rufr+5SDtK8rtxyGGgRW9JigMEV1yTGKUwt5gMT/sIsdTqfy8j62y0lNMEY36QrTPo
	 7rkHVMprGaJXG5XQjhkeSw89oSlWZDJ8gEhCTgvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jagmeet Randhawa <jagmeet.randhawa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 290/558] drm/xe: Drop warn on xe_guc_pc_gucrc_disable in guc pc fini
Date: Tue,  8 Oct 2024 14:05:20 +0200
Message-ID: <20241008115713.737119332@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit a323782567812ee925e9b7926445532c7afe331b ]

Not a big deal if CT is down as driver is unloading, no need to warn.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jagmeet Randhawa <jagmeet.randhawa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240820172958.1095143-4-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index ccd574e948aa3..034b29984d5ed 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -1042,7 +1042,7 @@ static void xe_guc_pc_fini_hw(void *arg)
 		return;
 
 	XE_WARN_ON(xe_force_wake_get(gt_to_fw(pc_to_gt(pc)), XE_FORCEWAKE_ALL));
-	XE_WARN_ON(xe_guc_pc_gucrc_disable(pc));
+	xe_guc_pc_gucrc_disable(pc);
 	XE_WARN_ON(xe_guc_pc_stop(pc));
 
 	/* Bind requested freq to mert_freq_cap before unload */
-- 
2.43.0



