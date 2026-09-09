Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1E7568FD9;
	Wed,  9 Sep 2026 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964921; cv=none; b=P4xv/blGNcbjnVssGYvO+48FPJD/zda21SiXG8GVWdVB5Rg1zYIjkyf92uUirORrCwlSynSTJsvULlEFs3pAnehU7t+0noTHR0tiy6LDTRvAzuX9zbA/oGXBIE1z/asEShuvJb8gKd5KDsuqUyVRraLIdckYWpOd83BTF0MVbyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964921; c=relaxed/simple;
	bh=/sBLBcO3tYAnnICRn9aSRhLcuVfSDPbvMA0ad4kbfaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKutvIwoPhCDFHj5iXiRVzT7LWjysfNrszHR+WXxG1E9naEtl1T1n8zos0PThbrkAJ1rISHAfOwngANCTs9pZSNJI/IRodrlTQo7v7OX1PBDZdcexqxBVSIz83xPl8TSx6brRndkqslxU2P0DutImiLFKnd/5l1nn3eUR6ZYRuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcMb9CbT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcMb9CbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC62C1F00A3A;
	Wed,  9 Sep 2026 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964920;
	bh=IGR3jybrOMGbpQWF/+QO3wDjxR/F8jg5JyGvBAwfbS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcMb9CbTLfDposG4Md48flcWnboGBpVjG85+YFP0IoVavXkN2O1Yeir6SLqy/nTjB
	 pYnQdDeKloreSv8dSI/6WZUyCtc9T2pX/I8oM/wdCDULUkKOuJvYkxskS+dPb8PV88
	 Hlh+8Kb2hb4NJGDm6zF8GQL8XlEZBAFZNztgCU00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pan Chuang <panchuang@vivo.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 564/583] power: supply: ab8500_fg: Remove redundant dev_err()/dev_err_probe()
Date: Wed,  9 Sep 2026 15:44:09 +0200
Message-ID: <20260909134257.208512736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Pan Chuang <panchuang@vivo.com>

[ Upstream commit aa5f4decedfb4fc5cd0fe49ab256ad4304d192e4 ]

The devm_request_threaded_irq() and devm_request_irq() now automatically
log detailed error messages on failure. This eliminates the need for
driver-specific dev_err() and dev_err_probe() calls that previously
printed generic messages.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260709033428.362970-7-panchuang@vivo.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 75b1e88d3425 ("power: supply: ab8500_fg: fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/ab8500_fg.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3178,8 +3178,6 @@ static int ab8500_fg_probe(struct platfo
 				  ab8500_fg_irq[i].name, di);
 
 		if (ret != 0) {
-			dev_err(dev, "failed to request %s IRQ %d: %d\n",
-				ab8500_fg_irq[i].name, irq, ret);
 			destroy_workqueue(di->fg_wq);
 			return ret;
 		}


