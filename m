Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835512E88A5;
	Tue, 17 Jun 2025 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174691; cv=none; b=Yc0suJzkzVphIayOESdpvE6UBODvDsnILrqkKvHSgkfoL+R3RNbHvZXu2COWY3CNkrzbTy2V5JEZU+cPBk5vjPO83TE5ugllcfS5NPNGjrlb5vLQGjRz7UtXmd34uEr6SdpmhaD/QEpPXZ4E/+P+hudY0BpzVOibVqJBEJhX/iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174691; c=relaxed/simple;
	bh=4lwwZl75SK8I30Uhy+x+guOruuTSfUu0ZQ9OIFFGxXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MicNKZ5IBYIWw/GGRwgqWAx/bYfq31Rekvx4je3kUoo+wEJj+cCOVDEMU7by7btFV+1nYfgf6LC62gHh5QQUwPy2I3wa7etFWMmXq5kHRlheMlavRfCqm2dJYN8HfRo0Ni5yC63o50zVKG0H2WeRqOlaIEAKocxt1A0OL9q7zoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxnRYoQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxnRYoQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7916C4CEE3;
	Tue, 17 Jun 2025 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174691;
	bh=4lwwZl75SK8I30Uhy+x+guOruuTSfUu0ZQ9OIFFGxXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxnRYoQ1rYl+XFy+7Mrgq0gWnJ15d5E1EaPBL1Pld/ELY+n7EeM5WheOyZnB0WY82
	 05q8anLMpwhCv/uDcYNtUcHuHQI9b48FN4JS6xbGhY6t6DieI9NvDbIG8FotiDEPXO
	 +izwv2or8PUNs8jQUIng0X5goymJCXwOi/JfMLOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/512] ACPI: resource: fix a typo for MECHREVO in irq1_edge_low_force_override[]
Date: Tue, 17 Jun 2025 17:20:17 +0200
Message-ID: <20250617152421.603700740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingcong Bai <jeffbai@aosc.io>

[ Upstream commit 113e04276018bd13978051d8b05a613b4d390cc9 ]

The vendor name for MECHREVO was incorrectly spelled in commit
b53f09ecd602 ("ACPI: resource: Do IRQ override on MECHREV GM7XG0M").

Correct this typo in this trivial patch.

Fixes: b53f09ecd602 ("ACPI: resource: Do IRQ override on MECHREV GM7XG0M")
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Link: https://patch.msgid.link/20250417073947.47419-1-jeffbai@aosc.io
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 14c7bac4100b4..7d59c6c9185fc 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -534,7 +534,7 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
  */
 static const struct dmi_system_id irq1_edge_low_force_override[] = {
 	{
-		/* MECHREV Jiaolong17KS Series GM7XG0M */
+		/* MECHREVO Jiaolong17KS Series GM7XG0M */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GM7XG0M"),
 		},
-- 
2.39.5



