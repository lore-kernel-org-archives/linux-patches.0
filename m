Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017386;
	b=T0n4uO1HLwbrBJk+xRKugbMC5l0CiARiKuAN5Qo7FHrtNymAcZiAzLvMjqlSZsMAh7D1
	 /aayBb8N6l2ibPrIlhvYl6GDwuSSGZlbNiBCV9HZ4soeRevEu945X4g2D4UNDf0BykhXj
	 Eo8PACfk/SMGalpR0X1wIiIv/wx/ZawLD5QvIkQFPEjpOE/bnQ7evzk5r1APYZ05kFX/Y
	 cRjaRlAdLqx811bo8+nEi9BIAOhC5mOFtd0ibzOARKciRePIiJ6Zsltndx3f4SGhKC3Is
	 KrewnF3v71JT5H2zs7lONszABPv55K63y0IRZoHB961mUFgK6MfFi1qOeLyDVj5x11A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6nJiZRrlfPC1rnzLKK1i0cOCOMC7cy2G60Nd/yV/GA=;
	b=fgZLwEA78wpVruW+0CgeP3UmMr8JVAhMfeLY1yKWRMfWIEAXKFBvM3Z20akia7r1oitv
	 P0eh0tp5ZjwscbNLnNmfwCq6fetzdWjgX11BAEZhMASDbb0As/lRp8/met8QFJvOcBI1a
	 gg5G0sRI5Pim5kCxDzTITKUNtTvvDJ055HWmrSRhp7y2x1obxOg4u+gTxbyUDgSFuWkO4
	 pkP2qvPYb04gB8cKsc5SkMcYzvmBtfk7jxzMgt1VncsP02W4ohEpyxlAwzGVroTWzMwyi
	 lOcx3SoeCz01W4O7211aCAWBcxHfw3zEDks9x/Kdm7dVm7fNMYfY/No4wFCFB0YLw9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0elgSXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C1F606A330;
	Wed, 18 Nov 2026 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0elgSXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759601F000C9;
	Wed, 18 Nov 2026 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017386;
	bh=v6nJiZRrlfPC1rnzLKK1i0cOCOMC7cy2G60Nd/yV/GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0elgSXY3kTKM7kY/6Iyo2sG1bkCSQMUDcVcoYs94NjAYzJg45aIp2WV+rZLm1GiN
	 n1QxxvaPzJOYG597LaHHQWh0PuhCVzKLEwfY7cHsp5r5U2f22cD4CoXcFLy1uo2aRw
	 dPDtP9EiKwjT4IC1GTTROnQCWolOfhPJF9jDtY+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0864/2651] ACPICA: Fix PCC OperationRegion command offsets
Date: Wed, 18 Nov 2026 15:35:04 +0100
Message-ID: <20261118150318.964345317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 888dab4b04ea8725168c6d50d0bfb8057fccca18 ]

ACPI 6.3, section 5.5.2.4.7.3, states that the PCC Operation
Region is associated with the region of shared memory that follows the
PCC signature.

The generic and extended PCC shared memory layouts include the 4-byte
signature at offset 0, so their raw shared memory COMMAND fields are at
offsets 4 and 12 respectively. Since AML field offsets for the PCC
OperationRegion are relative to the region after that signature, ACPICA
must look for those COMMAND fields at OperationRegion offsets 0 and 8.

Adjust the generic and master subspace command checks to use those
OperationRegion-relative offsets. Otherwise writes to the COMMAND field
can fail to invoke the PCC address space handler at the offset described
by the PCC OperationRegion definition.

Link: https://github.com/open-acpica/acpica/pull/1205
Fixes: aa6ec56b574d ("ACPICA: ACPI 6.3: add PCC operation region support for AML interpreter")
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
[ rjw: Fixed the Fixes: tag ]
Link: https://patch.msgid.link/20260922144302.3847593-2-sudeep.holla@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exfield.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/exfield.c b/drivers/acpi/acpica/exfield.c
index 9a55524ed8f42..50317fe0cbd5e 100644
--- a/drivers/acpi/acpica/exfield.c
+++ b/drivers/acpi/acpica/exfield.c
@@ -45,12 +45,13 @@ static const u8 acpi_protocol_lengths[] = {
 
 /*
  * The following macros determine a given offset is a COMD field.
- * According to the specification, generic subspaces (types 0-2) contains a
- * 2-byte COMD field at offset 4 and master subspaces (type 3) contains a 4-byte
- * COMD field starting at offset 12.
+ * According to the specification, the PCC OperationRegion begins after
+ * the PCC signature. The raw shared memory COMD offsets of 4 for generic
+ * subspaces (types 0-2) and 12 for master subspaces (type 3) therefore
+ * appear at OperationRegion offsets 0 and 8.
  */
-#define GENERIC_SUBSPACE_COMMAND(a)     (4 == a || a == 5)
-#define MASTER_SUBSPACE_COMMAND(a)      (12 <= a && a <= 15)
+#define GENERIC_SUBSPACE_COMMAND(a)     (0 == a || a == 1)
+#define MASTER_SUBSPACE_COMMAND(a)      (8 <= a && a <= 11)
 
 /*******************************************************************************
  *
-- 
2.53.0



