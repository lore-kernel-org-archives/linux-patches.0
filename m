Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050283;
	b=ZIzygPImZmAnOiu1ZFDNSolCtvsxz/NkCsPiHD/hU0HpeDfp8BfNZl3witfxh9ebbIVH
	 AzPZHTOICoctTuCtNXYbalIiTp1r4kdQebGrxhUJP0G/BtPjcXT30+7jc8fWszZ7eSSqS
	 08RD/5soMv2T4uKYUJCvAYYfco4ZhbeLocts0xrepXqbAsrh7Vxg1+lkkSofjqAhOTQOI
	 P7BCOk0GfmvwZam/qLtURIDc4ucZSTG0Lh5p7JCf2qDjQxjeUV+lUC7eSpJmTE1++IXGi
	 cASGwsaO4/COowRy5TIpUb10xx3FsFlXwmfWNs/VzQTsLer6UB3a1aa8ywqcl7lFS0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vEqBdHSb7FqqDI8FASKEQAq5tH+SH3PamSqzKczOpQA=;
	b=jmQPbJ76qb0mI6ZbBM9cwomq5Lp7KdUZH525fCKpRuFAOvrpx5YNHrW3siLK69PQVT3k
	 UT86dKOpYZXcWWnT2N9GArFHVKFcrpE9EriSklKgT8cS+UYqOj1Pc++U2LR3JK23VDytE
	 bDNC3ff1lvBDfZESNKDI5IWo/ByQieHGqWgOTKLR8l2C7ZPxEYtjOoBwmUjhkslOWHj8b
	 RDvnA2ZKzuOEbWZLzM4qHVBYkqY+3bpnJrKpP89EhKji9mvChDKo13Z++a6tCA8OnjL1X
	 +DaPFRfoHHPFVLA/bY76qWb0piEMBltt/xBWSaRpk0PCU8izSbRhbdXa6VZPcPHU14Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJq827eD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92116606A330;
	Thu, 19 Nov 2026 01:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJq827eD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E088B1F000C4;
	Thu, 19 Nov 2026 01:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050283;
	bh=vEqBdHSb7FqqDI8FASKEQAq5tH+SH3PamSqzKczOpQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJq827eDpDkUmN78cDJ43BXvGwORiXEjawxATBQpAWn3Klg4SgZRimGGPXV3rUQ8C
	 PHlnF/suaMr2iBRegEzPwV05DQyi4vIie6sUkqyFVYLgvN3c/VMYg/+Y3dSjRX3zfk
	 aQ/5ODi6kTWDjmbDotWEjfqgZKOlB4a1j3FgBm4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2652/2857] platform/x86: gpd pocket fan: Cancel work before releasing GPIOs
Date: Wed, 18 Nov 2026 16:01:26 +0100
Message-ID: <20261118150337.076079753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9962770049c715fc30a7b3274d8f245167c0a410 ]

The fan worker changes the direction of both GPIOs and schedules its
next run. Its managed cancellation action is registered before the GPIOs
are acquired, so devres releases the GPIOs before cancelling the work. A
running worker can therefore change a GPIO after the driver has released
it.

Register the work cancellation action after both GPIO acquisitions. This
makes devres cancel and drain the worker before releasing either GPIO.
No work has been queued yet if GPIO acquisition or action registration
fails.

This issue was identified as part of our ongoing research while
reviewing kernel code.

Fixes: b82a7b018b93 ("platform/x86: gpd pocket fan: Clean-up by using managed work init")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/179229442299.3956787.17526066623947466315.gpd-pocket-fan@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gpd-pocket-fan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/gpd-pocket-fan.c b/drivers/platform/x86/gpd-pocket-fan.c
index 7a20f68ae2061..01f9676fc0f43 100644
--- a/drivers/platform/x86/gpd-pocket-fan.c
+++ b/drivers/platform/x86/gpd-pocket-fan.c
@@ -153,10 +153,6 @@ static int gpd_pocket_fan_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	fan->dev = &pdev->dev;
-	ret = devm_delayed_work_autocancel(&pdev->dev, &fan->work,
-					   gpd_pocket_fan_worker);
-	if (ret)
-		return ret;
 
 	/* Note this returns a "weak" reference which we don't need to free */
 	fan->dts0 = thermal_zone_get_zone_by_name("soc_dts0");
@@ -175,6 +171,11 @@ static int gpd_pocket_fan_probe(struct platform_device *pdev)
 	if (IS_ERR(fan->gpio1))
 		return PTR_ERR(fan->gpio1);
 
+	ret = devm_delayed_work_autocancel(&pdev->dev, &fan->work,
+					   gpd_pocket_fan_worker);
+	if (ret)
+		return ret;
+
 	gpd_pocket_fan_force_update(fan);
 
 	platform_set_drvdata(pdev, fan);
-- 
2.53.0



