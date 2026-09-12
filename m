Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD637B407;
	Sat, 12 Sep 2026 08:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200716; cv=none; b=uBmd4qWfQo0w824boILGs9QheiEoiB0sBl0Jhz08No6LP1195Af6kKRtM2g1NZaw/ZCh3VUHE1Drd7z7TeHB4EjLfZu1WV/xKebnzH/4mlEN1gsJv647XHeh/vxCTNry0wCqIfdIu8Ni/xs5Ckmpm3Oo0tTVA2Es7AVE/jDY4Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200716; c=relaxed/simple;
	bh=/uIoDytDxNimz73fACQy/zIDXI8SvNWvG97vMLJXdJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpXHawH0oq2VbxZJu+3O+y5OqQKlzCGlISd9vfXqs/qq/N1VsGGmK9qO8X+c0VlknHEGHLDtM2R2JFVhdousivLHx92scgHrvl9T/M+Lgsc+radpyQmkDOfLpKn2mcEmfBAiijqpZ0S3Pd4G0EFfP/kKJVM+X1m/BawuFP9iH/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkxvl9RM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkxvl9RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE021F000FF;
	Sat, 12 Sep 2026 08:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200714;
	bh=wjU9ta4OhUa0yMW7OpyQTPTehbHL4y2fVRW5oMIWPcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkxvl9RMKq+PZ0uznrOeTcaV8P19V6nqGgnjwRZickfvD9v/c6knzPYrqmz1yiN4S
	 apgjVc4NkswgGfi0eQDItUVF3yd265u/CMuSZvAIB1AMpz+U1EVPlOhOygDHdGHt1t
	 GDnRk8RVF7Xvozc79XXVlHveKh7Kp3P4eXwwVERk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <komal.bajaj@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0847/1815] pinctrl: qcom: shikra: Fix intr_target_width for summary interrupt routing
Date: Sat, 12 Sep 2026 08:43:17 +0200
Message-ID: <20260912065708.803134555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Komal Bajaj <komal.bajaj@oss.qualcomm.com>

[ Upstream commit 1e7b04c12c077e8829991833a9aa2cb3bdacab61 ]

The intr_target_width field sets the mask width used when writing
target processor into interrupt config register and deciding which
processor receives summary interrupt for a given GPIO.

Without it, pinctrl driver defaults to a 3-bit mask. On Shikra, this
field is 4 bits wide, which could corrupt adjacent bits and mis-route
interrupts. Set intr_target_width = 4 to match the hardware.

Fixes: 9db68ec534c5 ("pinctrl: qcom: Add Shikra pinctrl driver")
Signed-off-by: Komal Bajaj <komal.bajaj@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260728-shikra-pinctrl-intr-width-v1-1-46583734d808@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-shikra.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-shikra.c b/drivers/pinctrl/qcom/pinctrl-shikra.c
index 0fc98369948cb..55aec2f675e6b 100644
--- a/drivers/pinctrl/qcom/pinctrl-shikra.c
+++ b/drivers/pinctrl/qcom/pinctrl-shikra.c
@@ -44,6 +44,7 @@
 		.intr_status_bit = 0,		\
 		.intr_wakeup_enable_bit = 7,	\
 		.intr_wakeup_present_bit = 6,	\
+		.intr_target_width = 4,		\
 		.intr_target_bit = 8,		\
 		.intr_target_kpss_val = 3,	\
 		.intr_raw_status_bit = 4,	\
-- 
2.53.0



