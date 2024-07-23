Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7601586C4;
	Tue, 23 Jul 2024 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759795; cv=none; b=fAHpBkScvl72/9YCI/nXLoc+VKVnCj5O5SbcDJ6JTei8pcd6jchAAm9ii+Yn+6B6RSa/Vn6/fNQpQF+eAmWSCSkQwxZ1TnGjbE4XRgBSlzm1m7Y7nqeFD3lseT1d3vThsnV6V3tu1DtZQvayns3ZAC/qYHR9tPUqU0Nee2hUAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759795; c=relaxed/simple;
	bh=zpuHKN5NaXH7kcqs9oNIDi9Bq6VWt1dA2glWst8KrV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kr+X5e/fEnsgCt/s3ZuWchQiee7DqYkjqQF3LBnZA5FptuQfK4KqFO2bGzPHjHMtwssNkXqZ1UJ3vRv5wNko9qTa/9VOrZGH38KSuxHAIsq+C+c1qELR5/Mcdpp8LY/a3LHPgNJD5BHMJylvNwT7o2hEN4JAn45EOuBuqPAQjiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySgeGLJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySgeGLJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C34FC4AF0A;
	Tue, 23 Jul 2024 18:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759795;
	bh=zpuHKN5NaXH7kcqs9oNIDi9Bq6VWt1dA2glWst8KrV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySgeGLJwtRodDjVFUFo9PrGpNMl53Ry88UwN1IWUqWXPwZqXvNcuPmC4ESJgSqtgY
	 BZ87t0DEFa/cDbSJyjn+n7UD6wm9oUZPIihvp9z8sgqNbLq0KeWSO3MObcfzlsqoug
	 rwGydMWxGlH23yiE8V5K8qQTDGlaBK8a7oPTmz+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/129] Bluetooth: btnxpuart: Enable Power Save feature on startup
Date: Tue, 23 Jul 2024 20:24:07 +0200
Message-ID: <20240723180408.614035237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
index abccd571cf3ee..5c5a5b752419e 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -280,7 +280,7 @@ static u8 crc8_table[CRC8_TABLE_SIZE];
 
 /* Default configurations */
 #define DEFAULT_H2C_WAKEUP_MODE	WAKEUP_METHOD_BREAK
-#define DEFAULT_PS_MODE		PS_MODE_DISABLE
+#define DEFAULT_PS_MODE		PS_MODE_ENABLE
 #define FW_INIT_BAUDRATE	HCI_NXP_PRI_BAUDRATE
 
 static struct sk_buff *nxp_drv_send_cmd(struct hci_dev *hdev, u16 opcode,
-- 
2.43.0



