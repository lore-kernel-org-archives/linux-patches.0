Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F06519AD51;
	Tue, 16 Jul 2024 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146087; cv=none; b=PTVcNSBxwGfPzGzAkRL3nK9eaIY705tBISxbLfq1xF5FxId98Axew/PWPvC3ljv7ivQ7MfO0zyGxzx/GAVatgq2g3OoSUx9b1eD7AchIfiNVZd40yzjvpDgzU15N+DPau4ynsQbkodzhDgm2SqbAvKMvME5zRWRJnaQqQUUzkkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146087; c=relaxed/simple;
	bh=uTRx3+1Od3DBB5wM2S3OaoRJSC20AxlkBTa8KGGKcP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqBdlvRX3qgx0+dL9YuSFprpHXnIpe3/WIK5Vo545hjRz3ZDwqMDmFqEtdgL8ZJcMJHuZ6KbjD+lWOebs7ymewcgH+w8vVbjyrdPg2aWCasXqFo9R0EpaiCRLRb3tsBDGzhO8Za8OKCMEdrmYj8EPWgd6PJwYRORNV727lINVZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owI12RF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owI12RF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AB3C116B1;
	Tue, 16 Jul 2024 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146087;
	bh=uTRx3+1Od3DBB5wM2S3OaoRJSC20AxlkBTa8KGGKcP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owI12RF6OGVehFxZcHMpHZtzFWbj2jBJnMLpv05pIR/nTKWlFNznJYPrsPgwk2AHs
	 vFW6LCPqbMPi4tlo90x761bFNQKNhPGhG4k/3Q9UvF0nn31CY8067qGAS8gDXLqj9U
	 E7ABCr0xgx+4jaYUFsqtn4hgZgELioNF2F6bGmpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 053/144] can: kvaser_usb: Explicitly initialize family in leafimx driver_info struct
Date: Tue, 16 Jul 2024 17:32:02 +0200
Message-ID: <20240716152754.586867929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: Jimmy Assarsson <extja@kvaser.com>

commit 19d5b2698c35b2132a355c67b4d429053804f8cc upstream.

Explicitly set the 'family' driver_info struct member for leafimx.
Previously, the correct operation relied on KVASER_LEAF being the first
defined value in enum kvaser_usb_leaf_family.

Fixes: e6c80e601053 ("can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression")
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20240628194529.312968-1-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -123,6 +123,7 @@ static const struct kvaser_usb_driver_in
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
 	.quirks = 0,
+	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 


