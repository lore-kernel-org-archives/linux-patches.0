Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621780;
	b=MgE6lJyI8K0yM06WajsCQ2z9hTUfAp6wGF1awkObcnrBFl3NiodTsrd1CKR7UfhNQDJl
	 WJ8fvlak4u4iDSnCELz15qEyDTPdGydeXgjqHkEQ8ExlYX5yHBnJsQtCUyvuL8mbzs7BB
	 sytRg0YkZNB64zGwelXGcgv0RSuEQO9cl+zX/1zgonHlC4yL9KT4QoMEfcD33euQ4YO/J
	 IvtT2TTg4WxgvFS+pfd+DOQuNEhWVgbe81UUWqRBzGjqKGXboYpOwMqg6X7xcqTDhsths
	 /+5LRPxMaUM3sBjkmY+yEgVo7oByQqVBMiJuHsKW0QzgSzynvmFr7G5WwfkCXTguW8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6A989U8yegYQXuFCJN1DVA/S5VwSSqXtsSWpsu2Wwg=;
	b=fvNEY9vkUKM2KCEj/UJLvyQjSFqJAGYSBi2+yNCWRCjoUVarxRuWkOG0q8esCORXpVbx
	 9HuEE1fq4aDbZeQ3V/Sv8CJVGvYn2wBSkeuG/dEd/tv8cHMohYxP+Pz2P146bC2ft9dxk
	 Y2Omr3e55yg1ex75+2ynypY++hZhpBYq4h8Prqrtqa5S30U/lfXc0qcI65XB7vxv0TZXM
	 aJrDO5hRw1DayD24bmBZWKdz3b36J4vZoU8J2wN8xs943Jwu7qpWFnGydKiBULrACeHEC
	 FF/6NqF1pQuMRH51KAr0lI2xEv38KsoDEqyZKzXTSPm9M7LCmn4hDMNto5mrA4z0QIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AssRFp+l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9394F606A326;
	Wed, 25 Nov 2026 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AssRFp+l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6921F000E0;
	Wed, 25 Nov 2026 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621780;
	bh=v6A989U8yegYQXuFCJN1DVA/S5VwSSqXtsSWpsu2Wwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AssRFp+lf9sOY/kQ7+QsArYTRYt68QKAq55Ox6W8Tm6j+sixTreHoWOX9DnbtYi6E
	 vSTtjvgU1ev2t8X3IKoyq19hgnEBWLy7wYGQ0IJhQChYGcylov+GrCfTuPnVly9Uch
	 Qq9l6BGiaRvqLieeXUTWeSTvxrwk5N0AyCV6DPGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 333/990] ata: libata-scsi: do not accept subpage code FFh in MODE SELECT
Date: Wed, 25 Nov 2026 15:28:20 +0100
Message-ID: <20261125143829.889704656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index ee0346de04744..b761cfd435f84 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4332,19 +4332,11 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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



