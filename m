Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025480;
	b=uI/yiT6RpnF03fhfZa33hgL7hudGzf/i86N+jaBjyV0ZO+Lb+QN75wnTMGmdAmDVdNWt
	 a3fl8ooGbn/933t+z8I46zoAMc0GSYbSjD2HBlSCROM7TkP5VoxxKkPjJx2BUZ0Jw3Rmb
	 oBJ+6fEMX03ObsvUafQhwYLaTJ1b0K5nbw1CyrEm6vPMHIryOU3LwHBbasR1VdT7i2FEe
	 pwNbfSnsTZlVo69FuiKZig0Db87Yn5JhPyb+kp+TgVjfrDiHBE6n88rjS3Njm87Tx2DwW
	 RwYsEW8ZPtSk/yqhON4IOcKX2meHWUcabZ/yYABTQpDk0ufYF9MXJ/++ycGWJFZtx/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z3dplA3Rzj3e2z2Yl/GIzQjKvEpry0i11kI18OupZ3o=;
	b=Q5HdnhXeCMMhkKnBMxxWSBSNVJbDQvGvR2WUHMc3KYqqEM8SzbbEvMyp+wKBgjCSAoX0
	 AgDbAhINiTwFLzCgMvLc4RMqc74GfzwO1kPp6zuUYjvfSYAsXK81rCsaDAfGRPXQSA/LJ
	 PFmwA1B4xfClVgCGOPSKMGEW4MSzaDMMkrm0A/HxlVn718MQIIjARln+RB5bfjmQUhPuB
	 HiBjdBNqoFtuTQG0dt1IWkjpHQeqSr88ojGYYZZIXrLyHfWHlz+EvaIeaqAqbM2fUzLXs
	 xBinO3D+mzufQE+mrQRnc+Hq9WKit9B9i+0FZM1xZ24Jy7gfeNtHZg4+M0xpQVWVSXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QI6FqtHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A757F606A32C;
	Wed, 18 Nov 2026 18:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QI6FqtHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77DE1F000C4;
	Wed, 18 Nov 2026 18:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025480;
	bh=Z3dplA3Rzj3e2z2Yl/GIzQjKvEpry0i11kI18OupZ3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QI6FqtHA/8V0j6hbcwyXi+NDDSFrs+KI2EaQxRPpA67iPmdbn4WZXeUSDRrXBFEoL
	 PHay0pQfV7P9gNBZ58nXyLFzHcNdo1AuVLv9eFRnoC5Yx5YYU21PplNmYL4Pnea7gx
	 5RWxqBKUcATXl2gIG3FYy69pVw8O0BMlyJEWRwsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1093/2151] soc: qcom: pmic_pdcharger_ulog: prevent work requeue during remove
Date: Wed, 18 Nov 2026 15:47:08 +0100
Message-ID: <20261118150202.091190274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit 66894a1c51366cc2d5c498178105dfe3bcccc1e4 ]

pmic_pdcharger_ulog_rpmsg_remove() cancels the delayed worker while the
RPMsg endpoint can still deliver callbacks. The RPMsg core invokes the
driver remove callback before destroying the endpoint, so a response
callback can run after cancel_delayed_work_sync() returns and queue the
worker again.

Device cleanup then frees the devm-allocated pmic_pdcharger_ulog while the
requeued delayed work still embeds and dereferences that object. KASAN
reports a slab-use-after-free in pmic_pdcharger_ulog_work().

Use disable_delayed_work_sync() to drain the worker and reject queue
attempts that race with removal.

The issue was reproduced in four of four runs with the real target driver,
RPMsg bus removal, endpoint teardown, workqueue code and devres cleanup.
The test provider delivered a valid response in the window between the
driver remove callback and endpoint destruction. With this change, the
same late callback occurred in four of four runs without a KASAN report,
warning, Oops or panic.

The reproducer uses a test RPMsg provider to control the teardown timing.
No unprivileged trigger or physical Qualcomm-device result is claimed.

Fixes: 086fdb48bc65 ("soc: qcom: add ADSP PDCharger ULOG driver")
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260912161210.1683266-1-lhfff@tju.edu.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_pdcharger_ulog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pmic_pdcharger_ulog.c b/drivers/soc/qcom/pmic_pdcharger_ulog.c
index 39f412bbf2c1e..06cd9c4411c2f 100644
--- a/drivers/soc/qcom/pmic_pdcharger_ulog.c
+++ b/drivers/soc/qcom/pmic_pdcharger_ulog.c
@@ -143,7 +143,7 @@ static void pmic_pdcharger_ulog_rpmsg_remove(struct rpmsg_device *rpdev)
 {
 	struct pmic_pdcharger_ulog *pg = dev_get_drvdata(&rpdev->dev);
 
-	cancel_delayed_work_sync(&pg->ulog_work);
+	disable_delayed_work_sync(&pg->ulog_work);
 }
 
 static const struct rpmsg_device_id pmic_pdcharger_ulog_rpmsg_id_match[] = {
-- 
2.53.0



