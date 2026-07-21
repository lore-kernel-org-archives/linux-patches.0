Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E59A3B71A0;
	Tue, 21 Jul 2026 21:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667947; cv=none; b=IyM89gAZI+wZCoFII59wmwAoLW0oUrfHdLPUCdFFxQvtAQ0z4aSSaZ0okIdxGKC2VjmMFFmrvP7TcdJjUHyo42GZ+GeACqGu7iqczOgzf5FWQsveHSlL1bUPqIg4+GUY5XICwxN2dBYn28X4y+/caEIQDB9vgO3/X+1CLbFxlSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667947; c=relaxed/simple;
	bh=Xcv5/4UbbrmRO/vKGVTAsTU7Kb1k4DTadG1Qo9Ip4A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ1kBOWZilGvsM7rV0yXAyaeG7XE+vrUpZLIflJL0sTXpHCgdtMqjF8rUOt+6rupVVaIwHurWq4PPLcHAgWRo0dUF3Fe1AzZ7CZzwvt/ruLNCjCK+xyPcQpXqMUAw/rdg5NnyClsfTYasl88ajtvkOU1W1oEN7J8rOBnYo7uhgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkZF+Upu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkZF+Upu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740361F000E9;
	Tue, 21 Jul 2026 21:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667946;
	bh=W909kzAd6B8+BJaPieaol/95JfhXAGSXmL6aaW/+WSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkZF+Upurh0ikXrfNP5kbWPLYV8z1AGKa8DY4WgjqTQpobTvklpmkBFpy4ZIXwJnI
	 qSdbQtPl3whykM1lfDfk8YTk3vxftwB6RKhjbjIAib5E3roLzSo7N0+Fvp01P01wZv
	 SvdkPJyTIXoqlgj3AMhvcqetD0Czmac3hRFapSMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1254/1266] Bluetooth: hci_core: Remove check of BDADDR_ANY in hci_conn_hash_lookup_big_state
Date: Tue, 21 Jul 2026 17:28:11 +0200
Message-ID: <20260721152509.885241189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -1339,8 +1339,7 @@ hci_conn_hash_lookup_big_state(struct hc
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(c, &h->list, list) {
-		if (c->type != BIS_LINK || bacmp(&c->dst, BDADDR_ANY) ||
-		    c->state != state)
+		if (c->type != BIS_LINK || c->state != state)
 			continue;
 
 		if (handle == c->iso_qos.bcast.big) {


