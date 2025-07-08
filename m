Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0C21714B7;
	Tue,  8 Jul 2025 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992903; cv=none; b=E9D/udDk5cIRTK7f4qZ1eum4b7fTm9OmW5Lql67KqJDtgJZJXeZii2nWt0T2EhiYV8M02uMMomcT5zTntvgMB9JFJWuCBf6TvQBkwl5RpPwQOyYciEk9UEFB/8YWNiRbAR5EOmF4WqMzggkzS7ZA/ICAtuujodYzOqrNEacdCJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992903; c=relaxed/simple;
	bh=nroM5GMJOuT5cYdOyQFbQmuafdDAgAtOWr544bUxhQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAatDm2elgouo0yOZ2m6/HMI77KKTLvTOHHapRY+hKwRQznRjyMQdRwrvSMQrLs8HyjzUuEriP/M87lGhsGjqnoROQ5iU9VPr+ZJ46hlM1INy11T5RqWoG3LBe/oT1EMwqe3X2YZ64nOX2b2j4YkS8gzdXL+egq2zih3I0FGDnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Zl0nQAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Zl0nQAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4BBC4CEED;
	Tue,  8 Jul 2025 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992903;
	bh=nroM5GMJOuT5cYdOyQFbQmuafdDAgAtOWr544bUxhQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Zl0nQAwR4K1IplwLLRlVZyQBIvklrpSVSC47jV70Bth9g/Vnc+OLUEp+ibkgvFHU
	 GzuMOE4g41yVnp3QvrkLQ+bO5ModZTmzLyHiEqmjYT7r49OdbC/mWJExYG22v0BTUH
	 tDqPMMC9x9MKg2MXjSIV1OGkRdfnHZiooZ+S4wEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/232] ACPI: thermal: Fix stale comment regarding trip points
Date: Tue,  8 Jul 2025 18:21:56 +0200
Message-ID: <20250708162244.581252227@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 01ca2846338d314cdcd3da1aca7f290ec380542c ]

Update the comment next to acpi_thermal_get_trip_points() call site
in acpi_thermal_add() to reflect what the code does.

It has diverged from the code after changes that removed the _CRT
evaluation from acpi_thermal_get_trip_points() among other things.

Signed-off-by: xueqin Luo <luoxueqin@kylinos.cn>
Link: https://patch.msgid.link/20250208013335.126343-1-luoxueqin@kylinos.cn
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 3f7cd28ae3d1 ("ACPI: thermal: Execute _SCP before reading trip points")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 78db38c7076e4..dbc371ac2fa66 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -803,7 +803,7 @@ static int acpi_thermal_add(struct acpi_device *device)
 
 	acpi_thermal_aml_dependency_fix(tz);
 
-	/* Get trip points [_CRT, _PSV, etc.] (required). */
+	/* Get trip points [_ACi, _PSV, etc.] (required). */
 	acpi_thermal_get_trip_points(tz);
 
 	crit_temp = acpi_thermal_get_critical_trip(tz);
-- 
2.39.5



