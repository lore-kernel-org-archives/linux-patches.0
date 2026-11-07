Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063814;
	b=EqMltslBVe5C55TuhPLwCWKeKq47GHGUlTdb3HPiAQjcT5UT7o/cpqUZmhq8FZ4Snl52
	 EitDJ5p2LUuplOuAE0U5AxgBMFciXQd8tzWRoYLWkHIMbmuQQLpkPfHYvqMiEvBN8D0yh
	 uB3YtGle698SJ8HMjz7S+kUaDySCpuBi/xAIFJh7UBGpc5j4mhci2j2iidUt9/Cbh2QGO
	 cfUb5c3zGn635GfigxWWFRGlYK2gVOZl1xh8ByneeFoLpijcymlOGMNGuX8Z0FTKZaKb4
	 OQXOJCOF63e9W3cTU0L7vKxepKXhuqA3bm8xrKUcdwNsm3Qq2wazYCH5f4BvdU3cxSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qr0J/Doc8chmfNfTZXxEjG61AWxRzBDXCKsDo6kdhHE=;
	b=oPsDgcBfvwXGhoKE2Yne2m36G5KO9rvNV2NAH+ERrjWdeOtd1Ls3zJqdxg60QRJdu1DH
	 2VPJVm79zH15q6w4HW/BGpXRANvmyXoPUmTh2bTP4ae24GO7HcrWrFAvghVn/V3iq4NbQ
	 AkDPd7o4u3dOc+IgabjLgbILfFCepNexFPlhpJ8QvKeLziGtpSxX/q+mQyVWgd4pBFc3X
	 8N4gSVHJQbxcH/xGzf5iT7oO+jfoOAL63zu9dju93wosleaNLtCVlkGCX1Q8qp8YZ926f
	 vTG8zoXVhWSrp33IdCYi0ThMAyv11TbhMe/0a2nd2K2ELwfsuy6k7ubzt8uy5b3xUjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTUODynF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA88606EEA3;
	Sat,  7 Nov 2026 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTUODynF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966541F008A3;
	Sat,  7 Nov 2026 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063813;
	bh=Qr0J/Doc8chmfNfTZXxEjG61AWxRzBDXCKsDo6kdhHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTUODynFFLnRfqWjymd9C83h/H2Pg2BHoYxcQCUcI8eTbgI3ub0d1Tq+RbMY0PsR/
	 NIV1O9JQPC6A8MW8lLG9crRplSOK4rvyvl9+J7/RG8M0Nrh6fWvMHf34MSWKhwxxnA
	 x1ewbuQAFJRO/h+4dw089L2V2GB5OyyPp8c5RZNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0031/1257] media: meson-ir-tx: Ensure rc_free_device() is called on unbind
Date: Sat,  7 Nov 2026 08:38:47 -0500
Message-ID: <20261107134940.267078438@linuxfoundation.org>
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



