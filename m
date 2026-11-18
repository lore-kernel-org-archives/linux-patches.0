Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039122;
	b=Z2a+wKQq+p2Xn2YBPY8KFhss1ca0wSnrtBGGQjHio3JmMgTxgVZLanZH2nRwsAVI1x2Q
	 /VADgnXJ6F+aG7HNqc6LMW35kjbt52YOY2aMKOScj5fZA7+McPWWOSw6WNQNVtixfuC1H
	 d2rUnLZiIqzQPrf8qnCIhkpE0BY3HjaFOG/4++M9pUH9GcO3N0d7d2NNpZqqtvrxZ26dD
	 27cZ/QIzx0p6TUOrdGHU/KhNTtw6BY+z+CI/cCSH7UdAs+yiHllRa2fMR3i5D0b30XED1
	 JDUQHZbablNid2yg4dlB/awwbanNo1BKzg+e1L+eERj76ngANn17m+PufeOVs8G+fHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ayDpKPbSeHTEOkcQtG/DRA8KRHgaddnmgtucnDsf4A=;
	b=3YmgN90kDoa3kDUm44o1o2OLnlX4zta5M41rMNyCcfOFJ52J2xN9bQkDWZzbWy0nKYBY
	 7HvUw2WWN8h/+daFDLKuyRIVoP4TNM06KmT/IQ1FolFANGaTEhRY24S3ryTQnG40/2OSU
	 yNLg5jMVpTV1EML/TrwLm3ik2AUENTCPMsjYL2OuWwu70lXLd/QpiN/4c/T10aUakyqQY
	 ZwbDbSjm5tkukp7Mpv+sZ/MclUMAzJhdGQEcvhn77EAmZrVlW5QtkHqFGx7zQcyCNPiV/
	 8qtJQgSv0yIxQ+tIU4EpX6/XSBh606bz0uGNewVb2dtHxAaLEaXkgRJ5KwNNbbyhLLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3NjzTY+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1907606A31C;
	Wed, 18 Nov 2026 21:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3NjzTY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9871F000C4;
	Wed, 18 Nov 2026 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039122;
	bh=4ayDpKPbSeHTEOkcQtG/DRA8KRHgaddnmgtucnDsf4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3NjzTY+6F4/PMArxFUndbC3nV2PVs4EoQ8ZrbjG7x+dCDhhEg/pFkMs+Jj7BL5RO
	 WIghIN4tvwnDJB04J2bjEpluA1KIPpAlT9Z8ydXFsXrRUbtIy+CLHH6yIKmCF+CRl+
	 JujoyYD2ntz0yhuqjQ4E/VP0d1kYG9GS9DmAExOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1987/3318] regulator: fixed: reject incompatible platform devices
Date: Wed, 18 Nov 2026 15:43:29 +0100
Message-ID: <20261118150421.675370034@linuxfoundation.org>
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
index 4477bdeb9e60f..8a92257668458 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -28,6 +28,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/machine.h>
 #include <linux/clk.h>
+#include <linux/string.h>
 
 
 struct fixed_voltage_data {
@@ -181,6 +182,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
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



