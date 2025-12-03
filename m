Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BCC3148CD;
	Wed,  3 Dec 2025 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780504; cv=none; b=IMjTv3dLhWL/ww6WddgWLvqBGHzi26l6ZyO4XieM2EIuBxiX2aQHA5u77QLDcuirvXmUKK5gcJR7zvOO0xRiL4XLTwb+Kr8Oor/dz2+LHrozcJtx7grqSYmgyqKocz3ACnSIQvHkzc5UdM4msNq3zHpAed/SD2tlwKsnwxxEK8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780504; c=relaxed/simple;
	bh=ffTNd57sRrKUwIC/7Str78Qym88dWOsZChPl7nNpVTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0efEKo8TcWx9jYcsJyFwtWv2inEimzBM9dtx1Hdf6P5RmthmqaNpBwavj2mtsB/h0XazWBeGtOuCPlBXhiWtXIixZ6oNWPgZSCpizpzu/s/LQhPt/WZxRr001epcMQ8HUYjeH5cRAR/X9Ci/WlKYDCY01VKPi4cY+mwYwVlCbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrCRCOGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrCRCOGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7A6C4CEF5;
	Wed,  3 Dec 2025 16:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780503;
	bh=ffTNd57sRrKUwIC/7Str78Qym88dWOsZChPl7nNpVTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrCRCOGQ8ob8I9BBHrLdFCzbjMe3jLqHcyCrh1fjn/kIVRlcDIvuRutexwjOyD/Si
	 Jiu9ikrq8W7gFkMozcW5zgNpir8HitDvCsYaIjJShNiYvB/2QoISBzubOOeY+ARF4h
	 SF8mFRxPAmyzhr/zM0o5djSqmed2hjKJOf73ANec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.1 567/568] i2c: xgene-slimpro: Migrate to use generic PCC shmem related macros
Date: Wed,  3 Dec 2025 16:29:29 +0100
Message-ID: <20251203152501.518097111@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

commit 89a4ad1f437c049534891c3d83cd96d7c7debd2a upstream.

Use the newly defined common and generic PCC shared memory region
related macros in this driver to replace the locally defined ones.

Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Acked-by: Wolfram Sang <wsa@kernel.org>
Link: https://lore.kernel.org/r/20230927-pcc_defines-v2-2-0b8ffeaef2e5@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xgene-slimpro.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/i2c/busses/i2c-xgene-slimpro.c
+++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
@@ -91,14 +91,6 @@
 
 #define SLIMPRO_IIC_MSG_DWORD_COUNT			3
 
-/* PCC related defines */
-#define PCC_SIGNATURE			0x50424300
-#define PCC_STS_CMD_COMPLETE		BIT(0)
-#define PCC_STS_SCI_DOORBELL		BIT(1)
-#define PCC_STS_ERR			BIT(2)
-#define PCC_STS_PLAT_NOTIFY		BIT(3)
-#define PCC_CMD_GENERATE_DB_INT		BIT(15)
-
 struct slimpro_i2c_dev {
 	struct i2c_adapter adapter;
 	struct device *dev;
@@ -160,11 +152,11 @@ static void slimpro_i2c_pcc_rx_cb(struct
 
 	/* Check if platform sends interrupt */
 	if (!xgene_word_tst_and_clr(&generic_comm_base->status,
-				    PCC_STS_SCI_DOORBELL))
+				    PCC_STATUS_SCI_DOORBELL))
 		return;
 
 	if (xgene_word_tst_and_clr(&generic_comm_base->status,
-				   PCC_STS_CMD_COMPLETE)) {
+				   PCC_STATUS_CMD_COMPLETE)) {
 		msg = generic_comm_base + 1;
 
 		/* Response message msg[1] contains the return value. */
@@ -186,10 +178,10 @@ static void slimpro_i2c_pcc_tx_prepare(s
 		   cpu_to_le32(PCC_SIGNATURE | ctx->mbox_idx));
 
 	WRITE_ONCE(generic_comm_base->command,
-		   cpu_to_le16(SLIMPRO_MSG_TYPE(msg[0]) | PCC_CMD_GENERATE_DB_INT));
+		   cpu_to_le16(SLIMPRO_MSG_TYPE(msg[0]) | PCC_CMD_GENERATE_DB_INTR));
 
 	status = le16_to_cpu(READ_ONCE(generic_comm_base->status));
-	status &= ~PCC_STS_CMD_COMPLETE;
+	status &= ~PCC_STATUS_CMD_COMPLETE;
 	WRITE_ONCE(generic_comm_base->status, cpu_to_le16(status));
 
 	/* Copy the message to the PCC comm space */


