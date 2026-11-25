Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618728;
	b=MS6KFaWI89yqFEa48yi2jC5h72rfs/KOb/xyrpr/ReAKfMBvY1VlR5bNRTqrR+IZPv8L
	 jDCxceMyqga2SucGFJTIsDPxfDWW2ynxCqjza5IuUPs990LM67ZQAQYHuq/OY2KhA3mpQ
	 KzN8l6uYwnl2vyi3NXfRbRjpOtlHu4PpPat1VdCxQeN9haUrwakqf1uUoepxiDexoyPLf
	 6ZbMbAGbRGFLs025Sz8ZxZPfXFEaY+vj2CwYI7cS/YOryRy2sWjE7q9N9wtWiYP9tUdbj
	 i7jbmtcxMSqJtkN4MkT6Ys5lieTXrPbzk0HT5uzciP1Tm+gW0Cka9oyqSMLBX5rKdzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yamTf33xLT51ZPhJegxVAJho7vtTR5I2vgAa6iXUO4U=;
	b=a3PNQlRoNvxL56t2DhYjk5+aqnKHOgE7cyVpYHU/A6pX8Y9ahZL8LMGTeE3CZUS7GCc4
	 1hxHvMrLmW3hAZBldr4uxEABJifdrin/UwiliC6ecDzty+Dmt61ISWoTqCQ01OuucA9hB
	 o58xZMLNgHsz2C35WaGPDYq86/PeLUJn6Q50g2kwvSLhbgWzhYZjusWi0R0atqi9k/MVU
	 3nGAfzYl1Rf7mkpMQy8co4bjVBUIldINhUNhUX7Ohn70TwAULuegGy9e6bLHEHToIol1c
	 rEKevH1oVYZqdEctEkCvegOapNdr2gE1e0ubNofRyKliYnlX6l0vsU8PBgPie6IBQ4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmgdbwdc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9FF606A321;
	Wed, 25 Nov 2026 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmgdbwdc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9FE1F000C4;
	Wed, 25 Nov 2026 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618728;
	bh=yamTf33xLT51ZPhJegxVAJho7vtTR5I2vgAa6iXUO4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmgdbwdcxflSO3z6FIxS9NUFeOyX+RlJXqmJc3pX1NJfrBa1c2/qSa1ndr3UhjbW2
	 I+6kR2qUfW6/w84l1BUuMsUz7qJOy1xfOh9Z2MI+G+xnZKa4d0PYVM4czEtz467lCu
	 +DNgmaD0BqMMcQg0rveu1ur0bl8hKJVyrQOL3EaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0372/1005] ata: libata-scsi: fix MODE SELECT field pointer for unsupported subpages
Date: Wed, 25 Nov 2026 15:28:30 +0100
Message-ID: <20261125143830.450420105@linuxfoundation.org>
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

[ Upstream commit 2a4c61cf94d48ec8560473d4fd5383583ce8809c ]

When the mode page of a MODE SELECT parameter list has an unsupported
SUBPAGE CODE, ata_scsi_mode_select_xlat() sets the FIELD POINTER of the
INVALID FIELD IN PARAMETER LIST sense data to the SUBPAGE CODE byte of
the mode page header (byte 1 of the page) if the SPF bit is set, and to
the PAGE CODE byte (byte 0 of the page) otherwise.

However, the SPF bit is tested on p[0] after p has already been advanced
past the mode page header, so the test reads bit 6 of the first byte of
the mode page data instead. If the parameter list ends with the mode
page header, it even reads the byte that follows the parameter list in
buffer, which is not initialized when no data beyond the parameter list
was transferred.

The test is not needed anyway: spg can only be non-zero for a mode page
in sub_page format, i.e. with the SPF bit set, and the field in error is
the SUBPAGE CODE. Always set the FIELD POINTER to the SUBPAGE CODE byte,
which follows the mode parameter header, the block descriptors and the
PAGE CODE byte.

Fixes: 7780081c1f04 ("libata-scsi: Set information sense field for invalid parameter")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-14-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 37059d59b7ea0..71db0c4d4914a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4623,8 +4623,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 				break;
 			fallthrough;
 		default:
-			fp = (p[0] & 0x40) ? 1 : 0;
-			fp += hdr_len + bd_len;
+			fp = hdr_len + bd_len + 1;
 			goto invalid_param;
 		}
 	}
-- 
2.53.0



