Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064671;
	b=4Qf575kgci17R0yNt+ubgJPfUhmD/TpwhS91ejioPjKy8tetefvBiE1050WSJGnmIOad
	 CywENrjEu2BJm5CN5v2lW16tk8cPTC/zkGVQBkGsAT+RKljIZEz+ExlxD7BCQmSqBirI6
	 3i7/3M8IuUDfX24MMk5GERRO4JYDs9MnVtEPv9r+zEO2HIWnhEy29m+y7VGWnlIahf1FZ
	 /6TVC1aAT6xaK1OBvgRO6ohp+ViRQwUBwegh8dBLPJKOHMDtYaFa34Rg9n/BUhYizAZgz
	 8nOby+tpTueQhLb+f/YkMibGXHzhvj0b5KJJxTrY0Gnl/w4odjvZAjobovShNeGQJig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U0Hbq5fgqRORVxN/6+KuVP1bPxbgJy0Hc6sTMJtW2bc=;
	b=aHsGmLd7xJHgK6/RWmv0Vwm28PP+e3cLVTF+KqUUvCMZkt4b6dTjdK4KjWh+TgFqaPl2
	 iCYALnKL3ehZYl8CuuoJ/DVHZN6ju6ux5j9tSXBbnSprqTY7e0JBnCIcSFVcnzQImVE5K
	 VhsNhh+cjgXsMZawzzKwhzV4txaM8UUMOzX/q2F+EO1JTJCJdoBn1eKK8vBYDiswJuQU4
	 2pVAGYsZVYx0osKQfK+x3Mzg9BnzuyTMO2BCcXo81ubaG6AzL9+6WO2PgbSKVh7/COl9g
	 9PBDX/RecQz7icKn37BwHoHbf5hzb0kchalz/nFxyf+KcwahGbkHFVhxx0dKDbayd7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FcQZ1mM3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F6606A33C;
	Sat,  7 Nov 2026 15:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FcQZ1mM3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFCE1F0089F;
	Sat,  7 Nov 2026 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064671;
	bh=U0Hbq5fgqRORVxN/6+KuVP1bPxbgJy0Hc6sTMJtW2bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcQZ1mM3nOK/id9QIr9J1Y6md+2Nqt4eLXC2bU421i2frbTtkZR0ElgfPCDbF20LD
	 K4i/GZpAOWP2ETr0Wh1NefNbMW0z7rhlTw4jrUHp5to+d9gkIhlZX0RKC9uqZzHEJw
	 rOZjgBrUqfnPIqltgDtqxW2DDwZK4Jt0pZfdm4tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0631/1257] usb: typec: ucsi_ccg: Add retry mechanism in ccg_read
Date: Sat,  7 Nov 2026 08:48:47 -0500
Message-ID: <20261107134956.721904504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 80e3e84b418d7..3f12db95c7f46 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -135,6 +135,8 @@ struct version_format {
 #define NVIDIA_FTB_DP_OFFSET	(2)
 #define NVIDIA_FTB_DBG_OFFSET	(3)
 
+#define CCG_READ_MAX_RETRIES	4
+
 struct version_info {
 	struct version_format base;
 	struct version_format app;
@@ -255,6 +257,7 @@ static int ccg_read(struct ucsi_ccg *uc, u16 rab, u8 *data, u32 len)
 	};
 	u32 rlen, rem_len = len, max_read_len = len;
 	int status;
+	int retry_count;
 
 	/* check any max_read_len limitation on i2c adapter */
 	if (quirks && quirks->max_read_len)
@@ -266,7 +269,17 @@ static int ccg_read(struct ucsi_ccg *uc, u16 rab, u8 *data, u32 len)
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



