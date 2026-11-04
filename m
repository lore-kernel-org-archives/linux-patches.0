Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829392;
	b=uSL9ZfdI06c6qCwK3m4jaiRKhYTEBSv2ElQFdn4XyfN6xY81Ly03bPKLAfSUCl9irDUd
	 aQXTXSfERJ7MIOAjghG1Rh4LXZE23+doxCwu83hJCqycT/YJ7Gw5ZNvMCf2UdOTLjbYuW
	 KETcaCmFMSDqmpHXCb3IJAHld8zVB+zWTbLydd/QgsSXHNoqOqfnurdNUWjA5ahCmK3sf
	 UYsCD2YxKNv0TlTAUhfXJOXaPpwktT0/9FU3AHe+QAx9+jKY2FnAuZ7YamKPkWWjobGQL
	 TVmJaEEUAadSd6SLO6zyJDQQtZBjcCouGos+q/dMlTsG9qIbMe/p+dB8JeN6cUQokFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fWZ4re0egE3KKH90CKlEVQNOlY1tbAcrIRR+H5e6Log=;
	b=sAG9SKsVODLWp7MRXUfOGUGy6ScWGgZWFlAzvVDQcUS1wSTKLq0kIkxcd2NbFaG/W9Mh
	 Wqzxc1vewrJPMoGBhqm74VTncUqGwJBGOZjouXtVxz9kq+bijWvTeUAveQVBZ4agEdTe1
	 scayyLqJYqz6dulXNoofkq9g6e0ifeN/MPReKxl+CerN9hshktmOuL/SzBp4sFWQWWfzT
	 p7X8f3NOmFSVF4KyCJOjIX7v9b81Y8HJhsz4De5xN1ViQ95ulvyG2h3A7vJWb1LxjKW2A
	 ydD9+CwBuEGugTKhLROONYI1IrN8JjYXF7+oUEF4ydhooxwbXkTpMPnk945+1nSXv/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9sCfQZY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495BD606A865;
	Wed,  4 Nov 2026 21:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9sCfQZY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9D81F000C1;
	Wed,  4 Nov 2026 21:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829392;
	bh=fWZ4re0egE3KKH90CKlEVQNOlY1tbAcrIRR+H5e6Log=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9sCfQZYZY+uziPAYstg65EC6iapRi6WMcYCsnJltovW1+cZkVbmbQlI3d8nQuPDP
	 lS5FdvDF23H2Ibx/ozNbxoYkCRIj6rWhEJF981OSZ2GlN+7RtrXxF0RTnFSTBELmJk
	 Jtg9gRPJB3709AnJqP2+pIYKDJuIsp6J8jlugnTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paritosh Potukuchi <paritosh.potukuchi@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0058/1005] i2c: amd-asf: Validate firmware-reported length
Date: Wed,  4 Nov 2026 15:56:31 -0500
Message-ID: <20261104211045.219858703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paritosh Potukuchi <paritoshpotukuchi@gmail.com>

[ Upstream commit b2f4816a378dc840b605a1235b80e57c5f85b46c ]

The firmware may sometimes return a length greater than the
allocated buffer size, which can lead to out-of-bounds access
and a kernel panic.

Currently, the driver does not validate the length read from
firmware.

Add a check to ensure the firmware-reported length stays within
the bounds of the data buffer.

Signed-off-by: Paritosh Potukuchi <paritosh.potukuchi@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260612101815.4124804-1-paritosh.potukuchi@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-amd-asf-plat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-amd-asf-plat.c b/drivers/i2c/busses/i2c-amd-asf-plat.c
index ca45f0f233210..f5b73c8340495 100644
--- a/drivers/i2c/busses/i2c-amd-asf-plat.c
+++ b/drivers/i2c/busses/i2c-amd-asf-plat.c
@@ -90,6 +90,10 @@ static void amd_asf_process_target(struct work_struct *work)
 		outb_p(reg, ASFDATABNKSEL);
 		cmd = inb_p(ASFINDEX);
 		len = inb_p(ASFDATARWPTR);
+
+		if (len > ASF_BLOCK_MAX_BYTES)
+			return;
+
 		for (idx = 0; idx < len; idx++)
 			data[idx] = inb_p(ASFINDEX);
 
-- 
2.53.0



