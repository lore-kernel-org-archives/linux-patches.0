Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060221;
	b=SJ4OgARgHPxrMH1JQ28x+xHNgeuBK7VphRUyVylL8H8euLTG/UFggCwwzbdfh+So1A5c
	 VDo++T8/2xbhm/qmh9bxHnSh9vpTdQtrRgssKoEQLpa4ikk8goK2TynUenSKGU/n03qCQ
	 y7Cpj4pSIop4WKek61qdmgxblaUIaAyewKmcOT7ZJ5l+LZnqKo6lE+5/3OhEtRVla8kCU
	 tmBKj3zlnZfDa8owv7SezUUqr0cMt1NWrGxdRq/FCz7hqweTpoCJtiPLA9b1NnyzAPvlX
	 IPBEy/92NFK/9bt9t9BU/seqVSJCBcIjKhWgAbZZeRRK42Pgi5slpvO4HvMRme1roGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LOjRgU19GfvUm+YFbrSZfcK5iYuNPORZHgZGY3vgOEQ=;
	b=cqpXJOlgfJ6k2dbGaMnnP0DiJhZSgwLd/CDXdwYks/VqAamP4y1gs0VPFaHWBWB1sq9/
	 DZMSQk41K7DLzm4pxFFnTn4UEZbuE4FNmQgXwABdAT5Z2f/oB5+Z4GjMuPu2xM0ifp3Nf
	 wBCGcusxnqqkM0lM0t/prZrDLSGjR14VNlPQAzld6YA3JZ/vwT9z52pyuaarIuLQPoWE4
	 yIc8OGenJzsu4BK1QZWc+db8fxntHr1oPM3Z/sLTSOfbKNsohe/lRuT0jFUlQs0aZWHZQ
	 CgvNBmvD1IIwB8GPEyeeDt7kOEHXgROWOwyczU0C2OYvUgAA+MLj079AzB0Eq7tVtPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oj5E0nC3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0A5606A320;
	Thu, 19 Nov 2026 03:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oj5E0nC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185E11F000C5;
	Thu, 19 Nov 2026 03:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060221;
	bh=LOjRgU19GfvUm+YFbrSZfcK5iYuNPORZHgZGY3vgOEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oj5E0nC30uH1ly+q8We/SMB4p2BKjzpwt/WVyZnJ5gEKYbTttm6jcql39laAbS9M+
	 I9bOk3K5OeLj7HUHfvHTCD+fCAqcxPZBvL1Ek56jUnMY8z+sDkdeYtdVDDOTL7MvqT
	 Zr4S5jGtIIpwdYbOJptqeMKrlWanC8NINCQddQsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1122/1848] regulator: fixed: reject incompatible platform devices
Date: Wed, 18 Nov 2026 15:52:40 +0100
Message-ID: <20261118150006.285148374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1503a5ea0cc89..368c408eb87f4 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -27,6 +27,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/machine.h>
 #include <linux/clk.h>
+#include <linux/string.h>
 
 
 struct fixed_voltage_data {
@@ -142,6 +143,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
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



