Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585537;
	b=FHr/LlaumZakY/0VrFyhHfFNv0uo2yXn+9symrU5eNHYyM4qAXVzoi5yjmgCRW8N6d05
	 DbCqd5lIejR/0rRzGuglhuZ2k+/h+wNpdrfjyqtZSfZeZtT8GHTn7gFbiJMiDCzNr4zFc
	 79wrIM6A5ZOEQcL7y3InsyDCG3MA+kKdrDrsZ6ERsmAo5u8xUOc4l5yA02+SFtSgxxiJD
	 kklFmzIt37hhGeHTF5zoMPfIqwYaSAYmB2JpBaDxBpl097tV6JrRA1YK8wk2Llu/Pggcm
	 8xBOkqEDQvakVxMjkhWsR3HI9fsQa4SCA5Nq7gnQQf1TGa5iaewZh+qrD56vi75dVJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yEiXzqVSv/lwU9d3rbngk9CadiaLCmOI7sHrT5/06Rg=;
	b=IRjJ5pzAXmd6FbH9ZtCAfivtXmfeDIRK4tOZC9nVTOZqE4kClfzRhcVjCAcw5ziDyWwm
	 G0RA04d0vyb231Q6bX3gsimuD952jCRV6ZUkMDtIbKiMfHIlSHYX5V2Mx25X93s2PRFWK
	 1/2NWH8AhhW5v56Cgey2r/JtsZyGsW+1oDgZSW+UiSAW/2Y+I1JssZmRbmD5Vk/U0b3Mh
	 imkIlK67eDpEgfEs054Uf5p2ztLAxBuvsXQnthMJCjdpyVuthHSgTCTc3II0uQDHqaM0X
	 /yWkCVrm13VZAU5tlp7TEo4/wHYsCMSm4dp332ylYA2ckGiQYjjj6/fN9x1UD7sPrVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SK5pK3qF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A8C606D465;
	Fri, 13 Nov 2026 15:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SK5pK3qF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C475E1F000C7;
	Fri, 13 Nov 2026 15:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585537;
	bh=yEiXzqVSv/lwU9d3rbngk9CadiaLCmOI7sHrT5/06Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SK5pK3qFIim31H46N+1f5oZ7gqJqA4oC/RVXn0GkitA1U3lGV90uGNacAg6Xs3sWN
	 eDbZwNG/4noLQ2f8latEozTwQTCol0vkbPVpCUV+6VPzZdmHZcaLhxMGRlMF90n0/R
	 ODQdiW0L6oWbFe0azCvCpuVPAqZrmgeg9JHZxZuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 176/507] hwmon: chipcap2: defer probe when IRQs are unavailable
Date: Fri, 13 Nov 2026 10:48:00 -0500
Message-ID: <20261113153800.447691332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit b5a1412618f93b594f924cf4f3b4bb6b5dc49d41 ]

This device can work with or without interrupts, but if they
are provided and still not available, but if -EPROBE_DEFER is read,
its value must be propagated to enable probe retries.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-4-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index aec4adf986584..37dbf6a76fbce 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -636,6 +636,8 @@ static int cc2_request_ready_irq(struct cc2_data *data, struct device *dev)
 	int ret = 0;
 
 	data->irq_ready = fwnode_irq_get_byname(dev_fwnode(dev), "ready");
+	if (data->irq_ready == -EPROBE_DEFER)
+		return data->irq_ready;
 	if (data->irq_ready > 0) {
 		init_completion(&data->complete);
 		ret = devm_request_threaded_irq(dev, data->irq_ready, NULL,
@@ -653,6 +655,8 @@ static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
 	int ret = 0;
 
 	data->irq_low = fwnode_irq_get_byname(dev_fwnode(dev), "low");
+	if (data->irq_low == -EPROBE_DEFER)
+		return data->irq_low;
 	if (data->irq_low > 0) {
 		ret = devm_request_threaded_irq(dev, data->irq_low, NULL,
 						cc2_low_interrupt,
@@ -666,6 +670,8 @@ static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
 	}
 
 	data->irq_high = fwnode_irq_get_byname(dev_fwnode(dev), "high");
+	if (data->irq_high == -EPROBE_DEFER)
+		return data->irq_high;
 	if (data->irq_high > 0) {
 		ret = devm_request_threaded_irq(dev, data->irq_high, NULL,
 						cc2_high_interrupt,
-- 
2.53.0



