Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E4158A19;
	Tue,  9 Jul 2024 11:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523751; cv=none; b=KABxgWQLxgNqXQ0OhzCDF8lpeehVeepPd2pDTXY4ZoPft3FVf6BpUPR92OkBtF0qHx2gmHiTkpq/dWuLgF6U4qmpnq04XQYSFZM5UGBxONTcXC+Ylnu1gFpK65NebxMlbt6VlolzKOcCG2BHDMGT5I+ZAQjr2xOh5nEaaNdTXRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523751; c=relaxed/simple;
	bh=Y6e28hEE95uuk8E0blzeSu3pzs6v5q5Iix0gKufwI2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF+YUEQtBVB2ZTdE6ezNrppskd+EwS9sDn6EVuf1L7GW6LFVpH1llBy4XmLiKZNbUO2E/l5pKPvwPMcm3parxxo1lPXmqhk+exXzVVNadMR1QA9LfCE2oOo7+Rz04iam2JXXpxbEw/BqtLLCF5xVLyUUGlw+1/kU1CXaqDaCLAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CA9qBzhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CA9qBzhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9A2C3277B;
	Tue,  9 Jul 2024 11:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523751;
	bh=Y6e28hEE95uuk8E0blzeSu3pzs6v5q5Iix0gKufwI2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CA9qBzhHFi4Ic8OruFSrP1rX6jcs3Bs3maVS/YzZguwlA6lf/ZYQ5hnPIB1a1k+V6
	 KAu+yJBfPEfdH+7kIhlHWd+aX7Jrk6/evvFyjCFHyamT5tOZ1K5HNb1mF2hlSJ8DY9
	 LZMwIQUNfb6r/nBjMmsgUxwdUi8u9bGPEBByzZxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Sven Peter <sven@svenpeter.dev>,
	Neal Gompa <neal@gompa.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 097/139] Bluetooth: hci_bcm4377: Fix msgid release
Date: Tue,  9 Jul 2024 13:09:57 +0200
Message-ID: <20240709110701.929849596@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

commit 897e6120566f1c108b85fefe78d1c1bddfbd5988 upstream.

We are releasing a single msgid, so the order argument to
bitmap_release_region must be zero.

Fixes: 8a06127602de ("Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards")
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm4377.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_bcm4377.c
+++ b/drivers/bluetooth/hci_bcm4377.c
@@ -716,7 +716,7 @@ static void bcm4377_handle_ack(struct bc
 		ring->events[msgid] = NULL;
 	}
 
-	bitmap_release_region(ring->msgids, msgid, ring->n_entries);
+	bitmap_release_region(ring->msgids, msgid, 0);
 
 unlock:
 	spin_unlock_irqrestore(&ring->lock, flags);


