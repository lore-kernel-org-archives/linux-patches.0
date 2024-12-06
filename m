Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B077110E0;
	Fri,  6 Dec 2024 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496506; cv=none; b=XSHhN8fQ93iSIQdLxVCV1+nhho1Xrty88oWyFtsuVm5c+WbRHWP8FxQg1t8OZNiAcAdrL473saayNZoaahKHDGlB6VP0VPrlG5lIpJzF0XtF7vfQUkq5nx7RY2MB+9KRICKOwFAvM2T/qNphRtm6DFG7qL8CufeBx6aJSnkCmlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496506; c=relaxed/simple;
	bh=Jt/DSZibWf3KmYz7SLCQW0sIjoLASoP03SLJxUQ+bmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUUOgVswH63XR02c+CxbTRyo1y3osdtXoYrFeBjkmtidJd1F7E4ELUuceKXBSPSwaau5XNWRjUfXGSKRGRK5qOW8TqWuSA9hiAuELtymLYfwXONaF/mv1dCXc8TXWCgXbOR01LTTWeMCypVihRcPVtlRAv/400yMCdpb4uxDZiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSmnnEsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSmnnEsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237B4C4CEDF;
	Fri,  6 Dec 2024 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496506;
	bh=Jt/DSZibWf3KmYz7SLCQW0sIjoLASoP03SLJxUQ+bmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSmnnEsWiajCgjU+Dffq0FvPwrcnE7oB3k8nDbDvECcXcB2+nQWKgURIsncOT0T+I
	 lrF+CMyfR7j5pfYzyFwHQ+o5mzEOXUog7g3+lCdL+ARwCfykhZH0otMgovWsj/pCLd
	 /X9fQs8S2MvJpZogBaX15041GYRjV2B4rdrnFyxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Petri <mp@mpetri.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/676] ASoC: amd: yc: Support dmic on another model of Lenovo Thinkpad E14 Gen 6
Date: Fri,  6 Dec 2024 15:27:23 +0100
Message-ID: <20241206143654.303510662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Markus Petri <mp@mpetri.org>

[ Upstream commit 8c21e40e1e481f7fef6e570089e317068b972c45 ]

Another model of Thinkpad E14 Gen 6 (21M4)
needs a quirk entry for the dmic to be detected.

Signed-off-by: Markus Petri <mp@mpetri.org>
Link: https://patch.msgid.link/20241107094020.1050935-1-mp@localhost
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 08f823cd88699..04700e7471ca5 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -227,6 +227,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21M3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M4"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



