Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F493358C3;
	Tue, 11 Nov 2025 01:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824603; cv=none; b=SXMiLSs8A97AUTYqDaF7beUxiPHVoJWtpT4G3LNmOM/hfXqkloPF4fkE27/gzqp0KSfzw1gRp0mdXxxyo3B8pUXOQDjRY13NmhU4HxZxe2IBMCP88+lpbARaIq8GyH7BWpTNild+0QC0dFZfmBHe/utdY95SFCh7xAl8u8DieB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824603; c=relaxed/simple;
	bh=RBOqeJcOIKhJkBU4K5/pGyyIpbpcsJ0WvQ+Tsj9ROds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRTepfNUKQ7RJNnNVXkZpFJcT+/OXBdphxZx60FtfWGKjzETnAuIkt4Aj+OuT296KwEC9sozT+zyALua3h1gArGwIuA5MuI6K4/6Nc3Mz40ilR5tkBUR8rM1qQyrxAQt6Q6mFDIZs4CirSQ27dB9wm6lo1ZB4IN6tyhfXB54tu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7zmO64+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7zmO64+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47F3C4CEFB;
	Tue, 11 Nov 2025 01:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824603;
	bh=RBOqeJcOIKhJkBU4K5/pGyyIpbpcsJ0WvQ+Tsj9ROds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7zmO64+ZVhlLIkxF1gdZgUVfqrWrDui5VgNY3A92GR7q3CD4VbDmkAWF7G6pDo21
	 lWfKhOZ0+P/r8TmXS1S3ryMZokiT6H5zjk6aASmZqNxVBJWb0NAwkITYH/1qtdU5Xf
	 6wv2lsZNaB7Pgvfxqsb3iGUMyiJ+OJeitnbUCPMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 532/849] can: rcar_canfd: Update bit rate constants for RZ/G3E and R-Car Gen4
Date: Tue, 11 Nov 2025 09:41:42 +0900
Message-ID: <20251111004549.279460618@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 100fafc3e46138cb5a6526ddc03dcede8b020c8c ]

The calculation formula for nominal bit rate of classical CAN is the same as
that of nominal bit rate of CANFD on the RZ/G3E and R-Car Gen4 SoCs
compared to other SoCs. Update nominal bit rate constants.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250908120940.147196-2-biju.das.jz@bp.renesas.com
[mkl: slightly improve wording of commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 7e8b1d2f1af65..4f3ce948d74da 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1913,7 +1913,10 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 		priv->can.fd.do_get_auto_tdcv = rcar_canfd_get_auto_tdcv;
 	} else {
 		/* Controller starts in Classical CAN only mode */
-		priv->can.bittiming_const = &rcar_canfd_bittiming_const;
+		if (gpriv->info->shared_can_regs)
+			priv->can.bittiming_const = gpriv->info->nom_bittiming;
+		else
+			priv->can.bittiming_const = &rcar_canfd_bittiming_const;
 		priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
 	}
 
-- 
2.51.0



