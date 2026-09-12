Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612AC364059;
	Sat, 12 Sep 2026 08:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200701; cv=none; b=V+KEaQxFAP/xIHdWf+cbzOBX505XF7vIfmFZgdfvHHTdxG04nvKwAk9i5jfVi+H2ijd9D28NdLmdjQJ9zpgXF1ADaNl1BBbkbcsZfZVvqJ8YOwRB8zkSSt+DzW5V2wk3XlLuxMUaTdC6vnYc4wqtvmDikCsK7ndgO9ckkFNTpV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200701; c=relaxed/simple;
	bh=DIF6xAHMppk7q2fSs1Eo/5rGDDG6GPr7MGfTCeiE3Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbvSw0HgV+n7La06nliHHTL2Ci9XFgYENufYkhPQjJnpbN4teNFvwrzTQQS6KIKSc+DT89zBMBdx2p8LjlfYOtQKMslT/CK4tLzzygrT3HCSXYLZk9PbV/eMS7YvZWKzxa69IcGAWHbijdT3Fa0QmSYhgS94WHRqGocak13kGxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h06tMUip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h06tMUip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67461F000FF;
	Sat, 12 Sep 2026 08:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200700;
	bh=ujp2NtZqs4Jj6Z+gFD0lVR3Togle4n0nWzBVeLOP98o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h06tMUiplvvTq1aHoDfmE/pLZZuoUPFfqDP8eEKmdfgXp4Ic+QFev3jHtKP/t/dWp
	 fuBpSK1E0Qk41i4Ih3ac4PALMUZctAkDqRKU2TWRCoabVvhKV7YL6pKXfqLlp33DPg
	 pugvrNBkWk1PPcRN7hXxxp4ridASkx99t9QO+oeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0844/1815] i3c: master: adi: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 08:43:14 +0200
Message-ID: <20260912065708.731235547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit a733069a1943f30922b90bde5eef3cb25b010f8b ]

The Analog Devices I3C master driver can be built as a module and uses
adi_i3c_master_of_match as its OF match table, but the table is not
exported for module alias generation.

Add the MODULE_DEVICE_TABLE(of, ...) entry so modpost can generate OF
module aliases for OF based module autoloading.

Fixes: a79ac2cdc91d ("i3c: master: Add driver for Analog Devices I3C Controller IP")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260715012949.180245-1-pengcan@kylinos.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/adi-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/adi-i3c-master.c b/drivers/i3c/master/adi-i3c-master.c
index e29aac2869577..fb4cfc9026ccf 100644
--- a/drivers/i3c/master/adi-i3c-master.c
+++ b/drivers/i3c/master/adi-i3c-master.c
@@ -929,6 +929,7 @@ static const struct of_device_id adi_i3c_master_of_match[] = {
 	{ .compatible = "adi,i3c-master-v1" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, adi_i3c_master_of_match);
 
 static int adi_i3c_master_probe(struct platform_device *pdev)
 {
-- 
2.53.0



