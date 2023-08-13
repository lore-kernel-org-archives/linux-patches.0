Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0CC9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EE8C433C8;
	Sun, 13 Aug 2023 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961924;
	bh=usbrCYWnWrqnXz4FIP2bhefwrQV3tv8ofGDbSdIEa8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuPxDtIRT3TFyTjvHWr5V1K7MvEp80IG0MK/YAU00jKBEQIsn1zndKK+j/i2heEo+
	 ulNNIbyXCLRQVtRv5YlzvmjmE5biStMMaAS85p5uMq3JdrtVaNU/Q0OQcRtGvHO919
	 yncIxXh5DfGxk+xxKOlnVsybpGWJ1XpChRK6Oa2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.4 047/206] tpm: tpm_tis: Fix UPX-i11 DMI_MATCH condition
Date: Sun, 13 Aug 2023 23:16:57 +0200
Message-ID: <20230813211726.347546120@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 51e5e551af53259e0274b0cd4ff83d8351fb8c40 upstream.

The patch which made it to the kernel somehow changed the
match condition from
DMI_MATCH(DMI_PRODUCT_NAME, "UPX-TGL01")
to
DMI_MATCH(DMI_PRODUCT_VERSION, "UPX-TGL")

Revert back to the correct match condition to disable the
interrupt mode on the board.

Cc: stable@vger.kernel.org # v6.4+
Fixes: edb13d7bb034 ("tpm: tpm_tis: Disable interrupts *only* for AEON UPX-i11")
Link: https://lore.kernel.org/lkml/20230524085844.11580-1-peter.ujfalusi@linux.intel.com/
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index ac4daaf294a3..3c0f68b9e44f 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -183,7 +183,7 @@ static const struct dmi_system_id tpm_tis_dmi_table[] = {
 		.ident = "UPX-TGL",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "AAEON"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "UPX-TGL"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UPX-TGL01"),
 		},
 	},
 	{}
-- 
2.41.0



