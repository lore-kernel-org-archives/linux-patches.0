Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF00330B2E;
	Fri, 17 Oct 2025 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715942; cv=none; b=Wvxmku8EwyYs83sWa/7dNKJZ2VCi8ge8QPoc2bwE9VNlR8cpWsXdu6Q7GFdMGSCYSdOLnYUU8LruT4czUuSDNbIX9lSjqGfB6aoZUWZM5Cw9nRgdyyGSEVBgiKGj1ozPnBI5Qj5nDZg3X1G2U7aq++eSEI6zcoGEAjhZQ/KvFs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715942; c=relaxed/simple;
	bh=5cgFEaNm7+GC14hGZJXy4jGYVDTSpFXizv/Soej44HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZ9T/Ffho/hXSQnabzEuEXUi6gKxIP54gC4oAumPM5x4Wjv8NAp9PXBm6UzB4E7N8n76i9eWENH0i9JBMrupTMVP2Q4EWKsJmeDGPDYAjQkATBzf0kp1jWDmE9thFmDZUmdqNsGSc5R8mFyRLsc0oUurynabyh++eRMksVVsB+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Po+lhMcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Po+lhMcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6641C4CEE7;
	Fri, 17 Oct 2025 15:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715942;
	bh=5cgFEaNm7+GC14hGZJXy4jGYVDTSpFXizv/Soej44HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Po+lhMclS4erVVxmsWlYK5Jk3fiARtqknodW87wWQ4ZtYhzRoYIC9DhHZ5rrWBHO5
	 evRecCjaYp5CTZ1J3EBABdiFs+UGrCdb95nTxqqC4+HGuGgvZ/JgYZtBsLxliSa+2F
	 Xg6dQ/pni0GUwPXqr4xIbyX1snzeGPQbMlFMydTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>
Subject: [PATCH 5.15 019/276] platform/x86: int3472: Check for adev == NULL
Date: Fri, 17 Oct 2025 16:51:52 +0200
Message-ID: <20251017145143.103424643@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit cd2fd6eab480dfc247b737cf7a3d6b009c4d0f1c upstream.

Not all devices have an ACPI companion fwnode, so adev might be NULL. This
can e.g. (theoretically) happen when a user manually binds one of
the int3472 drivers to another i2c/platform device through sysfs.

Add a check for adev not being set and return -ENODEV in that case to
avoid a possible NULL pointer deref in skl_int3472_get_acpi_buffer().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241209220522.25288-1-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[iwamatsu: adjusted context]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/int3472/discrete.c |    3 +++
 drivers/platform/x86/intel/int3472/tps68470.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -345,6 +345,9 @@ static int skl_int3472_discrete_probe(st
 	struct int3472_cldb cldb;
 	int ret;
 
+	if (!adev)
+		return -ENODEV;
+
 	ret = skl_int3472_fill_cldb(adev, &cldb);
 	if (ret) {
 		dev_err(&pdev->dev, "Couldn't fill CLDB structure\n");
--- a/drivers/platform/x86/intel/int3472/tps68470.c
+++ b/drivers/platform/x86/intel/int3472/tps68470.c
@@ -102,6 +102,9 @@ static int skl_int3472_tps68470_probe(st
 	int device_type;
 	int ret;
 
+	if (!adev)
+		return -ENODEV;
+
 	regmap = devm_regmap_init_i2c(client, &tps68470_regmap_config);
 	if (IS_ERR(regmap)) {
 		dev_err(&client->dev, "Failed to create regmap: %ld\n", PTR_ERR(regmap));


