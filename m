Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6AF563FA1;
	Wed,  9 Sep 2026 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963190; cv=none; b=YoIRfyBgPx4NbUNYMJFfGWuDVpDzlqklF99z7hEQ+D2ENNU5n/WQs2JtSsww8miq6CNtGtR45H044O8tubP1GJWnhMg08h092vKUSm8upQMUTmgD5f4+0cJ2mXzNv689kbWmFKHMIdGET7t11bCB52kZ+d5LMm5WQ1yONSt4/4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963190; c=relaxed/simple;
	bh=JQjQnW0ndWOarz3p/k+sX75PSRblUt/l/lJpFwY/UMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+MiSr7NJKy2UTw696yc/WMd85u7YxJ/5sE9PL0oz+iub/bVoBvSf8DKjWEBNdWiZQQP4UGfclZQcmbcSv7Nw8S3V8Yp1ioSjX6Wk0ptglIRaBWOge1Mwd2Cq163MDav7KCRcOqFkqS1FkqUenYgF2zO3n8nQiQC6uJ6qOUtS40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZdbEttb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZdbEttb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E63F1F00A3A;
	Wed,  9 Sep 2026 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963189;
	bh=/gwuL0a21oW/TevH516gnfzUfxPZpgfKs3Qh5MWGsCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZdbEttbncrsKAk4ZSOKIjx0Y+yfm8uZYC5UTxFyPp+PXxgeV9g9NxmgG973ub8j5
	 J6TEfmcM4AmzhPt9KOYov0cs5evhXGtCY+maJjpqvdhR7d8iZcNL/wXUvuRFfVAOcW
	 VqxXGEiYbs2bWaLIaoim4HGw6BdYsb0KpjUtr2d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pan Chuang <panchuang@vivo.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 549/556] power: supply: ab8500_fg: Remove redundant dev_err()/dev_err_probe()
Date: Wed,  9 Sep 2026 15:43:49 +0200
Message-ID: <20260909134249.700768543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


