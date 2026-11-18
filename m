Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057298;
	b=IrHpAiU8eFN99YKYltQqALZyRXdz4FL7xpTL05NcHrR0reIve9kn00ZXp9JXzck9Hizq
	 np+5bVg+ltCeu02WHO+1blfIalKWZBukSlwYvXQVUwaFbbDOplykR+NkT6+761KjUaMKK
	 5EpGiXeb1pK0tSyngVzEs0xp9PNsLRTUpZNIKDAh5qBy5I0CHKoUghtuC1qjD8Tb0QusA
	 8jHknrU18yIGAR0CB1T0RIRoLcaKZccAEUpxiABiIulxiQ4lX2pjpeUUNUXWBkvgFLQN2
	 wpuDiGMLKvPXcg7UqyvYC6pvKK2iXhSTkeGpxqq9CzdrmeRbET++YhoAu70VcZmbb1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TEzzDHq+egq89Xt3CGiRHnoZk+stJLWylNFUqz11X5M=;
	b=zU3syfFj61Y2kpnWY3l872WRoUmB6zpi85fncIwsK8E2DkFkc8m1WfZ1iHFtloWfqS94
	 ygPt4z/IU5GvaQvbp/cE5wM/c52uHWHpfRAwquu7N/DaMUZtloWMLeOq4JyL36cyGQ3oa
	 1YnlJ+GgxH4pu0gki+HfUmkqJZdTY12FAA7f7d1sh1Xs6/eAW51vwURaHsebjgDIk+PWf
	 AnSbszp6phtsgaHCpUGYH/NLYvaw8pMle9AcIXqkgOGdQqZO8kn3X+tcUkM3vlrzYtd7h
	 K5GqEVmP9r6lXzhNGsl0wr8roNxTH/zh7jKIPZ0bx7oSy3IHcI0BhVt2NKms6hJqb3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uc4D4fj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0CD60A3807;
	Thu, 19 Nov 2026 03:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uc4D4fj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1451F000CA;
	Thu, 19 Nov 2026 03:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057298;
	bh=TEzzDHq+egq89Xt3CGiRHnoZk+stJLWylNFUqz11X5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uc4D4fj3SHibM2wJ2jeviXGXLIrVR/tdhdT3t1d/0q0bXVS2ulk5bbtW/ZJWgPka
	 FPYvwGSrKh5Mbq324AKRkrY8C1jQMYHkGng//pB7JYW2ZjElJvsC8gInR2KwaAgHOA
	 mFJxkcpBRCuFhf3A+0qVF6jH9SmFHZZa9jMMgqFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0080/1848] uio: sercos3: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:35:18 +0100
Message-ID: <20261118145914.460688060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a432f68c51fc6761658445e80a798b8425fdb3dc ]

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152642.54769-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_sercos3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 9658a0887feeb..660071683764f 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -218,6 +218,7 @@ static struct pci_device_id sercos3_pci_ids[] = {
 	},
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, sercos3_pci_ids);
 
 static struct pci_driver sercos3_pci_driver = {
 	.name = "sercos3",
-- 
2.53.0



