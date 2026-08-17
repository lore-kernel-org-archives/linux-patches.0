Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19363E63B0;
	Mon, 17 Aug 2026 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980540; cv=none; b=Z+3vNNLO3erEzqNFjgYvf4uxgLb5w5+vNYSb72ObdluWgw59N7X7Bqxlah0Nm2nbibsMSSNpelJZmNEJ1lV91yJryfYocd7LSPsm4SoUAs884b7FEKvwmJCCkeIlpfmj2Y/WJYpqcwgL66LFPOvSnW/aCsb80SF477CCSQ1iXk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980540; c=relaxed/simple;
	bh=fvmYk/W1Tv0xWNaFyh1fC7OjNXcCBTGCPdRBIP0rTkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4PGVEgwzrC1MM3VBYQEm1wgy8APjZrpj6Av6R7L3BEv8Tbx+8C5KNMtTIyiRzlgcB5Q+DFqHqXnkJ9jc6JD/22RB8FBh9JfUfGUFfupXs8sAcw6zvpt/P4R+Z476pnNiUUISra+ACjW00LYcEG+FdOQ4ow3+5s2ihe1ZVhFmGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGEbpmQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGEbpmQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561901F00A3A;
	Mon, 17 Aug 2026 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980538;
	bh=PqgDnaCzIXbGpwUT+Cx10Y/2h8qyWIPAqG76FM52mEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGEbpmQ9i22a84ThfCeqqjU/fGjsO5+roFETFzMFwFupT5RwJTN8nkgwjY871nz1T
	 ugpUM+1II5bEpptgqzGXRj7Qse7rCbzqX6RUVl1Als3pdeJUkQjLIyzosaUKR6Lbow
	 4wPm54XK7oBNLLBhQEBk1HdmDFpbQ2KplR7sogCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 607/609] regulator: devres: fix devm_regulator_get_enable_read_voltage() return
Date: Mon, 17 Aug 2026 15:35:03 +0200
Message-ID: <20260817132603.943573280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


