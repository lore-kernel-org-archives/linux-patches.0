Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04D9146A71;
	Thu, 11 Apr 2024 10:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831096; cv=none; b=hC+kysO3kWBCWayLgojo50aEkMGTnhX/oVaH3DmvmgpToLnOBT4rXoVRdgJt2MN5siCIY6tHiR8ll8/Vh8M27zaYL6Q91Jyx4lOoc9rcJCPjwIz3HtzlIjPaI7aW+lIfYQBtB6S4FFmUBMNxMf+y/6QWJdPrrFqA67mfP8KL9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831096; c=relaxed/simple;
	bh=3cZWNiS+y4VOWWXqaMO8p1WR+EwtKKsLaWZfKyLrZc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoxChzwKmEMvAbwSu0bIyYruDOXh2NaFO3WrWnsC4M3fBMaRD962NGFYerlQbLW6R2iLqNJYVFeXGRJX3q8p32zJC78M/3nH912E+f0EMEej04tYVq3sVi477pDlACtRWfQ2KpNx3SgrT7SJ4I8+s/lnAaXsD9bdMrWElCan6xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWeZPEMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWeZPEMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C267C433C7;
	Thu, 11 Apr 2024 10:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831096;
	bh=3cZWNiS+y4VOWWXqaMO8p1WR+EwtKKsLaWZfKyLrZc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWeZPEMTYMB7Zn7woqFNL3/EYdEmMXZTymIzFomsCu1dn94dq9np1nkWYUPGbSnu+
	 kRkn6NVi19D1SMK/NAKCCR5PVNzH3nngQIr0QsLQoUUeDSbr67/B7vTo0uCU7aiS2Q
	 Cvyu6ch7ZZ+ZyRKVp0iFw2mmuWmNpP1NXpPVaszQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/215] usb: typec: tcpci: add generic tcpci fallback compatible
Date: Thu, 11 Apr 2024 11:56:46 +0200
Message-ID: <20240411095430.781842014@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ccb72875c8ee5..c11c2f71521ce 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -634,6 +634,7 @@ MODULE_DEVICE_TABLE(i2c, tcpci_id);
 #ifdef CONFIG_OF
 static const struct of_device_id tcpci_of_match[] = {
 	{ .compatible = "nxp,ptn5110", },
+	{ .compatible = "tcpci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, tcpci_of_match);
-- 
2.43.0



