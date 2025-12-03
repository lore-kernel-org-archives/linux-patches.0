Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888FE257423;
	Wed,  3 Dec 2025 16:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778146; cv=none; b=YnYbyGEj6fh2fSokEe8YuetsG7v7FWVqD7nQc5jSynBEwc2hnC2uEXGIakmA1L6NoQsmmzDGXuaAYruD78yyAR/p1cqb2LF8tCyMX/eQ0miDQMhe2XGI8Acuq54JV58q5Rkun0J3DLG/QgCRJG5E5lr9ew+a5FQmN/TlM99NmLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778146; c=relaxed/simple;
	bh=AUoHBphc0EqbKt8aAJF2RzEzwIx1OQWdS6Yqp5kdVQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2+CjOD4OcZ3dAJC5tAdeVlWlVqvmGh2PTS1rV3t7Ir+ZapDLoQX5JOTIMsXM7AskX8liCht6xuFv4jNiVlijxh9F0++32TeagttfUt2jfCJLklr+AbrCgjfw8y7D9b3e3GJI+FJyZCxhKsIJl8W5NdyUuIyB2mGK+YIev7Cc/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9+UERWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9+UERWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C36C116B1;
	Wed,  3 Dec 2025 16:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778146;
	bh=AUoHBphc0EqbKt8aAJF2RzEzwIx1OQWdS6Yqp5kdVQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9+UERWjI9oVwJb3KOqQIHnbVTJT1rtDphdiiaGwTf34R8tN5QHzuHGOkKXh7QhAG
	 a5vzyheYtBQ8FEmteTv5dCGBqKjrg4iTDU6r0t9flBufkRSVe9gyjbGX6DCRCbowJA
	 ZlLBiWTZb/hZfyp3RFvNewBW8LNNsV+Mg0eywdEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/392] Bluetooth: L2CAP: export l2cap_chan_hold for modules
Date: Wed,  3 Dec 2025 16:26:47 +0100
Message-ID: <20251203152423.625811316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1af639f1dd8d1..06be471ce0c04 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -518,6 +518,7 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 
 	kref_get(&c->kref);
 }
+EXPORT_SYMBOL_GPL(l2cap_chan_hold);
 
 struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
 {
-- 
2.51.0



