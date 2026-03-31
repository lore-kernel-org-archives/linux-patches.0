Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A530E0DC;
	Tue, 31 Mar 2026 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974382; cv=none; b=i9q2AG3F1MxrEEW0v+KY/yZsSMCZwE5WeZK+6dz+RR62XrMeKmjY8BY2CZY00qa3MMF4FXRgYETZG7uq2XKV6lrlEcfwo8wDVkZzuHJM9ozP+eF+Pm0+1iYj67uDYvUxBb06JKPSRnjC2fzNZOvYSZeev8ih/Illr32CDkGpYJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974382; c=relaxed/simple;
	bh=Kgcy/MecW1iM+RmO80ASVbnwyR6S4LKkvOvJ5biwXwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1JH3FYdqWTMS6MMhKA4l9pVf7EMIfBKyioHX0pGx9z9DsMaT/pygHRl/fqGmiqA54msfOHzOLu3oK/H7pFDW3zzKdBdW47qMSUEFG5gyAjaKP4eRzKjf62tTHV0R0PMufi952OzT9OBgYoddXxFkYTULXXM+tui86Fo+zVvHX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUT3MAou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUT3MAou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6069C19423;
	Tue, 31 Mar 2026 16:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974382;
	bh=Kgcy/MecW1iM+RmO80ASVbnwyR6S4LKkvOvJ5biwXwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUT3MAouyGHxNO7teoxp9U8RP1iWghYGUngJl63ozXBl6yJpJIacj/bFf7MP7a7De
	 yyoN0Rcqt/h5Cnt8FqDLXdMYFE76LU13WiP6lG80wyTuUEhdUxbGi6iePCGtdRjgj9
	 8XkE9CVYi7h+JKHxwc/t6x2YM3bmgS4vWJtS986s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/175] Bluetooth: Remove 3 repeated macro definitions
Date: Tue, 31 Mar 2026 18:20:47 +0200
Message-ID: <20260331161732.098125584@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 94c603c28e59091f698efc5caaddc93c365455ab ]

Macros HCI_REQ_DONE, HCI_REQ_PEND and HCI_REQ_CANCELED are repeatedly
defined twice with hci_request.h, so remove a copy of definition.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 94d8e6fe5d08 ("Bluetooth: btintel: serialize btintel_hw_error() with hci_req_sync_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_request.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
index 0be75cf0efed8..c91f2838f5424 100644
--- a/net/bluetooth/hci_request.h
+++ b/net/bluetooth/hci_request.h
@@ -29,10 +29,6 @@
 #define hci_req_sync_lock(hdev)   mutex_lock(&hdev->req_lock)
 #define hci_req_sync_unlock(hdev) mutex_unlock(&hdev->req_lock)
 
-#define HCI_REQ_DONE	  0
-#define HCI_REQ_PEND	  1
-#define HCI_REQ_CANCELED  2
-
 struct hci_request {
 	struct hci_dev		*hdev;
 	struct sk_buff_head	cmd_q;
-- 
2.51.0



