Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3082F2BE62B;
	Tue, 26 Aug 2025 11:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207927; cv=none; b=YPvBaLppU/gtSmXqRAdDXxwhwKc3d5xDBEMVKQYE9k5zIM2QXofxJX5exqNuuVMmNQ5BDplOa5zL5sDx9qcr1mZk+82V7zsWMNtgf2VctdKYgkCRuoguUAW5C4DwWt1FDIO78lD9j+K/LduAkHPsygiQsB+/OHHfLJA4hJiQ9hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207927; c=relaxed/simple;
	bh=XCnSm6cNjRoERXxZHfd5cqSfLtmO1UCaUWyHwidE9f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmauR3HmuGGWHS+CH6bTwdJZhZ/pfx3TPmnQbt5gQav6NBnFSGNAQi7S1I/WSNr+x94hOyhVnQfqO1Obtf3wfLQuWbsnlzoOXMy4HlwKmjqfYxDllCkozd6Fbki/y1v1lzuF8ZtVgyG8VGSw8N6sqoTuq8emJyBTNCB4zTmrAQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6mXYVGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6mXYVGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DAAC4CEF1;
	Tue, 26 Aug 2025 11:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207925;
	bh=XCnSm6cNjRoERXxZHfd5cqSfLtmO1UCaUWyHwidE9f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6mXYVGxRiulED5SP7P99nZ8eSu9AAz8gYr3ig2D17swC6Ckk2ZpeQN6qNDev/Snt
	 Je85e4Ts8vtkDgeCvsI0S88SwKRuut7cRQHreJz8IWoITzMe5Xm70AhyVZUgZ09qC9
	 mdlxjQQqtKdkeanau+Xl5HGbNI4oVkEypBtc9JsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 370/457] rtase: Fix Rx descriptor CRC error bit definition
Date: Tue, 26 Aug 2025 13:10:54 +0200
Message-ID: <20250826110946.444256705@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit 065c31f2c6915b38f45b1c817b31f41f62eaa774 ]

The CRC error bit is located at bit 17 in the Rx descriptor, but the
driver was incorrectly using bit 16. Fix it.

Fixes: a36e9f5cfe9e ("rtase: Add support for a pci table in this module")
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Link: https://patch.msgid.link/20250813071631.7566-1-justinlai0215@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase.h b/drivers/net/ethernet/realtek/rtase/rtase.h
index 498cfe4d0cac..5f2e1ab6a100 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase.h
+++ b/drivers/net/ethernet/realtek/rtase/rtase.h
@@ -241,7 +241,7 @@ union rtase_rx_desc {
 #define RTASE_RX_RES        BIT(20)
 #define RTASE_RX_RUNT       BIT(19)
 #define RTASE_RX_RWT        BIT(18)
-#define RTASE_RX_CRC        BIT(16)
+#define RTASE_RX_CRC        BIT(17)
 #define RTASE_RX_V6F        BIT(31)
 #define RTASE_RX_V4F        BIT(30)
 #define RTASE_RX_UDPT       BIT(29)
-- 
2.50.1



