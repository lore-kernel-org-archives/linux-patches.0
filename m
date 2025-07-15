Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEB02E762F;
	Tue, 15 Jul 2025 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587498; cv=none; b=kkrM2v4fBVoA4i5VFExLwA/NDl7A96KJmny9bYeBCp8dkhYqcv13+Ly1PXUJ5pAbWAP9PIFib/la2y6vUbwNfg3JThZUTeAOO3RDZTwlFjSV9DT6GVhN2LwIm2TV/yQ/gE6XMv45nqL5oOHXc5w+e9BHB7uqrByvNMHePWYxXRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587498; c=relaxed/simple;
	bh=rX8ZceD1IH0KW2xb3jCcaGaa5GGl6ex1b14Pnq5w1W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6gStQXHeK8NvmvIaFwJueROqy3weVfChEs3tXP6VHKOAgO8v7yDDfpV4r3xOJNDiSGmOHvu95HYmTvdLaBNlx12a95I2w+/c4HBUhG4OIbqwjwmKLlBwClClrfDYVQ6SeTq35kh1Tf7ifliyfbZ/0L/xIISOAppjtLJGJknp/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iyezz+AI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iyezz+AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF86C4CEE3;
	Tue, 15 Jul 2025 13:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587498;
	bh=rX8ZceD1IH0KW2xb3jCcaGaa5GGl6ex1b14Pnq5w1W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iyezz+AI3F/rjdfXkJk4NaSP5AotTxSM5aIRTKJRjjWEyWeV0NQXbwUTA+Nno9soz
	 KGGxj9j+jdVrVAN9LG7b0Wd9x5yl7CnCfA1LjjNUOO75hZqpLX1I4rVmVCuFDu/I2J
	 B+oOPgicaUH//b6nM7J0OR3KS3DwOuuB+qL6DANA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Junlin Yang <yangjunlin@yulong.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/208] usb: typec: tcpci_maxim: remove redundant assignment
Date: Tue, 15 Jul 2025 15:12:16 +0200
Message-ID: <20250715130811.921024867@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junlin Yang <yangjunlin@yulong.com>

[ Upstream commit a63b53e19bdffd9338fab4536e8bc422ea812b4d ]

PTR_ERR(chip->tcpci) has been used as a return value,
it is not necessary to assign it to ret, so remove it.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
Link: https://lore.kernel.org/r/20210124143853.1630-1-angkery@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0736299d090f ("usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_maxim.c b/drivers/usb/typec/tcpm/tcpci_maxim.c
index 6bf0d1ebc1fae..57c5c073139a9 100644
--- a/drivers/usb/typec/tcpm/tcpci_maxim.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim.c
@@ -446,7 +446,6 @@ static int max_tcpci_probe(struct i2c_client *client, const struct i2c_device_id
 	chip->tcpci = tcpci_register_port(chip->dev, &chip->data);
 	if (IS_ERR(chip->tcpci)) {
 		dev_err(&client->dev, "TCPCI port registration failed");
-		ret = PTR_ERR(chip->tcpci);
 		return PTR_ERR(chip->tcpci);
 	}
 	chip->port = tcpci_get_tcpm_port(chip->tcpci);
-- 
2.39.5



