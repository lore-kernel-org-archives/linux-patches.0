Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914FC197A8A;
	Thu,  6 Jun 2024 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683013; cv=none; b=IzWtvWuB7n0Uro1aQvz5u7WH7T0+qUJDRF7piVlNm4UTb9cFE+cLD/j7HaHJvS5uwCvszx1cqP6Q31u2HHD/hLqDqksQCFlhz1VCso4CwvWjVzFMfYOIFTPZW26cgQT++c+x9CJ5UU5hHlhsHPLKIw5zIObe7mC3wWlogsf32a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683013; c=relaxed/simple;
	bh=ZWK2zAI4ll1amXUw01B9RePI2O0GUKyclyV0JDa0JgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cALPgInkQAugI7BPHOXCPR6gjpF5cS/mC+X6NdR9/wuP34wlqJHOkOHvZwRF8ni56pZ2g0e54OzIqOXtEgwmT5FyQM27Bncv/P4OYdoWJYVjcNjoeZl8QhPqZU0cyaL8oJ/by8uyqcQ+rX932XBf4xT6O9fPykHLMR3n79ICfTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aaqh7a7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aaqh7a7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C849C4AF0C;
	Thu,  6 Jun 2024 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683013;
	bh=ZWK2zAI4ll1amXUw01B9RePI2O0GUKyclyV0JDa0JgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aaqh7a7NSY8u8QA51hoY11OBpam+fA9+NzEtUkiX35g+fEL9dPRTYuUzoe1zigtIb
	 sp4zGTGi5UD7EYP5jGs4q24t0FNp0zA1tOLUMGpiKehF1hPUBLb/Ti2qkTfvTxbTJW
	 /5wwBpoRsWMvSPMKGdfn3Bm6UKmtJYIHadVqKZRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 187/374] tools/arch/x86/intel_sdsi: Fix meter_certificate decoding
Date: Thu,  6 Jun 2024 16:02:46 +0200
Message-ID: <20240606131658.133186755@linuxfoundation.org>
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



