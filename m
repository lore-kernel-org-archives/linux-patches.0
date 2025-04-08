Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5414826659C;
	Tue,  8 Apr 2025 11:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110153; cv=none; b=EKx3QGHaU7Cfzc57/2bJHsTs3jZx2jqXkJ+tjt/LeSzNQ7HhIIanku9bSP4CXPRQEncCM35+foT/nI9CtTdFX1M0d4jCHy1cz/N47NN/TI2GnXGUuTVmLH5GajFs0UiaHk7Z0tdoTMgV79TfyrF7O1AnPFcF5MUSVkKP7NJbcI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110153; c=relaxed/simple;
	bh=tkdtkppInQ3yanHezVdwuAWSxf4GO82hARqnWVPfxgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fYnAAN5DBWIPoEukn+VyR1DhxALeybhQlwPo3atndIhapI0kKFdt5rEOiwWBSEklPAPmBRNAm/MNU9NoskXpb0WKmNjf2d1blXdk7Zmb6q0rPEDlweP29kLMVPf4s87DQoLNdhF8jM8u88ultcucCufkTvcfdYrZPtKkW4KnSuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEVfZnR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEVfZnR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A34C4CEE5;
	Tue,  8 Apr 2025 11:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110153;
	bh=tkdtkppInQ3yanHezVdwuAWSxf4GO82hARqnWVPfxgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEVfZnR/rMYv8O2RwRscAJtPotxxJdCEelCZpKkO32qR4qY/oXPbB83pst/g2ArY6
	 BpINnPHaYYQ2jRZ+wlKqVYWcmWKWqS+x8PSPU/5a954urB7iq4DZ3D3zlCS0gtFuf/
	 THQJ+M880MMbzaUFX8ssCe+XlzRQe4BKAfNIAyQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Panchenko <dmitry@d-systems.ee>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/227] platform/x86: intel-hid: fix volume buttons on Microsoft Surface Go 4 tablet
Date: Tue,  8 Apr 2025 12:49:25 +0200
Message-ID: <20250408104825.914318238@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Panchenko <dmitry@d-systems.ee>

[ Upstream commit 2738d06fb4f01145b24c542fb06de538ffc56430 ]

Volume buttons on Microsoft Surface Go 4 tablet didn't send any events.
Add Surface Go 4 DMI match to button_array_table to fix this.

Signed-off-by: Dmitry Panchenko <dmitry@d-systems.ee>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250220154016.3620917-1-dmitry@d-systems.ee
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 0b0602fc43601..9bc2652b15e71 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -100,6 +100,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
 		},
 	},
+	{
+		.ident = "Microsoft Surface Go 4",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 4"),
+		},
+	},
 	{ }
 };
 
-- 
2.39.5



