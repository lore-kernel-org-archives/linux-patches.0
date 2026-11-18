Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045429;
	b=HUrn2FGPyOw04Z95/b7Q6cw2XKLx34fERWfePWtkZPtSfC/dxHReP9YaHNx48wn8/i1U
	 og4J1Nv/lM7XirugaMDyLg/8sNYWV6+hfaGF69H3WvfUhyHWYRrhfn71cvyRQEXtjL3CS
	 twYxbQnvIAbv9eE+yKWBhNgjl1xPO35oJaMgZJAuw8CWBoN860N39uddB+/ACSgXSpRw/
	 o1UUCFhmkWkD3kZa8xJGz03Q4Xkob2srDF8FECkdhmGwAxbaa1QfcgExZpCAN5uBKkRzQ
	 ADyz1+frfGca6S4vegLvGzFV8oKy4KKEMSZjNzg2Y2qdcD5HI+xT0Jnq2CnKkOsSvSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L+o2+usjVWwxfANuWRaaHfdiEctlMYdR4dfHgdrwRIs=;
	b=IffOzUK9EowOorAU1Jab5f/7CivXCeB6su6DbHIAWwrzewGmCC4KzcIwZM8axcefHjq2
	 UVEyce2Jg9dpPzXHQY1zJUtSH3Vk3Y3zKZ1EBSLs7EIsrzEKH0NOEA0saXEFwmh8tLfW5
	 SAOpCOHZyk7Qafm2lwelXrKWU81JycXGUncFNlODc1w3lUIP+pMp3ydKYw/umlGX8ZP2W
	 saV3lNkmzCfsMEwPG2dtRkKOUwNSfcnJfMFD7QQRDWufGCyxkvCtJM08L4pAA6JbuNJ41
	 GKnpfdrpZklWMBcGRWWQnZJfPU8Bxz1g41vAp80LoEhkRy5r6OednzWtSkPMPtTT48g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiQUOY1e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D5B606A31C;
	Wed, 18 Nov 2026 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiQUOY1e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4CC1F000C4;
	Wed, 18 Nov 2026 23:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045428;
	bh=L+o2+usjVWwxfANuWRaaHfdiEctlMYdR4dfHgdrwRIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiQUOY1e2h/1+o8w6oqget4zPaBayv4c4W+8KNO25WfTRxZdgpQNB7XhpMziBWZ/f
	 3jL39Ly9asro/gA563krK4k2kfo2D5Rxi/k91rH/joeeXK2D8ABfMfVbDO5ScWjAoF
	 rrXvd5Kk+f9WD1MbkgDIyd3JVpIBUSwkcu+ndySk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0919/2857] usb: typec: ucsi_ccg: Add retry mechanism in ccg_read
Date: Wed, 18 Nov 2026 15:32:33 +0100
Message-ID: <20261118150234.670491783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit bbf6b99a57b2479bf51c3c8ad0946f4b8c33ed69 ]

CCG4 firmware occasionally fails to respond to I2C read requests,
especially when reading cci and intr_reg from the ISR path. In these
cases, i2c_transfer() returns -EREMOTEIO.

The CCG4 is EOL, and Infineon no longer supports firmware updates, so
a software workaround is necessary.

Attempt the read up to CCG_READ_MAX_RETRIES (4) times in total when
-EREMOTEIO is returned, sleeping ~1 ms via fsleep() between attempts.
This allows recovery from transient I2C failures without affecting
other error paths.

The sleep is safe because ccg_read() is called both from process
context and from ccg_irq_handler(), which runs in threaded IRQ
context (registered via request_threaded_irq() with a NULL hard-IRQ
handler), so sleeping is allowed in both cases.

Fixes: 247c554a14aa ("usb: typec: ucsi: add support for Cypress CCGx")
Cc: stable <stable@kernel.org>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260916061858.1471606-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index 62d4e1fab2d77..20f7f87a92f2c 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -134,6 +134,8 @@ struct version_format {
 #define NVIDIA_FTB_DP_OFFSET	(2)
 #define NVIDIA_FTB_DBG_OFFSET	(3)
 
+#define CCG_READ_MAX_RETRIES	4
+
 struct version_info {
 	struct version_format base;
 	struct version_format app;
@@ -244,6 +246,7 @@ static int ccg_read(struct ucsi_ccg *uc, u16 rab, u8 *data, u32 len)
 	};
 	u32 rlen, rem_len = len, max_read_len = len;
 	int status;
+	int retry_count;
 
 	/* check any max_read_len limitation on i2c adapter */
 	if (quirks && quirks->max_read_len)
@@ -255,7 +258,17 @@ static int ccg_read(struct ucsi_ccg *uc, u16 rab, u8 *data, u32 len)
 		rlen = min_t(u16, rem_len, max_read_len);
 		msgs[1].len = rlen;
 		put_unaligned_le16(rab, buf);
-		status = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+
+		for (retry_count = 0; retry_count < CCG_READ_MAX_RETRIES; retry_count++) {
+			status = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+
+			/* Only retry on -EREMOTEIO, and not after the last attempt */
+			if (status != -EREMOTEIO || retry_count == CCG_READ_MAX_RETRIES - 1)
+				break;
+
+			fsleep(1000);
+		}
+
 		if (status < 0) {
 			dev_err(uc->dev, "i2c_transfer failed %d\n", status);
 			pm_runtime_put_sync(uc->dev);
-- 
2.53.0



