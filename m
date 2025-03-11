Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316E3C0B;
	Tue, 11 Mar 2025 15:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707590; cv=none; b=n1qJe0wk2rpIp4r8SkybE3IIwmDb6jhoHVmbrABxQxGWwPqNlVYm9pVqhOhwnQWZV0U7g+w4PvzcXmrP5hLxovTUou5Vhq7qZ7SM6d5kM/IpDLvzPCZFOzX5IidkNRFnIWmgosXO6VESNcA/U4nRUoeoxWzb6HE8sOV++4QlOfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707590; c=relaxed/simple;
	bh=GIL91lvsQFxeTYuakV1F3cQqcFpHOigbvu5dQ6Wl4oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeF8mCPw+wW4FDxmYmmivFoVwyrcFdZHK/upFLwdqSWPU+S7SLkwOBCQF/44CfUNRcCHerWW0fqJLJo1vWXtNH8BRmTjB45KCDtogWBaqV7e4MbEpqC2S5hcFl7ai/qwRwo3CRnWgQD/xCj/4yzrsW4jLRDrgDKm5vAJ2GdBfIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsvRQLsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsvRQLsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61106C4CEE9;
	Tue, 11 Mar 2025 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707589;
	bh=GIL91lvsQFxeTYuakV1F3cQqcFpHOigbvu5dQ6Wl4oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsvRQLsdVAmxZsiPRJJidwudZDqb0DMOs7xGqo5dMOQTAzLapC1RXVM4YzYaW1ZIi
	 ViC4n5q0M9yQDF1u7S+jVtlZ+mySr1CBEpKKN+kb9DQYSzFJTjbg7nmRtcdRb3N+4t
	 douSO7EOxaHPiSFGJT9wbLHjor38xaPu6g+orZWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 440/462] intel_th: pci: Add Panther Lake-H support
Date: Tue, 11 Mar 2025 16:01:46 +0100
Message-ID: <20250311145815.713512035@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit a70034d6c0d5f3cdee40bb00a578e17fd2ebe426 upstream.

Add support for the Trace Hub in Panther Lake-H.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20250211185017.1759193-5-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -335,6 +335,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Panther Lake-H */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe324),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


