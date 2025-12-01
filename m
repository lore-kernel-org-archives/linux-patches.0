Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516F58635C;
	Mon,  1 Dec 2025 11:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588715; cv=none; b=sL1cLuoXt9gu6H8s3AysaKgEnkow5EztgMtisGxRqTDjKA+ytmXnLLdf5fWKNDSb/OyLWMW2QcmFS4nPfjP6/nXvNU+UctK4+GvoD0Zy33v/73A92gWIE7OLVEgHXdQafdz4UPB0ZSw4zbrEqrpeBX0BCgPORsIeXss/adSvKIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588715; c=relaxed/simple;
	bh=5twT6OKywLsNdQTc0Uco+qcAUZxWDk+xfcMOtpP9CTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzKzsaraPDYY8+SwqSaMJUIFuwVSIAmr3UJwKzynRi8wv4XvoovS0CpOBDeSz2SUpYurRUgjmiswdPEIbyPQNAKPH1gkbQIFaw4V40LFzQ4bCpWs64zcHrZJXrZJ8duLJhH6TzY+2en9FRHMashkY0H8oL9nZGmb/39XRxUMf3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb+IPdv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb+IPdv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBC7C4CEF1;
	Mon,  1 Dec 2025 11:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588715;
	bh=5twT6OKywLsNdQTc0Uco+qcAUZxWDk+xfcMOtpP9CTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zb+IPdv8glJi1fevQk6ScULlJGbBLJdqJhq8OcN0tOL4D0NqBLhBPcQ1aU5YTgtQg
	 8moewQbJm7cDq7CcMOCSjQq3lnzmGuGtML06VNvp0rBK5U7iXgB+y0cKH+xrPENGgY
	 6+UiHNqzfQ8ua4dQwiJxvVTDVBiit37W+Wcnn+0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/187] Bluetooth: L2CAP: export l2cap_chan_hold for modules
Date: Mon,  1 Dec 2025 12:24:13 +0100
Message-ID: <20251201112246.458959316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e060088db0bdf7932e0e3c2d24b7371c4c5b867c ]

l2cap_chan_put() is exported, so export also l2cap_chan_hold() for
modules.

l2cap_chan_hold() has use case in net/bluetooth/6lowpan.c

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1272ad73e4011..4c82770173aad 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -517,6 +517,7 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 
 	kref_get(&c->kref);
 }
+EXPORT_SYMBOL_GPL(l2cap_chan_hold);
 
 struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
 {
-- 
2.51.0



