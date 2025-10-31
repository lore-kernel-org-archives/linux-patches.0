Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F962AD4B;
	Fri, 31 Oct 2025 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919343; cv=none; b=tdgNCBibsEALW4ouMeVxQwkEfnVxH4VYZZ8iPT2kbj5t8v2rYY5odNazXi5NWp5gwZmgF47MKskWupC1nAq/KeDqxEy0IIzgRkOfmvPqU6p1bT9JD7DK96qEQi02d7sRMZslMImpj/YfewX2C7s2usUq8mMo7d4RmE2pqIELxSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919343; c=relaxed/simple;
	bh=yc8C1VSJ6GSJrUyXCRDuSOtxAX1cUz1L3rl3IJ5hBqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eMuTL+7jjmGZ60t6iyRqFF1KbKXC5de9OZOfBHN4v2hINKUE5fjZp56UCR40sExGSteSWJiA1OcG/PXVOtBsy/3ljewJWzkrjailuNZegKY9mEbcfTLI7ZwUEvs02hALWR/dAzMHScHY8eQigObHBOlmnYmV0UG3DshJgkQboPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpMe++U4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpMe++U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E61C4CEF8;
	Fri, 31 Oct 2025 14:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919342;
	bh=yc8C1VSJ6GSJrUyXCRDuSOtxAX1cUz1L3rl3IJ5hBqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpMe++U4RiBgDCbv2fmsO6fWw1ysYI1rxcJ7siOPRgwC4arojyYanDj+6X33Be3CE
	 T8ryAs1nFvvP0YW/2THmzbM36p7oPvGbxJ96AzdWSXbLM5HgVIiUHHpPsSVdoRXXJ9
	 3kZmwro83qDwX1AatdN+/I9gUimddAxkuaeQjzW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 19/32] serial: sc16is7xx: remove unused to_sc16is7xx_port macro
Date: Fri, 31 Oct 2025 15:01:13 +0100
Message-ID: <20251031140042.901206602@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 22a048b0749346b6e3291892d06b95278d5ba84a ]

This macro is not used anywhere.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230905181649.134720-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c05bf6c0262 ("serial: sc16is7xx: remove useless enable of enhanced features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -358,7 +358,6 @@ static struct uart_driver sc16is7xx_uart
 static void sc16is7xx_ier_set(struct uart_port *port, u8 bit);
 static void sc16is7xx_stop_tx(struct uart_port *port);
 
-#define to_sc16is7xx_port(p,e)	((container_of((p), struct sc16is7xx_port, e)))
 #define to_sc16is7xx_one(p,e)	((container_of((p), struct sc16is7xx_one, e)))
 
 static u8 sc16is7xx_port_read(struct uart_port *port, u8 reg)


