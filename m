Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8813B52EE;
	Thu, 30 Jul 2026 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426951; cv=none; b=k8/ypoAx6LCV7c78XA3YE9ufKVxySA4X3IAXGL5oMYAGf35McJ/x6hetvM9a41fxmBaCzMg52Lug3v1f7GlO2gJTA+VDEG96slNpPCyXeZLL/GJkpaoB0TL6y45HlpDLpRmW+a9sSITOfx8xFzetkOH/Q7euOUypkPm2rQWWFLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426951; c=relaxed/simple;
	bh=hbBdDa7DIU1p8rDYz4H0TAEzkAWTLBTomerEFDk5nUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpstplhYjuuKXs73rprso/4PVHsnxhQv6varjNOYMgI9V5/q186WQslEZI3KJSopHhHwVndWCZogCCjoyNOpKLb4V/MrlM7pEhvj0bZVWWxTD4R0UsMIlbInXa7sUMvA4nyJUOQtFlNg26CPT+ehMU4gbiwf5+OC6oHGbz+BomA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9YCnwGG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9YCnwGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FF41F000E9;
	Thu, 30 Jul 2026 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426950;
	bh=2NkDo1RLJhKbZBF4UWU1c+RLoIbCSd9zLPgHx9InXg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9YCnwGGIfnENhNZmv3Jshm4aUrOuc31SsDehEUWZxvKK+lGnIxoFaiu/DTi/TklS
	 rZ7kzl1PHh6dCKx4e8Rk3Bd7BhVsexDPP5XaMO2km/bfomthQMjC0o1rJA7ZHID1lK
	 oW9HfOB/T0DQsyO7YSKXi+7ji7mbI+Us4vBcwJZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 598/602] Bluetooth: hci_conn: Fix not cleaning up Broadcaster/Broadcast Source
Date: Thu, 30 Jul 2026 16:16:30 +0200
Message-ID: <20260730141448.622182942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

commit 3ba486c5f3ce2c22ffd29c0103404cdbe21912b3 upstream.

This fixes Broadcaster/Broadcast Source not sending HCI_OP_LE_TERM_BIG
because HCI_CONN_PER_ADV where not being set.

Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2277,7 +2277,7 @@ struct hci_conn *hci_connect_bis(struct
 	 * the start periodic advertising and create BIG commands have
 	 * been queued
 	 */
-	hci_conn_hash_list_state(hdev, bis_mark_per_adv, PA_LINK,
+	hci_conn_hash_list_state(hdev, bis_mark_per_adv, BIS_LINK,
 				 BT_BOUND, &data);
 
 	/* Queue start periodic advertising and create BIG */


