Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590644;
	b=RHj5v2pJ4vDVppAU5IHTVeg7Htv/PMihU+bxNNEVIvlQ5Td7HXT3N/sa0i/+cDciF1sg
	 DWMBoYogE2v5PBgPR7jLt2z7Y08YgcCp+EVgE5g3TLAHUBs/f9FIWvrU0P16nUteOpBn3
	 eY1CPERmrKc0wtaZ4wFrmcW0suhbXJ2YOaOrt1rkI9S8Vsm6xC2N5+w+6qSYFOW6sHcGP
	 bYJ3qvu8IPQ0ZFVO156rqvkioTaLdj62TPm3mBFPaUnOoBp+mVL4v8FupLpzan8nJ23CW
	 L2F88Ci8xGG4BEiyF0sjpGsOXCMRjEEFrBI626kQeKyWuK/tZUMFj3M3Y8jzXruyCaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ugZrU7VZ56z/9MgWdV0Rb02pkGMSvS/nJDlc/PC0DZ0=;
	b=i2xtL2r42mt7tnq+T8yy9AUt06iVuUxhIrzCQIF50vogpCZr3zpCpcBtMnUeCEB0vKOG
	 TeGVXRJG9c1QFS73QApOPGVmeQzQmjfXGMPoo/ma70PIBez2RmvocaP+X/hguYsttCR6F
	 /fsuXJeZA6kMDTX3MjoK5O2BmYCG75ldZ9ZpTzPqMQ0ghwLWuLLlIJ/TCP1Jo2g1HvE9Z
	 Q3zWJaLiUBqpUP/t+YA+VTXt/ABs2pe9BYk2+0oBVimo/101CiG4SxcF0vtiODJoV4KcY
	 8X4W0MTyqWspQX6OB5toF9GwNZ4nhurdr7FP4O+qChcxSotnrHAjjNGV1giIuuC7YUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jltagqx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8C46077D54;
	Fri, 13 Nov 2026 17:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jltagqx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9C01F000C4;
	Fri, 13 Nov 2026 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590644;
	bh=ugZrU7VZ56z/9MgWdV0Rb02pkGMSvS/nJDlc/PC0DZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jltagqx4Y0o9/q6oTmCF4KcjzoEFBSlLRyPH+Tiec93yE15GELcJV837RFrLewD0G
	 mdyme0aVcNBAUnf1Z8n6Arq87f7qhH7C2I27eI3ZCzJ/CMtQRa559wGT74TUGa8yhv
	 sHY8CHXKGKj/OC1dSzkecJ0lzoJ/CpVb+C8jCJcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 566/686] ata: libata: Add an argument to ata_eh_reset()
Date: Fri, 13 Nov 2026 10:51:39 -0500
Message-ID: <20261113153840.847741548@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4b3c2ca268b0a66093793466e02d8566d642f19c ]

Pass the ATA port pointer as first argument to ata_eh_reset(). No
functionality has been changed. This patch prepares for enabling lock
context analysis. Without this patch, lockdep_assert_held() statements
would have to be added before each ata_eh_reset() call because the
compiler doesn't know that ap->link.p == ap. See also ata_link_init().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 96fdeb7e3fd8 ("ata: sata_inic162x: remove dangerous broken driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c  | 6 +++---
 drivers/ata/libata-pmp.c | 2 +-
 drivers/ata/libata.h     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f21efb0f6419f..9d35b4f8d3929 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2812,10 +2812,9 @@ static bool ata_eh_followup_srst_needed(struct ata_link *link, int rc)
 	return false;
 }
 
-int ata_eh_reset(struct ata_link *link, int classify,
+int ata_eh_reset(struct ata_port *ap, struct ata_link *link, int classify,
 		 struct ata_reset_operations *reset_ops)
 {
-	struct ata_port *ap = link->ap;
 	struct ata_link *slave = ap->slave_link;
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_eh_context *sehc = slave ? &slave->eh_context : NULL;
@@ -3863,7 +3862,8 @@ int ata_eh_recover(struct ata_port *ap, struct ata_reset_operations *reset_ops,
 		if (!(ehc->i.action & ATA_EH_RESET))
 			continue;
 
-		rc = ata_eh_reset(link, ata_link_nr_vacant(link), reset_ops);
+		rc = ata_eh_reset(ap, link, ata_link_nr_vacant(link),
+				  reset_ops);
 		if (rc) {
 			ata_link_err(link, "reset failed, giving up\n");
 			goto out;
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 99c67dbfb7536..c3b3af28d17c9 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -796,7 +796,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 		struct ata_link *tlink;
 
 		/* reset */
-		rc = ata_eh_reset(link, 0, reset_ops);
+		rc = ata_eh_reset(ap, link, 0, reset_ops);
 		if (rc) {
 			ata_link_err(link, "failed to reset PMP, giving up\n");
 			goto fail;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 9f96ca2acfd90..506a649b73d58 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -192,8 +192,8 @@ extern void ata_eh_done(struct ata_link *link, struct ata_device *dev,
 extern void ata_eh_autopsy(struct ata_port *ap);
 const char *ata_get_cmd_name(u8 command);
 extern void ata_eh_report(struct ata_port *ap);
-extern int ata_eh_reset(struct ata_link *link, int classify,
-			struct ata_reset_operations *reset_ops);
+extern int ata_eh_reset(struct ata_port *ap, struct ata_link *link,
+			int classify, struct ata_reset_operations *reset_ops);
 extern int ata_eh_recover(struct ata_port *ap,
 			  struct ata_reset_operations *reset_ops,
 			  struct ata_link **r_failed_disk);
-- 
2.53.0



