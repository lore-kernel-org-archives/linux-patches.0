Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061532;
	b=Bu0Ycq350v6f93A3IvZj/hF/6c/2qPIO4+U2Ov9UXJ9ttdJaakAIwsiGzCL2xpc/whNO
	 7BTNuxMJFlYsDeVp7ULq2jSaxdQ7Zl3d+Q9XyvoIGhHj8s40WSndc4ENawqCl9YwbtiP9
	 KYWpCgYWDGvnhRobdlEXw+tRFNcMkUJlTHJ3XzmCrgrn9x4nBx3IuaZszaORTYaqbrlLT
	 G8kPKTdp7+NZglYpLSxr5cZcYzHNhRlI8eDYZsPYzKa7E8VyB/dRkpknSYnLmYElh95kY
	 OHJuhvzaW+o8MygcAdk8LUgg3PV2mzw5h615D49b6R5dD9HPVqUfOlz87gc+XZ2kksg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jlDqaUzBmY7KSJR/cJQFa9bN9vjDKYH/L3WntiwrWeU=;
	b=fp5QBl15GDcNt604kk3vUV+SZXnqJyTy9NSWe5AJBrqXU398XJCHBrABeu9CicAvoVJd
	 xZv62Wgzeiq/LMr7f98ghaM/t9G0L3V78VnWxIwPRHJFPhOK7l5miwWmDZFmiI6ooNGHz
	 VV3Cf6qTJwjV3LrE5nlwh6+mVD9n8DvA4wnUhl/NQ+yEy0YlsupSRcuzoJ05PPnh314Qk
	 7oncanPKUEvZ7Ra28RCypXafoz0jooYhT2w0Uhk+8jjjjuEkC4tTY4x9sWiLwtw6ZXe8f
	 GmH6Oxajtd10DBAnRNRJIwSlf+dWHZ0v022hosG/70ezunJ1XBpHpgWQ6Gy4p3zpBgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpWjZ4IF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369CC60A2608;
	Thu, 19 Nov 2026 04:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpWjZ4IF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5C11F000C6;
	Thu, 19 Nov 2026 04:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061531;
	bh=jlDqaUzBmY7KSJR/cJQFa9bN9vjDKYH/L3WntiwrWeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpWjZ4IFA/wEoUmOqL1tB2XTVHZEtv3+kbEe/pYUTrz8bEt6ajQjAd+cJ9t3sLm40
	 I8hTWNvwZkDJERi6XhrtxseVizSUI96edme+owfeFjQnYx8DAWzMA7k2qnrkcq+Ic9
	 wRis5ZLPUA5eD1d/I6AO+ZRLnJEwlXJT7J6x4jno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1585/1848] serial: max310x: remove holes in struct max310x_devtype
Date: Wed, 18 Nov 2026 16:00:23 +0100
Message-ID: <20261118150025.904902886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit eaf29135abb1c152a05572a5454c61dcd65bdeea ]

Running pahole shows that there are some holes within the
max310x_devtype structure.

Remove holes and optimize alignment by reorganizing structure members.

This can also lead to data structure size reduction for some CPUs.

On 64-bit CPU (arm64):
Before:
    /* size: 40, cachelines: 1, members: 6 */
    /* sum members: 34, holes: 2, sum holes: 6 */
    /* last cacheline: 40 bytes */
After:
    /* size: 40, cachelines: 1, members: 6 */
    /* padding: 6 */
    /* last cacheline: 40 bytes */

On 32-bit CPU (i386):
Before:
    /* size: 32, cachelines: 1, members: 6 */
    /* sum members: 26, holes: 2, sum holes: 6 */
    /* last cacheline: 32 bytes */
After:
    /* size: 24, cachelines: 1, members: 8 */
    /* padding: 2 */
    /* last cacheline: 24 bytes */

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-7-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 36f63519ebc33..15b0ad92d7264 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -268,11 +268,11 @@ struct max310x_devtype {
 		unsigned short min;
 		unsigned short max;
 	} slave_addr;
-	char	name[9];
 	int	nr;
-	u8	mode1;
 	int	(*detect)(struct device *);
 	void	(*power)(struct uart_port *, int);
+	char	name[9];
+	u8	mode1;
 };
 
 struct max310x_one {
-- 
2.53.0



