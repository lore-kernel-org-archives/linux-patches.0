Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619BE1DDA15;
	Wed,  6 Nov 2024 12:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896115; cv=none; b=pewnu2hgq1dmTuwR9YvDLrkwXpTye+bBNlnir5kR0SIDld+a7a4TPQwhH/lSkDk4DOLYIkNWqLLQYBZf3fkBfckz+fqD67azFvZG1QBMGV+AHXj8ehdJOD9J/wBcLnsHh4sPzXlaheMUoTsR7DA0bPJD0Ne3HbuKlcB2fq0MIBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896115; c=relaxed/simple;
	bh=Dh52sPhpcg4nyUdDwlqZ3vZP8EXVdNyEUDzhHLfC7J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVmVriycbQ2IMnECQfDvNEJXnjYJGe6t9+spbsgzcTcHTFkI/l0J5dhjgSo0E7ps/hm+Gpcx66wC9WHfHvbReaqCtFPbdsUS2maY+k816zRH0iiSysAqXXP+Ox4ajwwgyjI0wSKLoGLNxloxtElVB8QRIc8zpfvGgR4OsKNutD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CK4mZy0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CK4mZy0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BCFC4CECD;
	Wed,  6 Nov 2024 12:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896115;
	bh=Dh52sPhpcg4nyUdDwlqZ3vZP8EXVdNyEUDzhHLfC7J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CK4mZy0ceRe3VCMy6q9o8A1tA7KO1yhz+0+4J8jByUURUgxre/V6qsZ5bktuVpohd
	 iC39OnmLcrNjglZW+FnS5gjn1gDqpI/Y8tpTDX0dP0mBmehkRWDCBMYl3OnoSfHXUx
	 kTalpm3Kt55lWXIKQB7IVA8xKeoRKeS6dlYWWufw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 095/245] ACPI: resource: Fold Asus Vivobook Pro N6506M* DMI quirks together
Date: Wed,  6 Nov 2024 13:02:28 +0100
Message-ID: <20241106120321.547183252@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1af7e441feb08cdaab8f4a320577ed0bba1f5896 ]

Asus Vivobook Pro 15 OLED comes in 3 N6506M* models:

N6506MU: Intel Ultra 9 185H, 3K OLED, RTX4060
N6506MV: Intel Ultra 7 155H, 3K OLED, RTX4050
N6506MJ: Intel Ultra 7 155H, FHD OLED, RTX3050

Fold the 3 DMI quirks for these into a single quirk to reduce the number
of quirks.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241005212819.354681-5-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index a904bf9a7f7db..42c490149a431 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -511,24 +511,10 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 		},
 	},
 	{
-		/* Asus Vivobook Pro N6506MV */
+		/* Asus Vivobook Pro N6506M* */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "N6506MV"),
-		},
-	},
-	{
-		/* Asus Vivobook Pro N6506MU */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "N6506MU"),
-		},
-	},
-	{
-		/* Asus Vivobook Pro N6506MJ */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "N6506MJ"),
+			DMI_MATCH(DMI_BOARD_NAME, "N6506M"),
 		},
 	},
 	{
-- 
2.43.0



