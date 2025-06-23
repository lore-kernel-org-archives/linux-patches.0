Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05C3219E0;
	Mon, 23 Jun 2025 21:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713680; cv=none; b=ZDZjG9myNkbyND1R59FLVJ6GecyIoqQggKjnZc81lcX/euzbrZ7qunMGhetBSz7265xmVCvAVXTTRLPHLUpztB5FurJ/5RCVGdXTjD0fR3SZZwuoTwUznq637GDjC8yPvF+bc2aSSbNx2IZrWbhZNmHoFUmiMBQ9CqvjlbwG6ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713680; c=relaxed/simple;
	bh=XdnJRX5irk/hrTGcQDMfMrGPzOly8PncyZ75GGg1nnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAXixbyDvtid+iV/mG/0SwlNk3QboMialgyKOMHdjWA8/F56Y7/fphm2oZkMWLXlM5hZgIXiMrOw9yHboCU4+mQYzYfkt5s/ke/BJJFCjsHK7/yZZxrgmi0cDHSQok1hZnwHXblI/DVG2xbUJE87s0oKz5Uk/wMBhJzLjCCTFkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSqsPTJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSqsPTJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91BFC4CEEA;
	Mon, 23 Jun 2025 21:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713680;
	bh=XdnJRX5irk/hrTGcQDMfMrGPzOly8PncyZ75GGg1nnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSqsPTJV0C8z77cTe181F2YrYirDSHAPWi3p9bNT0HZWjLk12bboA6Hi1AKv92F94
	 Gj88bvQ8P34wlJ6QjW8sIa1SKj0IKnfZYTJFYSJ8uj9Yg/KHl/oUl6OWbQLHMovUC1
	 SdW8rzyFviXDX9Hl727aLATt1slxE3xwh5sT4wAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 057/414] media: ipu6: Remove workaround for Meteor Lake ES2
Date: Mon, 23 Jun 2025 15:03:14 +0200
Message-ID: <20250623130643.495232022@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Hao Yao <hao.yao@intel.com>

commit d471fb06b21ae54bf76464731ae1dcb26ef1ca68 upstream.

There was a hardware bug which need IPU6 driver to disable the ATS. This
workaround is not needed anymore as the bug was fixed in hardware level.

Additionally, Arrow Lake has the same IPU6 PCI ID and x86 stepping but
does not have the bug. Removing the Meteor Lake workaround is also
required for the driver to function on Arrow Lake.

Signed-off-by: Hao Yao <hao.yao@intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Fixes: 25fedc021985 ("media: intel/ipu6: add Intel IPU6 PCI device driver")
Cc: stable@vger.kernel.org
[Sakari Ailus: Added tags and explanation of what is fixed.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/media/pci/intel/ipu6/ipu6.c
+++ b/drivers/media/pci/intel/ipu6/ipu6.c
@@ -463,11 +463,6 @@ static int ipu6_pci_config_setup(struct
 {
 	int ret;
 
-	/* disable IPU6 PCI ATS on mtl ES2 */
-	if (is_ipu6ep_mtl(hw_ver) && boot_cpu_data.x86_stepping == 0x2 &&
-	    pci_ats_supported(dev))
-		pci_disable_ats(dev);
-
 	/* No PCI msi capability for IPU6EP */
 	if (is_ipu6ep(hw_ver) || is_ipu6ep_mtl(hw_ver)) {
 		/* likely do nothing as msi not enabled by default */


