Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4FC1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F252C433C9;
	Fri, 21 Jul 2023 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956084;
	bh=s4qekzqvjL/7jc55eW6LyrJDVhpMjcPXFei8oxa2TaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtI8XMzI65jrWI3iIo5F9GBv2iUfEz+gf9YsJ9BdWBL2tqWQGUrotjGZKQ4r0jJLh
	 GU5l2widQ7sAgGnToCKqHznStBl/iDY5eB4g6U2ysrCUe3WkxufX3fzxu6UMnA1KgV
	 8KjFjG/YMR31JHKX5kEXp99W+rIgN/vSdEKZEaxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	roubro1991@gmail.com,
	Christian Hesse <mail@eworm.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.4 127/292] tpm/tpm_tis: Disable interrupts for Framework Laptop Intel 12th gen
Date: Fri, 21 Jul 2023 18:03:56 +0200
Message-ID: <20230721160534.281900124@linuxfoundation.org>
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

commit 08b0af4478bacb8bb701c172c99a34ea32da89f5 upstream.

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
index 9cb4e81fc548..5dd391ed3320 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -114,6 +114,14 @@ static int tpm_tis_disable_irq(const struct dmi_system_id *d)
 }
 
 static const struct dmi_system_id tpm_tis_dmi_table[] = {
+	{
+		.callback = tpm_tis_disable_irq,
+		.ident = "Framework Laptop (12th Gen Intel Core)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Framework"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Laptop (12th Gen Intel Core)"),
+		},
+	},
 	{
 		.callback = tpm_tis_disable_irq,
 		.ident = "ThinkPad T490s",
-- 
2.41.0



