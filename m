Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DCC3ED3B8;
	Wed, 20 May 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300170; cv=none; b=O67nyqauLLxzPh82c7sAlJPc9kzHQVtiKt5IHGoFJe03RBRMe2BlwLDtTWlJdnYdHCYKFd/lsHP1k0gm4qlMZOy7dQWhRPgasHNfcZDvTS5sU5ef25dtuhn5iD2oQUxEhLT4BzPVLt7ks4WbV0gJqWPNxET9TzpRzG6MOlJwSQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300170; c=relaxed/simple;
	bh=44Z+LuUH/XE5Nvgv0u988R+Ze8PUniTdge7UnC2wcy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYcxvmtyTG3pkciL74ypDlYlPfzlvCeMPvN/zOw/De1rCziZhW6wmov+5KhjxaqKJ2CqnxwnjsW94p/1P3v8EsuzihzjVg8f9zxaFAEYCfknrWdCwGGRXt152RevHFbjL5jTjve5uhCq2o6/T1ncV1h69qIxD8lyt043Acd1IvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnKuFY+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnKuFY+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD221F000E9;
	Wed, 20 May 2026 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300169;
	bh=Xnw0QS4JsMUhhNV3cHZhKwr9if6VVHBp9Eh9evwHxJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnKuFY+jJPIv3ZacvkLEtKMNlE/fvc9KAP+oFMxWQzERmKUHDNe9PlkzptW+UTQVa
	 mljjUM4PcbJetUKseJ0RGvAtw+jrMbWuaZrkRz9TsWe+Y+m9zMN1+e/Wf/o+cXqN6r
	 Rg+bOO8DPgeWKDT+1q5mmkV3L4gpLLSP7uxCiW0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Haoyu Lu <hechushiguitu666@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/666] ACPI: AGDI: fix missing newline in error message
Date: Wed, 20 May 2026 18:14:42 +0200
Message-ID: <20260520162112.770766624@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Lu <hechushiguitu666@gmail.com>

[ Upstream commit b178330b67abb7293b6de28b2a49d49c83962db5 ]

Add the missing trailing newline to the dev_err() message
printed when SDEI event registration fails.

This keeps the error output as a properly terminated log line.

Fixes: a2a591fb76e6 ("ACPI: AGDI: Add driver for Arm Generic Diagnostic Dump and Reset device")
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Haoyu Lu <hechushiguitu666@gmail.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/agdi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/arm64/agdi.c b/drivers/acpi/arm64/agdi.c
index f5f21dd0d277e..dccbd1c4dafcf 100644
--- a/drivers/acpi/arm64/agdi.c
+++ b/drivers/acpi/arm64/agdi.c
@@ -32,7 +32,7 @@ static int agdi_sdei_probe(struct platform_device *pdev,
 
 	err = sdei_event_register(adata->sdei_event, agdi_sdei_handler, pdev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to register for SDEI event %d",
+		dev_err(&pdev->dev, "Failed to register for SDEI event %d\n",
 			adata->sdei_event);
 		return err;
 	}
-- 
2.53.0



