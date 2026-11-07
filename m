Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064758;
	b=B7RC68Um/jFHMrHDFari+5rfLiMAr+dTdHVsQey2H5ivGoT3dgw58H7D5sRgklHxV9OG
	 d8+fa3Qi8MK4j0V/8tyoPS2MdZaQiPTusW8ILjogVHx9cKGO3Yrbn6plizdcJWYm7D5jk
	 qYK9PqmXsHkZl20Vhypefo9ugprZfcXOStX8h3CnPYZoekxUzA9M/NXHcoOsUPhe6tAfe
	 URAym/cXDmWfTfs5BRtY8O8KjjZDkncwSnM+gDiQhl1Cp/ChrZVtWxYUyz4cZmvNbyJca
	 mVlffCZ9mZfSRRH71TyjpomSMlGKHJILl86N4tnKWmxwPG1r9gEBXc76Tl69jcgT0+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wxQHkyeK9cCQFmPoj3vQKncsisPz0GyjdNoortIeZ4k=;
	b=eLq8Qe5j6ahCcfKUZlVmVm+wRbnT/XihkLF5eG6LNUkdMpps0FaV70ZcDQb2Bc1UUuTP
	 L9J4sHpU+OlMMJntI2wdC+P5Xo/raxDnUm30Zp0ySqWUitCLNzXxYLFY0pbxbLCU2ES1o
	 t9CHXqm6IMP3R8TJJRay0Bl/3LiRn/alwqRaiFrDVcLVqtFKoz25PttHTNvMTwQ9Yx/d+
	 3reBT27BRzXOsF7NjM+UP36rn5vL3UB2kaa4OedVIswYeb2clQuRD2qYiQuNRjauiFHUA
	 Xs9WD1kaKRAbCLklSUE41MXCJue+2qa10WeC07bRSoT14qNxexp95VqO42eiUKHIFAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iazc3q0o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C927606E8DB;
	Sat,  7 Nov 2026 15:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iazc3q0o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DDE1F008A3;
	Sat,  7 Nov 2026 15:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064758;
	bh=wxQHkyeK9cCQFmPoj3vQKncsisPz0GyjdNoortIeZ4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iazc3q0ovPHFZ9N5DkIJLBZVdRYFhfq7Amh3BfRnxKShHCth9wFHTx49JfES2RijB
	 HHbGjJzAnK7dvfTuIvV4J4fn+5WCuHRyq4sgVQJ8OtpoLr+FcspSDf74MsIF2nVCLB
	 /1hCbsfPEArtbpLlVLPO/NLjOL3x8h6rDKnTsFf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0729/1257] pinctrl: stm32: Fix fwnode reference leak in stm32_gpiolib_register_bank()
Date: Sat,  7 Nov 2026 08:50:25 -0500
Message-ID: <20261107134959.408195023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 54c66b5e47a9b10cbf4a1efe9b01301b7ffee205 ]

stm32_gpiolib_register_bank() walks the "gpio-ranges" property with
fwnode_property_get_reference_args().  As documented in
drivers/base/property.c:

 * The caller is responsible for calling fwnode_handle_put() on the
 * returned @args->fwnode pointer.

The returned reference is never put.  The function calls the helper
twice, once directly and then repeatedly in a while loop, and each
call overwrites args, so only the last reference is even reachable
and all the earlier ones are leaked for good.

Put the reference as soon as args.args[] has been consumed, both for
the initial call and for every iteration of the loop.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: bb949ed9b16b ("pinctrl: stm32: Switch to use for_each_gpiochip_node() helper")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 6a99708a5a23c..93127da05d560 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1666,8 +1666,12 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
 
 		/* get the last defined gpio line (offset + nb of pins) */
 		npins = args.args[0] + args.args[2];
-		while (!fwnode_property_get_reference_args(fwnode, "gpio-ranges", NULL, 3, ++i, &args))
+		fwnode_handle_put(args.fwnode);
+
+		while (!fwnode_property_get_reference_args(fwnode, "gpio-ranges", NULL, 3, ++i, &args)) {
 			npins = max(npins, (int)(args.args[0] + args.args[2]));
+			fwnode_handle_put(args.fwnode);
+		}
 	} else {
 		bank_nr = pctl->nbanks;
 		bank->gpio_chip.base = bank_nr * STM32_GPIO_PINS_PER_BANK;
-- 
2.53.0



