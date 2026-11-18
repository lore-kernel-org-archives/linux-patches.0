Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047812;
	b=4H+zuNXBFUtySgxzaU4EmTFdswGJEGUJ9w7ffAyxIahQoiPW3BHIM2bDbt5umxKrOrtQ
	 omzdOqtn+rIAETLBrLZHUyED+sXWnsT64wACfgYgiOIoHkQUnrVLcvIll6u3QqTN3ovM5
	 9tNsD5mlkY/HGBhB7iMiKyr8urPDt0EWFgBclzwyH1YsSLbQiYEnSB5Ju7NfEOe6KrB/X
	 gPUpd4HUaylGYkRB93pCb8CgpMx285nnMI9MV/HDay15weroG+miM4gCIT2osj3kwp7z6
	 bdNuY0sFTyXbOcx2RAVQOeiReVsCe1rnsAAKIRUmEsrAx1gqgxyuLybndsTeywR9j3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=25MU9iqRo0P5Xxl0nAYzCbPmQMFsgPhKDUt4llFxfJ4=;
	b=u0Ars2W/t93mP92M/V26jRwCNeTWopc45Ks8ixqUboM/tEWxjJw1q1ALD4QFXhQaZcbL
	 1kczEy12LMQz7ZbOFSyf24QunGg4/HufXdzxbSL3RqGQbWFlobb0J5gkI2ttcVRRWdlGi
	 IHEKYtqVxDjZ8D7/SxlvLUD8vZJ1Wqrrk16v3v9X9Jvnjh8rmSi3gY4t4BHKiZTmChyAB
	 29lfU+gP6g2jUKh/Ts/bEDLYtXa1zHLMxFyAZNL3xQ6qsYWvkOLjbRB9ovPbS0bTga3mQ
	 e0T3blSBt0GA/a1Bo3YrM8mzQ7ZKiN5Xo9MamlVln3f2RDN7Gt750rFDizFA2nGYIkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fw1YS/+X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009B1606A32A;
	Thu, 19 Nov 2026 00:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fw1YS/+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096531F000C4;
	Thu, 19 Nov 2026 00:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047811;
	bh=25MU9iqRo0P5Xxl0nAYzCbPmQMFsgPhKDUt4llFxfJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fw1YS/+XMc2SRiEBunyXzoUgWN1ieVNfifKswU6iKD+IEYHjjGbdTyqqMyyQBuLGR
	 C0no9jxX9ikm90zv4sVT2eTagSx2Hy1TpkgZYUQO9S/B6J4eJerWcVlJsRygwZ2Mx9
	 uTb0azoVu+lvwwxMpt0+kJj4KNw/EiYE3OxagOq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1731/2857] regulator: fixed: reject incompatible platform devices
Date: Wed, 18 Nov 2026 15:46:05 +0100
Message-ID: <20261118150303.642876635@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandradhar Kumar <chandradhar.2003@gmail.com>

[ Upstream commit f7396c2dbbc1bed6c2c554d1ddf80d16e4780a7d ]

The fixed regulator driver expects non-DT platform devices to provide
their configuration through platform_data as a struct fixed_voltage_config.

An explicitly bound driver can bypass the normal platform device/driver
matching and attach the fixed regulator driver to an unrelated platform
device. This causes the driver's platform_data to be interpreted as a
struct fixed_voltage_config even though it contains data for a different
device.

Reject non-DT platform devices whose name does not match the fixed
regulator driver before accessing their platform data.

Fixes: 4b74ff651249 ("regulator: add support for fixed regulators.")
Reported-by: syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=bfc9e55cf4f98183c636
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
Link: https://patch.msgid.link/20260822065519.112441-1-chandradhar.2003@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index e273275e60259..ddaff8579c889 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -29,6 +29,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/machine.h>
 #include <linux/clk.h>
+#include <linux/string.h>
 
 
 struct fixed_voltage_data {
@@ -182,6 +183,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	enum gpiod_flags gflags;
 	int ret;
 
+	if (!pdev->dev.of_node && strcmp(pdev->name, "reg-fixed-voltage"))
+		return -ENODEV;
+
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct fixed_voltage_data),
 			       GFP_KERNEL);
 	if (!drvdata)
-- 
2.53.0



