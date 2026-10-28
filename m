Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214590;
	b=yuEuvJIygq01XtoED64KZauIhpmc6MoXAkI6WwDzVbZPmQmlzLN+Z9ETAv1hFBjqgEWd
	 KSAqLecQq4XWVb+BNC5QbDrcjo0+rqszCBOShEXhTNE/kqxdSM3+tTu4T8oy801aXM+9i
	 acyNpUcRgxmnACx4QDssDHvTDgXA2/biwvSXwLTpKH2WXd3SG8/cJDSCS4J/L52ASnfRG
	 RodWbEWdiLZseEt+wIrf+1BzEct/VtEWJTi/O6324h+PvQEjkiC5LTnyVevh8VFxXlk4r
	 uC99Sm+VscP7B3LuckIzWQVty3r2ReldVhRp30GVrQs7Sn0BdRcyjGM0jZdDfhVWNWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=urvDCydyjPyPm5hrcZ3BY4oRjrohPxBRahLXSitn1e0=;
	b=oKEUpaKUrGpRJXuCZnwnSPQk8ki39Mu/BEd5SnzPySgrnroQkVLvauShzFrS7iCT/gr7
	 qh2FOM06PMwG15G5EzKWcqJsRloquqt+4m1Geuke49E+iP6qhEZeiqUjtGWGZQvKGOA4E
	 H3xYjwVKfzi5CdBIIwTW76EX7P+zKh0ZcohKFPUP+X9yr3ynezYLzBMGrMHAAyHuMm6Z2
	 NEwbIqjovfVPy9snzvSPBO2HuiFj2hK9lE2xIqfyrBco3qkegvJqvwTanK1hsmSeUtK0v
	 4EEHii268lRQivDVGNlZGMocQoNshG8hlPh5xkwOVIaBPu1O5aUmg/wUtZASaf7fEDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UnU//pBV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17B4606AB01;
	Wed, 28 Oct 2026 19:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnU//pBV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBED1F031E3;
	Wed, 28 Oct 2026 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214589;
	bh=urvDCydyjPyPm5hrcZ3BY4oRjrohPxBRahLXSitn1e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnU//pBVSEt8R7/jIfP2rCGPQcfAyDc2IAGhRpAQ4cnoRU6IPePW1jbKIFScy7dbt
	 qOsXspOrnweFbKzIh1wy5pYnLBe+MiWgexWG2WVS6NWuXB8oPZ9hM5fquaI5jt7rpt
	 6DVwUwomnnQyHTI3TVEkA9UbtZ1p0+I3aQnBeTGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0913/1887] phy: qcom-qusb2: Fix NULL pointer dereference on early suspend
Date: Wed, 28 Oct 2026 17:50:09 +0100
Message-ID: <20261028170520.192747479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 1ca52c0983c34fca506921791202ed5bdafd5306 ]

Enabling runtime PM before attaching the QPHY instance as driver data
can lead to a NULL pointer dereference in runtime PM callbacks that
expect valid driver data. There is a small window where the suspend
callback may run after PM runtime enabling and before runtime forbid.
This causes a sporadic crash during boot:

```
Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a1
[...]
CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted 6.16.7+ #116 PREEMPT
Workqueue: pm pm_runtime_work
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : qusb2_phy_runtime_suspend+0x14/0x1e0 [phy_qcom_qusb2]
lr : pm_generic_runtime_suspend+0x2c/0x44
[...]
```

Attach the QPHY instance as driver data before enabling runtime PM to
prevent NULL pointer dereference in runtime PM callbacks.

Reorder pm_runtime_enable() and pm_runtime_forbid() to prevent a
short window where an unnecessary runtime suspend can occur.

Use the devres-managed version to ensure PM runtime is symmetrically
disabled during driver removal for proper cleanup.

Fixes: 891a96f65ac3 ("phy: qcom-qusb2: Add support for runtime PM")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20251219085640.114473-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qusb2.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qusb2.c b/drivers/phy/qualcomm/phy-qcom-qusb2.c
index 2ef638b32e8f0..9ee689e3ae337 100644
--- a/drivers/phy/qualcomm/phy-qcom-qusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-qusb2.c
@@ -1061,31 +1061,31 @@ static int qusb2_phy_probe(struct platform_device *pdev)
 		or->hsdisc_trim.override = true;
 	}
 
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	dev_set_drvdata(dev, qphy);
+
 	/*
-	 * Prevent runtime pm from being ON by default. Users can enable
-	 * it using power/control in sysfs.
+	 * Enable runtime PM support, but forbid it by default.
+	 * Users can allow it again via the power/control attribute in sysfs.
 	 */
+	pm_runtime_set_active(dev);
 	pm_runtime_forbid(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	generic_phy = devm_phy_create(dev, NULL, &qusb2_phy_gen_ops);
 	if (IS_ERR(generic_phy)) {
 		ret = PTR_ERR(generic_phy);
 		dev_err(dev, "failed to create phy, %d\n", ret);
-		pm_runtime_disable(dev);
 		return ret;
 	}
 	qphy->phy = generic_phy;
 
-	dev_set_drvdata(dev, qphy);
 	phy_set_drvdata(generic_phy, qphy);
 
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 	if (!IS_ERR(phy_provider))
 		dev_info(dev, "Registered Qcom-QUSB2 phy\n");
-	else
-		pm_runtime_disable(dev);
 
 	return PTR_ERR_OR_ZERO(phy_provider);
 }
-- 
2.53.0



