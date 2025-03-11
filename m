Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB28D1BD00C;
	Tue, 11 Mar 2025 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706284; cv=none; b=Ius+VhIml8Cz5HfPKpm9DWtKl6keFlvf7QVUttNeJygJzbcUZAqjIQ1B0Bpu/LYgqbF36mNaTdDjxUxmBAba1xGxJtinfmanF2orAFEzZe2vUG+htXp3qCXMA+cGbrjts1hU7Qjo2o6hykVrCG37TtAXp/gm8N0TmaXYZeS5Z1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706284; c=relaxed/simple;
	bh=RC6zOFGHWHH5YJKQbL+XlhZfGw+Y6hyDMyeYbHSNI2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOiiCxuLFuTpmegWsDaAp+dqorQoYKdlYtWfSOVCppP6OFz08T9FT4nVWDq5NzSDvfmbpzi44PLz6+1Mk+JLQn72h228XEUCK3fo1+n7b/lrmYFnsANoZzrn0eEVp2BTvqjD2Rer9PBnYeujRIRq86dQYQvjgJkhB39FcD3OtOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8mgzdVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8mgzdVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62838C4CEE9;
	Tue, 11 Mar 2025 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706283;
	bh=RC6zOFGHWHH5YJKQbL+XlhZfGw+Y6hyDMyeYbHSNI2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8mgzdVDyt2/wN11t80Jhx3M7xslFZPOm6VXv2LGgBRLlzvvL4ItDXlccEcyzXGkj
	 wrLsFEyP57ouF6Kdobcyo0sJ5LMzZR3SOs3xKHzXcHsctFW4WHwMWub7mDxDJqljHa
	 TEhBkmb6Z9kVpdYxYU3/1M0WOBYp+6Nv1whEEDrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 325/328] intel_th: pci: Add Panther Lake-H support
Date: Tue, 11 Mar 2025 16:01:35 +0100
Message-ID: <20250311145727.814835446@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,6 +330,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Panther Lake-H */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe324),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


