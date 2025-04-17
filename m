Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB842561BD;
	Thu, 17 Apr 2025 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912684; cv=none; b=lbM8WDP0lw0wqWudNL2vLPf12RqkLGAKqBJedBr71tG+0W1pq2vdgd3G/UfPgxPuznLMde5hGQTtZvRg7HfCFsD5dao0oLIQRqgq/SL8+itaaTUVOtVSQ/rnZapTVnW64c8XMARDlTO8Wmbz4cb+O3B2ZQdBJ+0ukbxvQ1ovcTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912684; c=relaxed/simple;
	bh=Pe4GjqkF3mhkHbXD+5fC1jV4On4roq9W6S3v6UQATJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZx8KA5GK/4fUGyAzuTJVtQGqlUVQioqETFQfXtxgcxMcSgBJQiOoae+/IOpujOha1eMhCbCrr1dxWF4TIbkXa74mJw3WLG/k9OZSpcVTxgJcUwIvQjAaex7erOeUdBliTktt6qgg4E64NEkNZnfbaTZR+yKhmUTZ0uxkEC97JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1F0ytXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1F0ytXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0730C4CEE4;
	Thu, 17 Apr 2025 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912684;
	bh=Pe4GjqkF3mhkHbXD+5fC1jV4On4roq9W6S3v6UQATJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1F0ytXc6rjiUB/2eO3FRS9HzfKxvECLfeamZA+Nn72T+mNJpJcIxfl1iKqttIjqS
	 SoZ5hmWvV9wssJFzqqw0wY2wv8/q6YXLk3QjQ0LaXhsATXMQ39B0/GrRFHSen/bpK+
	 j/knMacHvQczUeIY9ZPcwZT+YsTQ6etRMLqNzZVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	keenplify <keenplify@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 090/449] ASoC: amd: Add DMI quirk for ACP6X mic support
Date: Thu, 17 Apr 2025 19:46:18 +0200
Message-ID: <20250417175121.590926141@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: keenplify <keenplify@gmail.com>

[ Upstream commit 309b367eafc8e162603cd29189da6db770411fea ]

Some AMD laptops with ACP6X do not expose the DMIC properly on Linux.
Adding a DMI quirk enables mic functionality.

Similar to Bugzilla #218402, this issue affects multiple users.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219853
Signed-off-by: keenplify <keenplify@gmail.com>
Link: https://patch.msgid.link/20250315111617.12194-1-keenplify@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index a7637056972aa..bd3808f98ec9e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -584,6 +584,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "pang13"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7UCX"),
+		}
+	},
 	{}
 };
 
-- 
2.39.5



