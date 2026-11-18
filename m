Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043080;
	b=0V8as6GOeb8MEj/DtWt9Gb1pTiEAKgdEx4DWkI6gDVTYpTaY8Q/cnIkVtDAFznsRkJZw
	 hW9aa3zo/GAnD4mo83pSQz53WIkx1SyfBGtnEgkVEpLbpFbR4mOnvfvgpws/5kQlIKfXL
	 R4Ag2UazdN5OOVoNPf2UGs5iMZXKOFNNzCsvaqf6fVqiwnCX6t1p/vE6NL6SOOVmJUjJ4
	 pV3mbmI/6j6DDiRh92MgwVrrwx/89Jnmrz2ZX8G4hwLMTV0klkzPAJbcyTtDnVorY4A+5
	 shV8e2W0M7LqmWfTqL0JH51r41lkeW2ntKMnz9zxFwC/CR/g0WvWPCPWSzrupkhmnIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vr9X+jnJjSgrgoaTGtXRBn2tjDCBHq8BEv7+wfUT1Qs=;
	b=MoMEgiDGmp4I8+lxCNdGd+ohjQCf7y3FYN/8zMwGw0MmTaNapobEVRZMSLNp2Iw8zwQ2
	 dwBAr/GvtAXhS5cizQvj4Nqa8SpevAzRiIk3ODYd5ZSJ46/gPGy+G2EWHLu4P60GxZ2eJ
	 inv2adOJS5kP9S+Z/mJk0hokf/WXI09sde4SFwOn7rtrv+j5FkiwJyF36BH+dWRUDtVec
	 gK/iTmjWSMdp2OTDXF0aXV1XOSRjorDqGW3znWv5stECw3BzCY0KRLdD0lr9aV9xJIUzy
	 d2BS9MekffyYREXnZUNGGDLci1WAjLR5GOsMl5vMJ2zOxw6jzTeVKDRYPOkMjGqlhMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7WZzfIp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA2F606A325;
	Wed, 18 Nov 2026 23:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7WZzfIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D13F1F000C4;
	Wed, 18 Nov 2026 23:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043080;
	bh=Vr9X+jnJjSgrgoaTGtXRBn2tjDCBHq8BEv7+wfUT1Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7WZzfIpmWKD1foFvZz0DC0e3faw2+iZ0aO2B/exaNqHwfVwzhvG1dd1tJRfpsUa9
	 WHnXH14FFqq3bfXa7Wl0ANVK/meVl1Vfjd53NCMiGEeBGk/wWIV5NT8HhAALLdAudV
	 /Pz4orb7lWdcIJEDn1skzr5oSGsXUDS5KXOwxfQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0083/2857] soundwire: dmi-quirks: add a global ghost list
Date: Wed, 18 Nov 2026 15:18:37 +0100
Message-ID: <20261118150204.276492906@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit b7a5d101d7d267922e828c40135bcaccf8cfb3bf ]

Not like other ghost devices, the 0x000000D010010500 ADR doesn't belong
to any codec. We should disable it in all devices.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260703011656.2572959-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 2a98fc8c104d6..62cee6e2179da 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -15,6 +15,14 @@ struct adr_remap {
 	u64 remapped_adr;
 };
 
+static const struct adr_remap global_ghost_adr[] = {
+	{
+		0x000000D010010500ull,
+		0x0000000000000000ull
+	},
+	{}
+};
+
 /*
  * Some TigerLake devices based on an initial Intel BIOS do not expose
  * the correct _ADR in the DSDT.
@@ -212,6 +220,7 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 u64 sdw_dmi_override_adr(struct sdw_bus *bus, u64 addr)
 {
 	const struct dmi_system_id *dmi_id;
+	int i;
 
 	/* check if any address remap quirk applies */
 	dmi_id = dmi_first_match(adr_remap_quirk_table);
@@ -223,10 +232,20 @@ u64 sdw_dmi_override_adr(struct sdw_bus *bus, u64 addr)
 				dev_dbg(bus->dev, "remapped _ADR 0x%llx as 0x%llx\n",
 					addr, map->remapped_adr);
 				addr = map->remapped_adr;
-				break;
+				goto out;
 			}
 		}
 	}
 
+	/* remap the ghost ADRs */
+	for (i = 0; i < ARRAY_SIZE(global_ghost_adr); i++) {
+		if (global_ghost_adr[i].adr == addr) {
+			dev_dbg(bus->dev, "remapped _ADR 0x%llx as 0x%llx\n",
+				addr, global_ghost_adr[i].remapped_adr);
+			addr = global_ghost_adr[i].remapped_adr;
+			break;
+		}
+	}
+out:
 	return addr;
 }
-- 
2.53.0



