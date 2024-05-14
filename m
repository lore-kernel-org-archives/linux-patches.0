Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232DA13C684;
	Tue, 14 May 2024 10:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683239; cv=none; b=kgkthCjcLv2I2U5Da6It/dhLOO2MGj9Fmzy9xrIKJSzuBv1oxo6MRN4XY+TZTH2oXKHsYk1weWAHRkitUHXU1cxZ/T6YH4KAtSaYCeVOgPYwenlnF1NJWeCslIHfzljy/sn4N8g9kGEk6pR8z0SzEno3hPYBlwnUURraYwHu6xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683239; c=relaxed/simple;
	bh=RO3ZvG7g02Xbnae9VYS5GKHdhB437RJLogV/Vs2yxTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HYVys2ZF5Vc6Gka9Tz1lloRp2BGLQh36tsh8dAfIPvd0BqT7VqDOYHwwWPa5IxBGurP2FU8SBzGalFCXA86ir5DofTT7f8ScOkGLBeqWxNwQHFWN2Xr823CChhLkAulRyJAHbBU93ZjBigXVYY1LA5tvo2bbz3cX0Gg/Lxvd8gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5upJp1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5upJp1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844FBC2BD10;
	Tue, 14 May 2024 10:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683239;
	bh=RO3ZvG7g02Xbnae9VYS5GKHdhB437RJLogV/Vs2yxTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5upJp1c99cnKWTJQ6h7f3UtoJTDS7QpaiydXJ1cchIZIjI5TQTcmUxi3KZYh2Dx3
	 mmk9D7MglhXjc0HPdCjdhZklfeWYuUX4YtSm0Lalz0N5NIZ/Wv+VZI6ITYvtT/BBdi
	 gQeBuGp/xJpzVcDh6mvdgTFwmFDTrfL6gUcF6slU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 189/336] platform/x86/amd: pmf: Decrease error message to debug
Date: Tue, 14 May 2024 12:16:33 +0200
Message-ID: <20240514101045.736404980@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 03cea821b82cbf0ee4a285f9dca6cc1d660dbef3 ]

ASUS ROG Zephyrus G14 doesn't have _CRS in AMDI0102 device and so
there are no resources to walk.  This is expected behavior because
it doesn't support Smart PC.  Decrease error message to debug.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218685
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240410140956.385-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmf/acpi.c b/drivers/platform/x86/amd/pmf/acpi.c
index f2eb07ef855af..1c0d2bbc1f974 100644
--- a/drivers/platform/x86/amd/pmf/acpi.c
+++ b/drivers/platform/x86/amd/pmf/acpi.c
@@ -309,7 +309,7 @@ int apmf_check_smart_pc(struct amd_pmf_dev *pmf_dev)
 
 	status = acpi_walk_resources(ahandle, METHOD_NAME__CRS, apmf_walk_resources, pmf_dev);
 	if (ACPI_FAILURE(status)) {
-		dev_err(pmf_dev->dev, "acpi_walk_resources failed :%d\n", status);
+		dev_dbg(pmf_dev->dev, "acpi_walk_resources failed :%d\n", status);
 		return -EINVAL;
 	}
 
-- 
2.43.0



