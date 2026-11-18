Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033685;
	b=LGPl6KHQqLBpzVC8EoSzTsjH6y8j7KOi9sF9xqKxo1FbZCvfL0kqolRnehQU0bEKCjdw
	 bZ9ZRBWUsvBv19hMSK1wnV4B8IlrEq2tSdjQxKkmmJB9r2svO5kbRJ1DZ5iFbvezRo/kB
	 mpnCD38ml4ZvdTC9hqEeBGUqlkoL54XfvJqQzlN/WRZetymMUGLune5N7eeFdUam7iJa3
	 HL3z3BrC0QQTnKtoQzrMFAEmNo3XkgfBt7LsRSzYQ0DFaGmcQw6gisRqemoLg20cKOzQo
	 4K1f735LHwCzIP1h7l3fAZdgiyYx9lufJkofnIvNl0QRjYRMk1Ym7LMSBjzfLA7f8kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XC+G9KLxT5CCR28DOaKrcI9JWfilmDDZNsN52Xw+lqc=;
	b=Ky0llX8rzQAAiKyFS/t2M1jNOH5NvFBpxeK4pMMNxTa6XM76EYsVljV8ZKNvQaKH3wZO
	 tUEb0u9cbpzAY1ONa2bV7DdRxqLV2UwRgw64u6yWq6S89jy96z2KYvI8aocV0Zn9x29bJ
	 wGnlCvoP4HowbKahqaV3+dwF1GNWPVtMMCURPNFkK50gqwCK+q4ztuPxrNorAB6sKQauv
	 3aa72+HdfpsQQYJTNntZ1D3pICp4sHwEZAF3wJl8YfZISxppTv42RCgNmhyBLKTRHx55F
	 jCgsmOXpmqnkw50f/GzF694/IgrrcCPpWSuowQX9wx6Bk70RfI6IxKJwlGbe8wGXZZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilo5nGof;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462A1606A325;
	Wed, 18 Nov 2026 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilo5nGof
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9061F000C4;
	Wed, 18 Nov 2026 20:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033685;
	bh=XC+G9KLxT5CCR28DOaKrcI9JWfilmDDZNsN52Xw+lqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilo5nGofuMi9EdJReS45Z68U0SQHUMaRk6BwRgGPaq/RL9Y45o93OqWTN+pENAFhc
	 kwill3yF6KX6P4W49THz2u7hUZ11OnbO4PhOUZNcFt/mNpZ6b7wa6AtTkcyKJh4JFp
	 ID0KuMWj/vmn7tlEX3D4ny4+B+zxAnwrssMGu3Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0101/3318] soundwire: dmi-quirks: add a global ghost list
Date: Wed, 18 Nov 2026 15:12:03 +0100
Message-ID: <20261118150317.253405714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



