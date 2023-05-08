Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81E7168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41639C433D2;
	Mon,  8 May 2023 11:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544055;
	bh=U3GQrR3uJLaucEjmkIUed2quljwFDiOi/otQYZ8DQnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iriwRI/1K4Ndb0HlvS2GIplg354D7qGXiCyAw3pfhszgXImvzM1hX5AU2WP/Jv9mo
	 ltcqWyv39ExwnRNf1V9YHOB05J2V94O2Q3fpdhIrBwPih07wg3fISSf32IqZBN+odi
	 aIdW9aSdg3AghAxdBDuLIIELVYNa9U5iJe6HKhkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 288/694] platform/x86/amd: pmc: Dont try to read SMU version on Picasso
Date: Mon,  8 May 2023 11:42:03 +0200
Message-Id: <20230508094441.637905681@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit b845772677ea19b8e4c032bc07393ef32de4ee39 ]

Picasso doesn't support the command in the uPEP mailbox to try to
read the SMU version.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2449
Fixes: f6045de1f532 ("platform/x86: amd-pmc: Export Idlemask values based on the APU")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230409185348.556161-2-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 2edaae04a6912..4ffb08d2b01bc 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -403,6 +403,9 @@ static int amd_pmc_get_smu_version(struct amd_pmc_dev *dev)
 	int rc;
 	u32 val;
 
+	if (dev->cpu_id == AMD_CPU_ID_PCO)
+		return -ENODEV;
+
 	rc = amd_pmc_send_cmd(dev, 0, &val, SMU_MSG_GETSMUVERSION, 1);
 	if (rc)
 		return rc;
-- 
2.39.2



