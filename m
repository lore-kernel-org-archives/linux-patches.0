Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E36308F2E;
	Wed, 21 Jan 2026 18:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020097; cv=none; b=iv5fy0XurU59QfI7xWBxE3FBBFUQoFCpJQLcClpAkuHu6Ur20vroZwoiwvlOFOQABlb6VEZ5Fzdj0BsGyFfakx4tDAybYfpWtyfF1q1MLZ+s5ibJNOgnhZxuEE45SdU1Yn65H/cCRCOD0BUQpk9Ja/WC2aJEUe/5J9DcfdDGP7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020097; c=relaxed/simple;
	bh=YmgRO04ekBEiMpKXNKF/JksQNRF/TzjecwpxJCSlmE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Efb7HP4vzyA18IPQG6La9Oj0jB5MZIm3cmLa3MAJAstNpKF15JN6WEaZEn9oSgiwfKm9MiuB2Q8uNmac0NUFNRfdI187tQyDbyf7LQx205SAIFrApNNBcdeIc7YlubWtIRWlw+t2VSlSTe7RFDIvpLktFjSljlUR/yWEgCrpF4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awW7nA8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awW7nA8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77735C4CEF1;
	Wed, 21 Jan 2026 18:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020096;
	bh=YmgRO04ekBEiMpKXNKF/JksQNRF/TzjecwpxJCSlmE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awW7nA8l4VXLt5UkJTH3xQnDqAAqKSr7uXYNy3mdvFtotR1U+qJRTOfI5jqHnLv3S
	 Th0HCX3txZ4FkizBLQOnEItwN0SCa2zSVYI/XIoIq280pm+THvIoRzSQo1IEvKeIuB
	 SGjK8IYee+9OtRuwn9eCtcHhwzedJnyLcWczckSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/198] Bluetooth: hci_sync: enable PA Sync Lost event
Date: Wed, 21 Jan 2026 19:14:19 +0100
Message-ID: <20260121181419.672367540@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit ab749bfe6a1fc233213f2d00facea5233139d509 ]

Enable the PA Sync Lost event mask to ensure PA sync loss is properly
reported and handled.

Fixes: 485e0626e587 ("Bluetooth: hci_event: Fix not handling PA Sync Lost event")
Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6e76798ec786b..f5896c023a9fa 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4402,6 +4402,7 @@ static int hci_le_set_event_mask_sync(struct hci_dev *hdev)
 	if (bis_capable(hdev)) {
 		events[1] |= 0x20;	/* LE PA Report */
 		events[1] |= 0x40;	/* LE PA Sync Established */
+		events[1] |= 0x80;	/* LE PA Sync Lost */
 		events[3] |= 0x04;	/* LE Create BIG Complete */
 		events[3] |= 0x08;	/* LE Terminate BIG Complete */
 		events[3] |= 0x10;	/* LE BIG Sync Established */
-- 
2.51.0



