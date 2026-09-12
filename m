Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0304942A149;
	Sat, 12 Sep 2026 10:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208918; cv=none; b=J19O7oqaTTC0TbkJAgiBVkO9waMG7jbeqxs7XiQN5XT+n+NsxXAocZBuVnHjjLsBLCOf527jwkmQcqnf/6uzgSqGIFwNgsmo9vCWhuwGEjxkrwjOzjzkmi81DAuvX5qCHLYRNvgeC3MwnlthmuDjBbXILhJtCY+2sa/56dsW9s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208918; c=relaxed/simple;
	bh=z/uTPP23Q8Gb8PZ6fhjoRBnS9t1YgrWAE2xyqBMs/ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFWO6VZy2faKYylG+BXX2LaPJojU/VADszGQd+iRdvcsx/14fINZ8NZmfK5TDGy5zhVhxf1z6fV9XT8UgtuNEKfgC5Lij8xBhEqjVPECqc4utFytd+3nmziG07QHVO891SF1FlNWluqfjyGQLS8/FNYdvncGY9FxL4hYP2pTuR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgcc33oh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgcc33oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269AB1F000FF;
	Sat, 12 Sep 2026 10:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208915;
	bh=y24O3zIzf0cvtOaJ/Oc367Pqi4NZ798Aw+xzLZtucDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgcc33ohuQBUPcVxeyIQEw2/zJIqboa1jQF7Bh0yXBAHOKbkQ45cQDzKmyYrmj/yo
	 7rdAQb/D1sW/tilXo3a4AnHJaiUn1fYdt6p4qTGPdvgbGUYGlmDY1lsPG73lnJvioy
	 EwtHGmy76nWJXxDz2Oqco/l3dg2rbV8yLFx0Sv+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0715/1518] i3c: master: adi: add OF module alias for autoloading
Date: Sat, 12 Sep 2026 08:48:04 +0200
Message-ID: <20260912065639.610408968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f0c2ddb2f4b21..178029769bab4 100644
--- a/drivers/i3c/master/adi-i3c-master.c
+++ b/drivers/i3c/master/adi-i3c-master.c
@@ -932,6 +932,7 @@ static const struct of_device_id adi_i3c_master_of_match[] = {
 	{ .compatible = "adi,i3c-master-v1" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, adi_i3c_master_of_match);
 
 static int adi_i3c_master_probe(struct platform_device *pdev)
 {
-- 
2.53.0



