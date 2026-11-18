Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061660;
	b=pMFqaIU1ZkLA7Vn3mrRHyjzGmjW4G9nxWJqM2PNRxVs684H9s5cYMp2+9W5+RDhD+sii
	 v0NuPX1rL33hz7VrjXFxagVOZi5IxcXdzoU7yd9AxSAZ+JM3vo4Ykqzbsx3xefSgrL6aW
	 PO8OYwzCS/WJKAdHtVayoLnlciPYYe9gligtQYBwC+4xBz+JDWOIAnoovAih4kBfvyh9o
	 epV6IW4ApccpcrU8tsZX5lOq2/ltKA8VETFVEs1tVlCNBqtQI82pcXFILDGOxjZ0HbIM/
	 b6dlQKuTjEkLOEzP+76Vuy0tcxS7t3OV6zSIr/96XfIBn0wtz7+lE7rOKy2ZT+KwZ2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HCWdo826hMeF9wBWNYZD9xABRUinnvzi38E7+qPAZTo=;
	b=Fp77oSncjbu0S/dfEHudP1wHJ1EcOld0KyDYeckt6/gecJeczapMMj7r02H3s6woPj5B
	 ZmyZXvDt+IroLcPhg39hkGYs6jw9hf3Zxzr0aCF+UcgQxZwQXLQLWwd+xy5U73n2FoZTh
	 BLdGqDbZ85WEuBblPKpeTDa0JlFubM195BIZNoGlzrvqBPc6Q5AQJiAtcidDlj2j105M4
	 6soSuSoA7MuLagBuWuga8+oT4uKooMCyx+GwnX6Q4bOdo3+FDtxPotoyvM8KpjH9ApoTb
	 xGVzLD5vP+r77AQ3pVjQ0q6eo3Q7LGTkLwO8E3bgQ9BgmEAly67Y7TPbHrvoVcc8jDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sAZFo3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD34606A325;
	Thu, 19 Nov 2026 04:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sAZFo3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BBE1F000C4;
	Thu, 19 Nov 2026 04:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061659;
	bh=HCWdo826hMeF9wBWNYZD9xABRUinnvzi38E7+qPAZTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sAZFo3I/rq0LLDJVMorxd+WrCQghEqvm/65nnUHcPMCtkglMqvukY/HuT+Qhaf3J
	 +H5lfs+Aq6L83ztLeP7Hh+9ghXseO6XEe587IQ1lYYmaaQgaKEphrYRSu5wDp6ROz0
	 WrfhcfT1M0ccDeymNtrWWBrat9wTt9LHztddm/jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1631/1848] serial: pmac_zilog: report received breaks
Date: Wed, 18 Nov 2026 16:01:09 +0100
Message-ID: <20261118150027.861319709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Douglas <me@timdoug.com>

[ Upstream commit 8db79ea07a67b126c773da6efdc00066000daeb8 ]

pmz_status_handle() sets PMACZILOG_FLAG_BREAK from RR0, and
pmz_receive_chars() clears it on the null character that ends the
break without marking that character, then tests BRK_ABRT in RR1,
where the SCC does not set it in asynchronous mode. Breaks therefore
arrive as plain NULs: brk is never counted and BRKINT, PARMRK and SysRq
never see them.

Set BRK_ABRT in r1 for that character, as sunzilog does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: LLM
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013013541.4535-3-me@timdoug.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pmac_zilog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index a0857b911cdf8..5db257b8e0674 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -240,6 +240,7 @@ static bool pmz_receive_chars(struct uart_pmac_port *uap)
 		ch &= uap->parity_mask;
 		if (ch == 0 && uap->flags & PMACZILOG_FLAG_BREAK) {
 			uap->flags &= ~PMACZILOG_FLAG_BREAK;
+			r1 |= BRK_ABRT;
 		}
 
 #if defined(CONFIG_MAGIC_SYSRQ) && defined(CONFIG_SERIAL_CORE_CONSOLE)
-- 
2.53.0



