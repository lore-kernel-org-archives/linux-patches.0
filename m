Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050588;
	b=wos3xjSXiRcUspfeehUAAQdPay930Npp+nHxuiNvw5jEKdWA8R4WrcW56DzyztF6RZd+
	 N3+zYfqVe5RwbSHKsKykj7YdPuKNI51Hoz6DgkpUxRHUF5P90C8/ePPc7dokG6j+nd/pv
	 IFRMXgF1jf4/xFCxYuY3Lwm+Ll/myh/OBYEpNUKgHpdzyiU0q31JgbH/obTJXXzNUvcnL
	 FjMsBynbfQaVokLWZEPImISnNCaroBFNAOteaCsEgwLGSDubOwtd/DrIHFQuS5YQpjBOk
	 czn50H/Fx7JLzTKkh6aUXd6FS9Ekg7HAZpW8uipM2XCc187/ef5BroxdNhVONbHd6cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MXSgJWXDwbtet1Q3tA8yM8/ffdC5l8evFy7P+AisHlA=;
	b=O1r387eodb7SkwvilaoZ3Xi/q2fDCkAPqDyLWb8mdv7JnS4/M1T4ARoHhnqmSQRdZkvL
	 PiUzpLMWe9nvZyvZCuHdLU1xg7DBPn6bSmt5JSArvilW6UkOjI/LveKSfQVyW6cIwavNF
	 2WZC41doPu1uFPbglqqcxvj5ld59iG+10dwXqPEm48ljMU01uwMxI7IeHF2YVFDLw9MyM
	 fSNk+tUlBeymSIzKwTDX/Z0AdJHUIIJzgkSDCgHIlq5Rl+hnXZqNWZNGDJBtrQkwN4yL2
	 xwSIS0wDHtCTAEiMCMV3+pUQxyY+UKOBxqRFr7S2rDRz7+mjLGCCrO8AeR0WHgE7l6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DtGKGRdx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E341606A32C;
	Thu, 19 Nov 2026 01:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DtGKGRdx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6A81F000C9;
	Thu, 19 Nov 2026 01:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050587;
	bh=MXSgJWXDwbtet1Q3tA8yM8/ffdC5l8evFy7P+AisHlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtGKGRdx7bgDxsYIf0/wkobGaLnTVoCZ/x7UIBxccFBN/Wu+zYIwnqQ4gflGBcrPd
	 EaHDfBLiQOVwp0SIvpZnJrBguaDvx3qe3nxHwNMOB41yB5XAYJ9eR3w2/YFY6HdtuG
	 a8rA2VbOgZv2mFggaDp8YpmyPnVXwkXKdJ65Tvcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2754/2857] net: lan966x: do not warn on MAC entries that are not port destined
Date: Wed, 18 Nov 2026 16:03:08 +0100
Message-ID: <20261118150340.768668089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 2cffcf1aeabb187e4f08fe4f5363128a3c45d786 ]

lan966x_mac_irq_handler() scans the rows of the MAC table that the
analyzer reports as changed, reads back all four columns of each row and
treats ANA_MACACCESS.DEST_IDX as a port number.

Before this patch, a destination index above num_phys_ports hits a
WARN_ON(). The driver installs such entries itself:
lan966x_mac_cpu_learn() uses PGID_CPU, and L2 multicast entries use a
general-purpose PGID. A row holding one of them is read back whenever
another entry in the same row is learned or aged out, so the scan warns
in normal operation, repeatedly once the MAC table is busy.

Skipping such a column is already the right behaviour. Drop the
WARN_ON() and keep the bounds check as a plain filter.

Found by an AI code review agent. Reproduced on a lan9668 board by
bridging two ports with a 10 s ageing time and sending three rounds of
2048 new source MACs: the base kernel warned 42 times from
lan966x_mac_irq_process(), the fixed kernel did not warn.

Fixes: 5ccd66e01cbe ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261026-lan966x-mac-warn-v1-1-9c885f9cbda9@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index baa3a30c039f4..96bb0a16ac08d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -447,7 +447,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 			lan966x_mac_process_raw_entry(&raw_entries[column],
 						      mac, &vid, &dest_idx);
-			if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
+			if (dest_idx >= lan966x->num_phys_ports)
 				continue;
 
 			/* If the entry in SW is found, then there is nothing
@@ -501,7 +501,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 		lan966x_mac_process_raw_entry(&raw_entries[column],
 					      mac, &vid, &dest_idx);
-		if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
+		if (dest_idx >= lan966x->num_phys_ports)
 			continue;
 
 		spin_lock(&lan966x->mac_lock);
-- 
2.53.0



