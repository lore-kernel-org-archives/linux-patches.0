Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829526;
	b=r5GkG7w78xG8mbhI9GAGgzDRH6l7lBbFtXJ87FZTQpCNonnrRYYJwn4lIVoxx675Qvm1
	 83ZI8Su6R5gtvIoiLdbZfCbVAh2x9eEEYl0I8FHTVWK3JvmjRb2Iy1QLqPGQ1begS1aN3
	 UeiFTdSAlWu+kjJ0wz4ljVKyOzjacgfGJnVK8UGrdgMKpSH7j+ZSf96kJePVpW0KQxOpS
	 vsRyIv86aSaw58t0IIcXcGmUw02RB6km/kSmBKHwE8fR8hT1caAee5cQlAPAHtcupNPIx
	 2ZE2VF+JI0OhM440xvmgi3TiZgXhEl/esLSXxz+oWDubfc5cFYET6++ibm9qpwumtqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ntCJYV8Z6HqWkJyhCMtzURIAc/WgmqRX7/hhRKRrfEM=;
	b=y1AvR9SdjYMOOekUh8+IGbesqcJXV35WB0s+7QZy4PP3DClw0oWOwH39H2MIvDRCwl47
	 qaaooEfzyNdcyDLoli2dsJJwYTSZRpcBsKcVIx+f+2R2iiTk5XNX4dEvpJRNtdYnYHYKz
	 onE3hri0ChHqcRHM1FwG7qLRk3HSGSnsHZg8vHqCHzfs4oVtihhwjSwixDpks58T+N6Db
	 XbuZQdynhS58VqzZFmY+mzro5rOs/z/rV24j6FscuGLN4pRLm899Tfp2GOWWyAYEeb7RZ
	 ts6mwPZDVELI6BHtxNaifH1qos/hQEgWiGFh9dENLfQDpOP4Xw1DVK6Ah/FmihJkM5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xb9VxzIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430AD606AB38;
	Wed,  4 Nov 2026 21:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xb9VxzIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FFA1F000C1;
	Wed,  4 Nov 2026 21:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829526;
	bh=ntCJYV8Z6HqWkJyhCMtzURIAc/WgmqRX7/hhRKRrfEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xb9VxzIghWyOWe4oR7cnkK2H/nN0AHkiHFB5oXDGZ17bx5iwWnzkvjE2Wn5LSFFU6
	 3mBZ7vqvjzVjlH2mAlFax8xUXDwnX8/2dpObmmtxTyfu0iueCTSX6DZy97tClUgGol
	 kdU+Vin17sdsqDOFIzp/Qa0blG8xOVtaoKxF8XSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0142/1005] soundwire: dmi-quirks: add a global ghost list
Date: Wed,  4 Nov 2026 15:57:55 -0500
Message-ID: <20261104211047.679948600@linuxfoundation.org>
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



