Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8521581F4;
	Tue, 23 Jul 2024 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760187; cv=none; b=ojTdZYSOxWhj5JgW7pM6EVZ43GGBBOKxz0bw/c5Ru8m91byGrhiB+dEHUSmqKhHgDqMQkgEnFKX1fit4WhwOb89j+lvtt4W+w8ajz/CbE1ldLKU0Dm0yQPlRIZ0wHo+Pf6KcfUszq0wzqFI+pMmNgW2eEWnCc6FdGj7iZtk6Y7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760187; c=relaxed/simple;
	bh=mcqRJzvS6+BHdYXJBxTxwzwSfrR5Nvtri/hOCi45320=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUiSsgbqhAGMU0AbhB/9E4lRhLTGYDnZbwMPv1CsE36aobSPP1PwpokATYbng7I75AFgAEuH/DcjS/PKY1via095DO4F1zYKD26miZCebBifA8RlVN7TPGiQ0prlvnVFJ8wGqvC3ecMX+84bvt/0PYlCFOIbm9udWx0zISOs0+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sC5/XVqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sC5/XVqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C75C4AF0A;
	Tue, 23 Jul 2024 18:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760187;
	bh=mcqRJzvS6+BHdYXJBxTxwzwSfrR5Nvtri/hOCi45320=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sC5/XVqzqXYjtWz5Oer1m+0E0HTzd53hDDH2noLACVR9VOs4A3vgy3/XD1TNXmdqP
	 +PyY0SYHX6Zfp46oRKq15kMKpbmXZqB4A3EFokvUDj9fuimdQVOkgRmCY0Lwsl9OBT
	 6q02CJmyfclGgO/WT94wjl25xVQSrSKsD+p1BzAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 130/163] Bluetooth: btnxpuart: Enable Power Save feature on startup
Date: Tue, 23 Jul 2024 20:24:19 +0200
Message-ID: <20240723180148.496066671@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

[ Upstream commit 4183a7be77009fc31c5760429fe095f163bf96a9 ]

This sets the default power save mode setting to enabled.

The power save feature is now stable and stress test issues, such as the
TX timeout error, have been resolved.
commit c7ee0bc8db32 ("Bluetooth: btnxpuart: Resolve TX timeout error in
power save stress test")

With this setting, the driver will send the vendor command to FW at
startup, to enable power save feature.

User can disable this feature using the following vendor command:
hcitool cmd 3f 23 03 00 00 (HCI_NXP_AUTO_SLEEP_MODE)

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index 9d0c7e278114b..9bfa9a6ad56c8 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -281,7 +281,7 @@ static u8 crc8_table[CRC8_TABLE_SIZE];
 
 /* Default configurations */
 #define DEFAULT_H2C_WAKEUP_MODE	WAKEUP_METHOD_BREAK
-#define DEFAULT_PS_MODE		PS_MODE_DISABLE
+#define DEFAULT_PS_MODE		PS_MODE_ENABLE
 #define FW_INIT_BAUDRATE	HCI_NXP_PRI_BAUDRATE
 
 static struct sk_buff *nxp_drv_send_cmd(struct hci_dev *hdev, u16 opcode,
-- 
2.43.0



