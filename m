Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20314133987;
	Tue, 20 Feb 2024 21:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463132; cv=none; b=ghktSWVzdN/Sqjd5/wmrrEkuEdM2SfCf3p8M/9NQ3R8o4qP4skY4eoASM5/ntmil3gc7ODaduikraTFdKHjUzCVrDfZgQVPr+DH1DHEW6Bsw7vEswnzReyOBRgIGrqm0+UQDJzymxbyBcRa/I2r5b9OluiPRVBb9nd7FfydJLMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463132; c=relaxed/simple;
	bh=nHOUZHrfpj8diZFGW75Y+W3B0lV3M9/wJI553gPKA0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLCfHJz9l4spQrjHE1A7mXSflReDlNqaLnDf9QIak03tSoAnYLZg7jpslia3zZGdAG/q1AaVtF5SHjMXvb0oZHI60G3aSYrbWVfLeN/nAhY0NocECSKty/MwcmQ6K2iu4AnASogagi32lP2fA5rD76q2o33/G0oK4phxmpqtI9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaa7UJbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaa7UJbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BDAC433C7;
	Tue, 20 Feb 2024 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463132;
	bh=nHOUZHrfpj8diZFGW75Y+W3B0lV3M9/wJI553gPKA0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaa7UJbllQyBP9ep3qtNnq4qScPlBGM2QeGLqHLlH2mYK4+YsC7+cSV2P8zRV3Z2V
	 6dvvKOjfzG8VsUSCU33C2CYnHcO4Vd2Ldmd41LmICvaO/aU0wR9NtPQsr1SKkmms5K
	 cu1kRHbrk20VrIOo0ofhYHwiOv9n6rmsxTK1x8t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Petrov <stanislav.i.petrov@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 146/197] ASoC: amd: yc: Add DMI quirk for Lenovo Ideapad Pro 5 16ARP8
Date: Tue, 20 Feb 2024 21:51:45 +0100
Message-ID: <20240220204845.435867432@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -245,6 +245,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83AS"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82UG"),
 		}
 	},


