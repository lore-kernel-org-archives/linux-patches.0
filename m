Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD74C50B435;
	Thu, 17 Sep 2026 16:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664020; cv=none; b=WYgfPjBVgjeRDLQRDKxVTxaT3ydUPyJ4p0x0StgKlUbZuQjfk1P95njGV6p+11vGmQuzBwYg60cQ1Ds7Q+h1NRbqIMzZJdNMagag08DQiPHkSTtfqYHbXLewX2Z5R9TBL9/WWVz9IXxS06D/BBr6Mwb4GMFa+8EDleqxg5kRgD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664020; c=relaxed/simple;
	bh=K8ZmWIk0Dx5a4mXaH2gwkRYukqkzzkT1zcXPmmK1wHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrwUgGm1nWhz9pBVPJldxK9em1sHwiif9YnpEbIhdu4l1Zt7nCQb5bd9hqPMhpaGG9Kib5seNcnSbBuiCY7JjM7FrX3cu5ipMw6OV1b63wZuOGQt2qO3hfaD/v2nS38WreLE0mtCYWHF6C9syGClG2XHfauCQfab4snBdzTSkwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPAZU+s9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPAZU+s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E3B1F00893;
	Thu, 17 Sep 2026 16:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664019;
	bh=3sK8fVQAi4WLkJ6VmEOcdtDhnsFpSYcHLtw4DnI0sh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPAZU+s9FobmQrREd6+hXCHU83tZFvdaNSyG8AYQGIfMCv76gF8dHBO97/I9k8WQL
	 R88StgkrKAS/5rBiBaQAnhiXB4yodUHke7UXbkd7rPGpv2J0ph89iFZrO9ACVItf5M
	 Qse2fyWRNb5lKu1ISWAG9WQNCw1cjTtcL8B/jZcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shawn C Lee <shawn.c.lee@intel.com>
Subject: [PATCH 6.18 0232/1250] drm/dp: Add DSC virtual DPCD quirk for Realtek MST branch device
Date: Thu, 17 Sep 2026 16:00:27 +0100
Message-ID: <20260917151558.429764022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit bff2da7aa0020eb72e42d63868dc5adaa0fb85d3 ]

The ASUS DC301 USB-C dock containing a Realtek MST branch device
supports the DSC decompression functionality on each of the dock's
downstream connectors, even though there is no discoverable peer-to-peer
virtual device in the MST topology (which the DP Standard
requires/suggests to control the DSC functionality on a per-DFP basis).
Add the DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD quirk for this branch
device as well to enable the DSC decompression functionality on all DFP
connectors of the dock, similarly to how this is done for dock's
containing older Synaptics branch devices.

Cc: Lyude Paul <lyude@redhat.com>
Reported-and-tested-by: Shawn C Lee <shawn.c.lee@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260525125516.2794636-1-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 8c858ba40c6c6..77336bc3e62c2 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2537,6 +2537,8 @@ static const struct dpcd_quirk dpcd_quirk_list[] = {
 	{ OUI(0x00, 0x00, 0x00), DEVICE_ID('C', 'H', '7', '5', '1', '1'), false, BIT(DP_DPCD_QUIRK_NO_SINK_COUNT) },
 	/* Synaptics DP1.4 MST hubs can support DSC without virtual DPCD */
 	{ OUI(0x90, 0xCC, 0x24), DEVICE_ID_ANY, true, BIT(DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD) },
+	/* Realtek DP1.4 MST hubs can support DSC without virtual DPCD */
+	{ OUI(0x00, 0xe0, 0x4c), DEVICE_ID('D', 'p', '1', '.', '4', 0), true, BIT(DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD) },
 	/* Synaptics DP1.4 MST hubs require DSC for some modes on which it applies HBLANK expansion. */
 	{ OUI(0x90, 0xCC, 0x24), DEVICE_ID_ANY, true, BIT(DP_DPCD_QUIRK_HBLANK_EXPANSION_REQUIRES_DSC) },
 	/* MediaTek panels (at least in U3224KBA) require DSC for modes with a short HBLANK on UHBR links. */
-- 
2.53.0



