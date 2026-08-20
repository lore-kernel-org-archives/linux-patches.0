Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A90346C82A;
	Thu, 20 Aug 2026 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248466; cv=none; b=gxfwKsPcM8Mff2dTUhIpWTcnREVAObCWnUDaeNw9lN4MdxEWTwr4f90jcJb3wYrULuqCm+H2mGUl8lVOM0MMkcMFJGuvcuCg1AQPyq1JC1Rj9uetGC213QC2cQHu/IobYEgPo8ISZvwg8u4qgPY8i6m7SakvQCwlpfIapQQLilM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248466; c=relaxed/simple;
	bh=QxfHTNajaFzevOba06yqAIVKdSLdkUzWJ0+maiIml7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEJk6x42aiZgtFb2siUG5PKvWT+WZ3goKtXrCdArTHYXVyPRGKLEoYwW7uAlfWKnWn7ERE7Hqd0r+Y9vyuWZ/IKF7HUIl4tdJfjYTretbxKqjDFvIxJTts0w5cnum+vsgOqxx3caj5e182i5WbSRb0WnI4sJDpTnpF76NOC1M4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMiJnYu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMiJnYu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D560E1F000E9;
	Thu, 20 Aug 2026 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248465;
	bh=OxFjcYu4S06hmqKWDBktrJwh6xf8klUm6ofNf0wCmvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMiJnYu0oDFBcZfuWF/SGYtZMkkoElRMQtEsY0Z2WbjObq03w9M3/BwxgqJNgJZTa
	 SB9WJNyAjmxC9V8zD9fT1+OjQcaleoiJYsGE24EjL66LBVnCAGEy7Bjwr/EdZNc0pR
	 mhaqy0yAQ1BAJmKFV3iugLRuBJaa6ep/KBuf+z5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Simon Horman <horms@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/303] Bluetooth: MGMT: Remove unused mgmt_pending_find_data
Date: Thu, 20 Aug 2026 16:56:14 +0200
Message-ID: <20260820145300.604617384@linuxfoundation.org>
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

From: "Dr. David Alan Gilbert" <linux@treblig.org>

[ Upstream commit 276af34d82f13bda0b2a4d9786c90b8bbf1cd064 ]

mgmt_pending_find_data() last use was removed in 2021 by
commit 5a7501374664 ("Bluetooth: hci_sync: Convert MGMT_OP_GET_CLOCK_INFO")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: d0a7b48ad092 ("Bluetooth: mgmt: fix UAF in pair command cancellation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt_util.c |   17 -----------------
 net/bluetooth/mgmt_util.h |    4 ----
 2 files changed, 21 deletions(-)

--- a/net/bluetooth/mgmt_util.c
+++ b/net/bluetooth/mgmt_util.c
@@ -229,23 +229,6 @@ struct mgmt_pending_cmd *mgmt_pending_fi
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
--- a/net/bluetooth/mgmt_util.h
+++ b/net/bluetooth/mgmt_util.h
@@ -54,10 +54,6 @@ int mgmt_cmd_complete(struct sock *sk, u
 
 struct mgmt_pending_cmd *mgmt_pending_find(unsigned short channel, u16 opcode,
 					   struct hci_dev *hdev);
-struct mgmt_pending_cmd *mgmt_pending_find_data(unsigned short channel,
-						u16 opcode,
-						struct hci_dev *hdev,
-						const void *data);
 void mgmt_pending_foreach(u16 opcode, struct hci_dev *hdev,
 			  void (*cb)(struct mgmt_pending_cmd *cmd, void *data),
 			  void *data);


