Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E891464CC0;
	Thu, 11 Apr 2024 10:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832662; cv=none; b=buGRu+6vF3tCA9V0n3GM8UeDoJkf2slR3TMFSLBxPdUdB3mzjHZ/iTC+y4E94I+3QooWfUNrtjHw4coMMbw6xk1hlNB9CinFPPZSPo0Nhil9nJeDFi6l40QvzthysmCyeed++jGQPslkVvj9P9uYQkwG/zkraVPPIepPiQVc0XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832662; c=relaxed/simple;
	bh=Y542NSK8+1O99wbRBcj2ZSYMgSqUEjvHsQS5VtcbhzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeUDTurP3sESgISEbcLCXmqH+gLLXoALH9kzh2qzlQsgpA2x4DlwsQ0E55KFmrWAFLCq//A8bwfUnW6c5Fjy3DzuKIdl0OA4QOX5Kg0aQ+kgLVTQqc00nzl1d2vGrvmYH+PITbIsJyVh/QDUSMcbis5kMFIgI0UlorX+cQ3ysEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ay9tPJIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ay9tPJIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687C7C433C7;
	Thu, 11 Apr 2024 10:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832661;
	bh=Y542NSK8+1O99wbRBcj2ZSYMgSqUEjvHsQS5VtcbhzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ay9tPJIJAhxndt5MLYebFtM4zOs6IkHuRg1u9bwvd5ED591c62liw+0w3on4H6CWt
	 FKxMiX90JenNuMqiGDdIds9Wb1/hX1DHIGgA1/WBlPIxv8FO5OV1T79dMJo9BOuMs5
	 aFbB74NtvILw8LpSvh8b6ZODtO+270JpqHmqweZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 40/57] usb: typec: tcpci: add generic tcpci fallback compatible
Date: Thu, 11 Apr 2024 11:57:48 +0200
Message-ID: <20240411095409.205276052@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 8774ea7a553e2aec323170d49365b59af0a2b7e0 ]

The driver already support the tcpci binding for the i2c_device_id so
add the support for the of_device_id too.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240222210903.208901-3-m.felsch@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index a7b0134d382b8..e047a15e67347 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -899,6 +899,7 @@ MODULE_DEVICE_TABLE(i2c, tcpci_id);
 #ifdef CONFIG_OF
 static const struct of_device_id tcpci_of_match[] = {
 	{ .compatible = "nxp,ptn5110", },
+	{ .compatible = "tcpci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, tcpci_of_match);
-- 
2.43.0



