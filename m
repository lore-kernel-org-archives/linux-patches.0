Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7617D14A4E6;
	Tue, 20 Feb 2024 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464068; cv=none; b=bXlNAElHavUynK07nJCGrKwVExzL6mMxuPLo6d8ydscqked561b3wRdSyLh2cQPVHBKcO4gHW9f0RHWsSeiaC02ZZ+WHv50XE7Npk/0sIiggWH0gYqh7FNbMAb9oso+uCBC5tdP0x0CBArWMAOXKTBFX61NIu3h2D2313TMWqJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464068; c=relaxed/simple;
	bh=g+p9gCrNOOFgKdXdNGzveW4cszUt/oDH1ndoyW0spG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4dsIGp9YlAScvUwinl+VLl+1Chxb9i7b8oIjl+MB9kdCPdl1hZheJbpvXEQceMGZPcWLCmCYNL0gdh+Z8sFSqvGXxgBaygpKDexPT7G77yRQWq860xmxY3+6iZyN+S8yCG07EfVlJ+w5qE+brursh4hhS5KB3hzeXmQXZfSTj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilTHs0tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilTHs0tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F56EC433F1;
	Tue, 20 Feb 2024 21:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464067;
	bh=g+p9gCrNOOFgKdXdNGzveW4cszUt/oDH1ndoyW0spG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilTHs0tZQDObIRXeV3pekJeYYTB1vKmrkDClj1CYJIBQW4ibh26XOMBvS8Oct5F6g
	 6B/01l47JHr8UngL/YsYr79rAVpFVPHC+0ZvXuMEnQPBPyljLrcyNqjQKd7LH4mHy0
	 lBKiV3qxXr+AA9DWQHT0+ji7UZFvIewfzgfxCcdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Rahimi <rahimi.mhmmd@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 213/331] thunderbolt: Fix setting the CNS bit in ROUTER_CS_5
Date: Tue, 20 Feb 2024 21:55:29 +0100
Message-ID: <20240220205644.411914971@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammad Rahimi <rahimi.mhmmd@gmail.com>

commit ec4d82f855ce332de26fe080892483de98cc1a19 upstream.

The bit 23, CM TBT3 Not Supported (CNS), in ROUTER_CS_5 indicates
whether a USB4 Connection Manager is TBT3-Compatible and should be:
    0b for TBT3-Compatible
    1b for Not TBT3-Compatible

Fixes: b04079837b20 ("thunderbolt: Add initial support for USB4")
Cc: stable@vger.kernel.org
Signed-off-by: Mohammad Rahimi <rahimi.mhmmd@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb_regs.h |    2 +-
 drivers/thunderbolt/usb4.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -203,7 +203,7 @@ struct tb_regs_switch_header {
 #define ROUTER_CS_5_WOP				BIT(1)
 #define ROUTER_CS_5_WOU				BIT(2)
 #define ROUTER_CS_5_WOD				BIT(3)
-#define ROUTER_CS_5_C3S				BIT(23)
+#define ROUTER_CS_5_CNS				BIT(23)
 #define ROUTER_CS_5_PTO				BIT(24)
 #define ROUTER_CS_5_UTO				BIT(25)
 #define ROUTER_CS_5_HCO				BIT(26)
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -290,7 +290,7 @@ int usb4_switch_setup(struct tb_switch *
 	}
 
 	/* TBT3 supported by the CM */
-	val |= ROUTER_CS_5_C3S;
+	val &= ~ROUTER_CS_5_CNS;
 
 	return tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
 }


