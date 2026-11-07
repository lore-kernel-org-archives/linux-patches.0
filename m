Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060701;
	b=CyT/gCK17GlmfsTjrshDnJ0IPUuMNoVcOmgwdA/QBYu/fjXLapfFYqpjoGhfiGRKHVP7
	 UfqG06UEPjaaobMRVHTjbJ9uQ48lvJMnKw3L1FLa93MmXYEczTgXJ+JQUi3ysyU7PZ0UP
	 QlPByD2AGyG15bRyG9O8TmDp2ycNBiuJTdrNJ7e5q0QcgRCyuRZUZI4txsHLQ3Y7n+3AR
	 bXFk4pUZLhMasSvohUkfW4l/uSPdwh8Fgl7HmTvzBZTBYMIQeD+vnDRSP2fNijq2yyCc0
	 AGvZP4FqwkuSl4/JB/5pC+3fdXhHedPgIFqaYO+WvTmflUw3QgZLN7fN69eqhJAinUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fS9hbLUwLKKoLx7mVaPRjQ8EeFYbzaKjexGhRTX4A0c=;
	b=PWshEJylQSbGkTDlNaMIHQJJrcmZSbmDLVNwQSv7D6CsU7/k+1a108oXVQBZaNq11oPy
	 A2rfh6hFaeNtQrPFdkAdNLZWgYZFI081H16jwhE9EYOSA+kA7XuZ672ESb5B6ea1yJje9
	 +MSWXYw6WO4Vm5h3Y+aTwNTDSxU0vR3mWKu80FkzYZ6uK4uFTDxQODFjhako1hiqQo4/N
	 OP9BpqWPjQzj64ZYSIF8yzhM0MRl4QAvbHatTcza7SKMt+9N7yind1Bj1ArR3ilUJ5VJ1
	 EchxJep4A8Qd+xqG1s+N6TRnohzZCN5WGg0uxBampxxqlHXATw4FTTsPscb8sFvrqPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPcEwGYN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC836606A326;
	Sat,  7 Nov 2026 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPcEwGYN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881011F0089F;
	Sat,  7 Nov 2026 14:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060700;
	bh=fS9hbLUwLKKoLx7mVaPRjQ8EeFYbzaKjexGhRTX4A0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPcEwGYNauMP87ezNQIWKvbIH034b45Wz6hhCqR0r8K+3aFjGgR1ZsxYvy/OmIaDT
	 1nt2XcxpHTKG7jOQSdsXUqyVUyDlM7/cnxiyFTimKRxY4SjIeMLCu4sgSsDumkrwVW
	 u4mNDgXm/n+aOtWxhgM3JdncwcqICdH6OXCSl4rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0122/1536] soundwire: dmi-quirks: add a global ghost list
Date: Sat,  7 Nov 2026 08:35:38 -0500
Message-ID: <20261107135001.112402629@linuxfoundation.org>
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



