Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78791247287;
	Tue, 12 Aug 2025 18:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024656; cv=none; b=ptjkQUXjrZ7fPSGNXcrBHVNYwfQlIGyjICNSZY9jExABJrB8HsdSFShDm6gNHUkplrTYvQtLeMhhOcYeWti/h6kBCUL2HwqwnaSxg4sNteS7s7y+ORyR6erF4q95WHLcn78xUZCGFjp/pgQAWdgfl/Ju8Sj5iI/TjukAI0OwgDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024656; c=relaxed/simple;
	bh=y2BERBwX7O/6q9/i0Lxx1mq7fT0NIMflhZWcwbkKXTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrrucJO5N9eJRC0fde4dUDa9WqHHkgNP7R3M2/STGvMk+2VCQzVjxbQV35ud19ouOXXl5UXx6fFRoVBedaUNN1AMSfq3SdKtYcrmfYGaAPmaLQWBjWa8N1OMOU1H2JXk/fCA2OA2bgmLmLq/6SRu2bCbujv53Bj0qqggv+R/7V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYHTn8PH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYHTn8PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7E5C4CEF6;
	Tue, 12 Aug 2025 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024656;
	bh=y2BERBwX7O/6q9/i0Lxx1mq7fT0NIMflhZWcwbkKXTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYHTn8PHtyf/QWGMjuK1M02jS7IfOwldwyVKowpOpQcf4Dr31VGix4x2HVOE9H31b
	 aT/bAF1qD3piwofGv9wMkxdzPBkw9Wgs+yJH9HKOtoW6dskc1hCBuD6VkwyboI8UNt
	 xF9C1B2l7M5Tp2eN2llpLAZlkX4RnJjBry/dkGj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 437/627] drm/xe/vf: Disable CSC support on VF
Date: Tue, 12 Aug 2025 19:32:12 +0200
Message-ID: <20250812173435.901231598@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Laguna <lukasz.laguna@intel.com>

[ Upstream commit f62408efc8669b82541295a4611494c8c8c52684 ]

CSC is not accessible by VF drivers, so disable its support flag on VF
to prevent further initialization attempts.

Fixes: e02cea83d32d ("drm/xe/gsc: add Battlemage support")
Signed-off-by: Lukasz Laguna <lukasz.laguna@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://lore.kernel.org/r/20250729123437.5933-1-lukasz.laguna@intel.com
(cherry picked from commit 552dbba1caaf0cb40ce961806d757615e26ec668)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index e9f3c1a53db2..7f839c3b9a14 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -685,6 +685,7 @@ static void sriov_update_device_info(struct xe_device *xe)
 	/* disable features that are not available/applicable to VFs */
 	if (IS_SRIOV_VF(xe)) {
 		xe->info.probe_display = 0;
+		xe->info.has_heci_cscfi = 0;
 		xe->info.has_heci_gscfi = 0;
 		xe->info.skip_guc_pc = 1;
 		xe->info.skip_pcode = 1;
-- 
2.39.5



