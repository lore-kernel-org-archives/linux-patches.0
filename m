Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A4F9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C83C433C7;
	Sun, 13 Aug 2023 21:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961815;
	bh=VYffoFa1P89M3jpYt6WZK7qm30iMTQN5Kd5QW2phFPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltntMl42aSC9kx62444bVkGySV20RolphZDjw/qKVywNDedK56hf4AAvXGYu176SL
	 saKILg6UvgmY685f2qACzHaRK4xRs7UsS9/HkI5HUadhXRPwSXqUcRAeoU5vlwtup+
	 dr16yL4dEzLOuza/Utf0YBajdposkKpGSl/BBAzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.4 001/206] tpm/tpm_tis: Disable interrupts for TUXEDO InfinityBook S 15/17 Gen7
Date: Sun, 13 Aug 2023 23:16:11 +0200
Message-ID: <20230813211725.016943773@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 0b15afc9038146bb2009e7924b1ead2e919b2a56 upstream.

TUXEDO InfinityBook S 15/17 Gen7 suffers from an IRQ problem on
tpm_tis like a few other laptops.  Add an entry for the workaround.

Cc: stable@vger.kernel.org
Fixes: e644b2f498d2 ("tpm, tpm_tis: Enable interrupt test")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1213645
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index cc42cf3de960..a98773ac2e55 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -162,6 +162,14 @@ static const struct dmi_system_id tpm_tis_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L590"),
 		},
 	},
+	{
+		.callback = tpm_tis_disable_irq,
+		.ident = "TUXEDO InfinityBook S 15/17 Gen7",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TUXEDO InfinityBook S 15/17 Gen7"),
+		},
+	},
 	{
 		.callback = tpm_tis_disable_irq,
 		.ident = "UPX-TGL",
-- 
2.41.0



