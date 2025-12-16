Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416733502A4;
	Tue, 16 Dec 2025 11:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886186; cv=none; b=jTmOrquLkDrhBajJ+EuQd5prN+0S+VbGKIg7o29FisPvuOoBekDIh8Xg4PCdfaL/T/zgfkDYtiJO7ocHxt9GCbOKa6qOihVxHAlvd0wrZXlLcK03TdfwUJ7atF4MNO/MCWq43DFrN61jdXLFufs5KVxyUahOSpAd/483mR0fsKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886186; c=relaxed/simple;
	bh=zTRnUs8LngfGLrUFkTGdw7ly1RSi2Rz7H3KC7TqshpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1XOgSPDfS0eIVoyNq1Wtu+3o9QHnWXKf4M0fiZ0mv/Sz5UkHgKfnnwgFGr36G3ikHbi6lKNsjGuOSSxplKO9cEjsBYkHBfiHp8RDAzt/mI16l+urFZYv6Zx3cJ0E9Rf1uMlJYzBLkq3P1s9LREiCrG3P9R0FSBDIjXeAJDyoxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MP31f4ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MP31f4ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C842C4CEF1;
	Tue, 16 Dec 2025 11:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886186;
	bh=zTRnUs8LngfGLrUFkTGdw7ly1RSi2Rz7H3KC7TqshpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP31f4ah0eGIOZjH8U9tLBpl87cpliNOivqgFBFm+lA/AMCs76xnL8t9pP4E1ao3Q
	 Ij4cJmCojGhpJQHvs8zbPpB5ec7aK5kE8q9mWvSClGyvkHoa0zbkaib56J++CtqOlZ
	 3Pib9sAGTazCieSFfqEB/WenP2z8fNyeVKczjKaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 364/507] firmware_loader: make RUST_FW_LOADER_ABSTRACTIONS select FW_LOADER
Date: Tue, 16 Dec 2025 12:13:25 +0100
Message-ID: <20251216111358.646009876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index 752b9a9bea038..15eff8a4b5053 100644
--- a/drivers/base/firmware_loader/Kconfig
+++ b/drivers/base/firmware_loader/Kconfig
@@ -38,7 +38,7 @@ config FW_LOADER_DEBUG
 config RUST_FW_LOADER_ABSTRACTIONS
 	bool "Rust Firmware Loader abstractions"
 	depends on RUST
-	depends on FW_LOADER=y
+	select FW_LOADER
 	help
 	  This enables the Rust abstractions for the firmware loader API.
 
-- 
2.51.0



