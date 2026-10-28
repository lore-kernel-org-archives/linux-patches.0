Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215284;
	b=UcXPlIXspOy8S22WWYsD9MSFWk1CC31GaJ9YB3nixLvQqDF//il0nA1R12oD/EA035B4
	 Sur46su7CHAEFu2slML6zKa4oNJeLH47HN6IV8pvXFEGD3YriGQAkqPdRm4lvcpwBFUpq
	 Ztr2mk2M3uPWW139M8uluBCvSCU8aEiddMz5UZUh0bbrnmAk24QUixSbyC7gXD0ip0EEC
	 dw6YJ4/AWX643wyDD03ArEtbgOpTkYyVptDOu90JS66jF8LPW6+zyKFakDX5nYVm7sZYK
	 XzLzN8EEXz1LbY2sqiT/4qNiHB5lnt9Cn1s51wbuzFT5taHQK6tb316U7uaHg+wlyKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NzmbXl/F2F1MUFc+Ca1LnBbRdKZNBU/60Uq6zPxAJoo=;
	b=ZQmdXI+TqkuZH5zpIq9J5FS3lauQTWnqrMtoXXnIRd5PArCTHKAwraf/yUhxVSRNLrpz
	 c088bf0XYuZ95leUCHdgTV5fsYfKFVBjlUUcz1KYhxlUnVOFWZoL1cvE8qenE1BK+q07W
	 6vbWg8VISaxkKZNJl68i3cs8uZsSl2WnWPkmt58fu+spZusDSwU+xN54w5p2j7UB75kBx
	 i+xQYiyBu2aQUmAK9aPHbwEc8+8ueRbxhFdke2Rf7a3iPi+KvEQmlD2E+OvlKRmQQgkH4
	 zHghVKOHObX8FtqejqLDgpa9PFGL9CvobGf0WfnBPYRQ/2RJTXcAn83Dp7NG+tWLuhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQkwlUbm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B644606A31A;
	Wed, 28 Oct 2026 19:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQkwlUbm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AA31F01825;
	Wed, 28 Oct 2026 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215284;
	bh=NzmbXl/F2F1MUFc+Ca1LnBbRdKZNBU/60Uq6zPxAJoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQkwlUbmdH77rlVD39jAVIAN3GKMJywOrcuMfobF54SOn/Pi4X0tP9pkyRmmQyawB
	 SdhkMoJTrG2A03wNddwNUU0w4fh7cSwjqM+D5DoPIvMpSXAjenRgwZgRD1pXpIQcPF
	 iGfg/k3ys51hpCoG6KDrIrHm4lJrgsieQ2Mx1StU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1157/1887] usb: typec: tcpci_rt1711h: unregister TCPCI port with devres
Date: Wed, 28 Oct 2026 17:54:13 +0100
Message-ID: <20261028170525.735004195@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit e8da46d99d3710106e7c44db14566bf9b57386b5 ]

rt1711h_probe() registers the TCPCI port before requesting the interrupt
and enabling alert interrupts. If either of those later steps fails, the
probe function returns without unregistering the TCPCI port. The explicit
unregister currently only happens from the remove callback.

Register a devres action immediately after tcpci_register_port() succeeds,
so tcpci_unregister_port() runs on later probe failures and on driver
detach. Drop the remove callback to avoid unregistering the same port
twice.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 302c570bf36e ("usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260706145312.37260-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci_rt1711h.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_rt1711h.c b/drivers/usb/typec/tcpm/tcpci_rt1711h.c
index d608fefd4f30e..8fdffec401e08 100644
--- a/drivers/usb/typec/tcpm/tcpci_rt1711h.c
+++ b/drivers/usb/typec/tcpm/tcpci_rt1711h.c
@@ -327,6 +327,8 @@ static int rt1711h_check_revision(struct i2c_client *i2c, struct rt1711h_chip *c
 	return ret;
 }
 
+static void rt1711h_unregister_tcpci_port(void *tcpci);
+
 static int rt1711h_probe(struct i2c_client *client,
 			 const struct i2c_device_id *i2c_id)
 {
@@ -379,6 +381,10 @@ static int rt1711h_probe(struct i2c_client *client,
 	if (IS_ERR_OR_NULL(chip->tcpci))
 		return PTR_ERR(chip->tcpci);
 
+	ret = devm_add_action_or_reset(chip->dev, rt1711h_unregister_tcpci_port, chip->tcpci);
+	if (ret)
+		return ret;
+
 	ret = devm_request_threaded_irq(chip->dev, client->irq, NULL,
 					rt1711h_irq,
 					IRQF_ONESHOT | IRQF_TRIGGER_LOW,
@@ -396,11 +402,9 @@ static int rt1711h_probe(struct i2c_client *client,
 	return 0;
 }
 
-static void rt1711h_remove(struct i2c_client *client)
+static void rt1711h_unregister_tcpci_port(void *tcpci)
 {
-	struct rt1711h_chip *chip = i2c_get_clientdata(client);
-
-	tcpci_unregister_port(chip->tcpci);
+	tcpci_unregister_port(tcpci);
 }
 
 static const struct i2c_device_id rt1711h_id[] = {
@@ -425,7 +429,6 @@ static struct i2c_driver rt1711h_i2c_driver = {
 		.of_match_table = of_match_ptr(rt1711h_of_match),
 	},
 	.probe = rt1711h_probe,
-	.remove = rt1711h_remove,
 	.id_table = rt1711h_id,
 };
 module_i2c_driver(rt1711h_i2c_driver);
-- 
2.53.0



