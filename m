Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353A91448EF;
	Thu, 11 Apr 2024 10:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830328; cv=none; b=fT225lZ/3eJoFaxV816oF4vQOyyghev8/Yz6gAFZV0M98JB7bjiLu2JSM/6xcK3auw1OlawCg/a2xippFMlIFzbybjZn15UGexL2uO25QOLIgfbBTFMiq82Ma04ZWGrDfnbL7wYAl7InNDDFjfzdROYlL8QpDifJtk01/4Q7M3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830328; c=relaxed/simple;
	bh=QtR5o5UosXfgjfYWbTftgUOkPpDJN6xYrOcJv45Sf7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rS1gZOSr51lPeOtFd+THiT+SztHP1ONbtQ7F+39vcCfaejq2ENW6yna9/+AWRHCm4crujmWMPS4tYUQ7pniSRlys6DEaNabF02MnrZgyJDSxEz4SgzFvvPIckqXdiYB3KeBCuGenNnuRbyUESbSlqAxyL58ztr/1RPw8AZscCWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bpi9tbjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bpi9tbjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2C5C433F1;
	Thu, 11 Apr 2024 10:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830328;
	bh=QtR5o5UosXfgjfYWbTftgUOkPpDJN6xYrOcJv45Sf7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bpi9tbjPwQP6IEWA0/QovtjFLVMU9TRJg2Aw1lQ1QRgG1/qQwrAKY6i4+QaOIBe44
	 skB0XMvWJxVH1OVuA18yv1XuKEqYguMVyJi/GiX4J5s3L8ewV6egAQRneIulG3wQa0
	 dXegN1j/UxXbrcEevZzMvvhu6/9vAZTBS5fmT43I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 111/143] usb: typec: ucsi: Add qcm6490-pmic-glink as needing PDOS quirk
Date: Thu, 11 Apr 2024 11:56:19 +0200
Message-ID: <20240411095424.248796785@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 88bae831f3810e02c9c951233c7ee662aa13dc2c ]

The QCM6490 Linux Android firmware needs this workaround as well. Add it
to the list.

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20240208-fp5-pmic-glink-v2-2-4837d4abd5a4@fairphone.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_glink.c b/drivers/usb/typec/ucsi/ucsi_glink.c
index 5d098e71f1bb7..ce08eb33e5bec 100644
--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -312,6 +312,7 @@ static void pmic_glink_ucsi_destroy(void *data)
 }
 
 static const struct of_device_id pmic_glink_ucsi_of_quirks[] = {
+	{ .compatible = "qcom,qcm6490-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
 	{ .compatible = "qcom,sc8180x-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
 	{ .compatible = "qcom,sc8280xp-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
 	{ .compatible = "qcom,sm8350-pmic-glink", .data = (void *)UCSI_NO_PARTNER_PDOS, },
-- 
2.43.0



