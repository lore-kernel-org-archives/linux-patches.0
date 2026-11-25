Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619230;
	b=p1W+ggAlck9qg0NIuGcuoi5tdNnnreqoCGy9ZKGFxzjjR9Hyp6J8rGM71btjDRJ0tWg8
	 cE3RSacRwzlelpJSKEKlPH7facgJqnOTvYFxkyguF90+0h72vQIHckjH5IHy1QhPz4mWi
	 uEJpDc6zyHPrBisQ0p2t32yGYOlu2+WLNYkuBmL/9zDQ42UYSrs4a0dkR3lYx225LkjIU
	 6sIxAPF2TCQcIo9AhOZPR/8zMAfhNNMPN5meW1zILgYCOQ18WPpMOpkQEQV7HxZPiQFkR
	 pOvBrurp8wVYTk5ULVbta6NM4CFIK1W9W/a5BTyt9gqOMhgVuALkJMN43ATrrEWvBPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zb8uy1P79Qyu9a4D7QYXpVT6DMTPTNvRAAYP73f/JiM=;
	b=xxu0T0IQAss3BU2Z1sOVD6Sh0T0w6AU4plih68saVY1kgJGF/upsmXiFh5TrNL83mOpA
	 ZvI/ZWad9ZLFofQm4eB1iuKskMiF0NnI8j+1+x+ijLuJms7D+1uqVXe8aTptvcFuz7Px3
	 zYYt8Yf61Ci9mEqAecaq00AB90noYpNPqGKMtTkG9N7M60rT7MEiv3t3gCcMjVzUQfX9P
	 Us1AscYoVCvdT3sHeOkuLBkBfTDCPrRyf1NK9ceuV2tx+3nSfY1b9QIjpPC7eXnTnQ+fw
	 3OsdqycHkhAWX373un+JKt8PkffFCDe/sdKCcyEVj80RhWwW3b2+wiMR15egzEjC90A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZoV+66HX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7A4606A321;
	Wed, 25 Nov 2026 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZoV+66HX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0291F000CF;
	Wed, 25 Nov 2026 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619230;
	bh=Zb8uy1P79Qyu9a4D7QYXpVT6DMTPTNvRAAYP73f/JiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoV+66HX9LW9qp2orFSS6mT3wQvhSZe9xhfvoC29KHMIoYI++9nS6mkTYBBnK7qPr
	 tg5PvGBVNu241L1NnoLMmLdL5Kc3yAXxh0OhQ4ArW7a4ITDNDYyUXQscEzx+ScZfwv
	 RM8OeXG0L9yWbrxTvSF5fVumRQUMoCmkOJx+dFJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0530/1005] drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule
Date: Wed, 25 Nov 2026 15:31:08 +0100
Message-ID: <20261125143834.163004306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Sousa <gustavo.sousa@intel.com>

[ Upstream commit 557c7b4343781cae9725bf26122d29c26ea12f5d ]

Wa_16023105232 was extended in xe_wa_oob.rules to match extra IP
releases while the respective entry in xe_was[] was overlooked.
Update the latter to be in sync with the former.

Also add comments in the code so that we don't forget to update both
places if new IP versions are added.

Fixes: c96e0df4e9f5 ("drm/xe/xe3: Add support for media IP version 30.02")
Fixes: 4fde66699f1c ("drm/xe/xe3: Add support for graphics IP versions 30.04 & 30.05")
Cc: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Shekhar Chauhan <shekhar.chauhan@intel.com>
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
Link: https://patch.msgid.link/20261105-wa_16031259911-v3-2-da6ec790aa29@intel.com
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
(cherry picked from commit 0cfb54f8f4d69efc847641738d25065049160aca)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c         | 5 +++--
 drivers/gpu/drm/xe/xe_wa_oob.rules | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 139434946f8f8..0c847029437c5 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -579,8 +579,9 @@ static const struct xe_rtp_table_sr engine_was = XE_RTP_TABLE_SR(
 	  XE_RTP_ACTIONS(SET(TDL_CHICKEN, QID_WAIT_FOR_THREAD_NOT_RUN_DISABLE))
 	},
 	{ XE_RTP_NAME("16023105232"),
-	  XE_RTP_RULES(MEDIA_VERSION_RANGE(1301, 3000), OR,
-		       GRAPHICS_VERSION_RANGE(2001, 3001)),
+	  /* IP versions need to be in sync with the respective entry in xe_wa_oob.rules. */
+	  XE_RTP_RULES(MEDIA_VERSION_RANGE(1301, 3002), OR,
+		       GRAPHICS_VERSION_RANGE(2001, 3005)),
 	  XE_RTP_ACTIONS(SET(RING_PSMI_CTL(0), RC_SEMA_IDLE_MSG_DISABLE,
 			     XE_RTP_ACTION_FLAG(ENGINE_BASE)))
 	},
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 6662987effd73..04eac463a261a 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -44,6 +44,7 @@
 18013179988	GRAPHICS_VERSION(1255)
 		GRAPHICS_VERSION_RANGE(1270, 1274)
 1508761755	GRAPHICS_VERSION(1255)
+# IP versions need to be in sync with the respective entry in xe_wa.c.
 16023105232	GRAPHICS_VERSION_RANGE(2001, 3005)
 		MEDIA_VERSION_RANGE(1301, 3002)
 16026508708	GRAPHICS_VERSION_RANGE(1200, 3005)
-- 
2.53.0



