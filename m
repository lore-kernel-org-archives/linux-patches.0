Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051062;
	b=R3jxS+6Fiz5fS9Qtn836Hoy6HI8+WPQdTUHWG3vMC7UtTBXMpZ09wE/dO0TFfSCUBngd
	 J02SX/TkqVLP7KOPZDfQ/UmmxflKwxeg57YiTVDd+bQQBDLUBLA4MLTqPUsbs2mZ3Ohb2
	 ZKA0/nT1tQ7yf3JtcRzN0pKAhlKOBC/q5uuwgGKds5ZcFZ+4AoS42brZ67BAaFmsXS3IJ
	 JMDZqSAIQxRb2IJfQBXe5zFxh6xG43nM1Kq5u9NxvcSfSPkTLs+1zlBzZCBKVG0O460GJ
	 1LT0sAy9DZ6YGbCdvu3BaMguolUkyo8QudI6XgaFfhP3SPpQI8Z3F79n7U0cZqWDtRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hkQVhYnFbc7KoVQAkV7qplEWnSgMsC5YSmLhbdkWGPA=;
	b=VTnZ9bTpuCEGX3maBokrZqulfGKZ+Ji4v8q49UDWUvpyco4OHelDNqeWH6N/LuHN43WV
	 Ib4dAn4dTaa/P8yRhH/LF+cIUJMeDje9UG/wpjGF4+eNkhqKpWozrJGFD7rgOq8oJWc6e
	 IlgSUs1wpIxZ0A24mbTzkwXx938Ilei+WNjQ8UxrslYsrebCDqibZ7wRrui2HmwqKlSxC
	 a0tm0Id4kVeeAsAOs5Yb3lRClkZYVfi5V2DsRrPQcoUl8grxdNE/3fBuMZcd+R2yDH6gj
	 +8tFrC5dJLs6SLqDr2td7aKftStlFuj5JBmiprDlrL6PONF0j34r1T4g6HWv2g6eeWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vETww9ld;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAEA606A31C;
	Thu, 19 Nov 2026 01:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vETww9ld
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDE41F000C4;
	Thu, 19 Nov 2026 01:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051061;
	bh=hkQVhYnFbc7KoVQAkV7qplEWnSgMsC5YSmLhbdkWGPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vETww9ld+4AAK3SqVCQqbJR33nC+cGL961FUKwUIFwE3jGt1dNj4B9TJyXvKRS+SY
	 j5wA24v37N60SYWcuT2b6Vos0C03F8LOfojZAy1wPpzjQOgW6Q4wnBzF5JrN+23Z5p
	 i3AUraneaJhGLdzaCLTrXl6ucYVohEP1oFB8vEHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0074/2214] soundwire: dmi-quirks: add a global ghost list
Date: Wed, 18 Nov 2026 15:29:10 +0100
Message-ID: <20261118150012.940359061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 39f0cc2a5b333..6739f30d25b20 100644
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
@@ -99,6 +107,7 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 u64 sdw_dmi_override_adr(struct sdw_bus *bus, u64 addr)
 {
 	const struct dmi_system_id *dmi_id;
+	int i;
 
 	/* check if any address remap quirk applies */
 	dmi_id = dmi_first_match(adr_remap_quirk_table);
@@ -110,10 +119,20 @@ u64 sdw_dmi_override_adr(struct sdw_bus *bus, u64 addr)
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



