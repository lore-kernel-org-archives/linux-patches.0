Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055683;
	b=E6jdn/e69AF4F4jLMmurERShjhf5/AigwQlcp8fqfudI94toXrN2pIpuwtA9rMdwYPIc
	 nPXu6snvNyelfRCBLBE/uFzx/+c9DbUAQCS7uWXY7M171hdDdKjkHE7sVF2o6uPdyNKD0
	 hPq1uol6Ds3EYCXjFuK5AxSSKUgMYJFJ4H6EvxedW3dFVPKnZVZ/o7pLDW7n1TzvL3WSy
	 jg/k5WcGLOAfbiOmU/DIhY17nPvMvyON6xXEbMg4+lRL4leYlHK8QPb2vX/2BDaDPywKS
	 3OVT60hS+rcrtcPWQ+We4Ur91Lpg0Y0ke5SDDKSHq0LAb/y7+I6EllyYLQa7dtZxSgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yhnesO8uGzv/jYDPyF/XGfUJ92HICacmdd2fPEavqnA=;
	b=RPQ3j7WGqpXNzriowIdK6VXOCTF5NDSE9HrYqB+CTTpAMl6hNmFIcQosBzpVQKPrCE5Y
	 6gfflxkzvnYCiOacOKFoTJ6yt98zXUQ2ujjK9xJVzPI0oIC4FNOWghWO6HPKbgz+m6lA1
	 O3V1k5DQWxS3JPycZi5+qRJCflinRYzQAYgSgoq0uvCNNgZZrVwf0TIPAcrwDvwc2PLLE
	 XIZjvYs5Bu+EHSo5umhweJTdMgDAP/XQ0X2stLo+nETma/RliccPRoeZNbQxWrGwRI0Kt
	 CeBHZyptgUdjatC+SXjKhhh226/2S1KlxJoJSZ0v/mXX0h6gxAhCQPcdINbH2LnU68g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ly4wXhDB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE45E606A31C;
	Thu, 19 Nov 2026 02:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ly4wXhDB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9FE1F000C5;
	Thu, 19 Nov 2026 02:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055683;
	bh=yhnesO8uGzv/jYDPyF/XGfUJ92HICacmdd2fPEavqnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ly4wXhDBgb+yqPOYU/FtAgX6JB+x1DVyBHIsVT+L3gajpEKWmxXIhcduJSj6nXCBY
	 fN3JqrPlNlKhP63UEoqFt1Y5/eXp/gM0Hh/nMUDWpkCgbvi29EZlmJQoY0yRxcnTWQ
	 IZ4/VQprN0PzeNOYzNT4cDvjN18ubPUZwpC8ddi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1718/2214] scsi: scsi_debug: Refuse a negative physblk_exp
Date: Wed, 18 Nov 2026 15:56:34 +0100
Message-ID: <20261118150120.462335577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a349876633f7a583429367daf16f9a4282118255 ]

sdebug_init() refuses a physblk_exp above 15, but the parameter is a signed
int, so a negative value is accepted. The driver then shifts by it when it
builds the Block Limits VPD page, which is undefined behaviour, and READ
CAPACITY (16) reports an exponent of 15 for -1.

Refuse a negative value as well, and print it as a signed value.

Assisted-by: LLM
Fixes: ea61fca58c13 ("scsi_debug: Add support for physical block exponent and alignment")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-18-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 843dc4728a5a0..4a9a1602589fb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6770,8 +6770,8 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (sdebug_physblk_exp > 15) {
-		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
+	if (sdebug_physblk_exp < 0 || sdebug_physblk_exp > 15) {
+		pr_err("invalid physblk_exp %d\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
 
-- 
2.53.0



