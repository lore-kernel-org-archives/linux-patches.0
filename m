Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129BA1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDwomz5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D72C433C9;
	Wed,  4 Oct 2023 18:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444652;
	bh=Zo4cmD3ih1B1T8xMqpKc3BAbTUA7+zW7oqmdbfwN72w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDwomz5pju1nfDpOMO33hV8/3+pBo8UQIkaKjgGnVk4Yn6JAiezLzMM7nCS2PQZ4H
	 ugIWXCKfL6Cles9sFwFtyCGrq7wvcWZb4b5cJbxbLJtg0SY7udtZx5KM4iPbvC71o0
	 jOVRUQDnPpyHAYhDEeL663q7PQJ/8asBgLIjw9mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <frattaroli.nicolas@gmail.com>,
	Chris Morgan <macromorgan@hotmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.5 309/321] power: supply: rk817: Add missing module alias
Date: Wed,  4 Oct 2023 19:57:34 +0200
Message-ID: <20231004175243.611245994@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>

commit cbcdfbf5a6cd66e47e5ee5d49c4c5a27a07ba082 upstream.

Similar to the rk817 codec alias that was missing, the rk817 charger
driver is missing a module alias as well. This absence prevents the
driver from autoprobing on OF systems when it is built as a module.

Add the right MODULE_ALIAS to fix this.

Fixes: 11cb8da0189b ("power: supply: Add charger driver for Rockchip RK817")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
Reviewed-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20230612143651.959646-2-frattaroli.nicolas@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/rk817_charger.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/power/supply/rk817_charger.c
+++ b/drivers/power/supply/rk817_charger.c
@@ -1220,3 +1220,4 @@ MODULE_DESCRIPTION("Battery power supply
 MODULE_AUTHOR("Maya Matuszczyk <maccraft123mc@gmail.com>");
 MODULE_AUTHOR("Chris Morgan <macromorgan@hotmail.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rk817-charger");


