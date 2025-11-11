Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0183335060;
	Tue, 11 Nov 2025 01:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823972; cv=none; b=ok6RHgRvpREyEZs435PLvpGH7BNHiMQ58SiZ5WKnQsKIa0NKtPHqt8Tlj9AU9od73mjh/8c+44ykz78N4q6vG6LESrjFsL3a5Mm4kLvF4/ekTZZwiidPDFAN0ES332YOyOiAn4wzT09G19WrCay56QVuEC6WZcQBeWooRBNWsc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823972; c=relaxed/simple;
	bh=9nonu4U0rxm3Q6jjBPDcrpXfLZl4OqzhJazJQLy1iyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW87cxg12LEYJ3GRqQtiJ0u0BZdlGWoYUql6z9VTqoI2PRgIVjJaPFpSBZ0HEZ8VZAh0x/rxRxsbwkrIB4Yyg5fRF+s1KIJ/7wFI7dHVJoiWvlMqQ5UMP8L6Ge1C3i/wH3u2n0yIJ9MfS+jt6waTaGlDa+8FzJvwVmb/7tayMuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jnqd+S8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jnqd+S8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612ABC116B1;
	Tue, 11 Nov 2025 01:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823972;
	bh=9nonu4U0rxm3Q6jjBPDcrpXfLZl4OqzhJazJQLy1iyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jnqd+S8oCkD0hfbNWHOK3l4lI4O1rdbEQQzXt34j3OnOFaZdlQ3atYhx7xbgqg2AQ
	 kFqTaUxmK5i4vMC7YM8F/FY1FSy9a8+dhz2y+W12EuPEVxrqyD5vl1hjr95FYQdijM
	 fuyidrgIl8EdcMhrgLGmwkWXsL+FP6Yqv2JhQQKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nidhish A N <nidhish.a.n@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/565] wifi: iwlwifi: fw: Add ASUS to PPAG and TAS list
Date: Tue, 11 Nov 2025 09:42:53 +0900
Message-ID: <20251111004534.019168456@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nidhish A N <nidhish.a.n@intel.com>

[ Upstream commit c5318e6e1c6436ce35ba521d96975e13cc5119f7 ]

Add ASUS to the list of OEMs that are allowed to use
the PPAG and TAS feature.

Signed-off-by: Nidhish A N <nidhish.a.n@intel.com>
Reviewed-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250909061931.499af6568e89.Iafb2cb1c83ff82712c0e9d5529f76bc226ed12dd@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 4d9a1f83ef8c2..03af858440604 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -57,11 +57,16 @@ static const struct dmi_system_id dmi_ppag_approved_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 		},
 	},
-	{ .ident = "ASUS",
+	{ .ident = "ASUSTEK",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 		},
 	},
+	{ .ident = "ASUS",
+	  .matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+		},
+	},
 	{ .ident = "GOOGLE-HP",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
@@ -134,11 +139,16 @@ static const struct dmi_system_id dmi_tas_approved_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
 		},
 	},
-	{ .ident = "ASUS",
+	{ .ident = "ASUSTEK",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 		},
 	},
+	{ .ident = "ASUS",
+	  .matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+		},
+	},
 	{ .ident = "GOOGLE-HP",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
-- 
2.51.0



