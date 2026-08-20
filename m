Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBB5215075;
	Thu, 20 Aug 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248632; cv=none; b=Fs1zL5tg+rA3y78BvKn9H4xkSvvyquoFKOx8eREkP4mKIHeE2W/3h2hIkxSQ4b3uEEfV5ztOL/wwe6eDeqgDNAiMqPPDhKuWjenKBl+Pn9XSPh0a6ApLYkk4TgqmI3TPCUog1oyrqkhGxrgWx/RsLJNzvPLWVsZQCQxFit6Vb44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248632; c=relaxed/simple;
	bh=Kp51ImBqVofuqTxTxB0/dfjfciDrswlIrFcF9xoadu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aY9SviqipchIGYIghd9UxbLREGBFZZX5N4HMYmBQTQYAAxUTFNYLpn0ffPO0wD+51XXR9qOWnpmGoO224WMWEiV0GbUjF10Gu5CQboiNIcaOlK+Vql4v9PsgDPsgNrgORbyZFgZhJYbnT9eFO4g/oPsxLJfBXjTJU9ZSs0ajp6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCvBNHas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCvBNHas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0F51F000E9;
	Thu, 20 Aug 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248631;
	bh=QzUCiYOLY5ttxMoKEkGADFqP85rUmntx7mzAJTvcEb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCvBNHaspyRVyFE4ZkuN5i4ZfJjyXdo9OsFHhYZyNV1rj0ab3nUr+m55MgPs0thQy
	 OqPz47kDaGZWOijwxTsnwF0R+gqEeEv0g4pqm/RwqfccY8IeMPt4pRy06WG26vu8X/
	 8Sj0AmJiP4As+KnBqXXdUGH72Aaxe3zmmGOrhllA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 295/303] Bluetooth: hci_sync: Fix not using correct handle
Date: Thu, 20 Aug 2026 16:57:11 +0200
Message-ID: <20260820145302.341266876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 86fbd9f63a6b42b8f158361334f5a25762aea358 upstream.

When setting up an advertisement the code shall always attempt to use
the handle set by the instance since it may not be equal to the instance
ID.

Fixes: e77f43d531af ("Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1479,7 +1479,7 @@ int hci_setup_ext_adv_instance_sync(stru
 
 	cp.own_addr_type = own_addr_type;
 	cp.channel_map = hdev->le_adv_channel_map;
-	cp.handle = instance;
+	cp.handle = adv ? adv->handle : instance;
 
 	if (instance)
 		hci_dev_unlock(hdev);


