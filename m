Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA0130DEAC;
	Wed, 20 May 2026 18:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301873; cv=none; b=o/Mm0CJQ5YPi+TtjLbRQYhEwNc++Ikr4at95AYa2dI4VcvSijtc/wkK4sQWCW+JsgtMuzkVkWN14SxvvkE+suhyc28+973PPqxb52PxBTLYStndwu8G+hBfMSgK0ah+tYe/8xvmLTgjf/YUfgXP5fR4NQZ/95WWj5o4o/cZrsZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301873; c=relaxed/simple;
	bh=88V0wQJNfzii9bs1GjvwStnfEEy2F3UwtQoHCczoiiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sv0lJ1YKtnAGPSbO0R4oBhacgWU8AP2mWiU24Rkvd++96vskvH7o7bsksFBsT6CWOWcMJN/9/7k9VILPKSe8eu8Br6s86AjFxpO1iVph+Ruc4QGYrCfjSQopEZ8Nwjhn8hMx6m6bjHSdcZhC3m960+AycvVCxvV+5ibffMF2qWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q49lAErD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q49lAErD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2181F00898;
	Wed, 20 May 2026 18:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301871;
	bh=M7qaXttPXA2c8FKeu6AX/B36BfFU+gux8TpAw7zFfWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q49lAErDyR3lPlx9dLOK0WfwzW5emyRcvDi+GdIyqW4w3QCEsq1WnXPnMlMBZK/d4
	 GVls/3wI9K/K8nvfHVlwJWH1+mp0CwO6j8zGUnDOeqAsc6bPJIyIBELf9jZEV4wzQ6
	 wQ88yvbTzVD8IW8GAVHAEeMGxhpXyIN2ae95Zkvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Haoyu Lu <hechushiguitu666@gmail.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/508] ACPI: AGDI: fix missing newline in error message
Date: Wed, 20 May 2026 18:17:55 +0200
Message-ID: <20260520162059.724348370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 8b3c7d42b41bc..419a9f6c0a827 100644
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



