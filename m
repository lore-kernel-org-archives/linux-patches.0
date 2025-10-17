Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0295330317;
	Fri, 17 Oct 2025 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713667; cv=none; b=b1lAp+39joEH9eeck88NdSeNugvuJ/JUfGe803G/Be+84Lizq/RJ2bvOiSfCEWt6O+sMHwun1KuzEwpQg0DqsFL44RhuQpYkPk9UzjVW+vDZmcQh9TqMTtw770fqQkDw0G+aJNvM+Kedr4LAOOQ9ku7BLCjxGLNgNT8TqXq7ZqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713667; c=relaxed/simple;
	bh=DKIpzZaHKNiYUn2KhdNHJZArHLV/jVhHdzh+9rH1M5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nl45v9ZlrUTIdDWuf3nhDq0Ej7A5drhwHv8MdRuuLCgrlQroYEHlKf7TnEQ2Lv6xkwMuwr86YfYC53DFJe250u/CYmrLuZzrbMRXNx12DjVpeiA0eBi8Y1x079cUEUO9xYVt0QwKV9K3imsgdRhUGTiM3BPN2ddzernbZqcs194=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtdIftl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtdIftl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF337C4CEE7;
	Fri, 17 Oct 2025 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713667;
	bh=DKIpzZaHKNiYUn2KhdNHJZArHLV/jVhHdzh+9rH1M5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtdIftl4tn5zcjGjHv4K0kj66KkIEzvmjx2bUFk3xEG4KLzxz2B0pc8/qHhRdgHAB
	 aEdo6CBu2i8pi8XSUgIzyNSI5hZ0A63O/8XA4Nr7aowP8U6pjmi7/K2EvBFaM5NxCQ
	 9vsarSCFqlKgkfvq7wvuZfFEG7MYfOzIR5BhwEzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 076/201] media: venus: firmware: Use correct reset sequence for IRIS2
Date: Fri, 17 Oct 2025 16:52:17 +0200
Message-ID: <20251017145137.548698651@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 93f213b444a40f1e7a4383b499b65e782dcb14b9 upstream.

When starting venus with the "no_tz" code path, IRIS2 needs the same
boot/reset sequence as IRIS2_1. This is because most of the registers were
moved to the "wrapper_tz_base", which is already defined for both IRIS2 and
IRIS2_1 inside core.c. Add IRIS2 to the checks inside firmware.c as well to
make sure that it uses the correct reset sequence.

Both IRIS2 and IRIS2_1 are HFI v6 variants, so the correct sequence was
used before commit c38610f8981e ("media: venus: firmware: Sanitize
per-VPU-version").

Fixes: c38610f8981e ("media: venus: firmware: Sanitize per-VPU-version")
Cc: stable@vger.kernel.org
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
[bod: Fixed commit log IRIS -> IRIS2]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/firmware.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -30,7 +30,7 @@ static void venus_reset_cpu(struct venus
 	u32 fw_size = core->fw.mapped_mem_size;
 	void __iomem *wrapper_base;
 
-	if (IS_IRIS2_1(core))
+	if (IS_IRIS2(core) || IS_IRIS2_1(core))
 		wrapper_base = core->wrapper_tz_base;
 	else
 		wrapper_base = core->wrapper_base;
@@ -42,7 +42,7 @@ static void venus_reset_cpu(struct venus
 	writel(fw_size, wrapper_base + WRAPPER_NONPIX_START_ADDR);
 	writel(fw_size, wrapper_base + WRAPPER_NONPIX_END_ADDR);
 
-	if (IS_IRIS2_1(core)) {
+	if (IS_IRIS2(core) || IS_IRIS2_1(core)) {
 		/* Bring XTSS out of reset */
 		writel(0, wrapper_base + WRAPPER_TZ_XTSS_SW_RESET);
 	} else {
@@ -68,7 +68,7 @@ int venus_set_hw_state(struct venus_core
 	if (resume) {
 		venus_reset_cpu(core);
 	} else {
-		if (IS_IRIS2_1(core))
+		if (IS_IRIS2(core) || IS_IRIS2_1(core))
 			writel(WRAPPER_XTSS_SW_RESET_BIT,
 			       core->wrapper_tz_base + WRAPPER_TZ_XTSS_SW_RESET);
 		else
@@ -181,7 +181,7 @@ static int venus_shutdown_no_tz(struct v
 	void __iomem *wrapper_base = core->wrapper_base;
 	void __iomem *wrapper_tz_base = core->wrapper_tz_base;
 
-	if (IS_IRIS2_1(core)) {
+	if (IS_IRIS2(core) || IS_IRIS2_1(core)) {
 		/* Assert the reset to XTSS */
 		reg = readl(wrapper_tz_base + WRAPPER_TZ_XTSS_SW_RESET);
 		reg |= WRAPPER_XTSS_SW_RESET_BIT;


