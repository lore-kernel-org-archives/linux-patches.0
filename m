Received: from mo4-p03-ob.smtp.rzone.de (mo4-p03-ob.smtp.rzone.de [85.215.255.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DFA15EA2
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 09:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="Q7pf8uY3";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="K+SnUVtb"
ARC-Seal: i=1; a=rsa-sha256; t=1698744631; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=HQJc5Nkhswm5uSaWaKRRpcOscVIuDviuSTUtu8N2Z5P/CYT+sGpMs9uYVo2/xl4Elv
    7gxAtloOJzYd1xke4eSp53cxhs+scSSwZfNoBO6FW8OnDCTs1weqnIXgGa3TwkYRVuu7
    ZoAS4h+3ik+99NNfZX73Z47OjdgmgSKXiwECeeInEcnl4zo4I9ZKP36umfUXT+clhFv3
    Zs/F5FT22oe1gU0O88zMjTlwgM7NrnngCk4NddHgDn6kSI/XlS6bdyJ9glezmdHuIOKW
    zmLsT0IUkJjXdqaU9awSFP4UZz1q+GMwKe/Envu7mR7I1paW3zE80634jlXpVjjj2/eY
    FDeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698744631;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=jb2auSkUYoEo3cnWQFlmKJioU43fO00q1xNYwANBTcw=;
    b=TaaaZW9p3oyajbj+esigDDB47MxlLnkZnjNaqY5KSv1aAFUUeaovuW1hifAVUHPQEy
    FcVY8iCNrXiVWhy0U0FJJbfFMFDsPQio+IFfQ0oA72QcTAmpk2ERkDMo94oX1ZDgAOd+
    jO3pitVqpOidaXkYTOgwuSv7LU6UZIaqtpshHMdnyMZaELzsb2AAJDkiSm/nC04B/L9s
    8ofKAqxFKg4nGWSu3rfmcjSmQijrKgxi5efuBotDSfL4E9RNGhgmQyEib3EJ+2Mb19fz
    QmI2xFurxiEDKLp9QTYXbrU57zr/oek7WbbH1yFrpCHthiuSqd0JGkubMyZHCatHoIqT
    a7rQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo03
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698744631;
    s=strato-dkim-0002; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=jb2auSkUYoEo3cnWQFlmKJioU43fO00q1xNYwANBTcw=;
    b=Q7pf8uY3w9SNCEWx0sC3upSdPpgNzCWWz7rC/zsjWWR5Rqwb0vGJMK8rEg5IV1h9Vk
    Hrskt218FTzoCLttXOsm4xOm2NhuhR4lk94CoVS8sAvouBNkk+7KqMbnIH/VWf9FLkdj
    s0klNTM3FlWkdY6fwIofNg+lQMVS3PKTH/Vhp/xL40Rvx7gq9ro/cI5hZR8S6P6hJc03
    LOkPgFY9KGEQocehitRWPc2B4Hzzvd1XIES0DCa8Y/rUUQ4RtOnd/DLhsYaP/Nb0M3va
    uq2HlvUkLj7ntHSav8hHWASsbUIzlx2BcfTfeyhAJE0XWtcxVeJ/u1lAbj0fURkhfxgK
    lFqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698744631;
    s=strato-dkim-0003; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=jb2auSkUYoEo3cnWQFlmKJioU43fO00q1xNYwANBTcw=;
    b=K+SnUVtbggEBJFS0pr/H1dI4p1lIyDeC8EiEaN5GGLG6jKiCCnrGAJ7DtB/dAH2GSO
    1iJhI1nrHUQxbVkrlkBA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejuVITM8sik0"
Received: from lenov17.lan
    by smtp.strato.de (RZmta 49.9.1 DYNA|AUTH)
    with ESMTPSA id Kda39bz9V9UVFhY
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 31 Oct 2023 10:30:31 +0100 (CET)
From: Oliver Hartkopp <socketcan@hartkopp.net>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	sashal@kernel.org
Cc: linux-can@vger.kernel.org,
	lukas.magel@posteo.net,
	patches@lists.linux.dev,
	maxime.jayat@mobile-devices.fr,
	mkl@pengutronix.de,
	michal.sojka@cvut.cz,
	Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH stable 5.15 1/7] can: isotp: set max PDU size to 64 kByte
Date: Tue, 31 Oct 2023 10:30:19 +0100
Message-Id: <20231031093025.2699-2-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031093025.2699-1-socketcan@hartkopp.net>
References: <20231031093025.2699-1-socketcan@hartkopp.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

commit 9c0c191d82a1de964ac953a1df8b5744ec670b07 upstream

The reason to extend the max PDU size from 4095 Byte (12 bit length value)
to a 32 bit value (up to 4 GByte) was to be able to flash 64 kByte
bootloaders with a single ISO-TP PDU. The max PDU size in the Linux kernel
implementation was set to 8200 Bytes to be able to test the length
information escape sequence.

It turns out that the demand for 64 kByte PDUs is real so the value for
MAX_MSG_LENGTH is set to 66000 to be able to potentially add some checksums
to the 65.536 Byte block.

Link: https://github.com/linux-can/can-utils/issues/347#issuecomment-1056142301
Link: https://lore.kernel.org/all/20220309120416.83514-3-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 4dccf7b4b88d..3e2a7cbade24 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -85,13 +85,13 @@ MODULE_ALIAS("can-proto-6");
 			 (CAN_SFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG))
 
 /* ISO 15765-2:2016 supports more than 4095 byte per ISO PDU as the FF_DL can
  * take full 32 bit values (4 Gbyte). We would need some good concept to handle
  * this between user space and kernel space. For now increase the static buffer
- * to something about 8 kbyte to be able to test this new functionality.
+ * to something about 64 kbyte to be able to test this new functionality.
  */
-#define MAX_MSG_LENGTH 8200
+#define MAX_MSG_LENGTH 66000
 
 /* N_PCI type values in bits 7-4 of N_PCI bytes */
 #define N_PCI_SF 0x00	/* single frame */
 #define N_PCI_FF 0x10	/* first frame */
 #define N_PCI_CF 0x20	/* consecutive frame */
-- 
2.34.1

