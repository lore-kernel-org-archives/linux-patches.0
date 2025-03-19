Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC771D5CEA;
	Wed, 19 Mar 2025 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395044; cv=none; b=Jt7FiAv3d56spuME1VSUs/o98Kq7UlNTJOR7VxjJvGBq+8sLJwjXnFVJ5Jp7L/6cC8ZiIjxkq0d3Aqvkm9nn95VOMWuwfYZ6+qHNrEVd5jFMIsShMyuugeiwR4FR4bUkVPfesaV+1edpGogk36w4eWLSXa6aHzg0EdnmM3b1o1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395044; c=relaxed/simple;
	bh=7hUG8WHpQ3ynOIsJTSWMaIjkY0qvzHqDVs5vt1X1e7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnSzi6GbS/R94q73QxE8hzbruigfRYUbazwXo5Kutg6bbBUbOwe0o/QXFGKlZ1z0RKChrHkpsq9FD78IYqH6SdeGJc6mprVanyOdJI9Y8HO+c2bcgVbcN3jJ8u3Tmr0aKAimUS/qNBfS3cphRO15ZuYwxcEPsBNmVimJzisxR3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15MxjMtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15MxjMtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BDAC4CEE4;
	Wed, 19 Mar 2025 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395044;
	bh=7hUG8WHpQ3ynOIsJTSWMaIjkY0qvzHqDVs5vt1X1e7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15MxjMtS6MJBc8kEaFhXylmVQXn/60EHOHq0ZEKWw5xKSkMNvNROxemJtnPggFSaU
	 QXNzCY0e/EZWTYyBXqyJnonvkYX7igHqk1nqFqqWrhoEoLJI+IjRyhMZSa/BiAw3mY
	 gVsSSTbs1PLgDQP77QX/PB0WLX6mm3k8y9qjWsdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gannon Kolding <gannon.kolding@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/231] ACPI: resource: IRQ override for Eluktronics MECH-17
Date: Wed, 19 Mar 2025 07:29:22 -0700
Message-ID: <20250319143028.537258313@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Gannon Kolding <gannon.kolding@gmail.com>

[ Upstream commit 607ab6f85f4194b644ea95ac5fe660ef575db3b4 ]

The Eluktronics MECH-17 (GM7RG7N) needs IRQ overriding for the
keyboard to work.

Adding a DMI_MATCH entry for this laptop model makes the internal
keyboard function normally.

Signed-off-by: Gannon Kolding <gannon.kolding@gmail.com>
Link: https://patch.msgid.link/20250127093902.328361-1-gannon.kolding@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 90aaec923889c..b4cd14e7fa76c 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -563,6 +563,12 @@ static const struct dmi_system_id irq1_edge_low_force_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "RP-15"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "MECH-17"),
+		},
+	},
 	{
 		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
 		.matches = {
-- 
2.39.5



