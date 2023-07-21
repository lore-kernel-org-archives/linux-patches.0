Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2051F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A975AC433C8;
	Fri, 21 Jul 2023 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956269;
	bh=9HlVhkWCVKyP9n6mog91Ob/F06qrrJ6MnEw70/qdtwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2AZLYhjgaEbVbdSMUpxF28tzKXvNk02+QBuq1GVST+Ffbi4P29ZlK7Js5aNIh5NQ
	 pkAYs51K/LnCwxqLCVyEmF/NlAOFNn+nLrBAMRxzY2hsDKatAFvSYRgt3roIxLC+hJ
	 6pl2kg7JClPaPmKP/x2MMVpX9yp2H8EXe0yFrleI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Bezdeka <florian@bezdeka.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.4 132/292] tpm/tpm_tis: Disable interrupts for Lenovo L590 devices
Date: Fri, 21 Jul 2023 18:04:01 +0200
Message-ID: <20230721160534.498595024@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Bezdeka <florian@bezdeka.de>

commit 393f362389cecc2e4f2e3520a6c8ee9dbb1e3d15 upstream.

The Lenovo L590 suffers from an irq storm issue like the T490, T490s
and P360 Tiny, so add an entry for it to tpm_tis_dmi_table and force
polling.

Cc: stable@vger.kernel.org # v6.4+
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2214069#c0
Fixes: e644b2f498d2 ("tpm, tpm_tis: Enable interrupt test")
Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 4e4426965cd0..cc42cf3de960 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -154,6 +154,14 @@ static const struct dmi_system_id tpm_tis_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L490"),
 		},
 	},
+	{
+		.callback = tpm_tis_disable_irq,
+		.ident = "ThinkPad L590",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L590"),
+		},
+	},
 	{
 		.callback = tpm_tis_disable_irq,
 		.ident = "UPX-TGL",
-- 
2.41.0



