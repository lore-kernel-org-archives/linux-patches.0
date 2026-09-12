Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9763290B0;
	Sat, 12 Sep 2026 10:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210766; cv=none; b=bhbaeDUj/jTIJ+zBAgxRBLMu8DerCJBfP34dVrnswL1icx6h3qw05xHVs9u1yLihI0QNd0BWIz3f5XeXXEbdUKg9zkRSFTdOkXqQarS9ae2TYFkzRgm5iTXE+UhGtmqMN8v8LlspBcdI9y8nJ0TsLMVitOaCLcUg78WC4tph2Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210766; c=relaxed/simple;
	bh=3KKm9SyPPDEYyW2tQy6f8WRjEjLuiYtx0TqxFpj6s2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrCP11EOvpakDW53IqIbkJXkQFwm0zrArgfbWjmiPKfbv3FYaIqYAJ5T3XfDy8CjtNUkJXH5uOnZ2rgK5RooIbD67LfIfFo5lBKg9m7SCVnp6xTQoXsfN9TMucaiSyGAtMZqU2rwsT+8e11m4Khr7qcp3wMv4ZeI9AcaG5Mwr8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaFinYbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaFinYbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A06E1F000FF;
	Sat, 12 Sep 2026 10:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210764;
	bh=ZDW87jJMPBQ/MhmFf9lV3hW/m+hgY3hRmLq8H5k/rPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xaFinYbRZrjYzCESPlOnW9lujidAqGUO9yc9gc2zVtyfB/tJnezxFAilafhYBjVUP
	 h8bmmfpRULy0otefFWWVZgvdGmi4Wf5oHiwLof8ibH7LT53rq368acq6+8hVk1HOti
	 QnQBJRxEBaTE/Hl0oMKStwnFvhgtmFmKGZYPSxu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1092/1518] powerpc/configs: enable CONFIG_RAS to fix EDAC support
Date: Sat, 12 Sep 2026 08:54:21 +0200
Message-ID: <20260912065648.154731878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 3921cfc2e8155a767235801be88cbd0e4c73508d ]

Before commit e3c4ff6d8c94 ("EDAC: Remove EDAC_MM_EDAC") EDAC_MM_EDAC
selected RAS, after that commit, EDAC depends on RAS, but nobody enables
it. Enable it in the config again.

Fixes: e3c4ff6d8c94 ("EDAC: Remove EDAC_MM_EDAC")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260730105546.3658570-1-mwalle@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/85xx-hw.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/85xx-hw.config b/arch/powerpc/configs/85xx-hw.config
index 8aff832173977..b655c36e56dad 100644
--- a/arch/powerpc/configs/85xx-hw.config
+++ b/arch/powerpc/configs/85xx-hw.config
@@ -90,6 +90,7 @@ CONFIG_PPC_EPAPR_HV_BYTECHAN=y
 CONFIG_QE_GPIO=y
 CONFIG_QUICC_ENGINE=y
 CONFIG_RAPIDIO=y
+CONFIG_RAS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_CMOS=y
 CONFIG_RTC_DRV_DS1307=y
-- 
2.53.0



