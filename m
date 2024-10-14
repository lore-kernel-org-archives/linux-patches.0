Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95961ABEC7;
	Mon, 14 Oct 2024 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918967; cv=none; b=ipWQrocqMNVlqn6+p2ZgWhBLh7ofkdjPP+WOPYyYxEJwoTxozfu2WOejO+fk/7oef203zzVrwKkU6MhiUVGPWjEP7RlpQWkc6RZB1jlrJ7jhSSbUu/bEn4euxIbCvyN5CE20HmL/IrQ/AkMv22qa1BAur3MHv2C732CXOEkJvVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918967; c=relaxed/simple;
	bh=DnlvF95FF/YH1s8c6XnxOtRSkP917/br7uD5G7isoqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvP5cykPmFCLIVOqNsJS3eWfsEgiuCLho2tTcQjz/xSiZdisMsGQHJ6LvavWQ51rPpgCqFknyi9agTZR8XrzrdVdLfFn3zus2izgdI4ng4irgjdPKIvAix02vtpGPk+Ar3pLWX9dECGoxCycwnyFcU8hU0SmzJ5F0K/Z504GEVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVQ1M8kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVQ1M8kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156F0C4CEC3;
	Mon, 14 Oct 2024 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918966;
	bh=DnlvF95FF/YH1s8c6XnxOtRSkP917/br7uD5G7isoqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVQ1M8kzV5tU1RQS95ms//q6RSOdkZ4K7f2BrPM+o5keJ+IbZ15xSfDskf+UIUcRF
	 uz+eOVgHThKzYosj6hbaSvC+XT2AtahsopvSYTFbUaqY+CK/f4hsvYFkHXRVkwKjNX
	 Wci/pMiEQQ2TRf1svqYcsftCM0rb/YMHpM2I77Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 475/798] ata: pata_serverworks: Do not use the term blacklist
Date: Mon, 14 Oct 2024 16:17:09 +0200
Message-ID: <20241014141236.636386255@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 858048568c9e3887d8b19e101ee72f129d65cb15 ]

Let's not use the term blacklist in the function
serverworks_osb4_filter() documentation comment and rather simply refer
to what that function looks at: the list of devices with groken UDMA5.

While at it, also constify the values of the csb_bad_ata100 array.

Of note is that all of this should probably be handled using libata
quirk mechanism but it is unclear if these UDMA5 quirks are specific
to this controller only.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_serverworks.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index c0bc4af0d1960..804c74ce3c1df 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -46,10 +46,11 @@
 #define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
 #define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
 
-/* Seagate Barracuda ATA IV Family drives in UDMA mode 5
- * can overrun their FIFOs when used with the CSB5 */
-
-static const char *csb_bad_ata100[] = {
+/*
+ * Seagate Barracuda ATA IV Family drives in UDMA mode 5
+ * can overrun their FIFOs when used with the CSB5.
+ */
+static const char * const csb_bad_ata100[] = {
 	"ST320011A",
 	"ST340016A",
 	"ST360021A",
@@ -163,10 +164,11 @@ static unsigned int serverworks_osb4_filter(struct ata_device *adev, unsigned in
  *	@adev: ATA device
  *	@mask: Mask of proposed modes
  *
- *	Check the blacklist and disable UDMA5 if matched
+ *	Check the list of devices with broken UDMA5 and
+ *	disable UDMA5 if matched.
  */
-
-static unsigned int serverworks_csb_filter(struct ata_device *adev, unsigned int mask)
+static unsigned int serverworks_csb_filter(struct ata_device *adev,
+					   unsigned int mask)
 {
 	const char *p;
 	char model_num[ATA_ID_PROD_LEN + 1];
-- 
2.43.0



