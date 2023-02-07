Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16663212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37730C433EF;
	Tue,  7 Feb 2023 13:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774929;
	bh=lbSeOeUrq6xUkb8mcyLekTVxahAr75J+ybJ9w4nD1TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uxx/TozcbxtIqyHelEnDRN5hd+nqZZVU199nOpT1NWLIGREU0WZAFotvZexqQr8Zz
	 NU2rC4zLNZrOdfXVEm9TArXUtwMmgYRmoMYvMKT5uUSngaHCOfWJUlMXn84SKMDZTf
	 xRH6pC43rjZICAvUOu7lapjnTSOBL93Nx37TDYBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/208] platform/x86/amd/pmf: update to auto-mode limits only after AMT event
Date: Tue,  7 Feb 2023 13:55:07 +0100
Message-Id: <20230207125636.685111060@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 3dfe28c936f87373a2b6ada750be4c52c0f249f3 ]

Auto-mode thermal limits should be updated only after receiving the AMT
event. But due to a bug in the older commit, these settings were getting
applied during the auto-mode init.

Fix this by removing amd_pmf_set_automode() during auto-mode
initialization.

Fixes: 3f5571d99524 ("platform/x86/amd/pmf: Add support for Auto mode feature")
Suggested-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230125095936.3292883-4-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/auto-mode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/auto-mode.c b/drivers/platform/x86/amd/pmf/auto-mode.c
index 644af42e07cf..85ce9ed25b85 100644
--- a/drivers/platform/x86/amd/pmf/auto-mode.c
+++ b/drivers/platform/x86/amd/pmf/auto-mode.c
@@ -299,7 +299,5 @@ void amd_pmf_deinit_auto_mode(struct amd_pmf_dev *dev)
 void amd_pmf_init_auto_mode(struct amd_pmf_dev *dev)
 {
 	amd_pmf_load_defaults_auto_mode(dev);
-	/* update the thermal limits for Automode */
-	amd_pmf_set_automode(dev, config_store.current_mode, NULL);
 	amd_pmf_init_metrics_table(dev);
 }
-- 
2.39.0



