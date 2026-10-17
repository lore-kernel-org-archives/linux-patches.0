Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CF334EEF3;
	Sat, 17 Oct 2026 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252522; cv=none; b=tnBTVGmpugbfQwM8ddlzkRuIvWPAJNwV1OT/wA1O9sXVRnoz1GAc8X6iMS1myhPDzkyDiw7PV/cMDUT5DflZ4L7h1fpnR6g4uKmI/eb/C9OwqCEOXtXaw/9AJgkkSE1W8PbbL/fnxfVAcUNY/IlHEp1WJDYn+uUlIHed6S/NOnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252522; c=relaxed/simple;
	bh=3cc/dUdcBpSj+hhIcYGz/TBPFFB/Po/yRBSP4sLZdQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brhoUw+86X97WWG8y6+4rb4EifCsEHmBeR3A9Is8z0tK+jb53Y/hwpNRU502fc/FInrlykxC/vpSAYd/AaEsDnL3WPithtO2ZuixkvCq6i+BnkeG4erfnJYP7mZala54/sL4FK3tM24Ze12OeIyFPPUqR4yYK0eeVbY+hUcWzcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+Jv6/2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+Jv6/2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AC51F000C4;
	Sat, 17 Oct 2026 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252517;
	bh=mOpZHob+4ygOkYv8NZqYVlQ1H3aYltwGCyxNqEsdByQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+Jv6/2/IC2Nr8aH2zs0S3PV2UI9X/eIl38qU2EgpXCwk9PpSZL5dnwXxkgAXJEKi
	 1sJHfot1sBJXPuBVEC4lLlqVqces8w0y/vGQhxnSnmN9lhXYEecBHiImfEzIs0UGML
	 zywUKwOW2/MXXhPhoBiivj2d+bdNvecLR1zzt6Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 09/10] wifi: atk9k: Revert "wifi: ath9k: reject short WMI command responses"
Date: Sat, 17 Oct 2026 17:54:38 +0200
Message-ID: <20261017155100.032545897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
References: <20261017155059.698368299@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit 90201351a862182bdabfc1ad1c97b1e1b6ed5931 ]

This reverts commit 93ce8ea70451e800601bc9444aa33043de15d67b.

Mehmet reported that the offending commit breaks his AR9271 USB adapter
which uses zero-length replies to commands that don't return a value.
Revert the whole thing to restore the functionality.

Cc: stable@vger.kernel.org # the offending commit is in 6.12.113
Reported-by: Mehmet Fide <mehmet.fide@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 16 ++--------------
 drivers/net/wireless/ath/ath9k/wmi.h |  1 -
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 4a08babb6d9d6..44e91815a1594 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -206,16 +206,9 @@ static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
 {
 	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
 
-	if (wmi->cmd_rsp_buf && wmi->cmd_rsp_len) {
-		if (skb->len < wmi->cmd_rsp_len) {
-			wmi->cmd_rsp_status = -EMSGSIZE;
-			goto complete;
-		}
+	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
 		memcpy(wmi->cmd_rsp_buf, skb->data, wmi->cmd_rsp_len);
-	}
-	wmi->cmd_rsp_status = 0;
 
-complete:
 	complete(&wmi->cmd_wait);
 }
 
@@ -307,7 +300,6 @@ static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 	/* record the rsp buffer and length */
 	wmi->cmd_rsp_buf = rsp_buf;
 	wmi->cmd_rsp_len = rsp_len;
-	wmi->cmd_rsp_status = 0;
 
 	wmi->last_seq_id = wmi->tx_seq_id;
 	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
@@ -364,13 +356,9 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		return -ETIMEDOUT;
 	}
 
-	spin_lock_irqsave(&wmi->wmi_lock, flags);
-	ret = wmi->cmd_rsp_status;
-	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
-
 	mutex_unlock(&wmi->op_mutex);
 
-	return ret;
+	return 0;
 
 out:
 	ath_dbg(common, WMI, "WMI failure for: %s\n", wmi_cmd_to_name(cmd_id));
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 0bb9d31f1a1cc..5c3b710b8f319 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -157,7 +157,6 @@ struct wmi {
 	u16 tx_seq_id;
 	u8 *cmd_rsp_buf;
 	u32 cmd_rsp_len;
-	int cmd_rsp_status;
 	bool stopped;
 
 	struct list_head pending_tx_events;
-- 
2.53.0



