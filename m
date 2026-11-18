Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034755;
	b=DHUGC5JGwq6LP2SPboLjqNXrrPL4We8CJLiTksAVqf8Zp12PnZkQCCIb6taqGOHpVN/y
	 RBe186XpgBPD1+SzmgpwcLyWQBcawdr2tyr4o3mvpiZUdUpWEwYiroVlhCywadOdI+oqY
	 OjWL30h9nf8S8pq+YaT0a99Lp1u3TyGGltD8aPt/NERkOtOgS0p4Zkh6x/wFxeqvKpBT0
	 aJlol1mVBtassB6DBgUeV4uqoFvi0BlbnokmjTtJIBtz450dYbrI8rJ2YqIhT6/7LxYcm
	 TdhaRZGay3HiKNpEONadE01QcchUOWrE/y3yNhCTosoWxYIis8J+YinIJh88ZByux0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aan/r8Gnjj2pF729jgND7YTloS9EY3v1VNl9LHioF60=;
	b=17lbN4QixNqmWAMNHylGGAzoTn5bDbAT6mcd5+wasSwO8Zmi7O4vVRUs/rpoHyZ+KBd6
	 5PZ0DfNQrxy/HqiJALCtsGZKVmsxgsghjJ1b5igWilA3tSEB3IIPfTeUFsrwaKc/Hc6ZK
	 f4XYtNCAfxqPHIvcV973Vb0IuQOD1sHyZVxGJDvEDBYcT8UimiTbVs+qrai3Allgpo0Qp
	 HAGfXrNFiXvs9Zfs3mVxe01dwXRMI30FOTYm7fS3RG/DpdnleqjLZXIHsQvHUZvuWwtZJ
	 m8KJL2ljDkNAc7pwHRTSSp2nmDoT3TfDsBwGH4+pvqVs3B1eElzSmztYSNG+hqoZmTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bfq2JANU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C0F606A31C;
	Wed, 18 Nov 2026 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bfq2JANU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157111F000C4;
	Wed, 18 Nov 2026 20:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034755;
	bh=aan/r8Gnjj2pF729jgND7YTloS9EY3v1VNl9LHioF60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bfq2JANUHCOdQtjWBqh/3jiwi4bGhUDzDljIoDdA7GMWxoXMYU2S1HLf8X31VjQEM
	 Rdj1TFerGAr77OqbYuljl60VChYq6xDP7dKQHiNeTz+1faKEmE4NBveBe6p6Dy012W
	 KVYgM8fqEpQfqXav2dqy6/kVkiVS60smrEKlFq4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0435/3318] i2c: qcom-cci: fix autosuspend cleanup
Date: Wed, 18 Nov 2026 15:17:37 +0100
Message-ID: <20261118150329.710117015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f98d4986482151a835b521a734722fe8dc5ca37d ]

cci_probe() calls pm_runtime_use_autosuspend(), but the remove path
does not call the matching pm_runtime_dont_use_autosuspend() before
disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without undoing the autosuspend setting during
teardown, this reference is not dropped and usage_count remains
unbalanced.

Use devm_pm_runtime_set_active_enabled() to manage the runtime PM
state. Its managed cleanup disables autosuspend and runtime PM and
restores the suspended state on probe failure and driver removal.
Remove the now redundant manual runtime PM cleanup.

This issue was found by manual code inspection.

Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260812094425.3515179-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index cd2fe0cb77bdd..c73cf7abe5832 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -635,9 +635,11 @@ static int cci_probe(struct platform_device *pdev)
 	cci_init(cci);
 
 	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
+	ret = devm_pm_runtime_set_active_enabled(dev);
+	if (ret)
+		goto disable_clocks;
+
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
 
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (!cci->master[i].cci)
@@ -653,8 +655,6 @@ static int cci_probe(struct platform_device *pdev)
 	return 0;
 
 error_i2c:
-	pm_runtime_disable(dev);
-	pm_runtime_dont_use_autosuspend(dev);
 
 	for (--i ; i >= 0; i--) {
 		if (cci->master[i].cci) {
@@ -680,9 +680,6 @@ static void cci_remove(struct platform_device *pdev)
 			cci_halt(cci, i);
 		}
 	}
-
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 }
 
 static const struct cci_data cci_v1_data = {
-- 
2.53.0



