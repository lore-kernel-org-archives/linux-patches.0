Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF82F19A288;
	Fri, 24 Apr 2026 13:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037746; cv=none; b=b4QHTOqwnafC9ejhzjcROgeMX6VCGWz2L+MuTh4eY9H3h05JgWfKQDa3BWZj1pCaNhJyDzdNEwW3GXqWFEjoP2gC4ibmN4/fmdEyfyGx5eOnB5hT2ewkOQCPStN/pvzJ8spfIe7Dkocga+KI+V+hD1aDOFQ8PVUx0gfmGV4PjH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037746; c=relaxed/simple;
	bh=eqMEKDlxzgQmeRGvH4wXypgWdzfLxcikGypZgWlXszM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUEM7sxgteON+v0rKaJq05JIIQNFAsD4RHpPsS4a3gVAzlqqTtufSJYyu8vOPWgi5eR7egxqpN2E7iXCw/RWXAgZ+OZ6NdhjjYqHyf2WVkI543agXlPQkqgB6ZGTYU//y2mNcf0X/El/32ZpUmAjxv5hDslsgqe0LHGvhfM+3Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aA2mafBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aA2mafBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CD2C19425;
	Fri, 24 Apr 2026 13:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037746;
	bh=eqMEKDlxzgQmeRGvH4wXypgWdzfLxcikGypZgWlXszM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aA2mafBRze4aFPPZYuj1p6ESg0gL6og3NP5nMfCtxU0z2QE4toEJPXN0UazqNMG2S
	 JGGwDv3bB62qSwEUIfPA/XZpKiTuJGpvAMWBR5unGkfr1p35YA1+DxXD9KS/tJSi95
	 R8lIG/2C3D/DEOObvHqgjubRyKzPCzn7a0f2UDRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imrane <ihalim.me@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/166] platform/x86/amd: pmc: Add Thinkpad L14 Gen3 to quirk_s2idle_bug
Date: Fri, 24 Apr 2026 15:28:54 +0200
Message-ID: <20260424132537.029497143@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1a9452c428a6b76f0b797bae21daa454fccef1a2 ]

This platform is a similar vintage of platforms that had a BIOS bug
leading to a 10s delay at resume from s0i3.

Add a quirk for it.

Reported-by: Imrane <ihalim.me@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221273
Tested-by: Imrane <ihalim.me@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260324211647.357924-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index a6006b4ec2cc0..a3921f8106c12 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -197,6 +197,15 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "82XQ"),
 		}
 	},
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=221273 */
+	{
+		.ident = "Thinkpad L14 Gen3",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21C6"),
+		}
+	},
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4434 */
 	{
 		.ident = "Lenovo Yoga 6 13ALC6",
-- 
2.53.0



