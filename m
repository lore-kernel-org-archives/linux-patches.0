Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640861F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB00C433C7;
	Fri, 21 Jul 2023 16:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956235;
	bh=GLTQt0lda/Teb+p8X1CkaAhLrrs6az1NUrKQOvjwkzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iwp71t1UwrQz+Fl+nCnnwCRcqE0lreiBibebXCdyEXZp7u97qDHCFD/XdEh03Jfvy
	 Q7UCUdABpgQO6L5Gm64bOmhGcGYSMXTydedHxUE4Yw6bQckClfROxUljW4NyueM8h9
	 bDT32GsinFvHEYU3thaR7a4WotJ+8vOiz2F3LaL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	roubro1991@gmail.com,
	Christian Hesse <mail@eworm.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.4 130/292] tpm/tpm_tis: Disable interrupts for Framework Laptop Intel 13th gen
Date: Fri, 21 Jul 2023 18:03:59 +0200
Message-ID: <20230721160534.411920399@linuxfoundation.org>
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

From: Christian Hesse <mail@eworm.de>

commit bc825e851c2fe89c127cac1e0e5cf344c4940619 upstream.

This device suffer an irq storm, so add it in tpm_tis_dmi_table to
force polling.

Cc: stable@vger.kernel.org # v6.4+
Link: https://community.frame.work/t/boot-and-shutdown-hangs-with-arch-linux-kernel-6-4-1-mainline-and-arch/33118
Fixes: e644b2f498d2 ("tpm, tpm_tis: Enable interrupt test")
Reported-by: <roubro1991@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217631
Signed-off-by: Christian Hesse <mail@eworm.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 5dd391ed3320..4e4426965cd0 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -122,6 +122,14 @@ static const struct dmi_system_id tpm_tis_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Laptop (12th Gen Intel Core)"),
 		},
 	},
+	{
+		.callback = tpm_tis_disable_irq,
+		.ident = "Framework Laptop (13th Gen Intel Core)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Framework"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Laptop (13th Gen Intel Core)"),
+		},
+	},
 	{
 		.callback = tpm_tis_disable_irq,
 		.ident = "ThinkPad T490s",
-- 
2.41.0



