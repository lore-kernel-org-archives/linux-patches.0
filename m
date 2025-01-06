Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177C914900B;
	Mon,  6 Jan 2025 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177268; cv=none; b=cluNGMZNhHKzCfwIdzyUf7nFC9bNT9q8tInnF0rXgSTi+dnJoWXMdeS3TbWsBKmfDhnUAHafjwFSULWbrEYHmO5OfH/vfgrjG527Sz89Qn3vrZwvOGizWx3tKfF6xqNMuo+G9qeXoOcmaQ+6YYjxVSv95kCD1l+hBMG7RFqZ26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177268; c=relaxed/simple;
	bh=TwJfmjS6GwGcJ6OqF71vugSi5xtQpRMQECyLfMP8nOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldwZHoMjXe71i0u0xbM+xe5YZQJ8SyHbYZLcp5cr68bMz2xXLYrYZfzrNYUuKJ25JrSWQ5J+eSACvfaNj6x4/OMVlrRlR1YkV+EOOhRKbg8bMWHAHNJQnxWpiDUQK4D1toQRxIdUDeCy0+E9/mgWRmVnwKRr7yQQpkK7cvieizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IurKX7ro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IurKX7ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B70C4CED6;
	Mon,  6 Jan 2025 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177268;
	bh=TwJfmjS6GwGcJ6OqF71vugSi5xtQpRMQECyLfMP8nOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IurKX7ro+Hcm9RhCiNuseJs8hGLlVP1ywmJUnyUPea+R5HeSb1iTVmSFTZEaBXRCu
	 nfng13ZA5lr2BoLnLQbVSmhpwJc7SkeLnfHEqIfIRgQ52YVzlwFULEQbVTmElyHeH2
	 hk1emr7+nh2aV4QnJKzeQqpWW/p7jJFAVfkFOflI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/222] usb: typec: ucsi: glink: fix off-by-one in connector_status
Date: Mon,  6 Jan 2025 16:15:12 +0100
Message-ID: <20250106151154.685210461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 4a22918810980897393fa1776ea3877e4baf8cca ]

UCSI connector's indices start from 1 up to 3, PMIC_GLINK_MAX_PORTS.
Correct the condition in the pmic_glink_ucsi_connector_status()
callback, fixing Type-C orientation reporting for the third USB-C
connector.

Fixes: 76716fd5bf09 ("usb: typec: ucsi: glink: move GPIO reading into connector_status callback")
Cc: stable@vger.kernel.org
Reported-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241109-ucsi-glue-fixes-v2-1-8b21ff4f9fbe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_glink.c b/drivers/usb/typec/ucsi/ucsi_glink.c
index f0b4d0a4bb19..82a1081d44f1 100644
--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -202,7 +202,7 @@ static void pmic_glink_ucsi_connector_status(struct ucsi_connector *con)
 	struct pmic_glink_ucsi *ucsi = ucsi_get_drvdata(con->ucsi);
 	int orientation;
 
-	if (con->num >= PMIC_GLINK_MAX_PORTS ||
+	if (con->num > PMIC_GLINK_MAX_PORTS ||
 	    !ucsi->port_orientation[con->num - 1])
 		return;
 
-- 
2.39.5



