Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591270;
	b=UX1JMC+S2OHNB1cDJ5ptv4iRtcegMklx0fEhG14KT9oK6ldJI8DQsp7WPc93Jtnzcp7w
	 VKfrRF0AasKBkLslmH9BNDreftrwwvpDh/tXusPWLJCNc5hLUcNtkvNR/8pwEfXzm6I80
	 6ihKUnLkbeW+qNGjCUulp4Rwu9K6zxflU0N+8WDY6vkGWe4Pc7XAL+Bg+AOeIrFBk2qnT
	 pibCbbgbmj2kFxG0YN9VrEDm9oXT5jtoDAcRU9mowMihWwiFgN7wdr+NNKGWo+BqmQMUI
	 r3CkRyLlcLDX8WLslsRJVdap2sZZkKnNYDffGsV1nZGcbHoLMzS5YbtijOG9lB/FFxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ucdWFlrdGCK9Advhx6y/o1w5Bq+yIwCHbcV0/lLLG5E=;
	b=rwL4lcjbw/fVLNhKFjoTCHf6Di2ft3TZfUrFoNP2RKghS8QbMUm+1e9p8vVuhCXyuDcA
	 IL9zmvd4eJw1gKnPm4bJmGq7zEQv8VPa48HazOH+6S9Sxm3k2coKlz1KFc2BIqrtCNtO6
	 wruxPIoi0G3dv6Vvp8Iiq2ui9ZxSQuVqH/TKDQloiHIxcF/u4hFB+Umg8L4j+1Jor5vUW
	 70ewQ5y3PcHLpMdfJK7eP+yJ7LgYloUiFdAfR+RdUXs0pahO2gecHLjZq+s6v7jqKzvNv
	 HaXZL6BTL6vA40ylPkwkYoAr9A/wOjJQ3H4du2hM1VKfCjaoQgaGr+NZ/bPRVJH45nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rl2b0r3q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BED6076FAE;
	Fri, 13 Nov 2026 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rl2b0r3q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004291F000C4;
	Fri, 13 Nov 2026 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591270;
	bh=ucdWFlrdGCK9Advhx6y/o1w5Bq+yIwCHbcV0/lLLG5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rl2b0r3q4k0bBo4Lat92XaHTjiMn8M67rqSfxwA/26xA1e70K3hlOGM0M0jvYze+n
	 8gS4yY2wZk1ujm1pay8evfRyQOBVZXZgrTF8wYbJVChOLmxuN7CvaygWFsL2njjXW4
	 RFVMHRLEGAuRSYRO5BkvL14UG1v7OmWWf2Cp17Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Marco Ziliani <rylos78@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 393/670] ata: libata-pmp: disable the SEMB port on Marvell 88SM9705
Date: Fri, 13 Nov 2026 10:49:17 -0500
Message-ID: <20261113153825.072452069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 20dd3a5a818a5..1f1e887442654 100644
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



