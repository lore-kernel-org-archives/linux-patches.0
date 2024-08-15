Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366DE19F49A;
	Thu, 15 Aug 2024 14:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730716; cv=none; b=M6sv7KMLiP95RZgQnVmc8wVIIbImDT9kKd74ASsmZ8h2GSOAN48NnUFHnuaySzYg60B9eO/fDDMX4Nz2rZCJu90RG8Jm4L+20ap5J488XXj/nLs+mucpEUYiVkIgT2jzkecfHWvIaQle2Hwl8D0v1WWWgCkTCzYizE3mno64BJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730716; c=relaxed/simple;
	bh=+0gUZK33TChAGhYpYSOSUYr+1V21TAa3TayiVMtSj28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTcXLLOpclgP+tHgFDa7hrT4NKg5awFMY9QXTmfj73r3R7j7cN3UJRmDYT3F/8YpmbWOxdaZvQ7kVRcVu4ADYnjwaYFrp8YUPbp9Bs24U/5frw6Z7BsfpesjKoP2bsyGfcnKwBd6D3AuYyaF6WTRsiMxhV1NM3GeXYAeM6zN9CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlJy4Wz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlJy4Wz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45C6C32786;
	Thu, 15 Aug 2024 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730716;
	bh=+0gUZK33TChAGhYpYSOSUYr+1V21TAa3TayiVMtSj28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlJy4Wz4t8bAQtc+ChdOioJPDuF3LoSW7QGWjmVLCxwW5D4qvCZAu73rw6rDSNi2K
	 2m0oRbUY/rowT21tIqYJ/oSw4SCZGnFtvLnKkJAW+G7xQtIxi5xgzdsLk8ItxB9+ZW
	 myJgyKkef+WYLEGQwCBQzE36ovZeKHUBNL6QRzHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 02/38] mptcp: pm: reduce indentation blocks
Date: Thu, 15 Aug 2024 15:25:36 +0200
Message-ID: <20240815131833.044733772@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit c95eb32ced823a00be62202b43966b07b2f20b7f upstream.

That will simplify the following commits.

No functional changes intended.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240731-upstream-net-20240731-mptcp-endp-subflow-signal-v1-3-c8a9b036493b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cd7c957f936f ("mptcp: pm: don't try to create sf if alloc failed")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -579,16 +579,19 @@ static void mptcp_pm_create_subflow_or_s
 		if (msk->pm.addr_signal & BIT(MPTCP_ADD_ADDR_SIGNAL))
 			return;
 
-		if (local) {
-			if (mptcp_pm_alloc_anno_list(msk, &local->addr)) {
-				__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
-				msk->pm.add_addr_signaled++;
-				mptcp_pm_announce_addr(msk, &local->addr, false);
-				mptcp_pm_nl_addr_send_ack(msk);
-			}
-		}
+		if (!local)
+			goto subflow;
+
+		if (!mptcp_pm_alloc_anno_list(msk, &local->addr))
+			goto subflow;
+
+		__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
+		msk->pm.add_addr_signaled++;
+		mptcp_pm_announce_addr(msk, &local->addr, false);
+		mptcp_pm_nl_addr_send_ack(msk);
 	}
 
+subflow:
 	/* check if should create a new subflow */
 	while (msk->pm.local_addr_used < local_addr_max &&
 	       msk->pm.subflows < subflows_max) {


