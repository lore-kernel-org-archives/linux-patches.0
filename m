Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590292;
	b=Lga+xCDzMhftGP/HcUfBa+WCxqSV1wQHAwxaZCHI0znXSM3TJYEJrH1ioJ5YXPx+mwbK
	 1ChbkcOr+5QIuifR6338rhvaOm/eEd4Wxofpp1YfEZFrkp7EUc4MYd8eodgt+lAxbcswd
	 JYn8vujVF7QwatPvXxRD4PAcA2ZjQDkhthqcOb2M3FfrxmEQL8y/DQq8adTfqdwRCmjXe
	 u+b067UPcEb+RFrS1dBnUONzWbZYrZn73SZ7unFhFMBdBrKIuPGMD6YTqrefrzyLsgxze
	 XQQ+5DDbB46hAom/2uLiLRk0FZL9xpBDUvCLKJAnjERyQGO6x4M3zEFBhkCovY8zWfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SgiF7bWoMTgGYrpzUiSSoDrP3pPwYtvA9x5DNTwy75Q=;
	b=FAPzuQ3RrXUjoHdwJMmn3rCcUCu8r67iesb2eMrWPmLAAe17sO/lSFyF5R3+sKsHFAFw
	 UN2CQE66qAD/w0FCbcW5+gR6WSd3VGusHWHEG7uBnJ8y0AHac0Y4d++2FKqkXLbVkpvM7
	 3paSFuntY42vG+0hXc8dTCW8Ick6+8xvedNuI93rCKPJS91V+1/4IVWyibFucrE8hV3Ki
	 JeL6gbX/TAFA3xMDL1+TICNaUsXB4xrNVKji6Ax1OXDBXvAeY2MiMbMnzrRt6BOt4LpVH
	 zIcBojrXXYJ/i5/Z9/rjuTcpKxQ28yICU7La+6F6ot8GVHyPQS8qlJ+3/KzOzERzEAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="izT86g/0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF47560A260B;
	Fri, 13 Nov 2026 17:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=izT86g/0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D54D1F000C5;
	Fri, 13 Nov 2026 17:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590292;
	bh=SgiF7bWoMTgGYrpzUiSSoDrP3pPwYtvA9x5DNTwy75Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izT86g/0T+3eLgAtI7Nw/cYJRYXwD849+5+jj5c78aES3j6IYwO0uJYdj9PJSA5Sa
	 +U3l0L4L43Ml9eR+aqboMOvu12zHRLOtUNZuYxYo22YZHih4wKMVvW4WKTt6H3CnZO
	 ZqM/VrpjamccB02YwqX1newI5qbdZcWNFsA5uqFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 273/686] hwmon: chipcap2: fix off-by-one in command mode retry loop
Date: Fri, 13 Nov 2026 10:46:46 -0500
Message-ID: <20261113153830.255623068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 4c0e65a4ed665c416ccb1524c58a646a580e491f ]

i == CC2_CM_RETRIES can never be true inside the loop, since it
only runs while i < CC2_CM_RETRIES. Use CC2_CM_RETRIES - 1 so the
last failed retry breaks out immediately instead of doing a useless
disable + 80 ms power-cycle delay before the loop condition ends it
anyway.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-2-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index b3d944852e73a..c5b6e147467cf 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -224,7 +224,7 @@ static int cc2_command_mode_start(struct cc2_data *data)
 				     2 * CC2_RESP_START_CM_US);
 		}
 		ret = cc2_read_command_status(data->client);
-		if (ret != -ETIMEDOUT || i == CC2_CM_RETRIES)
+		if (ret != -ETIMEDOUT || i == CC2_CM_RETRIES - 1)
 			break;
 
 		/* command window missed, prepare for a retry */
-- 
2.53.0



