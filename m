Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E29142624;
	Thu, 11 Apr 2024 10:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832239; cv=none; b=aNv719eUUnDArTIjkA5S92sn3ugGi6fnYb0MAA28WZhELVi80tECrIgpWB1DlGg7mpTswogvQ6rpFGwUg4NOYcjfbnPAevJihLTgCA0TKZAaQj1KVw2GF3jadWe+w2xXKLvZvVHExiDxJhP/PoFP89BEe0ZzX42yGKQACnTmncM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832239; c=relaxed/simple;
	bh=ZGofY7EdWaiOXqWTsqeG+K7Vp5QFAb82Y/xFGUYEnu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMNWhHpAVAAOq4+uSq44iJsgpaf3uES+QEEM/nyjYExeRoYDUF96cjFKbbcvOeSyOMX26pbzG6QpVa7kKg1PE0+3i+C2hCikWm7E9CXkYltYscENu3AhobDST5nf0zlWhCPo/jsA4KcMG0fQATegC47IW1n4hQkMoH0ZlgwIWO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=me5PJtud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="me5PJtud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADC4C433C7;
	Thu, 11 Apr 2024 10:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832239;
	bh=ZGofY7EdWaiOXqWTsqeG+K7Vp5QFAb82Y/xFGUYEnu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=me5PJtudHEZGYz2ot26AjkuK59rVPlu0Yo9KxFRmuiEldPP+D7y2bgzcE005dg+Su
	 cplgX3MWuMogMpuTqqoLfqYMCOmJ4ogBt9lB/caRFsAXcDIMgjt+QSGJN5zg+tcg3k
	 Xtnr96eDWOhIyViKzPBXw+tGnyDS9+MUbETiCHuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/294] usb: typec: tcpci: add generic tcpci fallback compatible
Date: Thu, 11 Apr 2024 11:57:20 +0200
Message-ID: <20240411095443.882398700@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e34e46df80243..33c67adf7c67a 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -732,6 +732,7 @@ MODULE_DEVICE_TABLE(i2c, tcpci_id);
 #ifdef CONFIG_OF
 static const struct of_device_id tcpci_of_match[] = {
 	{ .compatible = "nxp,ptn5110", },
+	{ .compatible = "tcpci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, tcpci_of_match);
-- 
2.43.0



