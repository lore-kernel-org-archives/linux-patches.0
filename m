Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B838271464;
	Mon, 13 Apr 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096421; cv=none; b=sq0fK6q3Kj3A4Ufa8rBttnrJOxu2eJ/Q6712g9tRYHumfXpo3KPxDvvdoWOaoaw2PgfivktVo5xmLv1iNri/x1cYUqjrjjeMXdKjlxC0WbiIlaGgL/PDp/K1pZtZHD60XBXOwkXbouNX0fZ6DWm0pWR7tIaEtSO7a595DWBUYIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096421; c=relaxed/simple;
	bh=RWdqWhgFTTBXhfWx9IyTen+UuFX0R6/7m8XYWZH/HCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVIAin87ib+TP6gS7dw5YUZMLfr1nI93YTQ2HrrD8+PdfUTKKDDnkersA0s4HXCJ3PGGq0keYeQygOZgRw9Kmb8LciUWnDfOPfvDIRPCRBtLXy6uEr6aaeQIFl326r8QBouGbYXZ/dKBM9O+WF2z73ohEr5P0bluYUMjyddc6F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VXwiysT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VXwiysT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB85C2BCAF;
	Mon, 13 Apr 2026 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096421;
	bh=RWdqWhgFTTBXhfWx9IyTen+UuFX0R6/7m8XYWZH/HCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VXwiysTtbUZBqrW2NKZl3d4qojuLVjFo84yDhFvnTnVyZ31S5fZYTkMRR6VZCtfs
	 F+Kn6OfYA/97LA2qLxQYGCIBShPDJmugG1RDgcFCQRrcfcsYmtPExWbM0PBoTO15bV
	 ZiU1CL0CFCYHNsMOmDB78YolGsgHWrfNvCqu6LZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 71/86] rxrpc: Fix rack timer warning to report unexpected mode
Date: Mon, 13 Apr 2026 18:00:18 +0200
Message-ID: <20260413155734.199029881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 65b3ffe0972ed023acc3981a0f7e1ae5d0208bd3 upstream.

rxrpc_rack_timer_expired() clears call->rack_timer_mode to OFF before
the switch. The default case warning therefore always prints OFF and
doesn't identify the unexpected timer mode.

Log the saved mode value instead so the warning reports the actual
unexpected rack timer mode.

Fixes: 7c482665931b ("rxrpc: Implement RACK/TLP to deal with transmission stalls [RFC8985]")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-8-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input_rack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/input_rack.c
+++ b/net/rxrpc/input_rack.c
@@ -413,6 +413,6 @@ void rxrpc_rack_timer_expired(struct rxr
 		break;
 	//case RXRPC_CALL_RACKTIMER_ZEROWIN:
 	default:
-		pr_warn("Unexpected rack timer %u", call->rack_timer_mode);
+		pr_warn("Unexpected rack timer %u", mode);
 	}
 }


