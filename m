Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520F41E0493;
	Wed,  6 Nov 2024 12:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896942; cv=none; b=Lr8+JHrdS9o7HVid+wfmOSXFs+cw57Y87Bcg+nstidKtCtaj1KoG6kgYcpAUEfi9UuZicen/UxA4T9CSa/DvHqhJrmXOkafq0N2nArhx4VKk5WxueiFR9gpM/llLJU5vdSf2XC8pjTiy0eWn8/BpL8QP7leXUK1yO5Qf5htjsZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896942; c=relaxed/simple;
	bh=2oRiRcMsbMqDNSEoFdFpCWTDOmksJVcHmOxSkWWCAKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpCMNSiNdg47pNh44LL+yPS9pO8MTiJZBqIAaIWNo8rbii/FZMbsJJAoXNgHxbHkENh/7vZawf7tCETP+hU+PBeI/ZTx5DP7B9WDIwANTbhcW0q8IuaLDjmLpbibQkI3duqAL+OG5DwZhcaMr2eVo2jEPb7LfmCTEZObD7IvGuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=molGheFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="molGheFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB118C4CED3;
	Wed,  6 Nov 2024 12:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896942;
	bh=2oRiRcMsbMqDNSEoFdFpCWTDOmksJVcHmOxSkWWCAKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=molGheFZEAOlkMURBiic8BTKzNfhvOd23h3hubxLjt9TmbPX5p9/eAQl6MpOGCOnB
	 UM4NOVL+BTRnN6aBpnm4FQseoPyVs+vi1RPuhZbEY+o3oL4QxScsttQaPbMW4BR/hx
	 EE0x/7wWKCnMBzOyxqT4OlvT4xw5kK1+VWoL7vRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/126] wifi: brcm80211: BRCM_TRACING should depend on TRACING
Date: Wed,  6 Nov 2024 13:03:35 +0100
Message-ID: <20241106120306.466523869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3a1a35b5672f1..19d0c003f6262 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -27,6 +27,7 @@ source "drivers/net/wireless/broadcom/brcm80211/brcmfmac/Kconfig"
 config BRCM_TRACING
 	bool "Broadcom device tracing"
 	depends on BRCMSMAC || BRCMFMAC
+	depends on TRACING
 	help
 	  If you say Y here, the Broadcom wireless drivers will register
 	  with ftrace to dump event information into the trace ringbuffer.
-- 
2.43.0



