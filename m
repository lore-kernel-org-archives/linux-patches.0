Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE74F196C8D;
	Thu,  6 Jun 2024 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682949; cv=none; b=m05itrxL/kKZwSRtmmyPLviyW+xCeeArFqU5bvHVwSfVWvh156cs/qm5apApPHJVRrif9xdPj/HuVxj60nGN7s3QNB6wyVFaKZjbQI7TYwZepzWl0TUYFZbay63kqzoVnQmCPEiU1PJ8rCKeOjf0ryss1BPI7Sole6VipwgrAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682949; c=relaxed/simple;
	bh=VId0kwqDIYkXhFNxKId0L3tA3FyknH8JXNe1wNgOPUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvX6WquCRg5PaL/jh5ay70CK6SGGLNYgvJQQPd/pGHYERHBAja0duG2SE+SPTmQoqeeOdAFDQFWEEJ1z5flNrAhMjfs720lWR0QdIkMgIZJaYuPcy1Hhq/u+6x9ZfixImAFvIviI2iLeuryN9G2XEUyjjg9Yv98HfgFsaZS3h7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MANauAkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MANauAkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB52C2BD10;
	Thu,  6 Jun 2024 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682949;
	bh=VId0kwqDIYkXhFNxKId0L3tA3FyknH8JXNe1wNgOPUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MANauAkj2A3bg1rl2qGk9kkchFvHoJu3axlg5u/arrUvAOXgB1KpTw/5sIA4MNLK9
	 dIxa4m8GP3+C7T8k5nNfEFp7kRgLVCDBPILBZvYuLLgy/P3fFEUEkdRzJEGXCRFK7T
	 /LGiRGS0bL/rr+URmX57MKzM9SI8bRmLt/Eqb004=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	David Collins <quic_collinsd@quicinc.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 095/374] spmi: pmic-arb: Replace three IS_ERR() calls by null pointer checks in spmi_pmic_arb_probe()
Date: Thu,  6 Jun 2024 16:01:14 +0200
Message-ID: <20240606131655.083232675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit c86f90e30a347ef0a28d0df3975c46389d0cc7fc ]

The devm_ioremap() function does not return error pointers.
It returns NULL on error.
This issue was detected once more also by using the Coccinelle software.

Update three checks (and corresponding error codes) for failed
function calls accordingly.

Fixes: ffdfbafdc4f4 ("spmi: Use devm_spmi_controller_alloc()")
Fixes: 231601cd22bd ("spmi: pmic-arb: Add support for PMIC v7")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Link: https://lore.kernel.org/r/82a0768e-95b0-4091-bdd1-14c3e893726b@web.de
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: David Collins <quic_collinsd@quicinc.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240507210809.3479953-6-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 9ed1180fe31f1..937c15324513f 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1462,8 +1462,8 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	 */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "core");
 	core = devm_ioremap(&ctrl->dev, res->start, resource_size(res));
-	if (IS_ERR(core))
-		return PTR_ERR(core);
+	if (!core)
+		return -ENOMEM;
 
 	pmic_arb->core_size = resource_size(res);
 
@@ -1495,15 +1495,15 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 						   "obsrvr");
 		pmic_arb->rd_base = devm_ioremap(&ctrl->dev, res->start,
 						 resource_size(res));
-		if (IS_ERR(pmic_arb->rd_base))
-			return PTR_ERR(pmic_arb->rd_base);
+		if (!pmic_arb->rd_base)
+			return -ENOMEM;
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 						   "chnls");
 		pmic_arb->wr_base = devm_ioremap(&ctrl->dev, res->start,
 						 resource_size(res));
-		if (IS_ERR(pmic_arb->wr_base))
-			return PTR_ERR(pmic_arb->wr_base);
+		if (!pmic_arb->wr_base)
+			return -ENOMEM;
 	}
 
 	pmic_arb->max_periphs = PMIC_ARB_MAX_PERIPHS;
-- 
2.43.0



