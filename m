Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215204;
	b=Ikd21YjkNwpqgzG5IGQdKDHb89TLFZGyffkZX5K/pz86yujZRmvZsGeSu3nDRLP1SR4F
	 82922+VzTrkPXRyIuQfil5zL0P9yt48EuDcKIWGrPBJNMDzdQ9igwCmxTras0DGm3qKqY
	 Ek0vFWifJtf2RvW+psLBKgj+BQ2b8Z5Io69LTZMJ//EtEZRSRCQkaaio3SvJcYX0pY3/0
	 Ny4TXDyEy/7uH5HLz9f69sYo3JoGpkDZCbJYLIAxeB9H5NGkvnbhbhky+lo2Qe3U6mLNG
	 V0bcsjL1WIeZJRjb4WSVZeq+x+jXdgCzHqFkFW3pjURIsRjS2ASMvUSbXkUkko++XSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T3IkaAe7NHI3nFZVqP0nRnegq+ywqwN42v+i9gsY3HM=;
	b=rUC1jGN9PCPs4mA+QMi+TPPijcMjuTQBp1ChCqpYmyorSReJpcEjYbkgY01x5frcQjb6
	 +x9wncsYhHMIpNVVHmSpxZngsPSjkgh1ByVrEimgmP9Wjj01Dlqglh1Kz+IRKx5l5oeZg
	 8kAQg/En+0gTOUrCQLN6sBde2j/h4TXbPJE+7C5WK0EyOkTukCS6e7Bf2nsGOQeubCAfr
	 JRvyZKlr+xj6jA0rBMyipsD4QkrNOgpmv2UKDR99dwGsw5OwNas8RlScMpGDesIbW7Rsb
	 VJFQ4BmIZRIzk1ewNWVV9il94FedStdWRp/pVXunZ6GEN2I4ba+W7phyiM2iWzPYYAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qv83nMYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA92606A31A;
	Wed, 28 Oct 2026 19:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qv83nMYg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C31F01825;
	Wed, 28 Oct 2026 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215204;
	bh=T3IkaAe7NHI3nFZVqP0nRnegq+ywqwN42v+i9gsY3HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qv83nMYgI+5SWxXccTuGvq5iUcPxyz3gQwcqlFd4s61FR9ToqncroFeCm6ONg2rAl
	 voibQ2YlLGrA8lYXCj9yGMu1z9cKDcrGpb3IpUG6U+6xOO9wHJuyQuH2szj+JSVlIN
	 GPwfodmG1rVekAQt5XDsDCk27RgD9UEtSoTkNYYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1127/1887] usb: typec: tcpm/tcpci_maxim: validate header NDO against RX_BYTE_CNT
Date: Wed, 28 Oct 2026 17:53:43 +0100
Message-ID: <20261028170525.048324895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit aa2f716327be1818e1cb156da8a2844804aaec2f ]

A broken/malicious port can transmit a CRC-valid frame whose header
advertises up to seven data objects but whose body carries fewer than
that.  Check for this, and rightfully reject the message, instead of
reading from uninitialized stack memory.

Assisted-by: gkh_clanker_t1000
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "André Draszik" <andre.draszik@linaro.org>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Cc: Amit Sunil Dhamne <amitsd@google.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/2026051350-sitter-canopener-9045@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpci_maxim.c b/drivers/usb/typec/tcpm/tcpci_maxim.c
index 83f5f1dcd2436..5333c609ddefe 100644
--- a/drivers/usb/typec/tcpm/tcpci_maxim.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim.c
@@ -191,6 +191,15 @@ static void process_rx(struct max_tcpci_chip *chip, u16 status)
 	rx_buf_ptr = rx_buf + TCPC_RECEIVE_BUFFER_RX_BYTE_BUF_OFFSET;
 	msg.header = cpu_to_le16(*(u16 *)rx_buf_ptr);
 	rx_buf_ptr = rx_buf_ptr + sizeof(msg.header);
+
+	if (count < TCPC_RECEIVE_BUFFER_RX_BYTE_BUF_OFFSET + sizeof(msg.header) +
+		    pd_header_cnt_le(msg.header) * sizeof(msg.payload[0])) {
+		max_tcpci_write16(chip, TCPC_ALERT, TCPC_ALERT_RX_STATUS);
+		dev_err(chip->dev, "Invalid TCPC_RX_BYTE_CNT %d for header cnt %d\n",
+			count, pd_header_cnt_le(msg.header));
+		return;
+	}
+
 	for (payload_index = 0; payload_index < pd_header_cnt_le(msg.header); payload_index++,
 	     rx_buf_ptr += sizeof(msg.payload[0]))
 		msg.payload[payload_index] = cpu_to_le32(*(u32 *)rx_buf_ptr);
-- 
2.53.0



