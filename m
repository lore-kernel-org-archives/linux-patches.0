Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018672;
	b=CrSIKCOfpq4t+88yAJzpXHewnUScvGfrOUorOnvKCr10tJaaDXtd9/Z2Yej2XFnGckwu
	 jEm+x+KV8/ZTPAHGs6eYpI9KkKh19CzsaOd+3xKREWy+PiA/nT7HABCTjMZWpuzpr7Dob
	 bWx2vUbz8k0Vm5awK09zx9creCHxQBSLD7XmD0WoT3bszpwiYkePFUW4wnqeOEHVsAF0X
	 409sUitixoJ+hI0iZZ1sV7gqZuUtG43rG+dKvHdxyL9Br01FRj1JMdi/kxcKMsBDmBXSV
	 BiGQPvGZKC99p4uootARwf8RvxrAIAmvLpcNJFuKb0Qiyzl74jzmCzRFUapWiXT1EJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aw4cEBjlIDje7CAEIK4lkdYLR/SnLougemJWfOiq/eU=;
	b=Eid/pujwUhVobI2veyC3PPkssUfGncCvczdf3XhYX525jOJlt4iQ4K3CjJTrGOLZ0cMa
	 lBzKCzmqc0MhaZkH64Qo9L2vpEObsl+OxPCaiAhsYRAaSBElEE0ZRJ3c21KxLr84VfLqH
	 UYQVVwty1zg5KesL9hsaFPEqKIzGM+t5wRGuzrtzIe1WUlB5Oe1uTAL2PGY6CIlC4bD7+
	 XednSdFqtzh+odtWSZBTTTJquo4pb7pqLnmQNiwqYthfX3tlkAax9TY9Z7WJBTex1d6dL
	 iegBsw8F1wTRcEgxNpQXFKDo478+kRI7bTGM0kvnJYJp0gLpD2QAZtjFswjqLq/SOlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLJrutcc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672BC606A31C;
	Wed, 18 Nov 2026 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLJrutcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27811F000C6;
	Wed, 18 Nov 2026 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018672;
	bh=Aw4cEBjlIDje7CAEIK4lkdYLR/SnLougemJWfOiq/eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLJrutccAUq7/+8XRBGuo1+TdakpQoIBRe06wGtpoEHp6620xyV3taFs2RVigmJ6M
	 Ayr6Szk60Pz2SecVmvVIfPk55zDWbHE6n2GNMKL5Ogqdec9skzj6kK4eo7COiQTa0l
	 KMLpcrH7bi3D8n3E6avgsTaKXppvq+1aoEuLNoa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1306/2651] soc: qcom: pmic_pdcharger_ulog: prevent work requeue during remove
Date: Wed, 18 Nov 2026 15:42:26 +0100
Message-ID: <20261118150334.988803386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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



