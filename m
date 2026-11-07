Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060722;
	b=bRRGKLYoFpb5YHI0tam8yZhmpWYxZ4nosV/Qe3LFTo0MKZL1YtRWDLEa39D4ockaH6XF
	 /syYVAlYWZ4W7Lj0tZaSdlxZ7oSj7OyVLYa8VtSby124yo5loO+dzv0NpZxaBS3BpCTLB
	 b9MpyDKt4cMe2HKZ833BJUf2Nbte5gY2fcDRBPiQbUSSi2E4JVDOHzoi0j9z/uGFQRfuo
	 VQeKBjqaW/E0ZjiP1rqdhAomhwx2j2L6e7PnoMPzHwgHnFEXeLy59z3jBvx9TNBnkAWZc
	 CM1KLD3GQVuhKNq+Pp3A8yI4vSjb4aoTnFqICfPenylo7ole2xn2agvffCHZhUSv+xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9I2ZCZmkiEqKlpOhSKqYOCxXCHFqlokKBEVrxqzf6PE=;
	b=S/xyZfKeV4nxVlIQP/NnXWi6pf/YBFicj9hPi43ue3JANfDR67GWMvvpEpflt6Z5hy/K
	 gOrD7i73+vPDicjMvhBal/DftezPLo/B+oVNWqT5KeQFCLo8UWEgzw61Kwm8FHLpZhYp9
	 gqoa4jYCutbNVIyl1XSkXDQjTFZWJtV745x8d1tYhE/JVpJoH11g/QscjF5+w41LQyj3p
	 iidvsL21Oqy9uaMJ3zN0zRhEyARB4D+FMVsYoMrls8U5I/V5RetOg1N20To+ScSaQQUAo
	 6dPZmAqkGfoNgGVAujv0lsc6kLUIzBnOB/ROcgrZC2Yp99wPpvf5T3EPYMkadnAD1VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzINfuTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121E3606A326;
	Sat,  7 Nov 2026 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzINfuTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4751F0089F;
	Sat,  7 Nov 2026 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060721;
	bh=9I2ZCZmkiEqKlpOhSKqYOCxXCHFqlokKBEVrxqzf6PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzINfuTBcF1cKKI8oU/RXkXT+6s0rhzq9gWsSukw51duW4mgjY3FDdPDC5PXmpoG1
	 EzLFZrZk6LKp1gih9Bfg7tT0YSaGJtzhj9z9lcWzDJIyLtaaK4Q2xzUUGWCHu6fVeD
	 FFoNsefkzhisqUZZDlH7boOLgE+xDYKCEqyWexJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0143/1536] uio: sercos3: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:35:59 -0500
Message-ID: <20261107135001.708030479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b93a5f8f4cba2..20d8b5f9d0e97 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -212,6 +212,7 @@ static struct pci_device_id sercos3_pci_ids[] = {
 	},
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, sercos3_pci_ids);
 
 static struct pci_driver sercos3_pci_driver = {
 	.name = "sercos3",
-- 
2.53.0



