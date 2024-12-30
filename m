Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A65715E8B;
	Mon, 30 Dec 2024 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574118; cv=none; b=mSDzR4y9oid/HgNovDCV/a7hJ306lgjH3uUSG9ku2bs9OFr8bIFjleB6/a06IuExfE1ZA96/0ovBqT8TPTkdEme2jT6TdcEIqEtx5uVR9JnxohiGysnsQ7aIHGNRcoUtgwerqS4zos7r6h/1oB4c4dcr27PYfwxhlxm/9CmEv3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574118; c=relaxed/simple;
	bh=B6/afbvMxUQUiGbQG/jtAPYa5WQ7hT9CIizZal7q+CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFEn5yf13Ed629OrQawkr6OIpk0HA3zqDqJJG6nQcLpfwC9D598vApddLbXMe2EoAjzD3QzqZG/sF5gypxNXNNz/Bide2FMYIqsFIZwRaUPiWaNId7N0vzyiEM9ezQFxSFbJMV7jQRhUQHS21q1B0efwX/yGwkma03PC84cG+58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7dHqkBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7dHqkBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FCAC4CED0;
	Mon, 30 Dec 2024 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574116;
	bh=B6/afbvMxUQUiGbQG/jtAPYa5WQ7hT9CIizZal7q+CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7dHqkBTf2yAm0wa8FseVX7otuBqLLjooSDEPH7wO6DazmqIPftbxf+H/qthTDwzP
	 eShlOBU2q7hU2rXj/dWS1recHdMns+1t7TcbHJJeOWiaUk302ARlNo0mXfbK5Fso0b
	 d4BOr6ejiqgd2vZbfXVrw63SL1b9ymQyMSgprzKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 041/114] ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 21Q6 and 21Q7
Date: Mon, 30 Dec 2024 16:42:38 +0100
Message-ID: <20241230154219.641225146@linuxfoundation.org>
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

commit 7c449ef0fdce540bfb235a2d93e7184864c3388b upstream.

Update the DMI match for a Lenovo laptop to the new DMI identifier.

This laptop ships with a different DMI identifier to what was expected,
and now has two identifiers.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 83c062ae81e8 ("ASoC: Intel: sof_sdw: Add quirks for some new Lenovo laptops")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241216140821.153670-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_sdw.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -626,9 +626,17 @@ static const struct dmi_system_id sof_sd
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "233B")
+			DMI_MATCH(DMI_PRODUCT_NAME, "21Q6")
 		},
-		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS),
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS | SOC_SDW_CODEC_MIC),
+	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21Q7")
+		},
+		.driver_data = (void *)(SOC_SDW_SIDECAR_AMPS | SOC_SDW_CODEC_MIC),
 	},
 
 	/* ArrowLake devices */


