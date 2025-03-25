Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD20D41C85;
	Tue, 25 Mar 2025 12:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905704; cv=none; b=YD71B2Q8FQ7uQ65RTm6rjZqLb+XkIPq39zZINtZyjdF4WPMtHwCwxfH5j4ZBByRJPHmXgQXx8q8chbme+p2k8HR7P39tlV+08/vRTUz1QWc/bklH+L6pGpUrVwE8g6spe6if0hiPDd0nuxEoLTDqc5YpOslPAFg7w+GMLex/pVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905704; c=relaxed/simple;
	bh=GKcVi+TSE0jWFzuxDmiYdGkKwiWlS84om56u5TfFyLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8LhCFQ28BJaejv5XUZQ+XzsIoRyXVkp3WFUdaDMniymh7R8GrZOQP709fX8ImbmGnIxLee2xTD3rx+xicQu6663aGwJJu0S1N7pslwypfwNGafe8yfwhHo9Lr0DmivfA9aU2Unb5L3CKg09lhQVDVVpRldiAIwNCrYxMfEbrHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gpyv2OFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gpyv2OFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E5DC4CEE4;
	Tue, 25 Mar 2025 12:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905704;
	bh=GKcVi+TSE0jWFzuxDmiYdGkKwiWlS84om56u5TfFyLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gpyv2OFPFLGTk2CtYh9B7BkjMPKFut4yfbdUe4Wj0MgHiA4+NeSeqOUHH5QbuJpFc
	 8FRceV7DSDReS+aknT3eoHDLNIRuNdyQ867FUSZiLWAGVNd+Py/eXrimc9TQ1cGob3
	 Y21p3h+2VhpYQhFe5mwSS2HxMFK/wZgcq9lWurCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Mizrahi <thomasmizra@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 119/198] ASoC: amd: yc: Support mic on another Lenovo ThinkPad E16 Gen 2 model
Date: Tue, 25 Mar 2025 08:21:21 -0400
Message-ID: <20250325122159.777197077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Mizrahi <thomasmizra@gmail.com>

commit 0704a15b930cf97073ce091a0cd7ad32f2304329 upstream.

The internal microphone on the Lenovo ThinkPad E16 model requires a
quirk entry to work properly. This was fixed in a previous patch (linked
below), but depending on the specific variant of the model, the product
name may be "21M5" or "21M6".

The following patch fixed this issue for the 21M5 variant:
  https://lore.kernel.org/all/20240725065442.9293-1-tiwai@suse.de/

This patch adds support for the microphone on the 21M6 variant.

Link: https://github.com/ramaureirac/thinkpad-e14-linux/issues/31
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Mizrahi <thomasmizra@gmail.com>
Link: https://patch.msgid.link/20250308041303.198765-1-thomasmizra@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -252,6 +252,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M6"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21ME"),
 		}
 	},


