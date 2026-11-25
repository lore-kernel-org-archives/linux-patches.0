Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618725;
	b=gdY5ytvAxV6K8wLv/LNz0vLNIktpjMsAvGGll8C7RkuiuosZzv1pudxjOxj1tgJ2Ks25
	 T3tZog15FbBHegvj0jOmn2q19sFL1/BhRNnY6yN0ufcUJHrJrz6FbkduOOjdsr34SAt6o
	 ev93oouCwafbrDTB/pLadMo9EGgOi4NQ8IDYemyB99yqVZI9YKpPMQvrsMn9BHDKpOtoJ
	 9Bgn/JrkRyeEB4hoD5xb4iGKbXmCGgMcbCHY7sSxU3zgxL38gQHM7AE8dfQiLE19BQOu2
	 xskR9PkRBf2DKZaBoGJGTINJf1WFy88hg1gP5WMwJbyW+UGrxWFtwICqWWBJYg0cZqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W+K3kF7zBN5LUf5tyt2W5ijAfn5nDVKn6vT+e5vyOD4=;
	b=RHZeQI+s/5eOktpCE6ZRZFsD5ovxbJPSl/IV+GhVUYz8N8u7orhOTyPeUgx3WIkbVXN9
	 +T46P6xyDYjmY+wH+0vKcIYZ7ss3EajIb55QRxgdSbH3+QRqg5lSln5czFLM8Vy/R0pUt
	 Y7O9Jkj39RcPgK+pVDWsaulUb3iQJ38hVXWPqG79fg+mYaUJ7U8AcWjELKnJvfjuRO99r
	 I/9iIoVToMzpt5U2QSECMFUTzF7dC9cSiY/MVs1pE09V7xQUcCEUNVEZgHan+2xHmAklq
	 M2NpX4e1vw1Xke7j9QAxDLL+ydz1rQj+E/ENlgjiXBvhxu0F6RcWS/1PYR20R0Iiv9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V/v8AS4g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6591606A31E;
	Wed, 25 Nov 2026 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V/v8AS4g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE451F000C4;
	Wed, 25 Nov 2026 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618725;
	bh=W+K3kF7zBN5LUf5tyt2W5ijAfn5nDVKn6vT+e5vyOD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/v8AS4gwVUoOHbtkafnkETQYRPhIsO9z3mfaBrtjGuC4fdEakxByZV9mixj4QyNy
	 WIfyKeBDrP+GoNhG3vbUiQwRKvh0ee57KxtCT9Wc/jSqBYJErGAyxmZJTLingaW79y
	 rro2a7t4V9iyHQnWxoC7nHi5E7dkeKjKpaR39XiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0371/1005] ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit
Date: Wed, 25 Nov 2026 15:28:29 +0100
Message-ID: <20261125143830.427894257@linuxfoundation.org>
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

[ Upstream commit a1eb72c477ec1320c540f27ce1e2f717d4518e62 ]

ata_scsi_mode_select_xlat() accepts the caching and control mode pages
both in page_0 format and in sub_page format with SUBPAGE CODE 00h.

However, SAT-2 and later versions of SAT define the SPF bit of the
Caching mode page and of the Control mode page as not changeable and
set to zero (see SAT-6, 10.4.9 and 10.4.6), and SPC-7 (6.12, MODE
SELECT(10) command) requires the device server to terminate a MODE
SELECT command with INVALID FIELD IN PARAMETER LIST if the application
client sets any field that is reported as not changeable to a value
other than its current value.

Reject a mode page with the SPF bit set to one and SUBPAGE CODE 00h,
with the FIELD POINTER set to the byte containing the SPF bit. The only
mode page with the SPF bit set to one that remains accepted is the ATA
Feature Control mode page (control mode page, sub-page f2h), for which
SAT-6 (12.3.4) requires the SPF bit to be set to one. The opposite case
does not need a check: a mode page in page_0 format always has subpage
code 00h, so it can never be the ATA Feature Control mode page.

This also allows the mode page handlers to rely on the format of their
mode page, which a later patch will make use of.

Fixes: 1b26d29ccd59 ("[libata] scsi: implement MODE SELECT command")
Link: https://lore.kernel.org/r/20261103205448.931471-13-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 26bf83188625b..37059d59b7ea0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4587,7 +4587,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		if (len < 4)
 			goto invalid_param_len;
 
+		/*
+		 * Mode pages with subpage code 00h use the page_0 format: SAT
+		 * defines the SPF bit of the Caching and Control mode pages,
+		 * for subpage code 00h, as not changeable and set to zero.
+		 */
 		spg = p[1];
+		if (!spg) {
+			fp = hdr_len + bd_len;
+			goto invalid_param;
+		}
+
 		pg_len = get_unaligned_be16(&p[2]);
 		p += 4;
 		len -= 4;
-- 
2.53.0



