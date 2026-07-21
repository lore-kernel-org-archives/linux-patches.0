Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF14F46A5FB;
	Tue, 21 Jul 2026 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648896; cv=none; b=FG5B2+klGIkbYq+EyeoCx9q++60DYNV0mTeFdr9c7bgkyRXqU+EsNkjCyrCnXJdFpI0uvQUBeV9Elb76OI0xQ8q5NY77d/UGWy7vltYyhXc/M/VUqQE0FYpim/yp4FcYnMH+v6ur3pV6NN4riLp3+O5OV4y5MyeUP/S4Bj6WtZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648896; c=relaxed/simple;
	bh=vf2JCzHpADQ8IBAnJ5z3RHWbN1L+Fz13NBbV3ZapL4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiuBZG3d9GkF0O1XWTV1iBU0wpcphClmPyfHW9ScJK77+xQOzGDICpUfrNurI1RL9r6IbPr8k5j9uZFTixWaIdJEnUTFOkI9wdXLmhz0GS89nwmoRGxCZkpRfJjLjr0fJvj2oihHP+5KqOhbX8zXE+ao388cGsaPCVIo7ZtTdGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T79U+5Ii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T79U+5Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8971F00A3D;
	Tue, 21 Jul 2026 15:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648891;
	bh=zD4nUQJ19r5MnO/jlj1sZJHpkqnFcX88mtfLA7K27Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T79U+5IitZzNpmnYoj/EGS2Oyf+HHUnBnz1ZoUIm6X3ow1IJC7F+GhPKmmngQjbYA
	 A1x/j+Z6cHhiEG4foLIUlTMCDDcHB1R2VZ4ZWxpUX90Gmoj98YkTPs+NaVMCwIidW8
	 bYtn6xpT1AjV/aQbGga4StZUcSNqclSmi4uzFS7U=
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
Subject: [PATCH 7.1 0372/2077] drm/msm/dp: Fix the ISR_* enum values
Date: Tue, 21 Jul 2026 17:00:45 +0200
Message-ID: <20260721152601.463455935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <jessica.zhang@oss.qualcomm.com>

[ Upstream commit 3fbfdc3b1d48cc115a86953e5df0c76cd2efc42b ]

The ISR_HPD_* enum should represent values that can be read from the
REG_DP_DP_HPD_INT_STATUS register. Swap ISR_HPD_IO_GLITCH_COUNT and
ISR_HPD_REPLUG_COUNT to map them correctly to register values.

While we are at it, correct the spelling for ISR_HPD_REPLUG_COUNT.

Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Signed-off-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Val Packett <val@packett.cool> # x1e80100-dell-latitude-7455
Tested-by: Yongxing Mou <yongxing.mou@oss.qualcomm.com> # Hamoa IOT EVK, QCS8300 Ride
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/727602/
Link: https://lore.kernel.org/r/20260524-hpd-refactor-v6-2-cf3ab488dd7b@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index d2124d6254855b..cf2415635c426f 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -38,9 +38,9 @@ enum {
 	ISR_DISCONNECTED,
 	ISR_CONNECT_PENDING,
 	ISR_CONNECTED,
-	ISR_HPD_REPLUG_COUNT,
+	ISR_HPD_IO_GLITCH_COUNT,
 	ISR_IRQ_HPD_PULSE_COUNT,
-	ISR_HPD_LO_GLITH_COUNT,
+	ISR_HPD_REPLUG_COUNT,
 };
 
 /* event thread connection state */
-- 
2.53.0



