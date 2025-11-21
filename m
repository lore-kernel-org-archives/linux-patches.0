Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA513491D5;
	Fri, 21 Nov 2025 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733350; cv=none; b=LBBfOExeCBlpGJ7mQQzpnh7Ajw20cZ+i/Yc9ZYAaOkD7UViFGsMpjYxp9TBackfo3ipBdrOxSSt7q92VpG9PkI+wPsfRsmJwl+oDcrkn/Jq6h0KkFhf7VOxOyg+f2i0R9qMqmLEEcnqgRvjw0crJMmhNqCPS2EDGOXUQsfIJJks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733350; c=relaxed/simple;
	bh=2N6QOEao2pJXAd5y+z+8HTfHIBxIi6sKZWXv+jGPVvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXl1nwjLQesXcqLvctJW1Y4gkD4/v8Yx9AjPYtH/U2324rjWxbyAAaqo84BscOVqMpswAT/BaDdWF7MF0UPa6gE1QNL5QVUvNaX71Fk1DIoSViu8dLgm8AsSq+6jXAgdShX9wlcxecCYnUZOsJTUwkiCjsgOD9/oKMX+bZRgBfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xj8LDHss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xj8LDHss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE95C4CEF1;
	Fri, 21 Nov 2025 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733349;
	bh=2N6QOEao2pJXAd5y+z+8HTfHIBxIi6sKZWXv+jGPVvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xj8LDHss9PASmvgR6q8a3DemSKAPpSaccIPzAbmPVImMOWoZecSaxao4rlmh0Gcok
	 IEE+y9MZ5TL19iSgP1XbnjTN8nlsiZ4GIROrkf95hWZKgw8XqN4XFVXqiNlyUg7Gae
	 Yl0515mxdCYsLCdUf5DHNhjiPzhaXPEdH1BNbxTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 421/529] Bluetooth: L2CAP: export l2cap_chan_hold for modules
Date: Fri, 21 Nov 2025 14:12:00 +0100
Message-ID: <20251121130245.994445933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dabc07700197c..ad46112cb596b 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -497,6 +497,7 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 
 	kref_get(&c->kref);
 }
+EXPORT_SYMBOL_GPL(l2cap_chan_hold);
 
 struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
 {
-- 
2.51.0



