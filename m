Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF3275B18;
	Fri, 21 Nov 2025 13:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731107; cv=none; b=T7YMujkf8BAa3zzlu2LzGGk/olB4BsO3MbpHFx4CM0aZVD5N+A0HaeSjEVla4J6wXo3tpi83Mc6bk500XdkDwG254JqwojcRdhBHk4R3nfWTiAiEHq1+rhdEw8km10dMImBUm/2ciPIl64QQHVdd8GJhM2lqYN+uWH9W4qkYm74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731107; c=relaxed/simple;
	bh=KoT2/F2OvEmeNFsVOkvcbzYQsLt1xmlNsPnwE9d1j7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IU5LIiQLg06nVHO3O+kUHkF3fzN6x5nK9T3Th7WznN6GS+WlskeE5/XcGwhVOWL10TuzvXyfo0iJ9D9Yzxaj/J80Ud0y3eEpEiNi5r9cLU4ubOTv1u/L8wgJN3PZ+3aKwUBIL+Lznm6CErqeWROmI+HJxQmc1sRuPctdakWSomk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6i2OSaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6i2OSaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACF2C4CEF1;
	Fri, 21 Nov 2025 13:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731107;
	bh=KoT2/F2OvEmeNFsVOkvcbzYQsLt1xmlNsPnwE9d1j7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6i2OSaPfdR5ODetffxdQGb799ygmE3egBrxotd8Xo6q+DIAQdhZWZ/q3vWltxoOg
	 MYAQkMeYWXfGewouuwTRklGp8lIcoEMZrhWgATsLjkO1ui5ZkIXT2OvDe/7s3Yrf2U
	 1hcrt//V6O6lhoitBJE/gsU3DJiTLEggcoFVYsmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 093/247] Bluetooth: L2CAP: export l2cap_chan_hold for modules
Date: Fri, 21 Nov 2025 14:10:40 +0100
Message-ID: <20251121130157.930046562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d08320380ad67..35c57657bcf4e 100644
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



