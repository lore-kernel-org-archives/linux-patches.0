Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361033A1E8C;
	Tue, 31 Mar 2026 16:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976388; cv=none; b=MRrryQX+N6j9+5rNM4V4KkMy4dHDnzkGi09QadD7WCjuLPn0becypcRAO9PPEv2W8/Epg906N3uN898l0zKKWgdMUCh22OMjNKBxqtRyWmgY09VLOc2lUK3PMbxOwe+TzhiBF1nxzdsnL/F6fdMdjBsc0VSzSape7oIE8EQKYKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976388; c=relaxed/simple;
	bh=6P31AoUHd9wGKr3GtdQ53IeYIMl4mOGrgM0LR659aUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRnyPVxu7hD8ajUwt4T9bxVEluf9ZXO4CaArpveENGAopTNPWxHLjs6NNvCbmRKVzQJLXkuFmIXxIW1sbTIAO+/sDt55Ff58/eZVdEqYLglyT5Mz4jNa75NvUeIqSwuGa2bqckmyO90TnaQozI6IbmzTu0+v/QaZF4NIqZ/kIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7j9PAEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7j9PAEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01B4C19423;
	Tue, 31 Mar 2026 16:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976388;
	bh=6P31AoUHd9wGKr3GtdQ53IeYIMl4mOGrgM0LR659aUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7j9PAEfTQpnrQLd4HOJJgr8jWeRVgDMev8xPqVjp8yU8iiDugY3b64HNxJUd+9kG
	 +K8dahcargQAMPDXBvY6D3m2kEwfcGtwSWpRWlVhYZl5MMgdPjVLfsClNl6wrtO9oM
	 5F3DEJKyDg6Remo3dGGPjQ50zo8FgNqJYkuWDxew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/309] pinctrl: renesas: rza1: Normalize return value of gpio_get()
Date: Tue, 31 Mar 2026 18:19:37 +0200
Message-ID: <20260331161756.213251264@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit fb22bb9701d48c4b0e81fe204c2f96a37a520568 ]

The GPIO .get() callback is expected to return 0 or 1 (or a negative
error code).  Ensure that the value returned by rza1_gpio_get() is
normalized to the [0, 1] range.

Fixes: 86ef402d805d606a ("gpiolib: sanitize the return value of gpio_chip::get()")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/aZYnyl-Nf4S1U2yj@google.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rza1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rza1.c b/drivers/pinctrl/renesas/pinctrl-rza1.c
index f24e5915cbe4b..2677ee7035fce 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza1.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza1.c
@@ -590,7 +590,7 @@ static inline unsigned int rza1_get_bit(struct rza1_port *port,
 {
 	void __iomem *mem = RZA1_ADDR(port->base, reg, port->id);
 
-	return ioread16(mem) & BIT(bit);
+	return !!(ioread16(mem) & BIT(bit));
 }
 
 /**
-- 
2.51.0



