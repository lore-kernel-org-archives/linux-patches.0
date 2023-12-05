Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90CF6FB1;
	Tue,  5 Dec 2023 03:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+BRo0Pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683E4C433C7;
	Tue,  5 Dec 2023 03:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747580;
	bh=a98O+MzXfTIis7bIA8EGJ5DSU7yM1xKEi79VwgVGDaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+BRo0PaGcLVgoDx9qw2z2ed21A8XPgEAqRGiOGxvd75D1gNbETpI6Tco/glJisVY
	 m9bNYJpL96It+Ys4KWn9GcBTI2LAVbtNlGq8iw841Gk2p2RCLsbz7tV2GFVPcptjkh
	 CbCrkbqp4zcDrgdvJGGT3SRP8YWxdhFZXXwP/mXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Hasemeyer <markhas@chromium.org>,
	Curtis Malainey <cujomalainey@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/135] ASoC: SOF: sof-pci-dev: Fix community key quirk detection
Date: Tue,  5 Dec 2023 12:17:11 +0900
Message-ID: <20231205031537.708974161@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Hasemeyer <markhas@chromium.org>

[ Upstream commit 7dd692217b861a8292ff8ac2c9d4458538fd6b96 ]

Some Chromebooks do not populate the product family DMI value resulting
in firmware load failures.

Add another quirk detection entry that looks for "Google" in the BIOS
version. Theoretically, PRODUCT_FAMILY could be replaced with
BIOS_VERSION, but it is left as a quirk to be conservative.

Cc: stable@vger.kernel.org
Signed-off-by: Mark Hasemeyer <markhas@chromium.org>
Acked-by: Curtis Malainey <cujomalainey@chromium.org>
Link: https://lore.kernel.org/r/20231020145953.v1.1.Iaf5702dc3f8af0fd2f81a22ba2da1a5e15b3604c@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index 42e1a62789bc6..ade292a61ed6d 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -96,6 +96,13 @@ static const struct dmi_system_id community_key_platforms[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google"),
 		}
 	},
+	{
+		.ident = "Google firmware",
+		.callback = chromebook_use_community_key,
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VERSION, "Google"),
+		}
+	},
 	{},
 };
 
-- 
2.42.0



