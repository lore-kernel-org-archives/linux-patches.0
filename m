Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027809;
	b=gN12uIWzPESCd2aUIDwJmjZlJkVG3WJhKjK3b4ZocOsaMsaQzsod0uawtRHz0/pbml4Z
	 RrjuqjUaxqnylfh+QQvdVIhxz9eZRicM0HG84JQ8Wyeh9UmtAUJeOX4dUYhcsV2j6w3hG
	 Q4np/RhqlRvBXdbcTVm6x/qlNIiJAevvUTYrEKKbThwP7JOESkJBLW4NYgIrPx/XkM/D7
	 LwJ6WftTRft+Rb0TtwWiOcqK4bvb4/SAMj3Ha6GxSK2iiAnt/nBFULwRk0W7JTurRLE1f
	 6eoyFOBUmEoUtJguE2BzTHju0FYXS/NJB3iJvhseLz1sS91mF1QSY0ywzir/Sp3IwoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0ibKU+kNgsYj4bEwvnkiLQGl2s/bgsUWyNnw6LgpY0=;
	b=YeuPDYs3LQ3c7I7VjZ3KAVJwcx+XeZKztff5qYmqfxyAEOuVcjzZwWxGOvl5Aa06lbXH
	 cGWaqzIrPUbJkR4ywa6r4eAh8qgNfWBKoJdQisdpH4tjxqm6HQRkMxF2wEowPDN3OHH/t
	 6eid58rnl6ZDVrdq29F105xajxdpuXTJ4jaRyKss9QZY/S7bpZq3NQPpGWSSG9Yl1sWlg
	 6I6P4RKb4mowzt+7oGhJiq31emU3roqLv/pSd7Ld4g3dHEsRXHoKPt6uiY6rr8sxtqOwr
	 O8rq3VKkFdWlPjafejhaVoa1sKJ4ir8WFjjan5l/LYR0JviO2xxR8tczUaJmIMjkSHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxFsd8YR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A9A606A325;
	Wed, 18 Nov 2026 18:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxFsd8YR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96C51F000C4;
	Wed, 18 Nov 2026 18:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027809;
	bh=+0ibKU+kNgsYj4bEwvnkiLQGl2s/bgsUWyNnw6LgpY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxFsd8YRJgcXBNadWAhnxPRnZ/vTAskqmjP0MfKBigTadpHBLq629qTVocTq833be
	 6MbZwl1SjCd3ih3TF8X5KUlOiKovIeU6uYox9lUFIJ0gncgdgBQ659VMaVhOJ6xDas
	 QKj8Xro4+p1nUol9xoJAz4bzse3z/SwsE+8hiBws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1922/2151] net: pse-pd: si3474: validate the channels of a PI
Date: Wed, 18 Nov 2026 16:00:57 +0100
Message-ID: <20261118150231.793858869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index a88ec2564364b..e4b7533a8853f 100644
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



