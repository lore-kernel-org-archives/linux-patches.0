Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C3B2E338F;
	Tue, 15 Jul 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586719; cv=none; b=G1sxCBVBFno19gleTYAVodx8iXWofLZTJeId4KMy6h86vq3y15UCmagpXZ939pWkNbJwfnX5D8JU44tCqNO/aYaNyjjKkZX82m2HOp22pwDfhO0tsq89FMtSKqKiFSVqv65K9xn9T+vHeAuq26dhRxKX7/tMeicoBG7bWIDcq2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586719; c=relaxed/simple;
	bh=DXwzxJuO1vGV/IjyZtzGma2S1Ewr/KrUIq9GTwh2vLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pBBiwb/coLucVSl8gUueChVKD37tLQJr8QaJonwHAfJSUq8qaQdgdY67v6lp9kiZrVkY2+qveFN8yqUesEYdqypk4siF2FSHeWHM0zb3QJ0mlowdCjXHVnqjQZb2eAnvSNzjDmZcLUOj1kO7pl92qspUbJwEPa0sblzHDlfV790=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9XMEd1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9XMEd1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C34EC4CEE3;
	Tue, 15 Jul 2025 13:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586719;
	bh=DXwzxJuO1vGV/IjyZtzGma2S1Ewr/KrUIq9GTwh2vLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9XMEd1/j2zawXvkkzyVRad5FsMqgf1gt9OtQ/uzvHiR6ek90668ExpUbiJiIXNum
	 wIV9UnJLVZctvAw5Mem1SciNCpp4EMLo1FOjb3mWBC6jYPwzGPPzrtmiPuKWt3yFnV
	 FT0OsKVpEDTikIXOWkAtFg/A1MzQWMWoGK7BBn8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 005/192] ASoC: soc-acpi: add get_function_tplg_files ops
Date: Tue, 15 Jul 2025 15:11:40 +0200
Message-ID: <20250715130815.075781051@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit d1e70eed0b30bd2b15fc6c93b5701be564bbe353 ]

We always use a single topology that contains all PCM devices belonging
to a machine configuration.
However, with SDCA, we want to be able to load function topologies based
on the supported device functions. This change is in preparation for
loading those function topologies.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250414063239.85200-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a7528e9beadb ("ASoC: Intel: soc-acpi: arl: Correct order of cs42l43 matches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-acpi.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/sound/soc-acpi.h b/include/sound/soc-acpi.h
index 72e371a217676..b8af309c2683f 100644
--- a/include/sound/soc-acpi.h
+++ b/include/sound/soc-acpi.h
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/mod_devicetable.h>
 #include <linux/soundwire/sdw.h>
+#include <sound/soc.h>
 
 struct snd_soc_acpi_package_context {
 	char *name;           /* package name */
@@ -193,6 +194,15 @@ struct snd_soc_acpi_link_adr {
  *  is not constant since this field may be updated at run-time
  * @sof_tplg_filename: Sound Open Firmware topology file name, if enabled
  * @tplg_quirk_mask: quirks to select different topology files dynamically
+ * @get_function_tplg_files: This is an optional callback, if specified then instead of
+ *	the single sof_tplg_filename the callback will return the list of function topology
+ *	files to be loaded.
+ *	Return value: The number of the files or negative ERRNO. 0 means that the single topology
+ *		      file should be used, no function topology split can be used on the machine.
+ *	@card: the pointer of the card
+ *	@mach: the pointer of the machine driver
+ *	@prefix: the prefix of the topology file name. Typically, it is the path.
+ *	@tplg_files: the pointer of the array of the topology file names.
  */
 /* Descriptor for SST ASoC machine driver */
 struct snd_soc_acpi_mach {
@@ -212,6 +222,9 @@ struct snd_soc_acpi_mach {
 	struct snd_soc_acpi_mach_params mach_params;
 	const char *sof_tplg_filename;
 	const u32 tplg_quirk_mask;
+	int (*get_function_tplg_files)(struct snd_soc_card *card,
+				       const struct snd_soc_acpi_mach *mach,
+				       const char *prefix, const char ***tplg_files);
 };
 
 #define SND_SOC_ACPI_MAX_CODECS 3
-- 
2.39.5



