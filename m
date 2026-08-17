Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30AF3DD851;
	Mon, 17 Aug 2026 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978787; cv=none; b=SLqM2VvqVsMe/0+n9TkjXfAiPEJ14a01aOMnVIdbKwPPPpD4D8U78yvjb1faGiFrnMUYpinjEuhOrXZccCk7Zlf2Fs9ieoZ8IRGTqsIjZS2r4fJ5tkVySvFUh4EgUAsP0ybVSHgU8tUj4W6xaxuODBw7B3FbYU39H+r8ARo0rW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978787; c=relaxed/simple;
	bh=WUQJZGofza3XjwaBXroOfz+nxbx6eojex/ChmHCzboQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oprG8ryg/6s0XjNHlziNutWQo4lOaTT5YSQcF3ZjeO2c6ZLasjtMqBap5suGmI/X7Kk5AMezR0jzn4sWH7plC/8IhkWyRyva1swr8dg0nBF6K3vm58c/o2uo/yaUkEARJ3Gxo9uJu1F6gEZ6f7JSiVi8+mXA96sLSltYb7mtTKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nACpB7EJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nACpB7EJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACE21F000E9;
	Mon, 17 Aug 2026 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978786;
	bh=nF99bIGS7QMPjRgVL2do/yUWLL2rlR9FEOcd2C0XqbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nACpB7EJmTzEvVbQ/e9T3sLn1xuLSdtHzhTXA8f68xb5sMQrqtZEjrjPeoz86p+o7
	 4KCovJg1iWXupv95Hs6MoOGta1CMNottPJVxBug/EipGc6TvGSPVatd+s6QvT5xmSD
	 nkrGAnU+2ATX/npRBfEQJd8UngCZBFPt9Mmyhs1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 156/156] regulator: devres: fix devm_regulator_get_enable_read_voltage() return
Date: Mon, 17 Aug 2026 15:34:50 +0200
Message-ID: <20260817132540.877381143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 257b2335eebf51e318db1f3b2d023512da46fa66 upstream.

The devm_regulator_get_enable_read_voltage() function is supposed to
return the voltage that the regulator is currently set to. However, it
currently returns 0.

Fixes: b250c20b6429 ("regulator: devres: add API for reference voltage supplies")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240506-regulator-devm_regulator_get_enable_read_voltage-fixes-v1-1-356cdd152067@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -193,7 +193,7 @@ int devm_regulator_get_enable_read_volta
 	if (ret < 0)
 		goto err_release_action;
 
-	return 0;
+	return ret;
 
 err_release_action:
 	devm_release_action(dev, regulator_action_disable, r);


