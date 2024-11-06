Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5AC1E048E;
	Wed,  6 Nov 2024 13:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899164; cv=none; b=gnZDxH8uWETOgOq4Gk0aKF4k2KEa8Zhf1zkxRZJQNuHdS+XHuE2n50P9YjlBs2IQxbXm6nj+m6RsAe2qHzZDMVPLHWj2lIrR96+l7lMyLVT2VtKi/aiwCoT4NYuhMTMw0tcYn1FfbXS9ppgfZsI8hBdVz+cL1zI3Wt4JbOZ8FrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899164; c=relaxed/simple;
	bh=sBqWhvb5NpfxxTJj0ljzc2anXJo/173n19xQQ7Rd6ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrutEW+mBEvwXCWaCN5NA461Bo0zsXgkqG1APkWhSSo7DHyJfG17b6vbfBoCkKMvFfRXHSS1FY9K9hgJP/rwwt8yQvmTIgjGW+y5dflwrfpg34ChRsJa5SXeGDSwcOq09lUTheX769zWnTIQiVE+wufcNv7Axvkol1vVtmpkOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bT+/RleN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bT+/RleN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4125DC4CECD;
	Wed,  6 Nov 2024 13:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899164;
	bh=sBqWhvb5NpfxxTJj0ljzc2anXJo/173n19xQQ7Rd6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bT+/RleNXkSgrI++luGU8YH+1USfr71DOBgWKyaSHOKQqUm10M2Tzd3YMYy415eIn
	 dtO1Eqq1qegW3aEzbbDK67PWnLfHHrQxWe+cWy7D3m3P+jqT4mlfHzF0Ip+f3hDHsL
	 vtbdhMHilN3+HLTmoLDi2vtg/SP9HdLw/b5zdpSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/73] wifi: brcm80211: BRCM_TRACING should depend on TRACING
Date: Wed,  6 Nov 2024 13:05:13 +0100
Message-ID: <20241106120300.242985549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit b73b2069528f90ec49d5fa1010a759baa2c2be05 ]

When tracing is disabled, there is no point in asking the user about
enabling Broadcom wireless device tracing.

Fixes: f5c4f10852d42012 ("brcm80211: Allow trace support to be enabled separately from debug")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/81a29b15eaacc1ac1fb421bdace9ac0c3385f40f.1727179742.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
index 5bf2318763c55..8f51099e15c90 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -23,6 +23,7 @@ source "drivers/net/wireless/broadcom/brcm80211/brcmfmac/Kconfig"
 config BRCM_TRACING
 	bool "Broadcom device tracing"
 	depends on BRCMSMAC || BRCMFMAC
+	depends on TRACING
 	help
 	  If you say Y here, the Broadcom wireless drivers will register
 	  with ftrace to dump event information into the trace ringbuffer.
-- 
2.43.0



