Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1715315665C;
	Mon, 16 Sep 2024 12:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488433; cv=none; b=uLBZ7HxglIAHMMbJs2tJ2po8i9bEoihnLrpay0NByRLGiBHnfxdAst+igbWZtDrC8VkoQTST4vgm8i7vzMSGFP3fjEfFyerpKk8rCuAJ38wvvuHLz8kF7wUqJu+tC3YNKDAkLmPek0jaGcwuPG5DuH66/BYWsXOXBk7T4wA3e1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488433; c=relaxed/simple;
	bh=2K0u835bQUYVIE94JnzLbwsTK/FRCaTbDVp1B7iEx4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcwP94VhhX1cydwMWL+MvV6Y6D2DiA2imBgJx4eizzLoinShMlKe4lXqtm06WWMaBp2XCRAktqm8UOxBZb3D9yo+549q2XRd60+v4TVd4gd1WRLuddMnmOBg7fgdRbsXxL70rB5Gw4fqZ6Up8mxnKJ67MCYbUdUYNCcJOgxGwTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHIN35bA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHIN35bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C91C4CEC4;
	Mon, 16 Sep 2024 12:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488433;
	bh=2K0u835bQUYVIE94JnzLbwsTK/FRCaTbDVp1B7iEx4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHIN35bAilK+8m2tMn0Ac8h7eW0x1bGiiennF6lFZd7hGNS8SrkM5Z410P8t3KXet
	 TSCsY7lOl2CNBseN8mGJxoHIMmBKQ0rDzTYR+5YQwyUeGplcyDgrDgbGi1Wurb/Q3R
	 5+4t2IxIPl1fBhLt7EVUr8fG68deZ6eoV1P0IClA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 112/121] ASoC: Intel: soc-acpi-intel-mtl-match: add missing empty item
Date: Mon, 16 Sep 2024 13:44:46 +0200
Message-ID: <20240916114232.803710505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit bf6d7a44a144aa9c476dee83c23faf3151181bab ]

There is no links_num in struct snd_soc_acpi_mach {}, and we test
!link->num_adr as a condition to end the loop in hda_sdw_machine_select().
So an empty item in struct snd_soc_acpi_link_adr array is required.

Fixes: f77ae7fcdc4763 ("ASoC: Intel: soc-acpi-intel-mtl-match: add cs42l43 only support")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20240906060224.2241212-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-mtl-match.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
index 8e0ae3635a35..d4435a34a3a3 100644
--- a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
@@ -674,6 +674,7 @@ static const struct snd_soc_acpi_link_adr mtl_cs42l43_l0[] = {
 		.num_adr = ARRAY_SIZE(cs42l43_0_adr),
 		.adr_d = cs42l43_0_adr,
 	},
+	{}
 };
 
 static const struct snd_soc_acpi_link_adr mtl_cs42l43_cs35l56[] = {
-- 
2.43.0



