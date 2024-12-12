Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F8713792B;
	Thu, 12 Dec 2024 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022659; cv=none; b=RH8DcpSTROwdB8vCD0/gE2dZbF4wd8Hey0tkNoGj46EJWUHl6UFR0uAxuukmS+sc6OVfNYOqZVbTuW9L2ZoGwr/9gIljbNi1Wb2pO8w4yxmYVQFHdnB8Snpe6N7p/yl32CF1fbP1WQ6aBjG5QVI+ubWWv29nP8x0DREfzWfu4WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022659; c=relaxed/simple;
	bh=jHxQ/jiqtXOnQhpEPV/kmt+woqG4ENjLlYmCK9Nf8Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvJAlnwZqirCg5vSvOwdfXkpUXGmAIBjZ8sn2gtEDOeNNZLB8wsFb4jA5vDw771iUQTHFwW/+qvzAPFSFnn/UAt9Gkm6BBFutrHaxwQfOTu59fXonDSMTt2OKumHOj93P9dJMMb/PTaZ9RlcHGlwXXXm9xPK5Ezt0SMyzEFA5Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJPesXFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJPesXFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2BDC4CED4;
	Thu, 12 Dec 2024 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022658;
	bh=jHxQ/jiqtXOnQhpEPV/kmt+woqG4ENjLlYmCK9Nf8Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJPesXFvh38gIBHSK+P2P4yTxCR9sprlazB9ZDTkzSxeIKTgHk7d2zzcRHr6w7LU3
	 ZH2iNYBwb54slAOo2og8/Nev7w6oGAB70OkX5pDDcjcz+gYxOcHpqU8G5qDyrjw49z
	 KM4/N+l5+sVw1B3h1GkOPgoRzSiweF5t9aPLSpuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 301/565] ASoC: Intel: sst: Fix used of uninitialized ctx to log an error
Date: Thu, 12 Dec 2024 15:58:16 +0100
Message-ID: <20241212144323.364572959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


