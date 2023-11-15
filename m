Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8478F433BB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4iHCI2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356DCC433C9;
	Wed, 15 Nov 2023 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077038;
	bh=IS6/zpZxfW9P679TJNY1NLFvvPfw13mD5OanZyfrUF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4iHCI2wVa4PA+9q8+xcaOWJzRVK4MBb3gDRV6ltYt7+cQnz0wvLDh9oqbRh9Qi68
	 FA5sNesxQymnxy/qJqkaBjXUmvDBOG/HiIMetHW7bfwU1Kfuks7cODmTf9c7agHg5z
	 FVb4tptu+46kH8vZEQxuIHuEgmnKlMG8VyWKvO7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/603] can: etas_es58x: add missing a blank line after declaration
Date: Wed, 15 Nov 2023 14:10:50 -0500
Message-ID: <20231115191620.474564060@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 4f8005092cafc194ba6a8e5f39626ba0b9f08271 ]

Fix below checkpatch warning:

  WARNING: Missing a blank line after declarations
  #2233: FILE: drivers/net/can/usb/etas_es58x/es58x_core.c:2233:
  +		int ret = es58x_init_netdev(es58x_dev, ch_idx);
  +		if (ret) {

Fixes: d8f26fd689dd ("can: etas_es58x: remove es58x_get_product_info()")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20230924110914.183898-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 0c7f7505632cd..5e3a72b7c4691 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2230,6 +2230,7 @@ static int es58x_probe(struct usb_interface *intf,
 
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
 		int ret = es58x_init_netdev(es58x_dev, ch_idx);
+
 		if (ret) {
 			es58x_free_netdevs(es58x_dev);
 			return ret;
-- 
2.42.0



