Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064270;
	b=qexZBwdxKMNAErcIP4i2mpwx3F4I6wnAfJBPtNfHs2xgm7MpfltxWB7nZbfV17pHannU
	 /1Z2ovLxsBR2ASY5bXSNLKds2lKLv+VqVnTneVIQx9IC97jllhqllA24fyUlC+1mSWxsd
	 vulozZiMbZSKEWVxm3G7QwohgSXfbNIKvbcobAvIJNHraioNAIoI+lRboOYmcAv0IPd1i
	 s1HemEaMZ4VAa2CNfAqeD/TvgKytbOCLZRrSKHiUZ4Bd7n/T1Knte5+x0nAXX2nPb+GDr
	 +rsXIUuAIFvIthDpNLhLJ100wNHoTzQWyZ5ez2rahCHCw47LVCfS/joBC6i5e7xU1hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=afGp/+mAEyfMRDtZn7sNwutS+x/xGX9+q8ObxdfNPuA=;
	b=pQz02NmQFKeHRR5O+plmiiFsYkF58My227utLTzK7i4K1EwX+K5YuLM/9+72B/Hi6unT
	 GcoKdI9C8kqElLj6SJZnX9y2HEp8/TGiWtFFN0IwaElacQCAAIHRTuoWlGpflCESm+Ktr
	 ucrOOVQfRCxi0WyYr4QvFYGajcGt/YOZ4B/C53KyQW063bZ+nlKGUmgE3POdnk97PdnDh
	 XEyZSqgh3FdHDaJHuDVkvoX5T2kNGWeokmY/zbfwqAzzP/X/IdZq8jqiCktN+h5eDMC+c
	 mISkodCc19kULecWyh3NKU+m5o+QlIH9k6PsNg9vt62DWMgwtaZul6XNnEvMFq8DTUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2ZMgk3B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C106082BCA;
	Sat,  7 Nov 2026 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2ZMgk3B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174F31F008A3;
	Sat,  7 Nov 2026 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064270;
	bh=afGp/+mAEyfMRDtZn7sNwutS+x/xGX9+q8ObxdfNPuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2ZMgk3BPlP7fItfcv3TYl/a55LIbUOOq++P4zZaoq+jJNlfWTxUI1WVDxN43jvaF
	 lN8vC2A9XVRUDuK5+51EGTaQDKqHFRiunErjDdVyQiRlnzxH91XEcM5cxaLQvvB8fS
	 tf4Rz4PSZRzRAKXPcoY623MMwF31q4yxX3Svcw/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0367/1257] media: iris: Fix power-off ordering to disable power domain after clocks
Date: Sat,  7 Nov 2026 08:44:23 -0500
Message-ID: <20261107134949.709854110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 9cfae7726a9a9f526e8905dbddde355be2674e3d ]

In iris_vpu_power_off_hw(), iris_disable_power_domains() was called
before the associated clocks (IRIS_BSE_HW_CLK, IRIS_HW_AHB_CLK,
IRIS_HW_CLK) were disabled and unprepared. This reverses the correct
power-down sequence: with the power domain already removed, the
subsequent clk_disable_unprepare() calls end up operating on
clock-controller hardware that is no longer powered, which can hang
or behave unpredictably.

Reorder the calls so iris_disable_power_domains() runs after all
three clocks are disabled, ensuring clocks are always turned off
while their power domain is still active, and mirroring the reverse
of the power-on sequence.

Fixes: bb8a95aa038e ("media: iris: implement power management")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vpu_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vpu_common.c b/drivers/media/platform/qcom/iris/iris_vpu_common.c
index 2ef8004e976e3..c9f5dc851d9f7 100644
--- a/drivers/media/platform/qcom/iris/iris_vpu_common.c
+++ b/drivers/media/platform/qcom/iris/iris_vpu_common.c
@@ -223,10 +223,10 @@ int iris_vpu_power_off_controller(struct iris_core *core)
 void iris_vpu_power_off_hw(struct iris_core *core)
 {
 	dev_pm_genpd_set_hwmode(core->pmdomain_tbl->pd_devs[IRIS_HW_POWER_DOMAIN], false);
-	iris_disable_power_domains(core, core->pmdomain_tbl->pd_devs[IRIS_HW_POWER_DOMAIN]);
 	iris_disable_unprepare_clock(core, IRIS_BSE_HW_CLK);
 	iris_disable_unprepare_clock(core, IRIS_HW_AHB_CLK);
 	iris_disable_unprepare_clock(core, IRIS_HW_CLK);
+	iris_disable_power_domains(core, core->pmdomain_tbl->pd_devs[IRIS_HW_POWER_DOMAIN]);
 }
 
 void iris_vpu_power_off(struct iris_core *core)
-- 
2.53.0



