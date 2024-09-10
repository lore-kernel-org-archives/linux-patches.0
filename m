Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A063618B48A;
	Tue, 10 Sep 2024 09:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960974; cv=none; b=gfssHVsSFWa8y6B1MtC2hqXWMdQqkhs65bAP4r1vplIk+BL0D3Ziczkia3jbcFoXoGzF1E9H36Goz7zEl4ORwoD04l1oBxLuQch9tp4pQys+G1ewjfjOZUqjKTg6Lyr2Kk0Y3yCwPdXfYOVdEk5U7IsGkQnaaR30tV4+wyFNCeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960974; c=relaxed/simple;
	bh=omOz/qI0381w6A2hCkKtpA6OVKxPxuGMEY8e0UNAwKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0NrreG8abgdUtRn3J2AyXizTPQgQycLJsiYhNwncg3twthSVlWAhPLgldgId0VGYJ4crn8ZAp9gg7XncypITSHncgT711PM79v7gBkFsGykfHllDAZeupUL5Vztu0/wc2sgFoHD5/kt6BF4l6A7P+z5Dp9G5Wb7F9icUCwaEC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeKHFaY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeKHFaY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CD3C4CECC;
	Tue, 10 Sep 2024 09:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725960974;
	bh=omOz/qI0381w6A2hCkKtpA6OVKxPxuGMEY8e0UNAwKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeKHFaY4Q0SyVR5UvAQSgeNm8PAYPIh4CkomYWb5jv+AEbA3oycVMc6vGM/BG9KbN
	 FKm195DS3YgSvLALlMiw7f8XA/Id4Iw+/K7C3SdwbiO7d9eg+W0IiMsso5v4EBkMc7
	 AKbg45t2D1Uovj73zrt+eQkpRmfJsYd3RyDIaNqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/96] usb: dwc3: st: add missing depopulate in probe error path
Date: Tue, 10 Sep 2024 11:31:05 +0200
Message-ID: <20240910092541.534713655@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit cd4897bfd14f6a5388b21ba45a066541a0425199 ]

Depopulate device in probe error paths to fix leak of children
resources.

Fixes: f83fca0707c6 ("usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240814093957.37940-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-st.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-st.c b/drivers/usb/dwc3/dwc3-st.c
index 770f80f53c356..d355c784f1f18 100644
--- a/drivers/usb/dwc3/dwc3-st.c
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -266,7 +266,7 @@ static int st_dwc3_probe(struct platform_device *pdev)
 	if (!child_pdev) {
 		dev_err(dev, "failed to find dwc3 core device\n");
 		ret = -ENODEV;
-		goto err_node_put;
+		goto depopulate;
 	}
 
 	dwc3_data->dr_mode = usb_get_dr_mode(&child_pdev->dev);
@@ -281,6 +281,7 @@ static int st_dwc3_probe(struct platform_device *pdev)
 	ret = st_dwc3_drd_init(dwc3_data);
 	if (ret) {
 		dev_err(dev, "drd initialisation failed\n");
+		of_platform_depopulate(dev);
 		goto undo_softreset;
 	}
 
@@ -290,6 +291,8 @@ static int st_dwc3_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dwc3_data);
 	return 0;
 
+depopulate:
+	of_platform_depopulate(dev);
 err_node_put:
 	of_node_put(child);
 undo_softreset:
-- 
2.43.0



