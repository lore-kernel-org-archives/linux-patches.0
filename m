Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F3E187332;
	Mon, 12 Aug 2024 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480454; cv=none; b=VQ3gpOB2rdb94Yqr72j0IhC7jHxF56cveQH5hewr6JrPCA0H2Ri235X0ZgimxvcCdFKAe7P5NuruPM7Qe3bEe9nf6+ZfeECmbm4vJ5Cq3bDOdwbAF9qfE1q+EjEnPfHu3g2/gGjqGWxb9d3IbRnrx7GGUyx3RId/q6xPkaj0Wsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480454; c=relaxed/simple;
	bh=qBHWYNtfztLra+93+UPWQ30zy0BIhKusgLOOhZo2OoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEhV8QtxTZiyXNC0xKZwcVtIiCLMLPqDCUI1ttWKTiJvoyh91L/xix0Uc5pfiqF8ifyj+dkVfNH9RCe1Y73fxOLvsFzdd6M7oQlub7yldauY+5dE/tffMDEjnGy0y/ptdYurZFc3rcyqVcgm3ua/2kAyOX+Iiw+YPbNYGMA7e5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InryaMXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InryaMXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BDAC32782;
	Mon, 12 Aug 2024 16:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480453;
	bh=qBHWYNtfztLra+93+UPWQ30zy0BIhKusgLOOhZo2OoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InryaMXV/dSwpVG7qcSp3gs4dO2I1STY4s5qMP07j2PUfcz0awicCPb9Asmrv2wQO
	 FnqSSFPCsbh9EZee5hNawFPT+ZYcpcnASzw3PcyYygWegZXwc6bavG86sBJa4LK9M/
	 SS5HnxZjjGnHxsoslYly0hlZXIb0OV0/KAMTy0us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Collins <quic_collinsd@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 201/263] spmi: pmic-arb: add missing newline in dev_err format strings
Date: Mon, 12 Aug 2024 18:03:22 +0200
Message-ID: <20240812160154.244270708@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Collins <quic_collinsd@quicinc.com>

[ Upstream commit ffcf2eb4bfa24f7256de53a95182c3e3e23fdc6c ]

dev_err() format strings should end with '\n'.  Several such
format strings in the spmi-pmic-arb driver are missing it.
Add newlines where needed.

Fixes: 02922ccbb330 ("spmi: pmic-arb: Register controller for bus instead of arbiter")
Signed-off-by: David Collins <quic_collinsd@quicinc.com>
Link: https://lore.kernel.org/r/20240703221248.3640490-1-quic_collinsd@quicinc.com
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240725164636.3362690-4-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 791cdc160c515..c408ded0c00f7 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -398,7 +398,7 @@ static int pmic_arb_fmt_read_cmd(struct spmi_pmic_arb_bus *bus, u8 opc, u8 sid,
 
 	*offset = rc;
 	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
-		dev_err(&bus->spmic->dev, "pmic-arb supports 1..%d bytes per trans, but:%zu requested",
+		dev_err(&bus->spmic->dev, "pmic-arb supports 1..%d bytes per trans, but:%zu requested\n",
 			PMIC_ARB_MAX_TRANS_BYTES, len);
 		return  -EINVAL;
 	}
@@ -477,7 +477,7 @@ static int pmic_arb_fmt_write_cmd(struct spmi_pmic_arb_bus *bus, u8 opc,
 
 	*offset = rc;
 	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
-		dev_err(&bus->spmic->dev, "pmic-arb supports 1..%d bytes per trans, but:%zu requested",
+		dev_err(&bus->spmic->dev, "pmic-arb supports 1..%d bytes per trans, but:%zu requested\n",
 			PMIC_ARB_MAX_TRANS_BYTES, len);
 		return  -EINVAL;
 	}
@@ -1702,7 +1702,7 @@ static int spmi_pmic_arb_bus_init(struct platform_device *pdev,
 
 	index = of_property_match_string(node, "reg-names", "cnfg");
 	if (index < 0) {
-		dev_err(dev, "cnfg reg region missing");
+		dev_err(dev, "cnfg reg region missing\n");
 		return -EINVAL;
 	}
 
@@ -1712,7 +1712,7 @@ static int spmi_pmic_arb_bus_init(struct platform_device *pdev,
 
 	index = of_property_match_string(node, "reg-names", "intr");
 	if (index < 0) {
-		dev_err(dev, "intr reg region missing");
+		dev_err(dev, "intr reg region missing\n");
 		return -EINVAL;
 	}
 
-- 
2.43.0



