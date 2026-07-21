Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5525C3BD63B;
	Tue, 21 Jul 2026 22:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671520; cv=none; b=Zi8HikqrBiuQnme+z9UpqsBeo6WMWdNqohb2p4SQ9l5CUJZdnNrLt6taX/R4JpyVORpkgANwTAWTyT3OYMp5jr7mvVJMzgXZiN/H0azRfRXNGbf7HPLc/X/fdl+Asng/lw0rd+h5hsnn81rO4mwLE/qC2dJM0d+AVNE6oObX474=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671520; c=relaxed/simple;
	bh=HQ+tGHHH22guOxz8b1d6/cdWknFI437RD/Ni8uQc2pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dziMjx7GciR8CkDpEZTPxBe1EZFoWlRsFMaULlnqjo3X/JciSSbm4bGTTatepiVk6ubjG1DifthIsqVfCWpLQPlGr9l5OnDEniViLXJ7KpAmn2R9sUYjkK9kromynvmXZGpZ2F5V4NhafrQC2F5dU/N7pdZMFHXVWsrzwltXTB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwysRV+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwysRV+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B561F000E9;
	Tue, 21 Jul 2026 22:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671519;
	bh=UeuziTShJdc+mpCen8NW/ktKyjM7V4Pfj/4HOZ6V7Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwysRV+A/+mHcMWvVwG0OEbY2UCWtJFnsF4vdtDaqym7N7tOhBHMGcAOfe/FDMhqQ
	 GIbRjWrTluo7EjS7juZpbznvuJah7hpYvR6k16La0vU9go4hK7551rw5qNUVqhSetF
	 acCH2p6htCtIXuEO95Oz+lzCl/vWXKRvc6kYz0dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Val Packett <val@packett.cool>,
	Yongxing Mou <yongxing.mou@oss.qualcomm.com>
Subject: [PATCH 5.15 278/843] drm/msm/dp: fix HPD state status bit shift value
Date: Tue, 21 Jul 2026 17:18:33 +0200
Message-ID: <20260721152412.279577153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <jessica.zhang@oss.qualcomm.com>

[ Upstream commit 2e6c2e81d81251623c458a60e2a57447dcbc988e ]

The HPD state status is the 3 most significant bits, not 4 bits of the
HPD_INT_STATUS register.

Fix the bit shift macro so that the correct bits are returned in
msm_dp_aux_is_link_connected().

Fixes: 19e52bcb27c2 ("drm/msm/dp: return correct connection status after suspend")
Signed-off-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Val Packett <val@packett.cool> # x1e80100-dell-latitude-7455
Tested-by: Yongxing Mou <yongxing.mou@oss.qualcomm.com> # Hamoa IOT EVK, QCS8300 Ride
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/727611/
Link: https://lore.kernel.org/r/20260524-hpd-refactor-v6-1-cf3ab488dd7b@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_reg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_reg.h b/drivers/gpu/drm/msm/dp/dp_reg.h
index 176a503ece9c04..92c69864ad7228 100644
--- a/drivers/gpu/drm/msm/dp/dp_reg.h
+++ b/drivers/gpu/drm/msm/dp/dp_reg.h
@@ -32,8 +32,8 @@
 #define DP_DP_IRQ_HPD_INT_ACK			(0x00000002)
 #define DP_DP_HPD_REPLUG_INT_ACK		(0x00000004)
 #define DP_DP_HPD_UNPLUG_INT_ACK		(0x00000008)
-#define DP_DP_HPD_STATE_STATUS_BITS_MASK	(0x0000000F)
-#define DP_DP_HPD_STATE_STATUS_BITS_SHIFT	(0x1C)
+#define DP_DP_HPD_STATE_STATUS_BITS_MASK	(0x00000007)
+#define DP_DP_HPD_STATE_STATUS_BITS_SHIFT	(0x1D)
 
 #define REG_DP_DP_HPD_INT_MASK			(0x0000000C)
 #define DP_DP_HPD_PLUG_INT_MASK			(0x00000001)
-- 
2.53.0



