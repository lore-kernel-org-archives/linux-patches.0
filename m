Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C48B26D4DF;
	Tue, 11 Nov 2025 01:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824373; cv=none; b=TYe3pokQznZdl0ZTGVhSoZoOOwqPCdxslwDXc/oavM5wXog4m2IfoXIc/cwn4nN0cLXSnjyIuxM++YKIeHVkHEMPj2SZ/2xOupYqNtTFortJtZu9Zg0pOXNSo+lLX7kbHimTJ26i0lljLDXrEWwrt/kM7+mdh6OahIj/WZNJkgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824373; c=relaxed/simple;
	bh=D+J05+i+oifaNjwTcpFUuTQR/2EmloALNTodOpV7A3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UC1L7VTWL3WDtAGpyHuUGVcQBSKZcjxib0tt0UV6xyuEo7Pu+vzpZkmTjk3KC+HU49BznU6BMhNrd36vVaZC6gJhGYaz9jZIcadmjZMfdG9DtQpn2wMKHPwJQrqQsVBGf6fgHXW/dR+U+m4ZedpP8+MvG2P4x+zNFJKsMAVFf6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkq17eUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkq17eUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6C7C19422;
	Tue, 11 Nov 2025 01:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824372;
	bh=D+J05+i+oifaNjwTcpFUuTQR/2EmloALNTodOpV7A3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkq17eUQAOiAIplZHNQdehQZKdpCYCOHOQw3EYGBEiRSMITuWOIVjzq2zdNUAGmg4
	 Jup2F4GSuBDxoy5dopCy0OrKI/LBpJl4BqEfqeHCqgEvuJPdeuYkXNAZGREiXAxiNm
	 +KxpydLus4aRaWKBL8CtsyXeuLb1AYpw8iNBYopg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nidhish A N <nidhish.a.n@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 482/849] wifi: iwlwifi: fw: Add ASUS to PPAG and TAS list
Date: Tue, 11 Nov 2025 09:40:52 +0900
Message-ID: <20251111004548.095756985@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 3d6d1a85bb51b..a59f7f6b24da0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -59,11 +59,16 @@ static const struct dmi_system_id dmi_ppag_approved_list[] = {
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
@@ -141,11 +146,16 @@ static const struct dmi_system_id dmi_tas_approved_list[] = {
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



