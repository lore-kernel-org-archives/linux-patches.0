Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D1F2AE68;
	Mon, 30 Dec 2024 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574110; cv=none; b=OrI9gsjltijMb70z6fnlGTUo8yqLO/j3JGR+uCwvT06LRhD5SyzLWFhhe1QFQ8HLL8aMoo3YdAmWABRkG6ElNsxiC1vnTnZROYm2/0XItnTE9aBF8GeKHw7JngyBQR7nytnPlUXEpT8ORnuYeyRhrkdStImz8ARQyb+y4m4b7RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574110; c=relaxed/simple;
	bh=4pmSZRdoh1m8bvowR7Bx1KTijlNBezG4FH/l0p6Sd+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpDeu0vmkIrjCk+Ba17PrJ20ynY8oSYycpIDhgaPz6uj7bIzrXv143fE1FUcGK5BxXd10O/hSqrgZZbQ5ZO+eISWydk11KTyaIvVrtYz5EgR6yO2WOaadohbC956/e+RBcn4jM3UHO1idjJmzPwaorjTV40Xzg2wAz0pMnH8OEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/ME/RLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/ME/RLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E549CC4CED0;
	Mon, 30 Dec 2024 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574110;
	bh=4pmSZRdoh1m8bvowR7Bx1KTijlNBezG4FH/l0p6Sd+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/ME/RLwjAgcWxvi52rMjZxF4PDATMBSGX7SChJfV2Qu0GnFVtUpw8IYOeHlyj0nQ
	 TtrQJr5ScHeENPqk7Y7FFbs95G3EUfsvUnlrMuGeQ6QjGqwz7yBpULZ9pFwdP5xF39
	 O7X/RAauchWpMoFVYWc//BI/T16JNzF2BlqIh9yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 039/114] ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 21QA and 21QB
Date: Mon, 30 Dec 2024 16:42:36 +0100
Message-ID: <20241230154219.566935730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit ba7d47a54bf23a7201bdd2978e16b04fc1cb1f6e upstream.

Update the DMI match for a Lenovo laptop to the new DMI identifier.

This laptop ships with a different DMI identifier to what was expected,
and now has two identifiers.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: ea657f6b24e1 ("ASoC: Intel: sof_sdw: Add quirk for cs42l43 system using host DMICs")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241216140821.153670-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_sdw.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -608,7 +608,16 @@ static const struct dmi_system_id sof_sd
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "233C")
+			DMI_MATCH(DMI_PRODUCT_NAME, "21QB")
+		},
+		/* Note this quirk excludes the CODEC mic */
+		.driver_data = (void *)(SOC_SDW_CODEC_MIC),
+	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21QA")
 		},
 		/* Note this quirk excludes the CODEC mic */
 		.driver_data = (void *)(SOC_SDW_CODEC_MIC),


