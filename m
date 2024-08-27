Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6F51C5783;
	Tue, 27 Aug 2024 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771597; cv=none; b=sgry3DRWgoBlh8zhUeyT5svx19hqMqb4yNgUbJsfH5S7jGjTE6ZBl0aIVE++L0cHJuC39j9jxGyN4U7qvfoTHwiMlivbdvDCgq6zDI3hULTlltL0rc2dlHGRm5q9QjEfGpA9o5Pr/p5hFEKbbfQ788qf0Hke1F4wEO/vMoKrnK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771597; c=relaxed/simple;
	bh=2owPgvtwIZCobc/hwf3ShDNI79f99v8XnmOj30PDMh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3qwsK90z9YIFw4AvtIjPJdK7k8gGu4w4q49zpTy3vDXCUaWJjj2NDSqNW+bH3sHff64T+u2Uypd+pz+4mPgdYgHu5mSvKDJ1EWCsWJHIgZET3bYKObSh+PwVmlgmyUisUIYqnC5uhTlJzR4QYL5ROCvJyjy9um6Dj9t4iZS3eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2TZEDdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2TZEDdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E973C4FE9A;
	Tue, 27 Aug 2024 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771597;
	bh=2owPgvtwIZCobc/hwf3ShDNI79f99v8XnmOj30PDMh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2TZEDdtLDUF2T++T3eVi0kUNw67ovZA/wPNvJeXHsnEK5nXnaDwjxYFbF52jMglU
	 1ACfs0opttqUdxh0yoQtQ5NdXTyEB9h7amZrxlB8smBr0U9nkSnNwAQG6ezm+WyGMA
	 pDmzwqorNDswKXl6PWVFemSUHrx53V86z5/409PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 205/273] drm/xe/display: stop calling domains_driver_remove twice
Date: Tue, 27 Aug 2024 16:38:49 +0200
Message-ID: <20240827143841.211892705@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 48d74a0a45201de4efa016fb2f556889db37ed28 ]

Unclear why we call this twice.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240522102143.128069-35-matthew.auld@intel.com
Stable-dep-of: f4b2a0ae1a31 ("drm/xe: Fix opregion leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_display.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/display/xe_display.c b/drivers/gpu/drm/xe/display/xe_display.c
index 0de0566e5b394..6ecaf83264d55 100644
--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -134,7 +134,6 @@ static void xe_display_fini_noirq(struct drm_device *dev, void *dummy)
 		return;
 
 	intel_display_driver_remove_noirq(xe);
-	intel_power_domains_driver_remove(xe);
 }
 
 int xe_display_init_noirq(struct xe_device *xe)
-- 
2.43.0



