Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213931FECAB;
	Tue, 26 Aug 2025 11:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208572; cv=none; b=QnEmOl3/BDuk1vnKS1SgiESdwO+eFp6ztZ23pH+1H2Uf+hSTedytm1VsKVSOSGh04jhvsp/JzVClunrxoN33tCPsTG3pHrBw3hWhpaY62qzqIb6KDfIVN56pCB76VxnJuZgtBOpRMlxqcbocdO7LQcy0ctMDxIihCGfUrveJREw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208572; c=relaxed/simple;
	bh=vDfJWoZUrGDRYz/mCLoXR2khibwuGmA9Ex6iNCHEjdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSIy3X6wkLB2B9EWDU4KWoxJ4kUaiSNkER7aupZ9MIQt9ttZXh+OH7T3ZH6VkvPkcbj9FBTYN0qS9WYZK/UrVfRGmcBtteah+aUy7yD2XiNnWBmaS/ZRsqfk0TUi6GlWysDAg+r50YzAFRv6ReB+rVB/KE4T6rHQFFQzJmaIdyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r61+70FR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r61+70FR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C4FC4CEF1;
	Tue, 26 Aug 2025 11:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208572;
	bh=vDfJWoZUrGDRYz/mCLoXR2khibwuGmA9Ex6iNCHEjdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r61+70FRmK9oS0N0Gt1lwSVPAIQ18EjTNMM7mn0dp63+XtUS7/qpXYbcssbk8LOc2
	 Sau4OiUydHlxzI09K9C0Wiiqjpq3tinNtZfiPQ2vIY1NSh5UgN57AetEpSQ5XkE4Xu
	 Hf7gPOQC52/zg3ZJ+Cal+ZS4z9CapGmf5rtJ/VHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/322] Revert "can: ti_hecc: fix -Woverflow compiler warning"
Date: Tue, 26 Aug 2025 13:09:37 +0200
Message-ID: <20250826110919.824243796@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 1da38b70d90f8529c060dd380d0c18e6d9595463 which is
commit 7cae4d04717b002cffe41169da3f239c845a0723 upstream.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/63e25fdb-095a-40eb-b341-75781e71ea95@roeck-us.net
Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ti_hecc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -383,7 +383,7 @@ static void ti_hecc_start(struct net_dev
 	 * overflows instead of the hardware silently dropping the
 	 * messages.
 	 */
-	mbx_mask = ~BIT_U32(HECC_RX_LAST_MBOX);
+	mbx_mask = ~BIT(HECC_RX_LAST_MBOX);
 	hecc_write(priv, HECC_CANOPC, mbx_mask);
 
 	/* Enable interrupts */


