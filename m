Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3332F12B0;
	Fri, 17 Oct 2025 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714342; cv=none; b=VSfOqJTN38V1TFy6jpmp1U4U3pIpKYRRXrifLTgVZAlIcXgPRiJb6dnbRyuTegMje/dDz4uihF9/RrQl7Fetbcb4si9lxr2EQTn24hW2hznNTQZZdr8Xero3C19+0C2/YxmKDkTdm5CBuIKJ5TkaHaUyP6y9lxBglWxx83Y2YgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714342; c=relaxed/simple;
	bh=RkN7GpYe6IGbmLlDkqsLIIAzZtOeY8yECppyaMErkwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP57Re+BUKWE/zXa+6nQ/ysqocCCqUmDy8Y2vpyvGUmirPliNAypmboxtgmmHWQ14j8k1TqdoaE0XZLy2kq5/1XDEcQJgXx0hfTL0jXdBmc1WQ/VHf1qQKu3tbjdWs7q3O/bzy4yAzJBzfK6eTdXfkCufcp5uwAOvEilwE7UdSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzAfAw1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzAfAw1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ADEC4CEE7;
	Fri, 17 Oct 2025 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714342;
	bh=RkN7GpYe6IGbmLlDkqsLIIAzZtOeY8yECppyaMErkwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzAfAw1LYH/LzPSUNL9qc6DpFsMFXoGxcpIXiXTaJXe8FC7mIJQ7Vn7EEn2EbHXll
	 t/oOqmP1S5mYDZ/mnotEQ79IsX0YlDEEqi7ZsXEMWIw9R2yr06JOZEKeHaA2uukRES
	 fuuFrol4C2tiSHeo9+a5Gc5zgmyGKaEtiCR3T+Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Subject: [PATCH 6.12 112/277] media: ti: j721e-csi2rx: Use devm_of_platform_populate
Date: Fri, 17 Oct 2025 16:51:59 +0200
Message-ID: <20251017145151.215451991@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Jai Luthra <jai.luthra@ideasonboard.com>

commit 072799db233f9de90a62be54c1e59275c2db3969 upstream.

Ensure that we clean up the platform bus when we remove this driver.

This fixes a crash seen when reloading the module for the child device
with the parent not yet reloaded.

Fixes: b4a3d877dc92 ("media: ti: Add CSI2RX support for J721E")
Cc: stable@vger.kernel.org
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Tested-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com> (on SK-AM68)
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
+++ b/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
@@ -1121,7 +1121,7 @@ static int ti_csi2rx_probe(struct platfo
 	if (ret)
 		goto err_vb2q;
 
-	ret = of_platform_populate(csi->dev->of_node, NULL, NULL, csi->dev);
+	ret = devm_of_platform_populate(csi->dev);
 	if (ret) {
 		dev_err(csi->dev, "Failed to create children: %d\n", ret);
 		goto err_subdev;


