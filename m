Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FC31A239A;
	Tue, 21 Jul 2026 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649042; cv=none; b=Gq2fBkxjI/CSDMQCmLd9GYuwkqoZIJ9VQ3t0tsVrwAcH2E3VEYB9pGyLqR7fiIbhYYAOreuTXonl2FhdNUacFx2xpUAd87/P9XPofgU6RDIsR5GpmFocISPYaMjVj17Jejzs7CV1RKcLpJLzPYkD6IyxtVeP4+7Cf35WDKO6wSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649042; c=relaxed/simple;
	bh=FrxOqrMFpFtElnsW4zcqQLb0otvyMdHbZY7Py4GQNyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnoOGNlbGWVr2oOAtgmXCEhHe6YbDTB5Te63kWc5Vu/fmszKGXrYKE5GtFz/2J5TlYrBZ7k3PzL6Z8sbF2ezfkjPi6SaKhxA4EWOvOarAX0CF0XZa/58jbJII6IB4Z2ztNya1I8FQImjgniKS7GhtsDX3n2vgYUKUjzRXlVX7xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WJ8Gkok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WJ8Gkok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57461F00A3A;
	Tue, 21 Jul 2026 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649039;
	bh=YtJG/+RF+WhBk5z9plxWbEfuaQEOpgJYXii0RT/10nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0WJ8GkokXVNaRgHhgVKLqLTwz7U6Dr/EN1g3x5nFt7LH0Ha6ZMrgcW0c+/n8xN1WA
	 cvVIcXlBA5RZQ4ufIdeW6slmkL1dQENhM8D5JYmkZD9fdhLOdg0cZwl+DR2yTj1lvf
	 WheU7OPBEMCYV2i4iVg3uvddpA+JVDKzwYv4aVbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Van Jacobson <vanj@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Tim Bird <tim.bird@sony.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0427/2077] tcp_bbr: fix SPDX-License-Identifier to be GPL-2.0 OR BSD-3-Clause
Date: Tue, 21 Jul 2026 17:01:40 +0200
Message-ID: <20260721152602.815457473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 4490516d2109e105daf732681435c5c075b5d61b ]

Since TCP BBR congestion control was introduced in
commit 0f8782ea1497 ("tcp_bbr: add BBR congestion control")
it has always been offered as "Dual BSD/GPL":

  MODULE_LICENSE("Dual BSD/GPL");

A GPL-2.0-only SPDX header was erroneously added in the recent
commit 2ed4b46b4fc7 ("net: Add SPDX ids to some source files").

This commit revises the tcp_bbr.c SPDX-License-Identifier to note that
this file is licensed as "GPL-2.0 OR BSD-3-Clause".

Fixes: 2ed4b46b4fc7 ("net: Add SPDX ids to some source files")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Van Jacobson <vanj@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Tim Bird <tim.bird@sony.com>
Link: https://patch.msgid.link/20260531183558.2337381-1-ncardwell.sw@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index aec7805b1d3763..82378a2bfd1e19 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /* Bottleneck Bandwidth and RTT (BBR) congestion control
  *
  * BBR congestion control computes the sending rate based on the delivery
-- 
2.53.0



