Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBD41D55F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/f3Z/AO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BC0C433C7;
	Mon, 16 Oct 2023 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467649;
	bh=uIQQXvud9xg///O3weg613GzpBQ+Xo4Kzpg0jhhk1d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/f3Z/AOfCmx8hgJf1p04sbRyLyqNQ4e5VSKLa9m/MgJeE44EnNqQDsoWBm7xJWa/
	 0frXgBqQR4wxYZ3O9VkJALicDg/1LfWSHn+ARIXjzX18valSOG3lB1NWsChUVYnZT7
	 U36g5cMeG9kC8x1Y3y91tnOtHQljlWHeBnEJVfe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 033/191] ASoC: Intel: soc-acpi: fix Dell SKU 0B34
Date: Mon, 16 Oct 2023 10:40:18 +0200
Message-ID: <20231016084016.171790163@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit b399f9706a1cbae42731cc420a46cfb9c3c6b10f upstream.

The rule for the SoundWire tables is that the platforms with more
devices need to be added first. We broke that rule with the Dell SKU
0B34, and caused the second amplifier for SKU 0AF3 to be ignored.

The fix is simple, we need to move the single-amplifier entry after
the two-amplifier one.

Fixes: b62a1a839b48 ("ASoC: Intel: soc-acpi: add tables for Dell SKU 0B34")
Closes: https://github.com/thesofproject/linux/issues/4559
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20230919083606.1920202-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/common/soc-acpi-intel-adl-match.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -649,18 +649,18 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 		.sof_tplg_filename = "sof-adl-rt1316-l2-mono-rt714-l3.tplg",
 	},
 	{
-		.link_mask = 0x3, /* rt1316 on link1 & rt714 on link0 */
-		.links = adl_sdw_rt1316_link1_rt714_link0,
-		.drv_name = "sof_sdw",
-		.sof_tplg_filename = "sof-adl-rt1316-l1-mono-rt714-l0.tplg",
-	},
-	{
 		.link_mask = 0x7, /* rt714 on link0 & two rt1316s on link1 and link2 */
 		.links = adl_sdw_rt1316_link12_rt714_link0,
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-adl-rt1316-l12-rt714-l0.tplg",
 	},
 	{
+		.link_mask = 0x3, /* rt1316 on link1 & rt714 on link0 */
+		.links = adl_sdw_rt1316_link1_rt714_link0,
+		.drv_name = "sof_sdw",
+		.sof_tplg_filename = "sof-adl-rt1316-l1-mono-rt714-l0.tplg",
+	},
+	{
 		.link_mask = 0x5, /* 2 active links required */
 		.links = adl_sdw_rt1316_link2_rt714_link0,
 		.drv_name = "sof_sdw",


