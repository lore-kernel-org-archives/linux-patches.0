Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5478522F164;
	Mon, 10 Mar 2025 17:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627532; cv=none; b=Lsg7jT73ybQ4uZUxTBtscETLGzwe6K5hsbfVwAfaMr3zPXWzPc4M+A6FuZCoB4wXlc+HuyGyT2S+XtM4x4PLgz6ADdq7tbjOGjTCLrBfximpIsu9BNT5UbVcQAMBCjQXMJKx8OYNhjT/WdWZAAg4bMQIvVPUbi/pbJO12b6lPKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627532; c=relaxed/simple;
	bh=fYg9mt7hCa8DgGPnrvOV3bVZ+hLotAgxfmvQBhoZNgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrKjCgcpxLs7ahN3xAer0cHU0Mm6DVJByaLmSx4ROSH/ZWtWDlIdOD5pAFFL6Q7T6t3x1CBmMnWT6fhAq48dMbXhXe7uh1P4itDbwlQV65DzC3wtoked3pw4tCePA2i+FbB5KdeRtW29bC8+Tl/S4yE9YmbFSEXGHDS4vvlzP68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPAbgv0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPAbgv0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11F5C4CEE5;
	Mon, 10 Mar 2025 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627532;
	bh=fYg9mt7hCa8DgGPnrvOV3bVZ+hLotAgxfmvQBhoZNgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPAbgv0q3RFQh5ZTyyTAINiA0xq9BfTyiJm+M8V/CuIC9wd/LqSuMuZvkzrvmbNAV
	 8d0Z17SpwTSZabcNZYFJxHSpPto7UN0PkpqlSh/NIXx4/BubQmSgYxTIoV3DEOmlvv
	 1GYBkYnW7b+xsVskPHsucleYAqmqZJJPbVuZ+vJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/269] bluetooth: btusb: Initialize .owner field of force_poll_sync_fops
Date: Mon, 10 Mar 2025 18:05:15 +0100
Message-ID: <20250310170504.175997940@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6bc6dd417adf6..3a0b9dc98707f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3644,6 +3644,7 @@ static ssize_t force_poll_sync_write(struct file *file,
 }
 
 static const struct file_operations force_poll_sync_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_poll_sync_read,
 	.write		= force_poll_sync_write,
-- 
2.39.5



