Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062716;
	b=NtlH7qf5IENl1h5TdA4IzjpVL61waUuK3TN3LBpELXY+scDTR/A3k+JGIxsdQ0nmMEZX
	 hkny5wGwSb6xIxY3aPlXeTRAZZbV71XKq2brYZSjMB4HRe+hCznLf1CWc5+WlnvEs+MhK
	 pwn7zEUUPm8o3/qP8Ox/cqBKaFk+nobrhIBzLSNYDqYMrnWwuAVpVUU7oifFyy6GMv6g6
	 iAgJxIU6eXaPrI/sKTxxggb5MzzzIGlwFRNIn1U/ENCPaC5WU05UUmRpsp8LaqdIQ7J/1
	 d5HlGMEQTpeIkbsToKmFWbtIBzDv+2QH9sYDlni28O0UZBTT+5UJnwcJOW5DtV3WqEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z6468zWWBZbbbvcrz7j6Ji8T843eLmaA09Ez+7OrY9o=;
	b=tU/E3oe2vteqeZbNxrbYNMzsw3U+qFs/3BdNVL4IBokkdjdnjPUN5sJELl9qZlV5a1Tj
	 INF2hA1Hb+k8SXUatTfqaSSptl1DkHcSpDvSARPigsCQVkWTVappRFux/1UWXevANuOCU
	 ynS+grJbbfXMDLCAOCTy0yWX2vbBP+QnPh7PraAkobvw8JcOfDpXIyD79JkwLFlBxgmEL
	 h3EYfKZJBrtMnlJJDAy5yE/fu41Dk1IlEP8W5wND8h/yXcI3nQ69tgkx/9hZiQ3fjmfWG
	 sbEEZ1it3LBTyDZnmLiZbQvspTbMZpOkSEmxymn9DB0sf+bwJZfouVz907HnGyGGkxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i89DcmTY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC2D606A336;
	Sat,  7 Nov 2026 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i89DcmTY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242601F0089F;
	Sat,  7 Nov 2026 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062716;
	bh=z6468zWWBZbbbvcrz7j6Ji8T843eLmaA09Ez+7OrY9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i89DcmTYbk4lW1v6qqbn0Z0D0/ySDGhOFSVCWLK9vtpH+gSkunNo6tA5Wty1e1YNz
	 CLPl97+qQyVhDKgyd69prGL8vmYCk3ja6FCTqjOkNcNY7mDIk8Vcy3cysF18Yn2TZw
	 E4WIAEEGcvN1qaHVFzlvma309Pc2WwVqLxpfWMFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/869] media: meson-ir-tx: Ensure rc_free_device() is called on unbind
Date: Sat,  7 Nov 2026 08:45:18 -0500
Message-ID: <20261107134853.403998122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 32999b8a9d5c4f497c9739e70ac4ee390cd650a7 ]

Make rc_dev devm managed.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 6beb9e97453dd..e8e3c1a303279 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -346,7 +346,7 @@ static int meson_irtx_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "irq request failed\n");
 
-	rc = rc_allocate_device(RC_DRIVER_IR_RAW_TX);
+	rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW_TX);
 	if (!rc)
 		return -ENOMEM;
 
@@ -359,10 +359,8 @@ static int meson_irtx_probe(struct platform_device *pdev)
 	rc->s_tx_duty_cycle = meson_irtx_set_duty_cycle;
 
 	ret = devm_rc_register_device(dev, rc);
-	if (ret < 0) {
-		rc_free_device(rc);
+	if (ret < 0)
 		return dev_err_probe(dev, ret, "rc_dev registration failed\n");
-	}
 
 	return 0;
 }
-- 
2.53.0



