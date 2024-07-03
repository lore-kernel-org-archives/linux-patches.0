Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A185173351;
	Wed,  3 Jul 2024 10:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003455; cv=none; b=dBR0yzxQU1ZakgdD7kSp3T6WjSHP11qyj5qEzJ2Sg8voQVMAw1DLQkpZVIRsP8uJlO2lt+xNgHWoJM/5oWZ0gtSlr2HkdvD+jcAYaOJCRwsVcAkMRzbfs/g+iguudc6CBy23QF7WrPoMtae/qjIXjS3COEdK5iVsBPjzX9QU+Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003455; c=relaxed/simple;
	bh=GbSw5bygV2mnVSG/ib0Nywb8gv5rSdLZi5+GEc1awSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA2SvPwxMf1Vo/FlQ4HuSw18iU2UxTwcqZILUzHHMzf/eNdMpnsXy/teG1WrLIncoTR1P2pNlDmN/5+qxjnQfgM1CVGE9kAlT5ZTQaBieCwyhDuzaIgfirFFOg6h93WThDLt/WTbdH3/xpt4ynlr7ywGPGmfwzVzy5VwagpT7qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2Y/9869; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2Y/9869"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1080FC2BD10;
	Wed,  3 Jul 2024 10:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003455;
	bh=GbSw5bygV2mnVSG/ib0Nywb8gv5rSdLZi5+GEc1awSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2Y/9869TpXSPdma+rUIb/aze+w+u7iF4hBmVS3Q1kx/rUCePFeLcsHQ1NBzuaFM0
	 y2bNyKhWGQK2qvn068SgNUUqK2Ib4cZc0aXNoMY0sSYk7uI7wFhFZx3nAjEd9iY4RD
	 A1xMHOJKtKshLsR40VOOdJ7StMKDHD4850PhnuKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 4.19 052/139] intel_th: pci: Add Granite Rapids support
Date: Wed,  3 Jul 2024 12:39:09 +0200
Message-ID: <20240703102832.404928000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit e44937889bdf4ecd1f0c25762b7226406b9b7a69 upstream.

Add support for the Trace Hub in Granite Rapids.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-11-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -266,6 +266,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0963),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


