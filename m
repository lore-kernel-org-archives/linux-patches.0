Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221121EF957;
	Wed,  6 Nov 2024 13:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898561; cv=none; b=A4e3F3qWR3p5P5RQ8u8gie7fsxmHgyzUADcVipatAHFxFHg2TJlP/dmztZ9bMgCYGVcvBPKHRKmF8cDwzMRSJYx14LSsWPP9j28D+0TZIy8BkLErK1d+yuM9DXZOeQ+jiPSAp7/tKtgl1P35PyPQ0LHWkqrajbNdlVC0BLtLdeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898561; c=relaxed/simple;
	bh=HMPcYuyTVjy98m0E5zWdouCwArbfOgIR5KaVodX6tbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDQKRpJFQLEIBJ1tmbxgV1WoXZ1Fhj5Rg1qvgzuCSehXoV9+oVYtpS5G6iHQM9+/5hA0V1GoelcFGhpjCNu3a8B9r7hA9PkkRrmyLTqz2mAzuiq4HEZ3eBPvYQy374QzhIJYcGpZXGhpKbZdSGMiIZWlYbJx93tK/n1bM11OvnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4bnY8B2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4bnY8B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FCAC4CED3;
	Wed,  6 Nov 2024 13:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898561;
	bh=HMPcYuyTVjy98m0E5zWdouCwArbfOgIR5KaVodX6tbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4bnY8B2uDeh7snCeiDijsFZ/kr1Zx1v7M+tNr6Qup54f7MCQgek9S7nxDJuwfAQw
	 lQpZc6CvcEAKGqfztv5VNSiXFEQubd4uuKSW91nB1L7Fk7GzfPSEN7YSM5q+uuEdRz
	 Vfj5WuWOo0DzyuIdh3kCdL7tZpScf6OEqBn51i/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Chauhan <alokc@codeaurora.org>,
	Douglas Anderson <dianders@chromium.org>,
	Brendan Higgins <brendanhiggins@google.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Amit Kucheria <amit.kucheria@linaro.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 280/462] i2c: qcom-geni: Let firmware specify irq trigger flags
Date: Wed,  6 Nov 2024 13:02:53 +0100
Message-ID: <20241106120338.441105466@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit b2ca8800621b95ecced081376de9fe256b1fa479 ]

We don't need to force IRQF_TRIGGER_HIGH here as the DT or ACPI tables
should take care of this for us. Just use 0 instead so that we use the
flags from the firmware. Also, remove specify dev_name() for the irq
name so that we can get better information in /proc/interrupts about
which device is generating interrupts.

Cc: Alok Chauhan <alokc@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Stable-dep-of: e2c85d85a05f ("i2c: qcom-geni: Use IRQF_NO_AUTOEN flag in request_irq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index c73b997899af8..6b87061ac81d1 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -576,8 +576,8 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	init_completion(&gi2c->done);
 	spin_lock_init(&gi2c->lock);
 	platform_set_drvdata(pdev, gi2c);
-	ret = devm_request_irq(&pdev->dev, gi2c->irq, geni_i2c_irq,
-			       IRQF_TRIGGER_HIGH, "i2c_geni", gi2c);
+	ret = devm_request_irq(&pdev->dev, gi2c->irq, geni_i2c_irq, 0,
+			       dev_name(&pdev->dev), gi2c);
 	if (ret) {
 		dev_err(&pdev->dev, "Request_irq failed:%d: err:%d\n",
 			gi2c->irq, ret);
-- 
2.43.0



