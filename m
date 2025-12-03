Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B048035BDDB;
	Wed,  3 Dec 2025 16:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779846; cv=none; b=Lr4aGgMHQs/BixWZw2I7+c5KoIYTpLC6bCOgrUZaphbXwDZUgON3gstVij3NCODUCwxqOgwM7HoRsp2kWhWlfFV3rSF3Qo+QMCuOr4+c1/+JayVSiYmhxpPzUp5d/qGtzZV2VB+d5HtfgxxfcH7udlQyRDE1AdZDcurngJsBd04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779846; c=relaxed/simple;
	bh=Osa/5skVqXVfrvH4iRB+KMk+SvunucpO7YNCdwHM0/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFWcI2tDwwteFB27JrWsSdj7S/pX6vRqRXWDIpdNSOdknYiqZop6FInE438OPeyW/ruQPuQBEb7xIbHC0RgPXJQOCgEsi5BUDPKx2UBKtHgBfj2PzVWJz+UxVYPAl+4kz42bWsqWkPyABZExehnXHFXzw2B1eehlawU52siJUrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1ANv74S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1ANv74S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B6CC4CEF5;
	Wed,  3 Dec 2025 16:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779846;
	bh=Osa/5skVqXVfrvH4iRB+KMk+SvunucpO7YNCdwHM0/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1ANv74SVpwVwQ4T5Wf5bOYC68IMrwvdiaLo7MeBxH1BpoYK5oyIhZr0a/I0gSXDm
	 4zXGM0egXrVo1vaWPyDLr7POIKA+gzIBuBaDrmHVEmD4bDGSJJUmZOVfB6XRzw0efF
	 OVOE8tgRepktG6kpPshH//9E9Ogd1hTKjiusY/ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 379/568] Bluetooth: L2CAP: export l2cap_chan_hold for modules
Date: Wed,  3 Dec 2025 16:26:21 +0100
Message-ID: <20251203152454.578188607@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8bb6d2690e2b9..ea82a468b314a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -521,6 +521,7 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 
 	kref_get(&c->kref);
 }
+EXPORT_SYMBOL_GPL(l2cap_chan_hold);
 
 struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
 {
-- 
2.51.0



