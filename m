Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082D946EF9C;
	Tue, 21 Jul 2026 20:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664608; cv=none; b=f5gWMsSzUFfISJVV7OWhGnRIhk9mpgYVP0N/4MrkKYY6owiBQgIGgylYZ4rXFY4K38QDsZyVM1nTLa2x+tWFncCWsNE1aFlcSkVtJZJHnh7t18tz/Z4Da8kvI7qYYObMKzpK1qC3xzxzfOdL7ZdW7P7kwZjOx1oOXsRusi3Ifyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664608; c=relaxed/simple;
	bh=CQmxVeGno/337VK7NxNi/6MRUMiqp7iFQdW3tl5cSTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0uuihRO9WDRv1940fqaMK+hZEr4NU51Cyo6II8bJmRGXwfP38+0eRmuVNsLCmHosxKDLzUT50r/g/cRgg7zT7N/lJIusHYRFjLYvUbHspe8glFwL/o0bcnzA45zrLwfPPFDIlWuwQI5/8Ji712b9O+xV8B7o7eeJtKx6tixves=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASvdxvni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASvdxvni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369CB1F000E9;
	Tue, 21 Jul 2026 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664606;
	bh=ADx6ICDgtyjrxBXvSL1iYwDeamFYP8Z9zbMAAh3IPZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASvdxvniwfZIsOLLYwRJ3Q+M7GGAvPw+ywpA3C7HTY5syfInMgbflP8l7MJC0dcF5
	 mOE0P+Mcag8Ma6P2pzeZaxLhOscXajr5eIBiK3hi7mOLiaesdxXcdxShQ6yzg9lGi0
	 EZCOcSVLCM7Uhx3Y7+VWd5dL+rMMEGgACINaVWsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 1264/1276] Bluetooth: hci_core: Remove check of BDADDR_ANY in hci_conn_hash_lookup_big_state
Date: Tue, 21 Jul 2026 17:28:27 +0200
Message-ID: <20260721152514.375959282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 59710a26a289ad4e7ef227d22063e964930928b0 upstream.

The check for destination to be BDADDR_ANY is no longer necessary with
the introduction of BIS_LINK.

Fixes: 23205562ffc8 ("Bluetooth: separate CIS_LINK and BIS_LINK link types")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1367,8 +1367,7 @@ hci_conn_hash_lookup_big_state(struct hc
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
-		if (c->type != BIS_LINK || bacmp(&c->dst, BDADDR_ANY) ||
-		    c->state != state)
+		if (c->type != BIS_LINK || c->state != state)
 			continue;
 
 		if (handle == c->iso_qos.bcast.big) {


