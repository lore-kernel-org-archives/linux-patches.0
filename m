Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C44A1991DC;
	Thu,  6 Jun 2024 14:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683689; cv=none; b=ejXkuO7kPOiWj7eOZfERuRuSj07ODlN5RusuauyB7iG/NX948FvzWNO3B6ODminZrIc5amFwDFGx8lKjPMGSW9k6TnNBHNCIAQs98EiWtM7ulhrUbZFo8vK/tgAjmBaBIGGwcySc5HqlQYk7hsKIcUnQ0ObHicX6tQ7KQ+nsF+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683689; c=relaxed/simple;
	bh=bfPFfobAfAA/pjC15vFBV/NqbzeIs7LlE+nk5fmKRB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EE1AMotdmEMU/FuyKUwwSgixOkINVVMAnN5NNqkrsToaUq4+682Q1pNZejgMdzvvZIBV8NGUEg468IeRSj80SK4Ri/is7nvLWMQ4d3o84lVDRahsETZrbXSIuAVM3SOOmAO76wTzwWP7qPafU/Ay4YuA160ZQCarq7qFeGKioIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ver3UCtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ver3UCtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADFAC2BD10;
	Thu,  6 Jun 2024 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683689;
	bh=bfPFfobAfAA/pjC15vFBV/NqbzeIs7LlE+nk5fmKRB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ver3UCtbGA/4wrIxA38U2Wb4IXAoYMCkNIx+LmAcIyQfwl94TAoDcVnPwPTTUdk+V
	 EAOjIoY4+ulk0vGDcl23YezWL4C0/q8Kb1IBDvGuaFNG2Rbh1Kfu2NwdJyutmvFIa+
	 R/qju0dVBCHBJ0IBlpkxB9j3FI2kV+uAlOqkoClI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 597/744] tools/arch/x86/intel_sdsi: Fix meter_certificate decoding
Date: Thu,  6 Jun 2024 16:04:29 +0200
Message-ID: <20240606131751.619680524@linuxfoundation.org>
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

[ Upstream commit 09d70ded6c566fd00886be32c26d0b2004ef239c ]

Fix errors in the calculation of the start position of the counters and in
the display loop. While here, use a #define for the bundle count and size.

Fixes: 7fdc03a7370f ("tools/arch/x86: intel_sdsi: Add support for reading meter certificates")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240411025856.2782476-8-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/x86/intel_sdsi/intel_sdsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/arch/x86/intel_sdsi/intel_sdsi.c b/tools/arch/x86/intel_sdsi/intel_sdsi.c
index ae29214da1029..ba2a6b6645ae8 100644
--- a/tools/arch/x86/intel_sdsi/intel_sdsi.c
+++ b/tools/arch/x86/intel_sdsi/intel_sdsi.c
@@ -394,7 +394,7 @@ static int sdsi_meter_cert_show(struct sdsi_dev *s)
 	printf("MMRC encoding:                %.4s\n", name);
 
 	printf("MMRC counter:                 %d\n", mc->mmrc_counter);
-	if (mc->bundle_length % 8) {
+	if (mc->bundle_length % METER_BUNDLE_SIZE) {
 		fprintf(stderr, "Invalid bundle length\n");
 		return -1;
 	}
@@ -405,15 +405,16 @@ static int sdsi_meter_cert_show(struct sdsi_dev *s)
 		return -1;
 	}
 
-	bec = (void *)(mc) + sizeof(mc);
+	bec = (struct bundle_encoding_counter *)(mc + 1);
 
 	printf("Number of Feature Counters:   %ld\n", BUNDLE_COUNT(mc->bundle_length));
-	while (count++ < mc->bundle_length / 8) {
+	while (count < BUNDLE_COUNT(mc->bundle_length)) {
 		char feature[5];
 
 		feature[4] = '\0';
 		get_feature(bec[count].encoding, feature);
 		printf("    %s:          %d\n", feature, bec[count].counter);
+		++count;
 	}
 
 	return 0;
-- 
2.43.0



