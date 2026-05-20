Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928F23FF8B5;
	Wed, 20 May 2026 18:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302768; cv=none; b=LxqwLta6gc3d4zFLf2nCg9SFiBfc9EeRWXh58a4BUNwlj84JcX5+ZjeT45rd5zE9+V+AtaqAIfpmILQN0Y3kU/sndWQzqDjgjifmK3s8Nsg7BtGWL8hOFtkOH/AxEy98qbvxnSNE3EYQoTMuJ1GsKqN7vWw9IhyUaKFD9gOO6R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302768; c=relaxed/simple;
	bh=6A45f6OgvcFrx14mKcvHhzpUUIzBOGQoeUOccgeZDyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hltGybTO+tZWDFGxBx+WpQNd0I420srRRCwdQe3iwec9U+VdNbM4JjSWF8pqHOsGzb93WAyRfXlfYs+YtKQhy73y1iL5NHSJyARhzU9Rw8WUtLDoBuI14SX6BTQnUrw/nuclyn/ReZjiw/escVQ/0d8zZyMCaav0PlnOZ5W9gUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZU5DyK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZU5DyK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B741F000E9;
	Wed, 20 May 2026 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302767;
	bh=rzRoXrLQRb4MB0Xsto8I8C396+PU1aV2EKFvSt6afHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZU5DyK4ZWPPdrafua2Hi1kHeT8kr+Xos2xtj7Bd3DtKCMHi59FXdI0J4i0r6fa/f
	 5hcMepel39XaDLD/rrChTqYReotEQQ+vXK4fcYKW80Y31zyVHwbk1FuzTvnyJwp+kN
	 cRora7cCMPnR5uuh3MikteXPtYhIRACB1dYKuSNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdulkader Alrezej <alrazj.abdulkader@gmail.com>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/508] net: dsa: realtek: rtl8365mb: fix mode mask calculation
Date: Wed, 20 May 2026 18:22:54 +0200
Message-ID: <20260520162106.242940981@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mieczyslaw Nalewaj <namiltd@yahoo.com>

[ Upstream commit 0c078021d3861966614d5e594ee03587f0c9e74d ]

The RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK macro was shifting
the 4-bit mask (0xF) by only (_extint % 2) bits instead of
(_extint % 2) * 4. This caused the mask to overlap with the adjacent
nibble when configuring odd-numbered external interfaces, selecting
the wrong bits entirely.

Align the shift calculation with the existing ...MODE_OFFSET macro.

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Signed-off-by: Abdulkader Alrezej <alrazj.abdulkader@gmail.com>
Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://patch.msgid.link/400a6387-a444-4576-af6d-26be5410bce3@yahoo.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 9d59d93807825..625d1d4d17a20 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -213,7 +213,7 @@
 		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
 		 0x0)
 #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) \
-		(0xF << (((_extint) % 2)))
+		(0xF << (((_extint) % 2) * 4))
 #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
 		(((_extint) % 2) * 4)
 
-- 
2.53.0



