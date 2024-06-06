Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9774F197A67;
	Thu,  6 Jun 2024 14:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682919; cv=none; b=lLoZRtBK7qdQf1UxyKRyiOJEwsmfj+jZ4JrNOX+eEa7H2QIif/WpZ8t+x87yQ8W9oShlww1UTTdWP3jMJciDYBrwyV7ZWWdIS3koIFavXII1NEA7m7p7eBndGR/2GM0JcxlvcWyucJPJF9v8ZWUuSzVRXghceY07RYjPC7dJ/vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682919; c=relaxed/simple;
	bh=62gBHaoQBqzfjI26ufyArHXKoUf5f7g5IjA/x7aCgdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUkZsub3PZmy4m0uE2V/RBWZ7Px/wd3v2uXjCsOHWi/hYAmSSJuC29rfCmJccJ3A1hVblEi2/8aevlbFATqJ/nzrvXRqNUv9B0XxV4B/ilh8lUjdyQONW8OOSK1eRC52xqkuozOCmbMXBbd24hSME+uWMOC2++mHfxTn7cX+VOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJOTcoJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJOTcoJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7360FC32781;
	Thu,  6 Jun 2024 14:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682919;
	bh=62gBHaoQBqzfjI26ufyArHXKoUf5f7g5IjA/x7aCgdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJOTcoJ2ONT0KxQYkxptdJYPdsnOY+7D1PCs6VfieoJks/5ElTaP2XO0zfAtKUqAd
	 3PTL4nlwshhA3SYmbRxuS6iWOur/5ZcdTc7Zu6/+QdFCUETUueI9LleM+QY8DajLmf
	 RamdTEJU+9zkSXh7MswbbpvbkZf6ktPWz13QhijU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 015/374] usb: typec: ucsi: allow non-partner GET_PDOS for Qualcomm devices
Date: Thu,  6 Jun 2024 15:59:54 +0200
Message-ID: <20240606131652.273128214@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 897d68d4ce7d50ca45a31e10c0e61597257b32d3 ]

The name and description of the USB_NO_PARTNER_PDOS quirk specifies that
only retrieving PDOS of the attached device is crashing. Retrieving PDOS
of the UCSI device works. Fix the condition to limit the workaround only
to is_partner cases.

Fixes: 1d103d6af241 ("usb: typec: ucsi: fix UCSI on buggy Qualcomm devices")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240329-qcom-ucsi-fixes-v2-1-0f5d37ed04db@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index bd6ae92aa39e7..7ec4fa4ff478f 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -619,7 +619,8 @@ static int ucsi_read_pdos(struct ucsi_connector *con,
 	u64 command;
 	int ret;
 
-	if (ucsi->quirks & UCSI_NO_PARTNER_PDOS)
+	if (is_partner &&
+	    ucsi->quirks & UCSI_NO_PARTNER_PDOS)
 		return 0;
 
 	command = UCSI_COMMAND(UCSI_GET_PDOS) | UCSI_CONNECTOR_NUMBER(con->num);
-- 
2.43.0



