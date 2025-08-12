Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A9827703A;
	Tue, 12 Aug 2025 19:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026381; cv=none; b=uXGhhwxl0KKw8hD7mHh8tp+hxXoaixAhkZt1E/YvX4Dtzq8qX435LYR+tWLdlaJ2jw2tq6uZOUNPQkTz7pgbpRiNI3fbxXuHsDCG+2rmprpkK1d/9AYZMX0dcGzpcjHGINW5Ve8Az57LgcAKVd8vfi32g/G5U568Pht7dsI9EQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026381; c=relaxed/simple;
	bh=9ReU9vxDtjY9RqpnbHQsVkyxKElFKpw1RBuRcTgFBww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2luEtpC+ch8CQFaN7Az1ZDNNGbUWXv12uLroSfTAGmGOT/lMfe3iI3WfB+csmrJOo5Kz/qzv1vm5k5mPTiGrSStKS7dw79Nolu9aQO/Gagj8LGGqZI+1Od7Ulo3BmvRWcDfy03P1iy/xYcTN7wdPa5cj9xqxts8gSshy5r35dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQl4wGuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQl4wGuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC6BC4CEF0;
	Tue, 12 Aug 2025 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026381;
	bh=9ReU9vxDtjY9RqpnbHQsVkyxKElFKpw1RBuRcTgFBww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQl4wGuWJ/bVEs+t+td4XgdLbCAhi9iPwNfJebrQXoah6QsCd0pm2jBYWs1PsLNQq
	 AHV4ox008EPzHIz+ZpLxi7NOErqFLjgCadFSRtSrlbPvgkCtoLi9j+cPYZQZFWoYZF
	 +89TONw9POG7+C6Z7EyxDmyv1vS7AqfKIMSHhkFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 320/480] drm/xe/vf: Disable CSC support on VF
Date: Tue, 12 Aug 2025 19:48:48 +0200
Message-ID: <20250812174410.635905262@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f3123914b1ab..258c9616de19 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -678,6 +678,7 @@ static void sriov_update_device_info(struct xe_device *xe)
 	/* disable features that are not available/applicable to VFs */
 	if (IS_SRIOV_VF(xe)) {
 		xe->info.probe_display = 0;
+		xe->info.has_heci_cscfi = 0;
 		xe->info.has_heci_gscfi = 0;
 		xe->info.skip_guc_pc = 1;
 		xe->info.skip_pcode = 1;
-- 
2.39.5



