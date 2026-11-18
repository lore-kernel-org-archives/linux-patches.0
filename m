Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053476;
	b=ZzyQ+u99q8RpJE49xXh3MKyQq6VZ0JgruFg5DfH++KlalT/iJENJVTPUqcZjMkHABZDz
	 qalvY/RwgKky0K3es9S+tAJYWLAsTKjcTUgp2ROw25KaQllnND4sbNITAURU2a6amcEpA
	 S/7XYCebKiogINBxeteuLeI68QPMDb0n7/BhShSA7xdDynLcvJNXVYFKcq1GFLsJFnIQ7
	 b4SCMt+pWxXYVZzP8kD7QGAGRB+EhqwV1H17DPjRMmrskh23ZECbQibOFdjd4HE2x9R3y
	 E3wP0aLDq+ULln+Phdx/EGn/Bxqysqq7BI0u2B6Ike3uWw9dFp+uI/+tZeKoy3kn8bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5bznCeAMAZuV5t9f8h8l+HXv7Ox+rUThhhMCe2/2HHU=;
	b=n9InxESElKcPK6rJQK9rMUrL/IOoK+ZtOwKd00DBD3xTlOJJ3UERsXIBjTaDbz+eCTq6
	 s2KNsL/6smU7eUlmS4E9anozLBafCWvk4q6AzE0NJMrkxJgFCvPyb+REw5Uqn9s8jKfxi
	 WtqTqm32kOntx9JQb2UOYR9k/hxwkGd8M9yfyizX5ntK0Y5tQpB3127copiFaNIyYcjB+
	 GRfemVsWuqJDyS9MpcznIrEOFAyT1EuhUyppeGiGwy8F8eQnSVLrKPo7ZX9okRO+yjXQI
	 fVCAf4j1//F8sxAnj9PBWZip3dwaNvPWaf0rjUrhYQOf1A1T0rUYNBPnw2lN/TkFhog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1h8FjI8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6278D606A32A;
	Thu, 19 Nov 2026 01:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1h8FjI8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B889C1F000C4;
	Thu, 19 Nov 2026 01:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053476;
	bh=5bznCeAMAZuV5t9f8h8l+HXv7Ox+rUThhhMCe2/2HHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1h8FjI8FZK6l/YzgU8xW6KUmShKc347okaoFPQH9jESnx1ioK9FQ6F0GNr63CCcCY
	 Kyj3hdwvgpsofD6TjeNy3GhDt14MDt1q2LnPGC1IvAxZ2bipbhCswrcuM/szT5CCLT
	 iHFaQ5va3yNYXjlZt4KcsxO1TW3yTP1Hkomuw1SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Marco Ziliani <rylos78@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0931/2214] ata: libata-pmp: disable the SEMB port on Marvell 88SM9705
Date: Wed, 18 Nov 2026 15:43:27 +0100
Message-ID: <20261118150049.606637253@linuxfoundation.org>
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
index 5347ed88f6386..63f0370a3ac87 100644
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



