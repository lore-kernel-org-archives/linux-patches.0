Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE821991DC;
	Thu,  6 Jun 2024 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683688; cv=none; b=Tl5u5FmT0UuZt0Yc1/l+dQR7CYwfKUyTHdovr7zs1ZQ2I5Hfmsj2KAI3ZWoHqPKof2nCrFEwb3+7aRNUZN3JDoVOfZM2rwQXAXRc9mnDnz92UXBGi2EtEkrn+Y1JFs38L0V9WWmmK3z4bj2zZ5oBCz5scsAhFnC0jZQxTYOUJbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683688; c=relaxed/simple;
	bh=9IZ3EI7J6gSUKSK/MlqWZ+HQFbJaewxFJwZviIQ5uYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADzfZsNi3FV7WaIlSoO429jmZ0DoPq8EeWFkTF/N6glYkZrBhaFsUTRDXYLDGY/nTdCdyiDYlvwPYEL6ne6hswPSgWaAQ8oYk95AB7rdYJ364o3u7Ngdae6Lt1FkrMtKNvp0GxOuugSnIlsy+NSZ5JS5KGkjWALwUx7+dqqiTQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uG0lOvVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uG0lOvVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E002C4AF09;
	Thu,  6 Jun 2024 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683688;
	bh=9IZ3EI7J6gSUKSK/MlqWZ+HQFbJaewxFJwZviIQ5uYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uG0lOvVTpeLLtPFfELmMz4LPber/RbwuvK3ktAxbKBhSJzoBR+qxlsE/AwkfFEkfG
	 93wunZcd70xmKkZqW25p9z/22PE7UYzq1WiDsoNZAOOVSq99CoTK1xS6vFism5gbZQ
	 vaBOqB2ieItLmhSnq+5SnqJEu3f3D/64zH2FevNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 596/744] tools/arch/x86/intel_sdsi: Fix meter_show display
Date: Thu,  6 Jun 2024 16:04:28 +0200
Message-ID: <20240606131751.591466334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



