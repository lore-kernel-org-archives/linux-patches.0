Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022937;
	b=AIHfplPVJrbMZbbQnmxkrVjv5uBbdprGyw2Eh0cbmu4paY7NPmDpuFV/bU0toZlPYe9O
	 +FsXgODSU1WIPrScEG5yfq8rZUfljxo99ebB/FZwzxqXuEUJccDi/dqTf9k4BwJg1Yjmo
	 ldDUoZATnNn48s78IAC5OkSrDAxDhNw0Lait4i8cTWp6/TXIhdrK5jASax2jYSerSJuyn
	 qnoJbL0cisbNuTpJvAUHdbND9lWFAqZz36eNQevfGWZqECR/x2718SrJNLfYRN2MS8ozt
	 PRC5esip2UDWBjaGRp5mzSbbtR6SAqYe+Biep0Vh/mZhkGUxrbiAXIQ5kfEzrSD+Juw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G6MXPgss29rXPPlsYz+re7LAFAhcEtEBxbPDspEuL1o=;
	b=4S7kBLqNMJzK7B8HO4PgCaM7kKjy1i9jjF3bsTe3MdP8PQjdIGhUiFNZUiuJPQGWj7Rt
	 b6S2siHYfKgheHk5ejU4IVGLqep/8WPXhVUf9TY12S7Q2NKx4yl28xQzAQfOkVaXpsIg2
	 HQh9X/GREU3FTLJkCn1aP5if0l7XEkiNEprF4q4sKLMtnx6zqm+dyf42RvTsEkF3s/9R6
	 WA8VARiy2g0dk/VsROrMrmlOGOtDZ0+12TmMNuujf8Obd9N3KO9BfzANgC8V9/Q9Aod1S
	 5FeLzROoskvBaOTMt7Y8t0N/aFyW57qtkHZ36WAq2mDnpkAMtoNAVfSmCAJ0dN1YGig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjX5phwJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D91606A76A;
	Wed, 18 Nov 2026 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjX5phwJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0872C1F000C4;
	Wed, 18 Nov 2026 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022937;
	bh=G6MXPgss29rXPPlsYz+re7LAFAhcEtEBxbPDspEuL1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjX5phwJCl2Uy3BMr8qHBQHo9AYbpGSWiGejzftNErProt9CmBXh8pXGw0QekYImT
	 SxRjvbGlgxwAV84Toh9XrG8hpg6pok1VqLblR0xOyAnbjKQEz5WPR/uZwHbfpQkVm+
	 m+zneJdvYjpC+8j9CefV72VM/15ppz0j0qqK9HIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0144/2151] regulator: fixed: reject incompatible platform devices
Date: Wed, 18 Nov 2026 15:31:19 +0100
Message-ID: <20261118150127.014645083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 254c0a8a45559..0f5451532c883 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -29,6 +29,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/machine.h>
 #include <linux/clk.h>
+#include <linux/string.h>
 
 /* Default time in millisecond to wait for emergency shutdown */
 #define FV_DEF_EMERG_SHUTDWN_TMO	10
@@ -229,6 +230,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
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



