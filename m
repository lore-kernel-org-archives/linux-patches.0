Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE0F334696;
	Thu, 27 Nov 2025 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255526; cv=none; b=YOJcYOMo0v1ea8eNcA3MIMrEjuoYecdZV06A0l006EB7VfHias6cy21DAuwQL6S799ZLnmxHH7wOUF0izCsvzJsB1Ei9SVU+we5Yau81aTMzIRCWKa7GXREURHKA0/zDfylM/XCG5lhPN7VWOxKfXPb5BDaIhs/pCvdoIXfCLwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255526; c=relaxed/simple;
	bh=ayk7B5Ftx5/wdyZU5lhhD8KY3PRhgu+xFPSj9oLBnoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfV2IWFu1XewEaEXFHrVorF2r7l/ZoJPtfo+kDrtfzgCVr3ZACbJHozRwQTsy9z3K2vy4/yP0BNWN2YyQtwrbfyY0ddhuTZf1Wndvp1yf7xrj84l8Reo60xgaOKgNSUEH06b2ZlK1DToXvNJuSJNVhlkiMZmwxWR6dYgOHZqdLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiFq85Qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiFq85Qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E2AC4CEF8;
	Thu, 27 Nov 2025 14:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255526;
	bh=ayk7B5Ftx5/wdyZU5lhhD8KY3PRhgu+xFPSj9oLBnoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiFq85QtWmbGEvpv47FMjnOdpA1AA59mbN4cAJIoy5V7hT1mc45ZLoizF9DWmIqhr
	 EX8Wyam/pVWet0Eimx17Uq62kpkmtXVxl47KdHdAFJ+xUFGDJHhQGt2iNIl4rXRI1a
	 6wtPFS8EubC0BrIEetrg/5Lph6Xe5MjUeCqf8q4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kernel test robot <oliver.sang@intel.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 023/175] lib/test_kho: check if KHO is enabled
Date: Thu, 27 Nov 2025 15:44:36 +0100
Message-ID: <20251127144043.808089105@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pasha Tatashin <pasha.tatashin@soleen.com>

commit a26ec8f3d4e56d4a7ffa301e8032dca9df0bbc05 upstream.

We must check whether KHO is enabled prior to issuing KHO commands,
otherwise KHO internal data structures are not initialized.

Link: https://lkml.kernel.org/r/20251106220635.2608494-1-pasha.tatashin@soleen.com
Fixes: b753522bed0b ("kho: add test for kexec handover")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202511061629.e242724-lkp@intel.com
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_kho.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -272,6 +272,9 @@ static int __init kho_test_init(void)
 	phys_addr_t fdt_phys;
 	int err;
 
+	if (!kho_is_enabled())
+		return 0;
+
 	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
 	if (!err)
 		return kho_test_restore(fdt_phys);


