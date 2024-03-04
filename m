Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DB578B47;
	Mon,  4 Mar 2024 21:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589327; cv=none; b=jhhGrfBceKZzuRSwsH24OAG2B7ARBKULKSKQeZYeJp3nripm6nOHx2tUb2AkJGfX0jt2FBpsbpUadVwyBlWo9G8Pn5XTvQsniCSEr0HimYICSJxKFunOt4VZHZMk0na8DNbPo20tf2shudpq7irfFvvnrbQ9U+sgzAMjHt4PlFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589327; c=relaxed/simple;
	bh=nn9Manah/kFqLOAJVTMPSodwR3m+/hKFBwuF2G1YRqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deH8dlvEkKxWcdKWWUUUVZOdb63bRxTulLKOfMhoZZP9RQtyZcFcO3aL5tZyh9eBtm8JsQPBpdfiGnxpDek9LAMk+7PGm15erLl4fpB+l/r700Acgy6Q+0XVnB7FEy1Mwroxo5qxFqCuuETmmbDY2QDk/9MtfuPJjr7iphXNRrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StoTmD12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StoTmD12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA23CC433C7;
	Mon,  4 Mar 2024 21:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589327;
	bh=nn9Manah/kFqLOAJVTMPSodwR3m+/hKFBwuF2G1YRqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StoTmD12Ur/jwmmvSvB3LIpJSBx+hcdLVEGx2JHkPc29Isjt/tbt61iaG24KwFEdU
	 MzWCHkHn4Z+q6F+DFi0pRr15/LkbGwRbcIFmlKrQLTglF6Q6fY3qEyGJxfa8SBGbqJ
	 Mcd+ZHnDf/SEKxtIiWXgUF+jCiWUjBDwQikrcoFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jean Sacren <sakiwit@gmail.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 66/84] mptcp: clean up harmless false expressions
Date: Mon,  4 Mar 2024 21:24:39 +0000
Message-ID: <20240304211544.598256654@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Sacren <sakiwit@gmail.com>

commit 59060a47ca50bbdb1d863b73667a1065873ecc06 upstream.

entry->addr.id is u8 with a range from 0 to 255 and MAX_ADDR_ID is 255.
We should drop both false expressions of (entry->addr.id > MAX_ADDR_ID).

We should also remove the obsolete parentheses in the first if branch.

Use U8_MAX for MAX_ADDR_ID and add a comment to show the link to
mptcp_addr_info.id as suggested by Mr. Matthieu Baerts.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jean Sacren <sakiwit@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -38,7 +38,8 @@ struct mptcp_pm_add_entry {
 	u8			retrans_times;
 };
 
-#define MAX_ADDR_ID		255
+/* max value of mptcp_addr_info.id */
+#define MAX_ADDR_ID		U8_MAX
 #define BITMAP_SZ DIV_ROUND_UP(MAX_ADDR_ID + 1, BITS_PER_LONG)
 
 struct pm_nl_pernet {
@@ -854,14 +855,13 @@ find_next:
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
 						    MAX_ADDR_ID + 1,
 						    pernet->next_id);
-		if ((!entry->addr.id || entry->addr.id > MAX_ADDR_ID) &&
-		    pernet->next_id != 1) {
+		if (!entry->addr.id && pernet->next_id != 1) {
 			pernet->next_id = 1;
 			goto find_next;
 		}
 	}
 
-	if (!entry->addr.id || entry->addr.id > MAX_ADDR_ID)
+	if (!entry->addr.id)
 		goto out;
 
 	__set_bit(entry->addr.id, pernet->id_bitmap);


