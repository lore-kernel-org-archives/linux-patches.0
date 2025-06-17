Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262022ED871;
	Tue, 17 Jun 2025 16:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176564; cv=none; b=Ujr09SPDg2m4Gxqd9il2C7aSqUykg/LhpNfSAR/q7LMMg+YPNwb1fEaENiyaRtPfyjjm0LNBlYCU7LqtvT6D84OH0jGTcBAqV3MaTuz5KM2DrcyO6sOlkYJcT8TxmlH7/czrWIOk5H41E77WuhoDanT1U1rhhqiOj+ZZJg6h+wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176564; c=relaxed/simple;
	bh=0KuRN1j1ox2LsaKK3mZak3HnDq8qcz2DSGz2rX2PRs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuLe4gckPkuYXpWezFwADVBjWbJGD0RAuVNeHtNU7BHXr6bezeY9cg+pzpTdKATKkuvzMRXiQ8tvrMTz4n6Qaw/5a1FV1Uc9TzVVtcRLByQ60lDDeL+5+E3YRCMncsmQ109rh3J5DZKVUBrujDahLbDHq5dDEs4VXL/bj0c9Xz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryY1WIOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryY1WIOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B9DC4CEE7;
	Tue, 17 Jun 2025 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176564;
	bh=0KuRN1j1ox2LsaKK3mZak3HnDq8qcz2DSGz2rX2PRs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryY1WIOI5sHbkBgbKVurGmZ07Sd+CPqxsr5aTBQz3RVYuxeQytEoWfgMX4zPEqrvz
	 d1Wf/D2nIAbiVaXzOJ2Yl4hTm3dvtM4VP2slt5WSR0hLh0VbMnZFlA4Cyy98G78ysm
	 ozRi3/z21fkFUnSwPdYJWueZ7i4ltLqyfRk4y1b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Simon Horman <horms@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/356] Bluetooth: MGMT: Remove unused mgmt_pending_find_data
Date: Tue, 17 Jun 2025 17:26:48 +0200
Message-ID: <20250617152349.969674740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dr. David Alan Gilbert <linux@treblig.org>

[ Upstream commit 276af34d82f13bda0b2a4d9786c90b8bbf1cd064 ]

mgmt_pending_find_data() last use was removed in 2021 by
commit 5a7501374664 ("Bluetooth: hci_sync: Convert MGMT_OP_GET_CLOCK_INFO")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 6fe26f694c82 ("Bluetooth: MGMT: Protect mgmt_pending list with its own lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt_util.c | 17 -----------------
 net/bluetooth/mgmt_util.h |  4 ----
 2 files changed, 21 deletions(-)

diff --git a/net/bluetooth/mgmt_util.c b/net/bluetooth/mgmt_util.c
index 17e32605d9b00..dba6a0d66500f 100644
--- a/net/bluetooth/mgmt_util.c
+++ b/net/bluetooth/mgmt_util.c
@@ -229,23 +229,6 @@ struct mgmt_pending_cmd *mgmt_pending_find(unsigned short channel, u16 opcode,
 	return NULL;
 }
 
-struct mgmt_pending_cmd *mgmt_pending_find_data(unsigned short channel,
-						u16 opcode,
-						struct hci_dev *hdev,
-						const void *data)
-{
-	struct mgmt_pending_cmd *cmd;
-
-	list_for_each_entry(cmd, &hdev->mgmt_pending, list) {
-		if (cmd->user_data != data)
-			continue;
-		if (cmd->opcode == opcode)
-			return cmd;
-	}
-
-	return NULL;
-}
-
 void mgmt_pending_foreach(u16 opcode, struct hci_dev *hdev,
 			  void (*cb)(struct mgmt_pending_cmd *cmd, void *data),
 			  void *data)
diff --git a/net/bluetooth/mgmt_util.h b/net/bluetooth/mgmt_util.h
index bdf978605d5a8..f2ba994ab1d84 100644
--- a/net/bluetooth/mgmt_util.h
+++ b/net/bluetooth/mgmt_util.h
@@ -54,10 +54,6 @@ int mgmt_cmd_complete(struct sock *sk, u16 index, u16 cmd, u8 status,
 
 struct mgmt_pending_cmd *mgmt_pending_find(unsigned short channel, u16 opcode,
 					   struct hci_dev *hdev);
-struct mgmt_pending_cmd *mgmt_pending_find_data(unsigned short channel,
-						u16 opcode,
-						struct hci_dev *hdev,
-						const void *data);
 void mgmt_pending_foreach(u16 opcode, struct hci_dev *hdev,
 			  void (*cb)(struct mgmt_pending_cmd *cmd, void *data),
 			  void *data);
-- 
2.39.5



