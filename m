Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1B5481DD;
	Sat, 30 May 2026 17:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161036; cv=none; b=QqgcmVOg9ec9z7Gwa0kQa8Kxuf0RJfOWTQfJ/rlRbKyaezng7Sr7IBthRc2Pw1msM++EMlLsEKOJ/2rDtDqSC0LlXUwmP1v2n8PzK1xY+Qev+Zk0cpxrJo4S7epLORIqpVpuv1qpdhD9JVRBOubae2hOdPxBZE7GdMj0sGrG/08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161036; c=relaxed/simple;
	bh=mEf16sPhU6C57PSvZopkqk9YUQe4/v6FU+qRe5SIZ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4RgodGQMnxWyTOaHAFKPkNn4tcTp5UZgh8c1+2nEgv6QILlssk5WMPbSrpl/+Vpm0wgA+Nk0jbHgZAne8DB//uy/7XvKOCmdPvBrTqz7cE0aZe0ecWKwwdKHsxUcCudrIjmRHOACQcuulVn+ayjgDnAC/09RFZF2/7Vz91fcu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AF3pDJw6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AF3pDJw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B121F00893;
	Sat, 30 May 2026 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161035;
	bh=GLiq2NaN3EjaSQfzy77efQlBw2egRWVq5LqmuElnXtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AF3pDJw6NsVNbwDqac05Vz7rGIEJN/IJVD00xhvC870wYqrp6YqHw61zFyg/8VNLJ
	 DuIb1Oq/dk6j3FDws5K4xemvEPF3qCRryV91S9ZYmvu3B9Z9RD5hwvGW+NVLt+7OPy
	 OOzQA3uza+/B3a7T9dgO0EToHccsTAUo2logZnU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Haoyu Lu <hechushiguitu666@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 466/969] ACPI: AGDI: fix missing newline in error message
Date: Sat, 30 May 2026 17:59:50 +0200
Message-ID: <20260530160313.154479249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index cf31abd0ed1bb..53a674c83f588 100644
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



