Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12FAE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B142C433EF;
	Thu,  1 Jun 2023 13:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625765;
	bh=aiYXE7OjtZw5d+fA+53xrBfr0NXXx+y/x4JybuWeWkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMI2nz5myAKj4U11JD0+JZx2qVxdJ41PAKXhh0e2NxtMcKTy5y59kmsTZNTadCv2f
	 aiJ3QnwexdjXsgM0uPO7E56EvXo30Bia8Sflxd7sl8+swZbEz3O9Ka9uPd36ftcVJo
	 Eg6ikQdV1zY1Tl3sCi371CpNXO+gwSxT5OB2V4Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Bersenev <bay@hackerdom.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/16] cdc_ncm: Fix the build warning
Date: Thu,  1 Jun 2023 14:21:04 +0100
Message-Id: <20230601131932.389174924@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131931.947241286@linuxfoundation.org>
References: <20230601131931.947241286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Bersenev <bay@hackerdom.ru>

[ Upstream commit 5d0ab06b63fc9c727a7bb72c81321c0114be540b ]

The ndp32->wLength is two bytes long, so replace cpu_to_le32 with cpu_to_le16.

Fixes: 0fa81b304a79 ("cdc_ncm: Implement the 32-bit version of NCM Transfer Block")
Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 5fb4f74c26efd..4824385fe2c79 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1177,7 +1177,7 @@ static struct usb_cdc_ncm_ndp32 *cdc_ncm_ndp32(struct cdc_ncm_ctx *ctx, struct s
 		ndp32 = ctx->delayed_ndp32;
 
 	ndp32->dwSignature = sign;
-	ndp32->wLength = cpu_to_le32(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
+	ndp32->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
 	return ndp32;
 }
 
-- 
2.39.2



