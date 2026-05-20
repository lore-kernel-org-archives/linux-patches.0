Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F22F3F7A9F;
	Wed, 20 May 2026 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300500; cv=none; b=FHjeSH0xVsZRh2rhZWshYXSeZ3xvLACnB6lQlPgVp+0WQHzzq94ggFrMuX/jBHyzujfXfMMmk2hkEDvk5z9qk0Me3kPJlfLYKHp1J5MAWaB3BGxeKSuFj/EKsD40VwXPDDxboKcrwcyGNaz0r+4uGZphqpT50vxNgVvBjRIsa7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300500; c=relaxed/simple;
	bh=lr2wBM4IyBRTQQMdau93eMQMuTMFCMKdQMMQpBX8yFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6DFMenowdiv6Wfr0iqYDHDi5lWhqhp/WZLS2O+TNYqAHqaHag0zTuu5CwmO2vQBHI7ILO+Iqts6runYPLXO9ATqgy4Uk5D+IDNjg3jFdNcAXmUVIYsAtOLhJjD4dlXbU4aaetg4dDigShAj+wmUSFEModEkU4O5ZNgr7NUlfF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmC7mgl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmC7mgl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C051F000E9;
	Wed, 20 May 2026 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300499;
	bh=7AoXyAu4io22gId/1xLxFKLVUPvVfZXAGqfmgQR6Io8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmC7mgl1FurOQPEI5I0VhKb4EFcLzt6KP7g0ieqyzfEaVQhrpSjkhMdnNPVWtjzt/
	 PQ8diIlhV7ITQg6S0f1+yw3bIMw9GKRckzZwRVG0SgE9t7BWApGWNd7u9nayZ+3tKr
	 5PW7MYKkiHJvzYJt3C5GaOwI2LD3e4kLLGSkdRgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/666] PM: domains: De-constify fields in struct dev_pm_domain_attach_data
Date: Wed, 20 May 2026 18:16:48 +0200
Message-ID: <20260520162115.471915243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 1877d3f258cbb57d64e275754fb9b18b089ce72d ]

It doesn't really make sense to keep u32 fields to be marked as const.
Having the const fields prevents their modification in the driver. Instead
the whole struct can be defined as const, if it is constant.

Fixes: 161e16a5e50a ("PM: domains: Add helper functions to attach/detach multiple PM domains")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm_domain.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index c6716f474ba45..908e20bbfcaef 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -36,8 +36,8 @@
 
 struct dev_pm_domain_attach_data {
 	const char * const *pd_names;
-	const u32 num_pd_names;
-	const u32 pd_flags;
+	u32 num_pd_names;
+	u32 pd_flags;
 };
 
 struct dev_pm_domain_list {
-- 
2.53.0



