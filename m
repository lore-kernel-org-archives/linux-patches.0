Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AD330C618;
	Thu, 30 Jul 2026 15:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424429; cv=none; b=LepC+XixptNew8niAUAXJF1pTwfNaMePK1ZeYliPiWybFZI+Yf0+JLGAgwtikOklubnQfsKZRCaQQoKVByWhU1/ZEz3O/94NHEuXtPcfPEXWBzdpRsCJSYDNhNc/keBAnlxOFjKBgFJ5XekqhwAfT8MuCf6kkspSioNI1wYPqkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424429; c=relaxed/simple;
	bh=IbPsmT3pqnwspA++FBBNjtxJITvgOeoyJecxLvnXt20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFw299yykS1FNXUqwV3mIAH9f6vvvVq18zPfe8R5GHRrk1ov1TrGBvj/K900aT/KcDk2/mwVdIn4A6/fDBhcDK+CS+UdI2GjZg2Q/4lwqbU6onk2AUfm2z5w7jL/KotV1Ob4mknhXE51wdh+hD846Z9yohUlJCOTTRn5+DvvCF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j60Qi0+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j60Qi0+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7223D1F000E9;
	Thu, 30 Jul 2026 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424427;
	bh=ObSotSOy48nO48aVnqneA2Ja6FpvR3WvSABabhngCyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j60Qi0+WRWBkeJKI42o91X+QjEYdnjY/OJ8cUVIndZEUBOdsIYVOcHhL8dR1MqCmT
	 oxg2asvmZTrQO91nKnsIHH6q7Bs1CFmxuPI/iapQOEdCkRIRlqDW/DxkEpTDBjr1I3
	 yd3+VKIaCt9QARHzWD4iRMWrtUSR8u/mtBumdX8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Leo Li <sunpeng.li@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.18 389/675] drm/amd/display: Fix missing DCE check in dm_gpureset_toggle_interrupts()
Date: Thu, 30 Jul 2026 16:11:59 +0200
Message-ID: <20260730141453.403380507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Leo Li <sunpeng.li@amd.com>

commit fbbaca9e208733652828ea98d00f09f260a7770e upstream.

This line was lost when cping from amd-staging-drm-next to drm-fixes.
So add it back.

Cc: stable@vger.kernel.org
Fixes: 8382cd234981 ("drm/amd/display: consolidate DCN vblank/flip handling onto vupdate_no_lock")
Reported-by: Lu Yao <yaolu@kylinos.cn>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260723134450.13838-1-sunpeng.li@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3068,7 +3068,8 @@ static void dm_gpureset_toggle_interrupt
 		acrtc = get_crtc_by_otg_inst(
 				adev, state->stream_status[i].primary_otg_inst);
 
-		if (acrtc && state->stream_status[i].plane_count != 0) {
+		if (acrtc && state->stream_status[i].plane_count != 0 &&
+		    amdgpu_ip_version(adev, DCE_HWIP, 0) == 0) {
 			irq_source = IRQ_TYPE_PFLIP + acrtc->otg_inst;
 			rc = dc_interrupt_set(adev->dm.dc, irq_source, enable) ? 0 : -EBUSY;
 			if (rc)


