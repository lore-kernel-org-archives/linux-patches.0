Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD7522B8D0;
	Mon, 10 Mar 2025 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626816; cv=none; b=W7tFjATqMOzm4zSADTc4a/vPVdkkL5h+7On4hR8BElUzyrx3mpkJ6TUevNIdnRtIWjjxsxlwN2adwL1F85W5NBuc/hIsycQ6kLr3wr3d8pcmD/uicJVhKwFscxjv5ozefb+l7q5XMOTjJ/o5dEkQtqBtz31wc2+yL6YE8ifTX7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626816; c=relaxed/simple;
	bh=7u/nJhZJwxRq4jdt1yAbHVpHrf/73bFwSsq3b9Tfrms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYkbOxpxZrEpm62HjKTOW3vRVfU+82ya6lKhwDIiOyT+LIWAz4dZqXGKO4pE7548a2L658Vqn6eBtXO44VLGps8PIdUGWULHLUKgsbUdgV1xox/yonWzDO21PxaCJFhqozlG7d5lTWnLaRALyUYW/jJ/oKK5feM61YsbdzP/Lqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nk7yvKRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nk7yvKRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE089C4CEE5;
	Mon, 10 Mar 2025 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626816;
	bh=7u/nJhZJwxRq4jdt1yAbHVpHrf/73bFwSsq3b9Tfrms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nk7yvKRhkRACRFY9XCgUsmnNkrGBG4ummm+rPHBB5HXKUkT2yNFJS3hGFVBYAoC96
	 zo27d5TKzHwgHv8CV5W5rPNZVNA3j1+2I9Kc7/QRbozp39BT9stmodTklOe2+LpGnD
	 qVTSy/FjLhCC+IfnaKopAPwWJPJVrnirUIAXjHtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 105/207] bluetooth: btusb: Initialize .owner field of force_poll_sync_fops
Date: Mon, 10 Mar 2025 18:04:58 +0100
Message-ID: <20250310170451.937102572@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit cbf85b9cb80bec6345ffe0368dfff98386f4714f ]

Initialize .owner field of force_poll_sync_fops to THIS_MODULE in order to
prevent btusb from being unloaded while its operations are in use.

Fixes: 800fe5ec302e ("Bluetooth: btusb: Add support for queuing during polling interval")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 72e85673b7095..75dbe07e07e21 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3652,6 +3652,7 @@ static ssize_t force_poll_sync_write(struct file *file,
 }
 
 static const struct file_operations force_poll_sync_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_poll_sync_read,
 	.write		= force_poll_sync_write,
-- 
2.39.5



