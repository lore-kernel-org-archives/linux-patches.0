Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015199;
	b=VQtYF6i9hoXS8JE1Gn/2OY39wZgvQcVt0muqg/kuuLCTxI1PrWZBLqAgbUtkmFFyNmKd
	 D1roP6Hdtaazc6WQ86NFYjdrtFk8CCfCYhq/nnFm0JV9dRf3Do+Gpg+AIeVl2FmayDkZo
	 vDHarbxGHA6MediLFNbh4i4jFgimVsRfyfxPJ8fk1Vs3AWCCm9rwpYD4CJBd5FxgAi/I5
	 /wknOZTM21UmaTwQML9ez5Su+avaRRnJmBDGKSdWsM3MEIMZLqpj4bEdDf4/JEXpshs/e
	 NzpSJ5oa1yWJsnCnAH7T4nI51kWMJm+t//A85KYpy6E98YFLnyvhwYetf3OHIhgKhYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y6bUUUqqJQTSy4bsLYyA+YOR3hKdF0Z0QxJ54Enyzik=;
	b=qXDz4JuoicGhFDF5JPRam1gXoWK0VYQV5w8GKXo23i56doLh0DjaryKSRXthpmRPIOZ0
	 jSPHbt/lFh4v0/eqj8oZPmvom4KLDYg+qsGI+OzIEkZ0CbrESnNA7CQxQ/hNzq2Knhe8V
	 nQ5dCI81pdGh9ky120cH4z9FPfRT0uNwZZ3ZlFmtxLKnqOM66j5N2LFTT3/4l5vr7HJ/G
	 vO9WubaqqpvfigjG0nGf//i36Pzqg63moCUrKOfC/r3Wfm3BCFxi4x8v8b8hF8fdk9tgw
	 3PR/J7LVrm/VEW0bTpuk7ZhecPs56fUDq88EXS7rMk9zilnc8vxNaj9njhJ3M5zfDWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVF2vn9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182DA60A2619;
	Wed, 18 Nov 2026 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVF2vn9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD181F000C9;
	Wed, 18 Nov 2026 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015198;
	bh=Y6bUUUqqJQTSy4bsLYyA+YOR3hKdF0Z0QxJ54Enyzik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVF2vn9GbcKRmdnvhYkk3ALCASYdfd1gllObbZfHtVlXp90bJYT039xMLqSJByX2V
	 kGKFJinxqTrX9N7B06hzChW9SjL3UOhcDgPezVBbI2YMqqiiMiXDhCYQl1gVEmjvWR
	 9BfXncVhR7LQyM0KpuHEZTOgEYXZH2RpEv7V7Ees=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0089/2651] regulator: fixed: reject incompatible platform devices
Date: Wed, 18 Nov 2026 15:22:09 +0100
Message-ID: <20261118150251.115520683@linuxfoundation.org>
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
index 417d282dd4ed7..faa82f30eb1f1 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -28,6 +28,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/machine.h>
 #include <linux/clk.h>
+#include <linux/string.h>
 
 struct fixed_voltage_data {
 	struct regulator_desc desc;
@@ -225,6 +226,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
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



