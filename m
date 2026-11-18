Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021623;
	b=g9NOEcEEXu7Pyuop3urGY8bAS/ZVyqf9M3vDb8O//sLY2bkm7N+gvykJTj98GD7Ae7By
	 4dU3b6+lZlZogz3x08SYptJql598eUIDgREtVz65REF/EAd7dMi0wjOvGlgVU9OTMJK6O
	 z0//vE3dX7lYyguMYcmn09GB21HnisR7uBW00UhWmoHa1sREfENeL94RPduka+yD8ne2C
	 tY7W+u6Qyyf0oVeFIQ/vlpVpCzzHjcW3AYwF2ksWs6zrW/WANIPtJDf6pjC1sn86T7jhA
	 n0wicL+PxI05HWHqHWGebeDvziq9Uk/YfZ5bm+bxYe/sgeNWm2LfI4kODsuT0qHPTZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Io9K1Fp0Hoc5YVjuqNA4cq3w9Sx2JBAb1jZXcPPoUrI=;
	b=c1LARyr59+ujneBtkd7D5XxE7D+0YfwKwc3aDho3irTKVMxakdRztwsL451CbpJ/fRvN
	 FZ71caEFNIADs6olcHftquDCJkMKuMcE7P/53/2hJUHdZD8NSIHZtOneQRQpzYwJDqb2l
	 6KcrvaX+tz0JbRbscfyeKsK7zEvnkdKB4BPGBfSIjNn0EhaUNumnq7nFjr9SKbDnTwA8v
	 MK85TnWgUYl12Sst+0tYMu49qzST19hEJ4v8j0XkNYbwLq2gUC4BndQdGTyDQKQ+ZIUpH
	 zVgW8SE5PBjmz8YnYJjVLNgj9ZUkBRInfcMIrCAy+2UfHVdODWWkTxBIiP666Drq6pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uo39NAGN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7765D606A31C;
	Wed, 18 Nov 2026 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uo39NAGN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F221F000C4;
	Wed, 18 Nov 2026 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021623;
	bh=Io9K1Fp0Hoc5YVjuqNA4cq3w9Sx2JBAb1jZXcPPoUrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uo39NAGN7/t70hBHIEcSTRhkDtALfLI8H4GehhJ2Fhc2WfxRR2T/Opb2n2who43e5
	 e7dv/Qpw3zO0Fq26GohauwFpguPYU+t36sVctEN/ueahje39wnFFUTxAHhV2jN57d1
	 hW02wpFXBJjCSTWINvQEPWc7yrwdM8/r4Zh8xYxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2374/2651] net: pse-pd: si3474: validate the channels of a PI
Date: Wed, 18 Nov 2026 16:00:14 +0100
Message-ID: <20261118150410.963097218@linuxfoundation.org>
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

From: Piotr Kubik <piotr@kubik.pl>

[ Upstream commit 110eb808324fd9713b04d874c97283d965e43d2a ]

si3474_get_of_channels() accepted channel 8, one past the last channel.
The driver then accessed channel 4 instead: quad 1, channel index 0.

It also accepted a 4-pair PI whose two channels are not a channel pair
of one quad. The chip forms a 4-pair port only from channels 0+1 or 2+3
of a quad (2P/4P mode bit in POWER_ALLOCATION, PORT_REMAP default), and
the driver sends every register access of a PI to the quad of its first
channel, so such a PI enabled and measured the wrong channels.

Reject both at probe.

Discovered by an AI code review agent; no shipped device tree triggers
it. Validated and tested on an SDG-9000 board (MediaTek MT7988A, two
Si3474) with Linux 6.18 and a modified device tree: one chip with a
channel at reg 8, the other with a 4-pair PI on channels 1 and 2. The
driver now rejects both at probe, and the unmodified device tree still
probes all eight PIs. No kernel selftest covers PSE hardware.

Fixes: a2317231df4b ("net: pse-pd: Add Si3474 PSE controller driver")
Signed-off-by: Piotr Kubik <piotr@kubik.pl>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20261019162453.1244120-3-piotr@kubik.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/si3474.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pse-pd/si3474.c b/drivers/net/pse-pd/si3474.c
index e4eff88ae6723..97a3b998729d9 100644
--- a/drivers/net/pse-pd/si3474.c
+++ b/drivers/net/pse-pd/si3474.c
@@ -250,9 +250,9 @@ static int si3474_get_of_channels(struct si3474_priv *priv)
 					"Failed to read channel reg property\n");
 				return ret;
 			}
-			if (chan_id > SI3474_MAX_CHANS) {
+			if (chan_id >= SI3474_MAX_CHANS) {
 				dev_err(&priv->client[0]->dev,
-					"Incorrect channel number: %d\n", chan_id);
+					"Incorrect channel number: %u\n", chan_id);
 				return -EINVAL;
 			}
 
@@ -267,6 +267,16 @@ static int si3474_get_of_channels(struct si3474_priv *priv)
 				pi->np);
 			return -EINVAL;
 		}
+
+		/* The 2P/4P mode bit pairs channels 0+1 and 2+3 of a quad */
+		if (pairset_found &&
+		    (priv->pi[pi_no].chan[0] ^ 1) != priv->pi[pi_no].chan[1]) {
+			dev_err(&priv->client[0]->dev,
+				"PI %pOF: channels %u and %u are not a channel pair\n",
+				pi->np, priv->pi[pi_no].chan[0],
+				priv->pi[pi_no].chan[1]);
+			return -EINVAL;
+		}
 	}
 
 	return 0;
-- 
2.53.0



