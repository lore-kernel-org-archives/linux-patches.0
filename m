Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF3748A;
	Thu, 12 Dec 2024 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017221; cv=none; b=rjxj/lzftpmQWfRoVQ1BMDEhOYOzf02k6Ys/G7qCuMhr9ZnO1pEpiHsqpxNucnLQlcWz2Rndn5PnS8md46Fz0Mu8uZmxJmGFT8hg8qTu7lC0ize1gJOxMcESd/uTIjaAJzJ875VYvrZxpHZEejqO6XhYYKHcR5L66tJT/GojlNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017221; c=relaxed/simple;
	bh=/jUeg3adNwtd/vuL52HbNs0sbfIH9WQ+dfU6+Qdv4a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgesO6CZ8LTmaS6vRzVSXBc53LT8a24pk6VLM+k/wzuJ4aKb7Labq33sDr27gdrKzKiiDBK7SQo0LVJ+hQWxtfFhK9DVCCrlu222kFSXDzFfsQiW3jkBVBvcvccsbBmWSOjW4ngqEJkm6HC69ThDoW9rXNs+JLhxF69GcAsQoAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cdr5X+06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cdr5X+06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DFAC4CECE;
	Thu, 12 Dec 2024 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017220;
	bh=/jUeg3adNwtd/vuL52HbNs0sbfIH9WQ+dfU6+Qdv4a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cdr5X+06KUy8r72jmvHfcKehyi4EEVapsWyUzREdm3KkxkXeNC8T61F1e2zdcvmfb
	 8cHH/KVxQck1EePRuBZcjk9urHMAFOQZ9EUFG9xBIkUXoLH/VeMr2+JnJ1QwtjY6RR
	 QE0+8VWsFDyyzbWKQ8kMP3VX7jBdHF8kHacJc1Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 416/466] usb: typec: ucsi: glink: be more precise on orientation-aware ports
Date: Thu, 12 Dec 2024 15:59:45 +0100
Message-ID: <20241212144323.191494929@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit de9df030ccb5d3e31ee0c715d74cd77c619748f8 ]

Instead of checking if any of the USB-C ports have orientation GPIO and
thus is orientation-aware, check for the GPIO for the port being
registered. There are no boards that are affected by this change at this
moment, so the patch is not marked as a fix, but it might affect other
boards in future.

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241109-ucsi-glue-fixes-v2-2-8b21ff4f9fbe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_glink.c b/drivers/usb/typec/ucsi/ucsi_glink.c
index f7000d383a4e6..9b6cb76e63280 100644
--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -172,12 +172,12 @@ static int pmic_glink_ucsi_async_control(struct ucsi *__ucsi, u64 command)
 static void pmic_glink_ucsi_update_connector(struct ucsi_connector *con)
 {
 	struct pmic_glink_ucsi *ucsi = ucsi_get_drvdata(con->ucsi);
-	int i;
 
-	for (i = 0; i < PMIC_GLINK_MAX_PORTS; i++) {
-		if (ucsi->port_orientation[i])
-			con->typec_cap.orientation_aware = true;
-	}
+	if (con->num > PMIC_GLINK_MAX_PORTS ||
+	    !ucsi->port_orientation[con->num - 1])
+		return;
+
+	con->typec_cap.orientation_aware = true;
 }
 
 static void pmic_glink_ucsi_connector_status(struct ucsi_connector *con)
-- 
2.43.0



