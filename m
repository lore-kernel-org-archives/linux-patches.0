Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D42211A34;
	Thu, 12 Dec 2024 16:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020151; cv=none; b=LEvx58VoigOteExb7tKvMu7+7SMsgULmptvO79Eq5EXSb8Sj2vJ6+CtDNyP5YZ72wHXMQIp827DMLG4JGNpiUr3Tomy8Tz+Ifd2vKKHSWV7FsbV/TTHKX8d1M4zr4RiGLUEMvKQ6GEbmob3qo7OmjbY/Vq1k/AtRimIvwmuuA64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020151; c=relaxed/simple;
	bh=u70sL5l5/WE9bTbxsLZN8bQP0O+TYVg1OY6Wq9YVsFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyiU3mTTDQvhVd3+HtYaUvFis6kfYWRooRVmh4wk/4RVx4QbnzpDV2WwfG1086cYbCH/5rrBoBESisUlKDr+A0uvPCZ4/zInQIr+S65N/6zDUNEdjS5feZ6hiPH67/Y2TWdSOYUcpsDKfC9+8Ufb7/xrvPxeKu++WzDZaoMgCV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPwi4413; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPwi4413"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933AAC4CECE;
	Thu, 12 Dec 2024 16:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020151;
	bh=u70sL5l5/WE9bTbxsLZN8bQP0O+TYVg1OY6Wq9YVsFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPwi44131HEi0SjOct3M5mDEDw0AnYi2khl/eaUEux1vzZYJETkNpiial5kG9tXwI
	 LUwKsTkq3KOtKHXBpmmz18WTJPR3VYzUnkx8U+Ezhc4MGLCMLZ7KPWZ2O4/9gdccuR
	 P6ZEge/CaRoMzbUPlTBMpzzh7HFvd1PsD46yUz50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 360/772] ASoC: Intel: sst: Fix used of uninitialized ctx to log an error
Date: Thu, 12 Dec 2024 15:55:05 +0100
Message-ID: <20241212144404.790917603@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c1895ba181e560144601fafe46aeedbafdf4dbc4 upstream.

Fix the new "LPE0F28" code path using the uninitialized ctx variable
to log an error.

Fixes: 6668610b4d8c ("ASoC: Intel: sst: Support LPE0F28 ACPI HID")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410261106.EBx49ssy-lkp@intel.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241026143615.171821-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/atom/sst/sst_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/atom/sst/sst_acpi.c
+++ b/sound/soc/intel/atom/sst/sst_acpi.c
@@ -309,7 +309,7 @@ static int sst_acpi_probe(struct platfor
 		rsrc = platform_get_resource(pdev, IORESOURCE_MEM,
 					     pdata->res_info->acpi_lpe_res_index);
 		if (!rsrc) {
-			dev_err(ctx->dev, "Invalid SHIM base\n");
+			dev_err(dev, "Invalid SHIM base\n");
 			return -EIO;
 		}
 		rsrc->start -= pdata->res_info->shim_offset;


