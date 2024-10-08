Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5AF1DE4CD;
	Tue,  8 Oct 2024 12:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391290; cv=none; b=n/aGKG9mQuF0KgBN53bYL4yrjsso8flOBDgk6ggBU6fMb7VO0BBGEdhkP2LoYKsczVkE4LPIrR3ukR9FSvyZJijR/n8f+MykGbQs0gpPZEncFJebzdFOwuvnKNiKut2GhNqwJRhM29O4nMeVMgGNyjRwML+/kouTbSjK/bkYrIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391290; c=relaxed/simple;
	bh=2+1PGwTS0VnnL3YCC4GDgstNj2raFViRMBg78Pausrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k4RSnUzOBXO1NEAcohYetuAhALpLWWTQB/dsf8eS88DzERehC1nsjOBNEOsFPilOWVYTRKS2fZI+tir6Py9cGWSaAb1iS1PaFw1/pIHaEjZnvWAUVESQvARSMxGl+M/eUQQUnUs8cguIRXZOmt3UOndOPBrIeS33t4ZOc3tkBVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SO93xbgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SO93xbgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B867CC4CEC7;
	Tue,  8 Oct 2024 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391290;
	bh=2+1PGwTS0VnnL3YCC4GDgstNj2raFViRMBg78Pausrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SO93xbgF6k/eUEqWXlZJkHFC5LjT7A2OT2iGfQ3EeWn2v6dMKb7yeWGqfjlppSpB4
	 oZLmdH4G7VsTP8dEqVsfQgSYTx/Lo674orasTcUJ95nBKkstpgC53ewFV8XZsAAzrP
	 +Zmkhfmtal0I0cFGr+niLY7+cN5GcSjmiz9SU4JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 066/558] ASoC: Intel: soc-acpi-intel-rpl-match: add missing empty item
Date: Tue,  8 Oct 2024 14:01:36 +0200
Message-ID: <20241008115704.814478505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 5afc29ba44fdd1bcbad4e07246c395d946301580 ]

There is no links_num in struct snd_soc_acpi_mach {}, and we test
!link->num_adr as a condition to end the loop in hda_sdw_machine_select().
So an empty item in struct snd_soc_acpi_link_adr array is required.

Fixes: 65ab45b90656 ("ASoC: Intel: soc-acpi: Add match entries for some cs42l43 laptops")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20241001061738.34854-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-rpl-match.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-rpl-match.c b/sound/soc/intel/common/soc-acpi-intel-rpl-match.c
index bc8817633b81b..b83ac2e6337cf 100644
--- a/sound/soc/intel/common/soc-acpi-intel-rpl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-rpl-match.c
@@ -198,6 +198,7 @@ static const struct snd_soc_acpi_link_adr rpl_cs42l43_l0[] = {
 		.num_adr = ARRAY_SIZE(cs42l43_0_adr),
 		.adr_d = cs42l43_0_adr,
 	},
+	{}
 };
 
 static const struct snd_soc_acpi_link_adr rpl_sdca_3_in_1[] = {
-- 
2.43.0



