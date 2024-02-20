Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7C8151CE5;
	Tue, 20 Feb 2024 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464008; cv=none; b=fjW09F17dcDejpycyPsdVtj0S9LWf4V21X9NNCiY3uuq8IwiyOr4FIXP4tPxuOBuMZnekLFl0+fm4Om9xQXCRR+0ga6yWxZuWXb7rgay9WggndRigOuoSw7zAI7laRxp5mteTDMFodt+8pKyhviQYMhct9YbMpzoP2Ffv1pNsxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464008; c=relaxed/simple;
	bh=wxS1ZRA3ZiXlwEty0CFpLYvd934106efxjFx5fl0z5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgv37S4QlTRumfHeOvR41vcbUIg70iMuRBoyvMYTzI1nhEiHpIvFFGdz2LqE41do7ps0/rP6g7P3Js4arDmqRv9HufIixJJnxf8duPLXn1jvMzZnBAxDYyxzOU9dgnWPqcXPIokAE+j5VoYPg9C0tJEZEEGyAg1Q5hhEmbyxumw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3vUohCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3vUohCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50735C433C7;
	Tue, 20 Feb 2024 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464007;
	bh=wxS1ZRA3ZiXlwEty0CFpLYvd934106efxjFx5fl0z5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3vUohCVmJonzknmu0gQfy1aEUs7PjUQh7xvVLv1SE0wgtAVs6elgpGZM3nJZ1GDq
	 SEOBCkogtJOfS6oswfb/LIdyOWiQeuVc6FmsbMTtVYzyhxg3+UP8uaCywdq5zbdWfh
	 sm11FA6GLt99k9nWeFJVSbIRR+tsZH+j5oKWmHLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Petrov <stanislav.i.petrov@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 223/331] ASoC: amd: yc: Add DMI quirk for Lenovo Ideapad Pro 5 16ARP8
Date: Tue, 20 Feb 2024 21:55:39 +0100
Message-ID: <20240220205644.740282961@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


