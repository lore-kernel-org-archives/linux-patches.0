Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBB3612D7;
	Tue, 20 Feb 2024 21:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465202; cv=none; b=iPT4XHI5gCZ9xe0ebxwkV7UTfe8tZH15uAuqGDWm8/3MpkWbyzsHTmaIlsMv1POLpQ9ZnQBlZA+J15lkGFo1dV5nR5eOaLIT4+1PBANDrUYuz+j83sIukZcNEoIZUYCYeETRY4YLTHLdlQfRlMDo88DKmzhxWtu2zKHGjifh7/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465202; c=relaxed/simple;
	bh=crtkNcit4fmCawRauSrupCG/3T0uxhC4Sp/qjSuWW40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtKG9Q3TBoQDIY1thdG1vMdzJPFWr6Rrua6mBrFYok5dUBMDxVbSMSK/Ao1WrXvxHyaIVdyr0lHwNYehQ1SSKvMRCA3wvmF7miHDwkoVtqV4GOyj29wt/o2mupDpx5ub2odfIu3/QAivf5lezst6DRJknLe3esbm8F859N2Tm3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5aiSuSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5aiSuSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77647C433C7;
	Tue, 20 Feb 2024 21:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465201;
	bh=crtkNcit4fmCawRauSrupCG/3T0uxhC4Sp/qjSuWW40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5aiSuSEQgL52HnTli2is2eOfe9pMVg1sG6LfNIaLy5kZ0GMHjbvZ2jsyptE2/MVj
	 +g53k4QE2m84NJRX0CZpfE4nsL8dOxDwNj6fZgjEJsqgBz/W9PXpA3moNgUIV8KuJn
	 lBTS83q92HBEBLmAYmWPM1PvFmdjZNdm1Y0od2Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Petrov <stanislav.i.petrov@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.7 269/309] ASoC: amd: yc: Add DMI quirk for Lenovo Ideapad Pro 5 16ARP8
Date: Tue, 20 Feb 2024 21:57:08 +0100
Message-ID: <20240220205641.560028057@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 610010737f74482a61896596a0116876ecf9e65c upstream.

The laptop requires a quirk ID to enable its internal microphone. Add
it to the DMI quirk table.

Reported-by: Stanislav Petrov <stanislav.i.petrov@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216925
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20240205214853.2689-1-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -251,6 +251,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83AS"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}


