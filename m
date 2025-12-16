Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F5A315786;
	Tue, 16 Dec 2025 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884589; cv=none; b=Tk+FHrt8PCTChT9o8K/407oIcwC9ArKJFDmtEaQlwXbk0F82zQkGhripLL0fn8kqrga49ai0w8/cWwwU8LN3HbL3SuR6kKpSPrdFAojk1aCE6qjylHBZRAuIPhsHF75jg83lIVA5TYRnoqKWJOcNSCYnhiQoB9EPRiYed0PWn6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884589; c=relaxed/simple;
	bh=cf09LaJoHrPottRfotqkY/1aLhTYq6ZAoHjYlQDPHko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGVYwBT5oNx/wVkoWg0gydU18GntQi9G3JafbpMkPlFryEnRhCPR4EkJIuMFRtk2LmzXTDBZhw2PYuvPYS5O0uTbU8U8wxFuWAk+EuQwV92S9uAWwaTNOScUqO55XKfp34BXXQ+YViAAHggLFOn3IGHm7/FL5oz4cx2g06sSWQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+MlPSXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+MlPSXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD69C4CEF1;
	Tue, 16 Dec 2025 11:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884589;
	bh=cf09LaJoHrPottRfotqkY/1aLhTYq6ZAoHjYlQDPHko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+MlPSXJsyWEVhJxnXlFfBBGpknxEOQbQysKiGTviZGLYRjepDN1bTwCAaASFXFry
	 d8M1lXNxGQA48vqe/pg3HKPJ88Ds6NkslzexsbAn6ciFRFuFmCDMsWlPZZMbSMALDE
	 kVh1SDZ+1XlI6P93ICUlGUZex6Etrez0cguRa5K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/354] firmware_loader: make RUST_FW_LOADER_ABSTRACTIONS select FW_LOADER
Date: Tue, 16 Dec 2025 12:13:25 +0100
Message-ID: <20251216111329.537553758@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit 9906efa545d1d2cf25a614eeb219d3f8d5a302cd ]

The use of firmware_loader is an implementation detail of drivers rather
than a dependency. FW_LOADER is typically selected rather than depended
on; the Rust abstractions should do the same thing.

Fixes: de6582833db0 ("rust: add firmware abstractions")
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20251106-b4-select-rust-fw-v3-1-771172257755@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_loader/Kconfig b/drivers/base/firmware_loader/Kconfig
index a037016742651..4bf593fb253ac 100644
--- a/drivers/base/firmware_loader/Kconfig
+++ b/drivers/base/firmware_loader/Kconfig
@@ -40,7 +40,7 @@ config FW_LOADER_DEBUG
 config RUST_FW_LOADER_ABSTRACTIONS
 	bool "Rust Firmware Loader abstractions"
 	depends on RUST
-	depends on FW_LOADER=y
+	select FW_LOADER
 	help
 	  This enables the Rust abstractions for the firmware loader API.
 
-- 
2.51.0



