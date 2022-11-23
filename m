Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503191C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2346C433C1;
	Wed, 23 Nov 2022 09:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197243;
	bh=P69XkczsHIbTF3iSIvY2sEtDIH/dFVjsIoFZ8FyFLU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhZgft0of5q8G1srABMhCjU1paMwSeUwN7+NCES+dICMG3L96J+t//RaMyu8JHfmD
	 ujP3RV3iwuuHgZjT1To3K61g3numpLiOGOteflcbgjYm+3oUKZuGxDhJ+P1MhnIwfA
	 9W90NlqPkmwaYXENCq0HFma+ixITXrkczwG6PSYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyupeng@zbhlos.com,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.0 208/314] platform/x86/amd: pmc: Remove more CONFIG_DEBUG_FS checks
Date: Wed, 23 Nov 2022 09:50:53 +0100
Message-Id: <20221123084634.962307164@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit a5b5fb0fc47ddc7d1ed6a0365197639a01bc1f3a upstream.

commit b37fe34c8309 ("platform/x86/amd: pmc: remove CONFIG_DEBUG_FS
checks") removed most CONFIG_DEBUG_FS checks, but there were some
left that were reported to cause compile test failures.

Remove the remaining checks, and also the unnecessary CONFIG_SUSPEND
used in the same place.

Reported-by: liyupeng@zbhlos.com
Fixes: b37fe34c8309 ("platform/x86/amd: pmc: remove CONFIG_DEBUG_FS checks")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216679
Link: https://lore.kernel.org/r/20221108023323.19304-1-mario.limonciello@amd.com
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -274,7 +274,6 @@ static const struct file_operations amd_
 	.release = amd_pmc_stb_debugfs_release_v2,
 };
 
-#if defined(CONFIG_SUSPEND) || defined(CONFIG_DEBUG_FS)
 static int amd_pmc_setup_smu_logging(struct amd_pmc_dev *dev)
 {
 	if (dev->cpu_id == AMD_CPU_ID_PCO) {
@@ -349,7 +348,6 @@ static int get_metrics_table(struct amd_
 	memcpy_fromio(table, pdev->smu_virt_addr, sizeof(struct smu_metrics));
 	return 0;
 }
-#endif /* CONFIG_SUSPEND || CONFIG_DEBUG_FS */
 
 #ifdef CONFIG_SUSPEND
 static void amd_pmc_validate_deepest(struct amd_pmc_dev *pdev)


