Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFC22F291B;
	Tue, 12 Aug 2025 18:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024290; cv=none; b=H6VQWXp6gULVcYnCUxIkGv9qVIVNyFfWNnLuRvtxYLi2ASo+wuacDoTUImNCt7WepuJ+gG5Id2+nFBeZLGF4EI4hVIYfD2jAV6Oh3tBwwyG505tPkQBr+/289GN/my94mN20MUcurPCncizBiLVj8ZuKhKDKTx9Xhzetp6QC1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024290; c=relaxed/simple;
	bh=BsuAkzF+8xlr55FDes4gcyJ75CapleLTz5NRWsrEJxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLQEjFW3m1pugkauO5HMoQAKAfZkMSIARy66DzZuww8eJXq6Y5gZHu3if4WjcDuW8aefnfhM7X4wjeSpBl9ik5aQC/EXef53sKm8yL2bqBwymjEvnHb+SYsgUhS8evbjXVoCccLjlSF3fTLwS6e7x3kDDKj88dB0ToSbzeU5uPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJgk1l24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJgk1l24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8953CC4CEF0;
	Tue, 12 Aug 2025 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024290;
	bh=BsuAkzF+8xlr55FDes4gcyJ75CapleLTz5NRWsrEJxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJgk1l24DulvSbZqATk5a6OX6LMP8hmIwY0M/g0DNXx8Ex1tghCX59W8PLaR/f+/z
	 WnZ0oN62BegF1b2qKke1v1EBwZdz+4qxZ8esGaDFjGVVz4zaCQHbIV/ReEnn+jiQIT
	 sgQKOHoYZZnW4qe52vyoyFN7dIp5ESvREhnOAYPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Ze Huang <huangze@whut.edu.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 329/627] pinctrl: canaan: k230: add NULL check in DT parse
Date: Tue, 12 Aug 2025 19:30:24 +0200
Message-ID: <20250812173431.812159463@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ze Huang <huangze@whut.edu.cn>

[ Upstream commit 65bd0be486390fc12a84eafaad78758c5e5a55e6 ]

Add a NULL check for the return value of of_get_property() when
retrieving the "pinmux" property in the group parser. This avoids
a potential NULL pointer dereference if the property is missing
from the device tree node.

Also fix a typo ("sintenel") in the device ID match table comment,
correcting it to "sentinel".

Fixes: 545887eab6f6 ("pinctrl: canaan: Add support for k230 SoC")
Reported-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Ze Huang <huangze@whut.edu.cn>
Link: https://lore.kernel.org/20250624-k230-return-check-v1-1-6b4fc5ba0c41@whut.edu.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-k230.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-k230.c b/drivers/pinctrl/pinctrl-k230.c
index a9b4627b46b0..4976308e6237 100644
--- a/drivers/pinctrl/pinctrl-k230.c
+++ b/drivers/pinctrl/pinctrl-k230.c
@@ -477,6 +477,10 @@ static int k230_pinctrl_parse_groups(struct device_node *np,
 	grp->name = np->name;
 
 	list = of_get_property(np, "pinmux", &size);
+	if (!list) {
+		dev_err(dev, "failed to get pinmux property\n");
+		return -EINVAL;
+	}
 	size /= sizeof(*list);
 
 	grp->num_pins = size;
@@ -623,7 +627,7 @@ static int k230_pinctrl_probe(struct platform_device *pdev)
 
 static const struct of_device_id k230_dt_ids[] = {
 	{ .compatible = "canaan,k230-pinctrl", },
-	{ /* sintenel */ }
+	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, k230_dt_ids);
 
-- 
2.39.5



