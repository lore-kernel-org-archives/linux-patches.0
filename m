Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A6619A287;
	Thu,  6 Jun 2024 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683013; cv=none; b=nU03Px8uPvFXYViEzhDpQBtbs7Fa6eyJH6ks2FtUKs0aLk9Aa0kJdd4CSOyCt4c3Dq7jTXOTM+ztdBDQ/HSPo/Z2WOf2SW5I2DDRnNYmCoHXSRlNhRfD4xQbOPJKzcRay/DDQAATKZgWBtz7yoQJKDrOtLv66P2ZEfntDlSuTDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683013; c=relaxed/simple;
	bh=er+zm+9XVCMqYBreHw9mFxIEEc4VGM1Pch6rnyxHsh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fsB1q4zBNy4SUyPvdZyR0pVq9mO4+hbY05nl0Q3ZLifMcZ0jOdMOiC/ABNhBX+tIcvrunTnBM5myz/ng8bYZZ5Z+vDGO0S6q4K/52/GnUeiUJjiosgq7XxrA/AsACr1oS3jCL69uEnFvnDivT1S1z2KJAwUsCMpxdi3bc/wQaKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/0EXepG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/0EXepG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE18C4AF0D;
	Thu,  6 Jun 2024 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683012;
	bh=er+zm+9XVCMqYBreHw9mFxIEEc4VGM1Pch6rnyxHsh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/0EXepGJwDqhoS8lfuvbNg+h/pKeDmOZv8gTy4J8sWYRYFJQYW13WMi1fP0H3EfF
	 ttTw/pQq53MV4+7uOfXHoWQF8X9ez+5BkSJ6144TNsAB/6MivLJUQlX7CpAl0RByVA
	 vvjz8V98oAqHTbJn7Jp8wmCJjN4uaH5NwZfVWSWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 186/374] tools/arch/x86/intel_sdsi: Fix meter_show display
Date: Thu,  6 Jun 2024 16:02:45 +0200
Message-ID: <20240606131658.102033332@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 76f2bc17428c890754d11aa6aea14b332ba130c5 ]

Fixes sdsi_meter_cert_show() to correctly decode and display the meter
certificate output. Adds and displays a missing version field, displays the
ASCII name of the signature, and fixes the print alignment.

Fixes: 7fdc03a7370f ("tools/arch/x86: intel_sdsi: Add support for reading meter certificates")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240411025856.2782476-7-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/x86/intel_sdsi/intel_sdsi.c | 29 +++++++++++++++++---------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/tools/arch/x86/intel_sdsi/intel_sdsi.c b/tools/arch/x86/intel_sdsi/intel_sdsi.c
index 7eaffcbff788c..ae29214da1029 100644
--- a/tools/arch/x86/intel_sdsi/intel_sdsi.c
+++ b/tools/arch/x86/intel_sdsi/intel_sdsi.c
@@ -153,11 +153,12 @@ struct bundle_encoding {
 };
 
 struct meter_certificate {
-	uint32_t block_signature;
-	uint32_t counter_unit;
+	uint32_t signature;
+	uint32_t version;
 	uint64_t ppin;
+	uint32_t counter_unit;
 	uint32_t bundle_length;
-	uint32_t reserved;
+	uint64_t reserved;
 	uint32_t mmrc_encoding;
 	uint32_t mmrc_counter;
 };
@@ -338,6 +339,7 @@ static int sdsi_meter_cert_show(struct sdsi_dev *s)
 	uint32_t count = 0;
 	FILE *cert_ptr;
 	int ret, size;
+	char name[4];
 
 	ret = sdsi_update_registers(s);
 	if (ret)
@@ -379,12 +381,19 @@ static int sdsi_meter_cert_show(struct sdsi_dev *s)
 	printf("\n");
 	printf("Meter certificate for device %s\n", s->dev_name);
 	printf("\n");
-	printf("Block Signature:       0x%x\n", mc->block_signature);
-	printf("Count Unit:            %dms\n", mc->counter_unit);
-	printf("PPIN:                  0x%lx\n", mc->ppin);
-	printf("Feature Bundle Length: %d\n", mc->bundle_length);
-	printf("MMRC encoding:         %d\n", mc->mmrc_encoding);
-	printf("MMRC counter:          %d\n", mc->mmrc_counter);
+
+	get_feature(mc->signature, name);
+	printf("Signature:                    %.4s\n", name);
+
+	printf("Version:                      %d\n", mc->version);
+	printf("Count Unit:                   %dms\n", mc->counter_unit);
+	printf("PPIN:                         0x%lx\n", mc->ppin);
+	printf("Feature Bundle Length:        %d\n", mc->bundle_length);
+
+	get_feature(mc->mmrc_encoding, name);
+	printf("MMRC encoding:                %.4s\n", name);
+
+	printf("MMRC counter:                 %d\n", mc->mmrc_counter);
 	if (mc->bundle_length % 8) {
 		fprintf(stderr, "Invalid bundle length\n");
 		return -1;
@@ -398,7 +407,7 @@ static int sdsi_meter_cert_show(struct sdsi_dev *s)
 
 	bec = (void *)(mc) + sizeof(mc);
 
-	printf("Number of Feature Counters:          %d\n", mc->bundle_length / 8);
+	printf("Number of Feature Counters:   %ld\n", BUNDLE_COUNT(mc->bundle_length));
 	while (count++ < mc->bundle_length / 8) {
 		char feature[5];
 
-- 
2.43.0



