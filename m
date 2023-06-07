Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079AC34CF6
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C072C433EF;
	Wed,  7 Jun 2023 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169216;
	bh=1un5sfJBGfmPBs+h3oVYtGKR2MzTnQrzWfPkJG4dIuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJn6EfQHPwoA9U75NVn3I1hOf+E4BbIpzNLdp9cR+mOyXViDMRHQQHm8OdPR/18Nv
	 P6l+8GeoiDnkcMEYJu47X3EoGUWMLoZM672Nj9sZHdIiAJRkQsdK0sUE/UFH+MTlFo
	 7DwcR1EgOYuW54NkrH4CVPbDqzBBubRfCNLZa8rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Bersenev <bay@hackerdom.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 4.14 58/61] cdc_ncm: Fix the build warning
Date: Wed,  7 Jun 2023 22:16:12 +0200
Message-ID: <20230607200855.203667352@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
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

commit 5d0ab06b63fc9c727a7bb72c81321c0114be540b upstream.

The ndp32->wLength is two bytes long, so replace cpu_to_le32 with cpu_to_le16.

Fixes: 0fa81b304a79 ("cdc_ncm: Implement the 32-bit version of NCM Transfer Block")
Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1176,7 +1176,7 @@ static struct usb_cdc_ncm_ndp32 *cdc_ncm
 		ndp32 = ctx->delayed_ndp32;
 
 	ndp32->dwSignature = sign;
-	ndp32->wLength = cpu_to_le32(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
+	ndp32->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
 	return ndp32;
 }
 


