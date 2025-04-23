Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFC2281376;
	Wed, 23 Apr 2025 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420289; cv=none; b=aqDaFQGWbFa7wnWmz0faLbgc3NNlLJF4wp05VYeVf4z+ZLs03f88qhFL0sFAVHTdDD/aXWM/Kj57Z3N9+rT7GjI7zbQhFVS7vOhBNSEOBxPAyJEKgMSw/OirQht9uwu+7KYJkTfI9IYwyByhr/wOvc0A3UKzj2y5ubLlcpoZrw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420289; c=relaxed/simple;
	bh=B3gMOjVve80gNTL9UEljEdLyuGmj1PKn2LgTzRve9Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+4uLDRABySkAfyRauBtEvBfUcjLN/ZtFkXNK9NGLtnwLPLCyT23JPU1wiX4+CTCIIFBccNuN0nODj61KuZtle0DUmnPzGKr5qgmrOErblHLBFI6PoLbGp/0u5b98Qd8QdYy3kJxhV98MkGcWN0qKLaVjwwzEBqcz85D2EZ/vak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jn8qt/Mu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jn8qt/Mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BC0C4CEE2;
	Wed, 23 Apr 2025 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420289;
	bh=B3gMOjVve80gNTL9UEljEdLyuGmj1PKn2LgTzRve9Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn8qt/MuIeByjn749jrMDT1cDnBVzsmuizhyklEmBhtfcWiOFYtVF5pEDPu426PC+
	 aaQtxA6eq3+0KBe9Pq7e20MXzeCfJVjpY+Bjy7XekeGE9XWjND2yU8XG1a7iVebu0v
	 /PtKa33UF1xyDsHZgTu2EJ4Z7BGXAIq81EbD29lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	keenplify <keenplify@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/291] ASoC: amd: Add DMI quirk for ACP6X mic support
Date: Wed, 23 Apr 2025 16:40:23 +0200
Message-ID: <20250423142625.786195034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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
index 77ea8a6c2d6d9..1f94269e121af 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -479,6 +479,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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



