Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66613C0B;
	Tue, 11 Mar 2025 15:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707595; cv=none; b=VsEkpcMWvUvt2gG4YK7Xtm7kTRoEtXMff4rxcM0rw8XijU69/o5iIoKEW+49EueB+vsFdEoiKX9cJ2TDR9BCrtpbiNjZsCrr2q82jqx+2WKRJHaLZTTrsRhUNj1suRdx5D0Q5LVm1e0qrkslmfj+6in2nVvDJ9ybmpNYR6edya0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707595; c=relaxed/simple;
	bh=+Qlyl/97R4N9wt5FiaX6bohJK+zeG5fWY8+7kjPn/0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgJslKx5J+N+a19skykxm+6NeyMfdRifak5BBbBPj0cuhK25EJyTxKj/Kzs2BPy9LJzRlps8WzrZ9yE7tqI1hJvxiXKWtW7jnkUW97X9Y2PWu6kqMv0eVvV5p4iQ5zzjw6ohv0BKepVJqub0Lnoummx3OtLB9fO+Y9pft9Tfc6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCa/gCx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCa/gCx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA5CC4CEEA;
	Tue, 11 Mar 2025 15:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707595;
	bh=+Qlyl/97R4N9wt5FiaX6bohJK+zeG5fWY8+7kjPn/0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCa/gCx4jdexvBzEmVd7qdzjj3OsI3gdjOQRSWPkK4v9L2bY5f1X7dazRrXeAZ5E9
	 m5ku8rUZbEhwOIRED1iMC1+Md84Yc72Wla9sS2rLlBmjHK8fHfYzFjirxvAgJRg5cR
	 o64f2euWC9iir8Ft4i4GHrkNZL6tIlTCHXsIPX5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 441/462] intel_th: pci: Add Panther Lake-P/U support
Date: Tue, 11 Mar 2025 16:01:47 +0100
Message-ID: <20250311145815.752479331@linuxfoundation.org>
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

commit 49114ff05770264ae233f50023fc64a719a9dcf9 upstream.

Add support for the Trace Hub in Panther Lake-P/U.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20250211185017.1759193-6-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -340,6 +340,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Panther Lake-P/U */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe424),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


