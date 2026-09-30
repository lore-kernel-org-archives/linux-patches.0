Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EF71E0DD8;
	Wed, 30 Sep 2026 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787580; cv=none; b=GbvNy8CufS18HKMEbZ44KqUqxOwXzN3foFtDZmU6PmOx1OP+1occjVj+7n6OMPCMf8gGzG9f7stZZCBKNkqufavMnd1ByLsV54Vi+0+cgjD67FV2KT3TeBS+idyffqjFYorbTiWPH3liA8tQI5Dp0jWUqm/CYN6sYjviIz0x0ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787580; c=relaxed/simple;
	bh=HbjCuLkDxsEpZxR37rRE1qUVEWbUBRFjngcvzVAWfLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5QWizSt9vlTOHajHnxrjSOrAN6F0v8CW02YCkNUGWc8Qzcl95Pli6Phh2ocpy9oh9/D3KJjlvPfeYqsmgBC1vVlnDhx8a/9rG4dyK1YAiLqiu00udFGYFQTuUYru1tvdTSR5mHe0h0eu8B3HjxZyPO3KxjOlzGvG8Ipr9INAeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+Xo1Y5x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+Xo1Y5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC17F1F00898;
	Wed, 30 Sep 2026 16:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787579;
	bh=fHYsLuYg3pxIvOqpzMh6kYqg5pSW9POByBBhva2hM68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+Xo1Y5xvzj/ng409l8IGnaLZIJG4LG+DAfBsK1Cu1N/eDilDUcVHYTPNaPyxFVxY
	 2cpucS/s4NgwXXbldyZOO2U07za3ArYO07YCBZ1bhlm3aChiYvczl0e3+s4xstPrJ6
	 vS18S6JJZ7u+LY8wQplvMCum/mYoh2VBkTRrkUWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annoy Cc <annoycc@gmail.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Nemesa Garg <nemesa.garg@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 7.2 279/457] drm/i915/quirks: Limit eDP rate to HBR2 on HP Pavilion Plus 14-ew1
Date: Wed, 30 Sep 2026 17:26:24 +0200
Message-ID: <20260930152352.057197067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit 5271d81f99dd01d983d439930eb056952485e15e upstream.

The eDP panel on the HP Pavilion Plus Laptop 14-ew1xxx advertises HBR3
while leaving the TPS4 support bit clear. The output however flickers, once
link is trained with HBR3.

Until commit 8c9006283e4b ("Revert "drm/i915/dp: Reject HBR3 when sink
doesn't support TPS4"") such sinks were capped at HBR2 by the TPS4 check
which incidentally kept this panel stable. That check was reverted because
other panels legitimately need HBR3 without advertising TPS4, and the
per-machine QUIRK_EDP_LIMIT_RATE_HBR2 was introduced to handle the affected
machines instead.

Add the machine to the list of devices that need the
QUIRK_EDP_LIMIT_RATE_HBR2.

Fixes: 8c9006283e4b ("Revert "drm/i915/dp: Reject HBR3 when sink doesn't support TPS4"")
Reported-by: Annoy Cc <annoycc@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16743
Cc: <stable@vger.kernel.org> # v6.18+
Tested-by: Annoy Cc <annoycc@gmail.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Nemesa Garg <nemesa.garg@intel.com>
Link: https://patch.msgid.link/20260907034555.2753846-1-ankit.k.nautiyal@intel.com
(cherry picked from commit 550b703fdbb2a2022faa75b4b11ab135241afbd9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -257,6 +257,9 @@ static struct intel_quirk intel_quirks[]
 	/* Dell XPS 13 7390 2-in-1 */
 	{ 0x8a52, 0x1028, 0x08b0, quirk_edp_limit_rate_hbr2 },
 
+	/* HP Pavilion Plus Laptop 14-ew1xxx */
+	{ 0x7d55, 0x103c, 0x8c31, quirk_edp_limit_rate_hbr2 },
+
 	/* Xiaomi Book Pro 14 2026 */
 	{ 0xb081, 0x1d72, 0x2424, quirk_disable_psr2 },
 };


