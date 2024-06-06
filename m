Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91103196D87;
	Thu,  6 Jun 2024 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683010; cv=none; b=D3VzdpbDtvx/gR2FVDXiHRN+C08fNu68tMI2y26LGJ89lcjEJ5sUN1G3KVpXmlUXu7i3+JTVhXQOiPc1144krjiha7fTEoErRdmWjSmt+V9iJJeGSIgSl/3Fx2JhVGjbw7SdwRtQZE0cMZV6cy7hGnWgShh98QYl8KzD0naDbGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683010; c=relaxed/simple;
	bh=pGev+Oj5MqMEFYUtDsSclMZwtHsFn27fyIC2hk1aSx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnDlhA1hvRl7TVp60ZIF4CFOXs5Mi2Dc+prSSSFtMd7PzGvPIO572RSyrgHWg5zsPiL1aSwP1ti+vxzYNfea0CCqPu1q5CpTGEfk3smOj/9QEm9f9ylv3BSdx1gH41y6oazO/d8TWhONddSlsstSC+6a9YOERf3UlbIFNpMUHBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giLSQ5pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giLSQ5pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A15C4AF4D;
	Thu,  6 Jun 2024 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683010;
	bh=pGev+Oj5MqMEFYUtDsSclMZwtHsFn27fyIC2hk1aSx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giLSQ5pzKTrNSvXic7OLVexpdIH4eOL4wzn7IY7i5SAHOuQz6wzLut5QJcMEHeh/2
	 9q2svOhpSQNJuLVr0/5HY0ax35HvE+ZyhZzcpHBEgd0aWH56dCVsbWHQ/xd0Mfuje3
	 5+1jHIRnQ1BLInvb3M9mlv+cmnkSjnwHoyYLF8G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 185/374] tools/arch/x86/intel_sdsi: Fix maximum meter bundle length
Date: Thu,  6 Jun 2024 16:02:44 +0200
Message-ID: <20240606131658.069404879@linuxfoundation.org>
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

[ Upstream commit a66f962f67ebbbdf7c82c6652180930c0169cf13 ]

The maximum number of bundles in the meter certificate was set to 8 which
is much less than the maximum. Instead, since the bundles appear at the end
of the file, set it based on the remaining file size from the bundle start
position.

Fixes: 7fdc03a7370f ("tools/arch/x86: intel_sdsi: Add support for reading meter certificates")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240411025856.2782476-6-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/x86/intel_sdsi/intel_sdsi.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/arch/x86/intel_sdsi/intel_sdsi.c b/tools/arch/x86/intel_sdsi/intel_sdsi.c
index 2cd92761f1714..7eaffcbff788c 100644
--- a/tools/arch/x86/intel_sdsi/intel_sdsi.c
+++ b/tools/arch/x86/intel_sdsi/intel_sdsi.c
@@ -43,7 +43,6 @@
 #define METER_CERT_MAX_SIZE	4096
 #define STATE_MAX_NUM_LICENSES	16
 #define STATE_MAX_NUM_IN_BUNDLE	(uint32_t)8
-#define METER_MAX_NUM_BUNDLES	8
 
 #define __round_mask(x, y) ((__typeof__(x))((y) - 1))
 #define round_up(x, y) ((((x) - 1) | __round_mask(x, y)) + 1)
@@ -167,6 +166,11 @@ struct bundle_encoding_counter {
 	uint32_t encoding;
 	uint32_t counter;
 };
+#define METER_BUNDLE_SIZE sizeof(struct bundle_encoding_counter)
+#define BUNDLE_COUNT(length) ((length) / METER_BUNDLE_SIZE)
+#define METER_MAX_NUM_BUNDLES							\
+		((METER_CERT_MAX_SIZE - sizeof(struct meter_certificate)) /	\
+		 sizeof(struct bundle_encoding_counter))
 
 struct sdsi_dev {
 	struct sdsi_regs regs;
@@ -386,9 +390,9 @@ static int sdsi_meter_cert_show(struct sdsi_dev *s)
 		return -1;
 	}
 
-	if (mc->bundle_length > METER_MAX_NUM_BUNDLES * 8)  {
-		fprintf(stderr, "More than %d bundles: %d\n",
-			METER_MAX_NUM_BUNDLES, mc->bundle_length / 8);
+	if (mc->bundle_length > METER_MAX_NUM_BUNDLES * METER_BUNDLE_SIZE)  {
+		fprintf(stderr, "More than %ld bundles: actual %ld\n",
+			METER_MAX_NUM_BUNDLES, BUNDLE_COUNT(mc->bundle_length));
 		return -1;
 	}
 
-- 
2.43.0



