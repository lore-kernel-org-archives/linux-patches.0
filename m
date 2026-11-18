Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054737;
	b=et/C525uTc0spqxdFmD9jfTL3Rf6Lp0A1wQZCNWRvazHgeRHhhy0Esni/j9AEb7mNlsf
	 cPuq1wIZeoqqY8HEMeUA4CCTcerUdAlsTOsyBVbsh/9GdIHmL8Tzkfyv062ALPJIgyqVn
	 eKezL0/IotAlk6/aO4pxZgISEpEfcFwJiJzaWqE9UWTLoLllqoK7xuWwLrSXOeagTt42x
	 69LwPxrogXIjNFbHgguMlvSU5T8t7MdsSNHeSrM+ykWOKELgc+fFaCoy2E2Q/Kvjs4Qni
	 7NfIsEOZxpwuhnz126IiIlwXK7yV0FYtH03gUTfxAEGX4lDKagpnDOfvB0Q1q4ZHfGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oruFyx9EZU/iC+i/HHWLJHHwNIkWFZVMVuwYNWGgYyU=;
	b=YUY59mYhSO/nOPy4S94en9ey5cq0oTvc169aRyrYYk/yuE/uTq/XFOL3EFzuLHEsOskD
	 ES09ET+qLic2kyPC0nrNxpzfUR7nolOjMWGa7WbwiMzaoBKUZ97SgSLQ4uuF6lqcEa2pP
	 vexY9N2BOuFQrOcBo3wMOktAu9lzuKn1kf2bBzUEUiBOP5db/uIfVjiPGL2VpE6nOFuGL
	 qgdl1vHJL+3t3XH7SHer8ews6rv12cbintln1b2L+rvxfp47DjAiP9U4tp/XobuMfnbpD
	 M0H+xSKL5PrB19Q+UUpFHijkMCjc0PMRi62Sx7l+2Q06X0ZrPVOQVWB4mzKhJKZBiBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5NaWp7H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A61606A325;
	Thu, 19 Nov 2026 02:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5NaWp7H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0931D1F000C4;
	Thu, 19 Nov 2026 02:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054737;
	bh=oruFyx9EZU/iC+i/HHWLJHHwNIkWFZVMVuwYNWGgYyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5NaWp7HGgW7GC6PLLIhf2PcO94sJsac3l+2TP702vngPNixBXTVtzB/tnkasBefl
	 uAOkn++nnWuqLeucmsS0qRj8PTQ5GEMdJtDq7eYehGui/WKkUcsN8oKeV1nPUOj4g+
	 ZE5fXV23nlUlRXA3/Yk68qJjfVI+QNiWXAePu+7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1330/2214] regulator: fixed: reject incompatible platform devices
Date: Wed, 18 Nov 2026 15:50:06 +0100
Message-ID: <20261118150104.617420966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index adc21b1bad94b..89387181596b2 100644
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



