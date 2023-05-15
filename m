Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160D0FBF8
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807BAC433EF;
	Mon, 15 May 2023 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170855;
	bh=TPCEFs6Gs0KWg4bFSeNpTS70JR5mYKAK7iYjeH5spc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPqeSpaHJk0tvJN++EPSsKS2Vq/iwWTuPTmrVthM75/30+DmabhYOmqlVSiJlvL4B
	 m59ZODTRAukm9mB/CiPfyN+OiCXPK6viwY0KUnLWb5Pzn0b79EzMqcwui4muRDxCsw
	 WOBykNzaj3S7PRaiplBNKjHJH/C1UraHceYVfy3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 023/242] ASoC: Intel: soc-acpi-byt: Fix "WM510205" match no longer working
Date: Mon, 15 May 2023 18:25:49 +0200
Message-Id: <20230515161722.626651950@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c963e2ec095cb3f855890be53f56f5a6c6fbe371 ]

Commit 7e1d728a94ca ("ASoC: Intel: soc-acpi-byt: Add new WM5102 ACPI HID")
added an extra HID to wm5102_comp_ids.codecs, but it forgot to bump
wm5102_comp_ids.num_codecs, causing the last codec HID in the codecs list
to no longer work.

Bump wm5102_comp_ids.num_codecs to fix this.

Fixes: 7e1d728a94ca ("ASoC: Intel: soc-acpi-byt: Add new WM5102 ACPI HID")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230421183714.35186-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-byt-match.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-byt-match.c b/sound/soc/intel/common/soc-acpi-intel-byt-match.c
index db5a92b9875a8..87c44f284971a 100644
--- a/sound/soc/intel/common/soc-acpi-intel-byt-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-byt-match.c
@@ -124,7 +124,7 @@ static const struct snd_soc_acpi_codecs rt5640_comp_ids = {
 };
 
 static const struct snd_soc_acpi_codecs wm5102_comp_ids = {
-	.num_codecs = 2,
+	.num_codecs = 3,
 	.codecs = { "10WM5102", "WM510204", "WM510205"},
 };
 
-- 
2.39.2



