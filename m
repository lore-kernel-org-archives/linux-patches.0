Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590576;
	b=IrUGP5qVYqMvZ7L+TRtF3WcAxq/AJ06hoJXiOCLd/EcpJk1rDWQXG9Eb3CtfQs6h2FCt
	 D/9fZq6+ml8obaskHV3XHc5rX0ixSKIFcsimLR+DwevnRD7LTk8eYw3Vm7fPO/apNlk81
	 YI4MXvSo7l5S4b3QZJH+C0IZHGozMUFqEKUOGb/Ri+T3s14mo6tJv0LnYUratgqcC7HhB
	 l/CsI8ENlpxvcJiGbzWQvQywWxLLa6FIR/LTixLyNAMsnScI6DyeUNhHXhBpjp4hdnMWZ
	 oCxlf+Jvjlw87stivsvQApfdVcgg0w/XnmHk9vXRIxGTadGXFuyk8W8x0ESPi7/TyDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MR7kG+HZoUAvRoAyWnyCP4QAfm0k+U+rny+8YbFhNnQ=;
	b=RO8gqVrB2futK5QLPayLNVt/WXEY+zbjCq4Al1kuOUteeBagYJwxyARMSozMh5P7Effa
	 mUV08gt3zzb4eCEOCKjsZpHFL9IptjSAOEiQBnbxrcCcaOymHQ4lQ/u3iMo2TZpgAHjPy
	 sm5WFqU0eBxzj15oxMzYen98hwlVdB+3QnGjx4DDPXYPFq2wK/OusGRuQOJLGFg+jg/4n
	 UiydkLpmts4nRiSIJDGTR424sHr/nMJ37T4CKl7Ns5n7LBAmcXIywn/hURxyTdraS/Asr
	 TWbE4uu1JHR+b0V4oFTxfQqjQfSjZRaqfK2+ZiT4zvBE9mloVRQzFtTE8KucF6NhXFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEF9sX3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C414F6073FC0;
	Fri, 13 Nov 2026 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEF9sX3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCD21F000C4;
	Fri, 13 Nov 2026 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590576;
	bh=MR7kG+HZoUAvRoAyWnyCP4QAfm0k+U+rny+8YbFhNnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEF9sX3kAEIXvcQkdWrx1Wk1LthK2t3laorAD0tUAtMoDd0rKh056EDrrbUrgaf5N
	 zZXMeAAz2di19QtrgsQ8HoX7BL7XOC5prnHEaySv8owq9p1gd8Vc4Kp6VnKOjmGmob
	 /i3ImXHbdSEYfWSK3B5LFSyYxtogX8mb/eqaD1os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Marco Ziliani <rylos78@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 460/686] ata: libata-pmp: disable the SEMB port on Marvell 88SM9705
Date: Fri, 13 Nov 2026 10:49:53 -0500
Message-ID: <20261113153836.451313542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 299b1823e0d09..99c67dbfb7536 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -482,6 +482,20 @@ static void sata_pmp_quirks(struct ata_port *ap)
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



