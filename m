Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDD01DFD8D;
	Wed,  6 Nov 2024 12:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895874; cv=none; b=o5bXaFNTzAx0blkWTj4Z52VDTs5fznA+7BqxiM8dv3cWHZX58I0tjRhKZl9EB8Gn40Ug2hZpaEVq4J/PhsawMLyzM9SOJ5qeqyCGY0Tk9dQ2/6Dy7bEVelMOJvf7yYE2kTimnZ00ODBsMZmc7q5ENqtBBfWMnwzHey1005NvgIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895874; c=relaxed/simple;
	bh=ftdAUAeUv8OiVy+ArUYwfXzyLr9F53PLlfQRUY6ZCTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rpbv6d5ArMGxROMgb000KQvx0irH5wqsUH+EXmwXwVKJByn29KlFWS1aGoVGASmK6NERHUgFOqZSmFHoz9BVjFX0QOhmYiTXpwMek+Fv/u56Pi/LiqXIyh9rfrI7IG+aWVIWHHiajyVLPZqRDXWeVl+K+d7JnGU3k0d9oBqqfXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acuK5Sal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acuK5Sal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5EDC4CECD;
	Wed,  6 Nov 2024 12:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895874;
	bh=ftdAUAeUv8OiVy+ArUYwfXzyLr9F53PLlfQRUY6ZCTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acuK5Sali54GRq92DTl9PxbeVNeshvC++FZfsNcfUte6PJVAsz+PXWP91a6ztwM3g
	 XvfKk93K2qh1QuM2UkM/3C2BUcXLwA8OPqMaKqedmi0yhytyn5v7GhRXPDxzW6zZVv
	 YA2m4vtu7e5I2nzCYqxeLw5wZ984GKWd5lixVWHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 014/245] wifi: brcm80211: BRCM_TRACING should depend on TRACING
Date: Wed,  6 Nov 2024 13:01:07 +0100
Message-ID: <20241106120319.592139958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



