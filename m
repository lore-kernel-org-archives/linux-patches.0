Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343D912FB31;
	Wed, 19 Jun 2024 13:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802603; cv=none; b=SG3oumuWDPR9Oi+wiDX6grf6BObMLYyDixin2gBzMdRrbI7Jo2rdf8Z3Xqwd68s8Q6vfpOxSRVGJaY2HJCnYRSt14XsXtUVy8e7vEDOSYVXYvhHu2lTrlugxFMgOcJb3wuMoQOExJpZiTf3ESnM4Lwhtnyl0I5NzFAmLRs0Guu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802603; c=relaxed/simple;
	bh=s9lA2cAXGnwVPRnRjJUNAcuoVcU47Y9BLDQLidC0Vd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYiqbekQ5+rIlsc78g5Fkm6zUsS5ETbCrXpg9aAMYRQcQ1sJp+kfiloEmC05UU1EeLH2qcm74kmgjk7PTOSf3SzKY9Q6jx6aQ5u5d9/WtGMpa+id4tcvozcJDWSCobpze2VvYiDJI6Y3PE7tGBeQahdm7Az3BPVHsGGutZ82b4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P75+1dOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P75+1dOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC460C2BBFC;
	Wed, 19 Jun 2024 13:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802603;
	bh=s9lA2cAXGnwVPRnRjJUNAcuoVcU47Y9BLDQLidC0Vd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P75+1dOfglmCFDf2N0A8aT7yXJ/NhtUOxY6Xy+KSZ1RTybzHT4cQKbcVaLl3hrzHW
	 RYx5KHNYephwjhoAEqctx13W1wf2q2Mnrfc9M1fSF/T8EsFh38klLTkv3N4zWjADes
	 atRor6/xvpNU2d8j2Y7RuAocJTiD5wwmoH9A8eLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 221/267] intel_th: pci: Add Sapphire Rapids SOC support
Date: Wed, 19 Jun 2024 14:56:12 +0200
Message-ID: <20240619125614.809021905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 2e1da7efabe05cb0cf0b358883b2bc89080ed0eb upstream.

Add support for the Trace Hub in Sapphire Rapids SOC.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-13-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -315,6 +315,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Sapphire Rapids SOC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3456),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


