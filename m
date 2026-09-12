Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9895D366052;
	Sat, 12 Sep 2026 09:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204381; cv=none; b=AVjtvwrlF26mh+Xa0wH8SvZMp1shCr+mmjsEyr0p3gCh7fN2Udj9uYSZcVjAko7RMbtkCAU0NCWl9CkQbV+h7P70ItaUThTqAaddniU2ECpbkZUuWIzofeWLZI3gZKwvWQDpvQi3BXxAwWHygEieoWUF3mHjXpDcQaktG7bPUsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204381; c=relaxed/simple;
	bh=1TgDTejC2aso1B0MpqSYBuPHsTFX3LF/QUaVKr0ir+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXoo4/b01NP1gOTaNgbtg6ohk9N4f1LdsbNJ0Ea8gHB6ZjiVDWbfuIcBMhLH5evNCytHiwiO/ucUZKPW5Yz3NfP+o2DBUqRPaHc1ei42GvYftT6+t/cpSA+IeYaN7ZUM3q9jieMrzTzmTUS8yNPY+IPQEVOlk3YtUnEwez034r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TC1WnhdS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TC1WnhdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5271F000FF;
	Sat, 12 Sep 2026 09:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204380;
	bh=GrS7756avIy0FSTmprnoD1bFS/Cv8Pc+vSkjqU33/UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TC1WnhdSeWNJrHn57sKikXXBat9cLrMlPL8E6cJDi+JN9UtvopIsztLCMH+m637Dj
	 4c2IAeRHOZlhJ1ctfCMeldtPCrdPeRPm5uiTGeIG9ibKlxCDGDa+P89wo/1Z1CW5Np
	 qlQmWK55RtEbISbx6nZ6dqkqseJjT1FnFIsqCNOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kendall Willis <k-willis@ti.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1558/1815] can: m_can: Use of_property_present() for wakeup-source
Date: Sat, 12 Sep 2026 08:55:08 +0200
Message-ID: <20260912065725.571782335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 966506838a4a8f51abcac8db67e6c2980f366134 ]

The 'wakeup-source' property is declared as a phandle-array in both YAML
bindings and Device Tree source files. However, the driver currently
uses of_property_read_bool() to check for its existence.

According to the function's documentation, usage on non-boolean property
types is deprecated. Switch to of_property_present() to comply with the
recommended API for checking the presence of a property.

Fixes: 04d5826b074e ("can: m_can: Map WoL to device_set_wakeup_enable")
Reviewed-by: Kendall Willis <k-willis@ti.com>
Acked-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260708030512.8570-1-phucduc.bui@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index eb856547ae7df..16f80607e150e 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2464,7 +2464,7 @@ struct m_can_classdev *m_can_class_allocate_dev(struct device *dev,
 		return ERR_PTR(ret);
 	}
 
-	if (dev->of_node && of_property_read_bool(dev->of_node, "wakeup-source"))
+	if (dev->of_node && of_property_present(dev->of_node, "wakeup-source"))
 		device_set_wakeup_capable(dev, true);
 
 	/* Get TX FIFO size
-- 
2.53.0



