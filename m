Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20A02EAB7E;
	Tue, 22 Jul 2025 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192610; cv=none; b=ftxs9YWL4yx8jNqiuJInsRJiyuj0UXCRjHhtj1PtmYTUxcQ+bP2OB9QOzAxJDHMI66g027rUELnotD8PqgrFwZqIVFq8ZOFFh7lkIBRSPbu9X41sQDy9QUrshgjPO+zOceaG38kArHU7YbFANY5qG79Owae9Dy733hRdc0vsYJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192610; c=relaxed/simple;
	bh=OAP6PDdYTZxPH9B4LunqpRHQArTXgUBniUZ5ji6GDQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knMXo7GzsmQ12yLM2m91DywSi3KG3VjfL91dKCC0RMwx2PLM5kAyyi2rGgSdt4f6dLRLEtirkwuePtQCVqKph7RbDsqHUuTurRE+3q/SL4RDtqx252XE0K0gEKN1XtR3Dk4D1ZLEAOFd91ifu+vdwrpvsX4Zo/5LqVB73Hbcg2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWwB5tzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWwB5tzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078B1C4CEF7;
	Tue, 22 Jul 2025 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192610;
	bh=OAP6PDdYTZxPH9B4LunqpRHQArTXgUBniUZ5ji6GDQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWwB5tzzwJf+JQLH3uU87MQkPLLY40VNX3qRdYnL0QRClZpup2cOm1OM6wW1y+DXm
	 0ddcyrIX2i0AljKSu/7LCgy1KvfoJmJZ+W0ivc5ucoffsQaJyBT4B3pdMGXDxRKxvd
	 cEJ7ABLjcAaN+713ns05rQxQL9GgzB7S4ZDC0INo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 110/111] i2c: omap: fix deprecated of_property_read_bool() use
Date: Tue, 22 Jul 2025 15:45:25 +0200
Message-ID: <20250722134337.519113389@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit e66b0a8f048bc8590eb1047480f946898a3f80c9 upstream.

Using of_property_read_bool() for non-boolean properties is deprecated
and results in a warning during runtime since commit c141ecc3cecd ("of:
Warn when of_property_read_bool() is used on non-boolean properties").

Fixes: b6ef830c60b6 ("i2c: omap: Add support for setting mux")
Cc: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Link: https://lore.kernel.org/r/20250415075230.16235-1-johan+linaro@kernel.org
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1457,7 +1457,7 @@ omap_i2c_probe(struct platform_device *p
 				       (1000 * omap->speed / 8);
 	}
 
-	if (of_property_read_bool(node, "mux-states")) {
+	if (of_property_present(node, "mux-states")) {
 		struct mux_state *mux_state;
 
 		mux_state = devm_mux_state_get(&pdev->dev, NULL);


