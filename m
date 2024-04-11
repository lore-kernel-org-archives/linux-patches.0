Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC4B1448EF;
	Thu, 11 Apr 2024 10:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830351; cv=none; b=OLSK6WQJTFuTCfoAE63ls9NAwz/pVKYG03L4QO0N2/21K5tfAqGpg9cwT7f0KxIfnUoZzKQKDJRDth1y3Qm7FyWHrwwQT02eNZuEjXRcL8+yxCPl7dIYO8LmNRpb1F9N6EX/uPuKBoKTh/mCRPugRBGiaZCmgAN2X1HA57miqzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830351; c=relaxed/simple;
	bh=6ikfXHeXH9UZyFFRr5yGkTXSUlEt8Hqz7y+2A63tcbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbObmVVnlzzaDkZzkzbvTSALVHn/vel9ZsRwV7WHOP/1dln1b9MENR5vVZcpv1YCguGqxxvL+DuQs0yQAe/GRHxiM4YORXw4welX1Rvz7hTd6+KkXuJX1TnaBTAkFrIYnLkwlJ6wEkjgrO67i9pFfDO32UBgkqahwKzRKbia44k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNFY3/mC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNFY3/mC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F137C433C7;
	Thu, 11 Apr 2024 10:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830351;
	bh=6ikfXHeXH9UZyFFRr5yGkTXSUlEt8Hqz7y+2A63tcbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNFY3/mC2GsNaicJpt48QmFe0no+zZCkRkN9mNTuM5XSJcPjap5qQaKvnlkEep2r4
	 3WaHsNuwFhHnU3XoTri2/LKwb+h84gxvF1y0cR1XY3srnXuDggoVUZwcHhBCB4Qkfn
	 T4rPBT+RTGsz8+wBneP0mMdXo+Cx0kF7QEnVXoig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 118/143] usb: typec: tcpci: add generic tcpci fallback compatible
Date: Thu, 11 Apr 2024 11:56:26 +0200
Message-ID: <20240411095424.458820320@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



