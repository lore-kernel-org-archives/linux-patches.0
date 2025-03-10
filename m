Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39FB22D7A6;
	Mon, 10 Mar 2025 17:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628030; cv=none; b=iq46YdtWDO7AYsNIq8FC6a8CynWL7TVzSdz4SBmTcEijUsHAtD8keWkmoiO2x/p7KCm6xmyeBtQcsmYqU6++fGXgRzMpjPSM/IMhUlgZyvMdHMrKjSysc4jEiEVoZP6zP0juoLBtXUalOteevt4FeVz5xl/w1C+CsXYVs3prbX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628030; c=relaxed/simple;
	bh=CYPI40PVO1KCRhZ5CQPQTF/3tiGTAvHABlxq0b1CVrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoTSyEPn8EZUTcV0H5zD8dMVxMSLnocIZKLfqCxfx2yHbBLsgbVeooDs2nmcip5tOUy1dZdmPLTyvPMDsKQSqXBQqz8GwlJF2ggJ+ocEvrBFS5Rq40q66k1Zu9nK4pOO7On5jmWeuQ2zujPvJEcjD0jFVSadcjQxTp0IH1xQQEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDJPPYlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDJPPYlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4729DC4CEE5;
	Mon, 10 Mar 2025 17:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628030;
	bh=CYPI40PVO1KCRhZ5CQPQTF/3tiGTAvHABlxq0b1CVrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDJPPYljKilEziCc+7HXc4z4mUGsA5Ct4QYehMBg/jSvbO6slZulJqK0SgtR6QC2q
	 1K6cmvk++/B+zz/QY6NdZUdvsRiwB/MnT1RxaHfL71KRT6fWpT8QKPY1vJcOwZ9PAL
	 EVp7yBHncjQ2e+ypyV7E2cowE9oNsnmO3xCcE/T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/145] bluetooth: btusb: Initialize .owner field of force_poll_sync_fops
Date: Mon, 10 Mar 2025 18:05:56 +0100
Message-ID: <20250310170437.247560856@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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
index c80b5aa7628ae..bc3f63f1ccd86 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4230,6 +4230,7 @@ static ssize_t force_poll_sync_write(struct file *file,
 }
 
 static const struct file_operations force_poll_sync_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_poll_sync_read,
 	.write		= force_poll_sync_write,
-- 
2.39.5



