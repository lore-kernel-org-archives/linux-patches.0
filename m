Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046548;
	b=O+Mly7oX+2WmINoyPJ9cudtc9yD0i1RgWUTgDM8s+5g9g57D5W48PkrX5rdlYmb9pdG+
	 yaYkc34J0ZCNqQ667Wc5Dos29/ET2Nn2C9SXcAR82bmoaylcTyofu5Ux/6uq1wuvHb1zH
	 xtdp8tIlll9f8xupTh5QoXWXBefLyU89gy5TjVGOouGjJO8JBHGOxXWb0FzUWKRlm9dsN
	 RCDLTgE45OZXpkXiWNYSm6icYfFnZcgoLF8u6cPD2H/5eJi/GvZ50OQ+ex+1+zy+Gjx1p
	 q5YSplGukDHoJ+GCrKdNWQN7GKlHlRKVro83xsjhN9srTeZezq4yo3EPufnprZYT3Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8EfgyuwWn2OvfxOllFrdP99isyBwoopcPOHYld/SUzM=;
	b=gTtG5v30/lrUWnwShd9+7xkrP86vCGUXfveufLQKWw8n28k/FIdB9rSXjukar+PnxT7R
	 x9nI+gOfrQi5u3hokfuGldhIx+TrkjZFDtCVVClETB9llb2LbCc0WDxo4MpBaiDR4MdNW
	 5e+3SYQC7loVRSe6rsq0tx/3H+YcD7Tb3S80tPcSITxE0XZdfjRFPmfhSIUHWFUJ5n3wR
	 UPkuebAGp1xsP+LVoAoZGfr07hE6t5ohnXc62OFFYQ7DARveK2TKTx3vhSo+QBJ91nNU+
	 LFNmqEGGhKmSfy8H/MGFYZDkrWvHBUJ4PIqUta7IN91i77qSpgErPCdQzDs6J4UTXEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbZVpZRN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AA4606A330;
	Thu, 19 Nov 2026 00:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbZVpZRN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048551F000C4;
	Thu, 19 Nov 2026 00:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046547;
	bh=8EfgyuwWn2OvfxOllFrdP99isyBwoopcPOHYld/SUzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbZVpZRNendwQT7dwQEQvBzGk0vqxWE80NO5DrINTpOyRqclE4o8kkjuyx7Hxo1Uf
	 qV2vp+Qt8yIn6ainX2QjOVPsbHAaKH62+DPjvaJzWkxKavJbPIY0v6bQoGvAPedg/C
	 6tKBpO8xUBdDC3ZYegRzBhJTQXyLBzNulMOBrvKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Marco Ziliani <rylos78@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1319/2857] ata: libata-pmp: disable the SEMB port on Marvell 88SM9705
Date: Wed, 18 Nov 2026 15:39:13 +0100
Message-ID: <20261118150248.941399298@linuxfoundation.org>
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

From: Marco Ziliani <rylos78@gmail.com>

[ Upstream commit 6b67cdb463b006e57f15e3fe4ea03b00f0ac9ee5 ]

The Marvell 88SM9705 is a 1-to-5 SATA port multiplier with one
additional SEMB (SATA Enclosure Management Bridge) port [1].  Ports
0-4 are device ports and port 5 is the SEMB.  The number of fan-out
ports in GSCR[2] is 6 when the SEMB is enabled and 5 when it is not,
so on boards without the SEMB there is no link 5 and this quirk does
nothing.  That includes the common 8-port PCIe cards that pair an
88SE9215 with an 88SM9705, which report 5 ports.

The SEMB port never answers SRST.  libata probes it like a device
port, and every EH round on the PMP ends in a retry loop that lasts
about a minute before EH gives up, then starts over:

  ata19.15: Port Multiplier 1.2, 0x1b4b:0x9705 r160, 6 ports, feat 0x1/0x1f
  ata19.05: hard resetting link
  ata19.05: failed to resume link (SControl 0)
  ata19.05: softreset failed (1st FIS failed)
  ata19.05: hard resetting link
  ...
  ata20.05: reset failed, giving up

Disk discovery waits for this, including disks on other controllers.

libata.force only partly works around it.  The "disable" horkage
only takes effect after IDENTIFY, which the SEMB link never reaches.
"norst" on port 5 stops the retry loop, but the disks still come up
about a minute later than with this change (see below).

Treat port 5 the same way as port 4 of the Marvell 88SM4140 and mark
the link ATA_LFLAG_DISABLED.

Tested on a Synology DX1222 expansion unit (four 88SM9705 r160 behind
a Marvell 88SE9235, passed through to a KVM guest, 6 disks), 7.4-rc1
with and without this change, one boot each:

                                    softreset  reset failed,  last disk
                                    failed     giving up      attached
  7.4-rc1, no libata.force          60         12             197 s
  7.4-rc1, libata.force=N.05:norst   0          0              70 s
  7.4-rc1 + this patch, no force     0          0              11 s

The problem was first found on a Synology DX1215 with the same chain,
where this change brought the disks up after about 20 s instead of
about 200 s, including a disk on a separate AHCI controller.

Each PMP still logs one "failed to resume link (SControl 0)" for port 5
at probe time.

Link: https://www.marvell.com/content/dam/marvell/en/public-collateral/storage/marvell-storage-88sm9705-functional-specifications-2015-06.pdf [1]
Cc: stable@vger.kernel.org
Tested-by: Kyrylo Biryuk <illofspeed@gmail.com>
Signed-off-by: Marco Ziliani <rylos78@gmail.com>
Link: https://lore.kernel.org/r/20261107-pmp-88sm9705-v2-1-18eed983d3db@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-pmp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 97f9fe5f5fb02..4306b0d947033 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -471,6 +471,20 @@ static void sata_pmp_quirks(struct ata_port *ap)
 			if (link->pmp == 4)
 				link->flags |= ATA_LFLAG_DISABLED;
 		}
+	} else if (vendor == 0x1b4b && devid == 0x9705) {
+		/*
+		 * Marvell 88SM9705 quirks
+		 *
+		 * 1-to-5 PMP with an extra SEMB port.  It reports 6 ports and
+		 * port 5 is the SEMB, which never answers SRST: EH spends about
+		 * a minute per round retrying it, and disk discovery waits for
+		 * that.  Seen behind a Marvell 88SE9235 in the Synology DX1215
+		 * and DX1222.
+		 */
+		ata_for_each_link(link, ap, EDGE) {
+			if (link->pmp == 5)
+				link->flags |= ATA_LFLAG_DISABLED;
+		}
 	}
 }
 
-- 
2.53.0



