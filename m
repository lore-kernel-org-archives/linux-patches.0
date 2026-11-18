Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045862;
	b=yhHyA008gJk02S4ko9ljcR+Tlbh6amhTDTQB20ansa/nEbRV6dXkoftwvMXJ6rju7ZjN
	 wT9GUpqmSxs0tUQbeX7MvsVIP4AMjgadVAEEbc2qoHiK9FzLnRjWHJrdn1CBance37dZv
	 PTyM3QBaMFT59e4rIHG/0gHPT2cJeneHk0JyhZkBpsYMFA4ls+JmUuuqZCWSHRP6j6T2d
	 vAOyChy9uTIQU4qxOEPw7dAxz0YNMbPnInwuQZT41RWlUoFkhc8bRVzdRWyLaoIVC6ZpW
	 QuCB1PIaI+Vr/K1gUPuPKCOv2KvaQ1QXZZE8pQZZ8VOKm3YAICCA38JERAfDUBCqCpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FJOudZrEttB3zzWjCx5kT4Apln0bGH1GH9gglv9MgMg=;
	b=daObsUDm68zVKTJ9/GD0YMrCnHhwOZHAxpX94tS/aZMcaDlNWpb6HNdpidYA4qwpfzfN
	 rQqWp+/r1tGneDayrL4F/fri1iaV1kLzpBM4/C6FIF6IOv7OdMZYINTvjbb27Cdo8XPlq
	 rt0jUUsRLH2OalsuD7MU2oHfzTcwZXsG/0y89KhdhBLSDBos0jVlvIrQIq7/Ev5xslP84
	 CNySWtpMXH25jO6Tu9/HOwm9kja415fJKbXz71EvcOdyhMUCYMo9FRkNmM0/t0x41LzG3
	 9UxUb/cHS0yQmRvAFOgf2ZGw8VNc6scu4vj2Tc2dMfkcTNhFtS8kRrQ61T6cEXe4+HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biElRfc0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C807D606A31C;
	Wed, 18 Nov 2026 23:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biElRfc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B91D1F000C5;
	Wed, 18 Nov 2026 23:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045862;
	bh=FJOudZrEttB3zzWjCx5kT4Apln0bGH1GH9gglv9MgMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biElRfc0k0IcwCyfxFk+RUnFonhH6P8E+HHVqotvwZfJqmkneMK5YNpGwKOVCbJHS
	 6mRnpWgv2OjYMyilQ0xjOGmtD4kfo/skhLLsXH6fmyDbAKSz1UWCgvwZFKuuthLw/W
	 +x/CQUcTbXyLXndyqOrkiXKfcZhgEfVjv2HydnEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1035/2857] scsi: ufs: core: Clear stale UIC result byte before peer DME retries
Date: Wed, 18 Nov 2026 15:34:29 +0100
Message-ID: <20261118150238.862912446@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit e4a9b7640914b248eb7537d4507aa42db080586a ]

Peer DME get and set retry a failed attempt with the same struct
uic_command. UIC completion ORs the ConfigResultCode into argument2[7:0],
and nothing clears it before the next attempt. Once an attempt fails, every
retry keeps reporting that error code, even when the device returns
success, so a transient failure becomes a hard failure after three
retries. Each such retry also triggers the WARN_ON_ONCE() in
ufshcd_dispatch_uic_cmd(). In ufshcd_dme_set_attr(), ufshcd_uic_cmd_compl()
also overwrites argument3 with the register readback before the next
attempt.

Clear the result byte and restore argument3 in ufshcd_dme_set_attr() when
an attempt fails.

Fixes: 64238fbd15ea ("scsi: ufs: add retries to dme_peer get and set attribute")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-6-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f441fc0903a8d..13cf6c80370f1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3959,9 +3959,12 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 	do {
 		/* for peer attributes we retry upon failure */
 		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-		if (ret)
+		if (ret) {
 			dev_dbg(hba->dev, "%s: attr-id 0x%x val 0x%x error code %d\n",
 				set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
+			uic_cmd.argument2 &= ~MASK_UIC_COMMAND_RESULT;
+			uic_cmd.argument3 = mib_val;
+		}
 	} while (ret && peer && --retries);
 
 	if (ret)
@@ -4026,9 +4029,11 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 	do {
 		/* for peer attributes we retry upon failure */
 		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-		if (ret)
+		if (ret) {
 			dev_dbg(hba->dev, "%s: attr-id 0x%x error code %d\n",
 				get, UIC_GET_ATTR_ID(attr_sel), ret);
+			uic_cmd.argument2 &= ~MASK_UIC_COMMAND_RESULT;
+		}
 	} while (ret && peer && --retries);
 
 	if (ret)
-- 
2.53.0



