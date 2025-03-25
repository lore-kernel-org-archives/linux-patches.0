Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D433B25B674;
	Tue, 25 Mar 2025 12:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905969; cv=none; b=fpAo+SxTu879oz2dIUCwLW7KFKxFJtFzVcbx4Kpm7GfcNUMguG4W90Bkp4WwnLRMPtpuL0/VE3Rberoym3LGkKJikahk+aVVd+Xm/YJlDKNGnCJnpgHFO8Ve86YvCw0cDH0QfQ2hthWsc6Lqoip0E293yRI0yCAsSFOryrk+jlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905969; c=relaxed/simple;
	bh=4r+1xruOXSRY0YXNK9XUjc5E0VNeBbFzb4SJN2dWpvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8pSZjmf1pTPwmV5YNXKJR5hQerMPY/mwTl4MDuyRicST/Uz6fBSO0hTNya9McBXWWgrxKErW/KdL2QcPmrn6v3+HSdRrFcNXPCfzkpYSd01kLJXcwj88wSkMIAcyZH9ngwO6pbj4kRqRW85t5AMgJyDfT65uJ7RmsCiEfPgVPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUz3xsh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUz3xsh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876F8C4CEE4;
	Tue, 25 Mar 2025 12:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905969;
	bh=4r+1xruOXSRY0YXNK9XUjc5E0VNeBbFzb4SJN2dWpvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUz3xsh0y+n9k+QSR50mvuLTWRIJ5y17HdZ1mtxS/3QyWv7/bcVSrBQxnCuFCiyh/
	 n/uqJsJfwjkIlRcixwKW0yPykid8aQsIlcY9bTLvSwsL3lXmrqNTzmi6MwT9QVQUgK
	 46KIUsyxv02KHmX8+hTMt+cjCUUHzZ+aHveZODTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	E Shattow <e@freeshell.de>,
	Hal Feng <hal.feng@starfivetech.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.13 064/119] riscv: dts: starfive: Fix a typo in StarFive JH7110 pin function definitions
Date: Tue, 25 Mar 2025 08:22:02 -0400
Message-ID: <20250325122150.692496846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: E Shattow <e@freeshell.de>

commit 1b133129ad6b28186214259af3bd5fc651a85509 upstream.

Fix a typo in StarFive JH7110 pin function definitions for GPOUT_SYS_SDIO1_DATA4

Fixes: e22f09e598d12 ("riscv: dts: starfive: Add StarFive JH7110 pin function definitions")
Signed-off-by: E Shattow <e@freeshell.de>
Acked-by: Hal Feng <hal.feng@starfivetech.com>
CC: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/starfive/jh7110-pinfunc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/boot/dts/starfive/jh7110-pinfunc.h
+++ b/arch/riscv/boot/dts/starfive/jh7110-pinfunc.h
@@ -89,7 +89,7 @@
 #define GPOUT_SYS_SDIO1_DATA1			59
 #define GPOUT_SYS_SDIO1_DATA2			60
 #define GPOUT_SYS_SDIO1_DATA3			61
-#define GPOUT_SYS_SDIO1_DATA4			63
+#define GPOUT_SYS_SDIO1_DATA4			62
 #define GPOUT_SYS_SDIO1_DATA5			63
 #define GPOUT_SYS_SDIO1_DATA6			64
 #define GPOUT_SYS_SDIO1_DATA7			65


