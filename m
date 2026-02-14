Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED7A3EBF2C;
	Sat, 14 Feb 2026 01:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031076; cv=none; b=fdBJdZA8ECTPeDaq6TAIJlgc/TVbHMjY+d5onsTYUb9pIuPv5BFHM56Tyvhzroz3fO71G/u41jntMvpidDM/QuGMUxwMqemLqGmfoLNR1ZiA03TMff4gEtLny+WNvdR7vS9cxF7SgXOJYAdwlSOMNNX/bNe5TjI42kdfmIp/xEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031076; c=relaxed/simple;
	bh=j2tHpRfH2AXto0QuNBhQC0zyM0XVJryZRltGbvGtj20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjEUTOn9ZEJE1x+5SRF0DpeiiRfhSJ1bY05fEEahZHLALTh+H3qxsIWJOSbbM+4KSFdzVssrnvopH/yVbOgt8lgTKlM/TrqlZagj8gV3As87UVw2JTmCmOfGaA3ZLiMgG8cSweMBMs724NmS+hjD0hW45u2BFAiKmTzAShz5AMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZSM+Xeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZSM+Xeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB6CC16AAE;
	Sat, 14 Feb 2026 01:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031076;
	bh=j2tHpRfH2AXto0QuNBhQC0zyM0XVJryZRltGbvGtj20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZSM+XeuNpkOmtLzMZGpxQqiYvT/oQoehHYgsqA7W91Lti7QYiVAvUv3EyngnaB3w
	 D4yGVEELCg/2WRXaz7vzyPBJRO4gsVsSgK0IDzQd9fDUdriEEJQxs/o8joSC1PN6rn
	 z5AG+I6KtEF1EfVmvvrOIcNVMFR3Egm9KZWEuz32UjQz2QyDPMfM4TJ4Gzs/7zmM0e
	 AGXxKciXeFPypqMIBwfnKfcRV3rYpK2CTYuOM/B/vYUlKlJoR5py1Y0cir4vGydODD
	 j8NCu58x3xN7oPLKbXJN3iHut2K2KFluT97cI14j92C0cDue/tc5Eq4SUzA8kKL98H
	 dRzZ1no4hBjiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/xe/ggtt: Use scope-based runtime pm
Date: Fri, 13 Feb 2026 19:58:51 -0500
Message-ID: <20260214010245.3671907-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 8a579f4b2476fd1df07e2bca9fedc82a39a56a65 ]

Switch the GGTT code to scope-based runtime PM for consistency with
other parts of the driver.

Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20251118164338.3572146-51-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 drivers/gpu/drm/xe/xe_ggtt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
index 793d7324a395d..9e6b4e9835424 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -396,9 +396,8 @@ static void ggtt_node_remove_work_func(struct work_struct *work)
 						 delayed_removal_work);
 	struct xe_device *xe = tile_to_xe(node->ggtt->tile);
 
-	xe_pm_runtime_get(xe);
+	guard(xe_pm_runtime)(xe);
 	ggtt_node_remove(node);
-	xe_pm_runtime_put(xe);
 }
 
 /**
-- 
2.51.0

