Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618722;
	b=qdqPbwtWJP0IlhYcduMKmlTRbJpnZ7cQt+rfdBHCyIfxf/42bkisQFOQs/0x8Fmv2QQ1
	 kh8ARfxoCryY78COx/2jU3iNklQEInvb6f0j9A97Tp4MVt5PHj2L3nbj75I8OMimJKZ/7
	 qhU+8ihAP8epGcIEToMefzREPMq1eVvHAnJMA0HFhlZfUx1hn83gKCn+TZfTwHUndK7b+
	 praRlicUoAJD99d1CF33/7TEilWQyOENDYaV2WpngPBhy0FsOU72P0Ro7oKNPBT6r7FFQ
	 86aXtenj2WBTlznh9z6KkyRTHlKvUFCXjynQMq+XYq5Qr1MWMuuVrNy7as9xsIZsMtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zFw1rRHw9J+Q/QLUQ8851lPdmpJ9kH1DAJtcz4hKiwo=;
	b=GT9zdV7rvEv1OX7YdpVy+Jcw0pfCIVCqMDCLJYlbvvnxSa49ab+27C3AN8GYUBCTBCy1
	 aOI7iJtBl2XkW9APLHiSly4orVSGkCwTT81fyGnLE14Wq0UtGnZTouTizhfkRIZOtSOtR
	 1FVQWaty477gUIpomxke2wMJ7Al222j8oVunP3BT3NTa4b9v2IpYNuCZeIRvaWxmW48lm
	 qP9/MTPzyZ9F9JF6A75W09gfRUDbhSqoG9g5C4JV7DYik8kvRK5JGfhANW0COSHjCpKmq
	 bNpk0TnN0bUb/cSsM1qthil5urDGEF5y/DqNKd+JVkZHo8grtexAm1Sj8qNjcj/Qf9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uReKFU32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8362C606A31E;
	Wed, 25 Nov 2026 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uReKFU32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EE51F000EB;
	Wed, 25 Nov 2026 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618721;
	bh=zFw1rRHw9J+Q/QLUQ8851lPdmpJ9kH1DAJtcz4hKiwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uReKFU32KhWllfJVtHq7vndRNmtumGmHAgcdh94XdJq6FUTIKPCLWjwWP7o1/B6VK
	 5myaT407hEqSqSRn8Xv1mUYkdPpjrU8+a8pPSTOpbk3mA84DxRu/4mE/EzgejqIH8k
	 0OWFYz1W86csn2gEFi+SAg72Kvj8Ox0FffG0WV34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0370/1005] ata: libata-scsi: do not accept subpage code FFh in MODE SELECT
Date: Wed, 25 Nov 2026 15:28:28 +0100
Message-ID: <20261125143830.404281959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit b29c40dc150b0b4218c4d6844770892eb6b2f6b5 ]

When the SUBPAGE CODE of the mode page in a MODE SELECT parameter list
is FFh, ata_scsi_mode_select_xlat() rejects it for the control mode
page, but accepts it for all other mode pages, i.e. for the caching
mode page, the only other mode page that it supports.

However, FFh is not the subpage code of an actual mode page: SPC-7
(7.5.2) only defines it as the MODE SENSE request code for all
subpages. SUBPAGE CODE FFh only means "all subpages" in requests, i.e.
in the MODE SENSE CDB for mode pages and in the LOG SELECT CDB for log
pages (see SPC-5, 6.8), while the SUBPAGE CODE of a mode page in a MODE
SELECT parameter list identifies a specific mode page. Also, SAT-2 and
later versions of SAT define the Caching mode page with the SPF bit set
to zero (see SAT-6, 10.4.9), i.e. without a SUBPAGE CODE field.

Remove the ALL_SUB_MPAGES case, so that SUBPAGE CODE FFh is rejected
like any other unsupported subpage.

Fixes: 1b26d29ccd59 ("[libata] scsi: implement MODE SELECT command")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-12-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3b65a086b535b..26bf83188625b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4602,19 +4602,11 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	}
 
 	/*
-	 * Supported subpages: all subpages and ATA feature sub-page f2h of
-	 * the control page.
+	 * The only supported subpage is the ATA feature sub-page f2h of the
+	 * control page.
 	 */
 	if (spg) {
 		switch (spg) {
-		case ALL_SUB_MPAGES:
-			/* All subpages is not supported for the control page */
-			if (pg == CONTROL_MPAGE) {
-				fp = (p[0] & 0x40) ? 1 : 0;
-				fp += hdr_len + bd_len;
-				goto invalid_param;
-			}
-			break;
 		case ATA_FEATURE_SUB_MPAGE:
 			if (qc->dev->flags & ATA_DFLAG_CDL &&
 			    pg == CONTROL_MPAGE)
-- 
2.53.0



