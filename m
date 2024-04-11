Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F8A1D558;
	Thu, 11 Apr 2024 10:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831351; cv=none; b=XLFv9JKVzxRPegq7ROigmFm4netthpShI/9uBJBhuzribUyekxEbnIZUnoHYB8oZoq1cj1LIXs4XLfC0DzYsMw6FjRlPrQiju62Tg1sNeeWOQlYmOixOpCWP3TOVrzRcoIR/AzRviXs+yQpdfWdYrVbU6MoUElWPNj5ZSnhhb5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831351; c=relaxed/simple;
	bh=0rXZEDwpQNVvVr14kMdM/UO1dF9Ei4YjVaSakf0FeDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPG4Ij3656KeHUxjKVwGYF4acMTciGJFzPJuE6JZY/hVDnozoV10jtvGTpSWX0V8KXppqtYoeHr4hPuD6ta4wdkXutQPHN6CzIkqyLP820IWxPB+N36sbnuA6x39NQmznU7NVgmEyR8YgJ8Iqfi9SqCBNCTzgDWlYmS/naAONyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqluGGZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqluGGZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B14FC433F1;
	Thu, 11 Apr 2024 10:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831351;
	bh=0rXZEDwpQNVvVr14kMdM/UO1dF9Ei4YjVaSakf0FeDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqluGGZX3EtGlQabxavjCxbZ9Z99Txs7wGVXpGhpnQ6lQZ788+ppMaOSfPL52xK0w
	 Oa7OTglrIeEO01r5Sc00SxQDJ4E2MbCfijAv3jN1Kc3ucGB4NTVXLPEUTvmrgzM/WW
	 KunwIJ8MuYF5TSFUvx3EFHBXbEiKAOPBdquReDYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/114] usb: typec: tcpci: add generic tcpci fallback compatible
Date: Thu, 11 Apr 2024 11:56:59 +0200
Message-ID: <20240411095419.669009630@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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
index 0ee3e6e29bb17..7118551827f6a 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -889,6 +889,7 @@ MODULE_DEVICE_TABLE(i2c, tcpci_id);
 #ifdef CONFIG_OF
 static const struct of_device_id tcpci_of_match[] = {
 	{ .compatible = "nxp,ptn5110", },
+	{ .compatible = "tcpci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, tcpci_of_match);
-- 
2.43.0



