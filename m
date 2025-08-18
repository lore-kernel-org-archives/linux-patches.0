Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D384431984A;
	Mon, 18 Aug 2025 12:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521698; cv=none; b=QvA7TyGD+1HRTicWWJR6OY2Cdpl9J9U1hH6ZbAa6Gfp3NpZdOgJUYZoxGmeyoF+zLhYGPU2U9CJdjG57cw0zLuD3lbQWOmnpBIPbnr31nIEDO2I5ChY6mu7Rsh302cS3gs+rdcwC8n9HjivOmiilvPpga0RtgcVt3YsjqRNto5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521698; c=relaxed/simple;
	bh=tmn3KtJaDc4Jb8c+3Puqzp3gPdO+l2CfYGYbPWbOwDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LuluuTHhzXe8MHgxU3eULeN1Oo8oRi/CctyOyrgvbCLWS2fkJbdc6f0kBxzLJVeMFfDuBi0cvhtscLkg54BmG7aky5//EtHbYNlnTsn3wJ0ZBrOAuebUApSpThiqgr1pa7ZwJShOZvOyikHP7VME4wL8//C0uveGvevIrCHiJqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIzSpuPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIzSpuPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42528C4CEEB;
	Mon, 18 Aug 2025 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521698;
	bh=tmn3KtJaDc4Jb8c+3Puqzp3gPdO+l2CfYGYbPWbOwDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIzSpuPd+237diuYDrhxQ+On/+HCpYERdC+gv+NeFi6JEU9AKSvOJITx6z7/wNH4V
	 8WJpevTU7Mix+lFe7JN77n0w3IaL6AgUKE79c2zO/e3AFt8dVsdfFet/az2ZXdUC80
	 zjrUOwU5RFVIaZmZXodmVJS0fn87IGoHhddTIFiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Berglund <adam.f.berglund@hotmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/444] platform/x86/amd: pmc: Add Lenovo Yoga 6 13ALC6 to pmc quirk list
Date: Mon, 18 Aug 2025 14:42:02 +0200
Message-ID: <20250818124452.543854419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4ff3aeb664f7dfe824ba91ffb0b203397a8d431e ]

The Lenovo Yoga 6 13ACL6 82ND has a similar BIOS problem as other Lenovo
laptops from that vintage that causes a rather long resume from suspend.

Add it to the quirk list that manipulates the scratch register to avoid
the issue.

Reported-by: Adam Berglund <adam.f.berglund@hotmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4434
Tested-by: Adam Berglund <adam.f.berglund@hotmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250718172307.1928744-1-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 7ed12c1d3b34..04686ae1e976 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -189,6 +189,15 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "82XQ"),
 		}
 	},
+	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4434 */
+	{
+		.ident = "Lenovo Yoga 6 13ALC6",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82ND"),
+		}
+	},
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/2684 */
 	{
 		.ident = "HP Laptop 15s-eq2xxx",
-- 
2.39.5



