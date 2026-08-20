Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C20E352019;
	Thu, 20 Aug 2026 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238144; cv=none; b=Hdo4ghtqQohUPTZwL5OhHVso1mouBsyNWp7LoKroIgmEdEBBv0gBtV8o6k90fF2WR34pkbY2N6/6rY99lFZ04zqxLbu6NvCWzgsI9rryTzgjrgfEgQUrnxWNRA5WV91IBXJjjmTwsn3mkrpAIlG9+1F9WP+owpxNrBr0ombKG2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238144; c=relaxed/simple;
	bh=C8pksKCnBLRLYnNcYe7tHM7a8HzBAt/BqUYDv0j2qHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghVuukBXtZnfcUVA8xpL5iVWw+Ccg+NlLNVycSXrZ4BpmqRBNDtWSA6XeJWNRni95toMAqp5EgXP/XME6aKgOJQYFlI5CQBF+XzrKVa6zQ0jztHXEdIv3iPfPwzg+LZqsKMrvfLEvhIyVKgMJ/LN6mI8pvgx9+IKLGxdvomRa4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/0NYySz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/0NYySz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922FB1F000E9;
	Thu, 20 Aug 2026 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238143;
	bh=9SUwFuAldep9FXCvL3PSDtDXnftB0MZQqhdx6VbDzXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/0NYySz+nl6ht0ywFFTSHSq0XuT17j5gnuz/pMVilWEGhEax40Xfp+8XTpqfs2O2
	 Fn0ZOgTWUCT+ILf/rywpxJ7UAyj1ZFtZT3flAjOsOOTbdanaEo7OLbo3sRM8ueccWu
	 Hjtry56eRl7APcLHCwoSqDX10oyGTsryqy4PGva4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 045/228] Input: psxpad-spi - set driver data before use
Date: Thu, 20 Aug 2026 16:53:07 +0200
Message-ID: <20260820145245.840127745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 732f38c36059e68ba3b4b89c56911d777fd3185c upstream.

psxpad_spi_suspend() retrieves the controller state with
spi_get_drvdata(), but probe never stores it, so suspend dereferences a
NULL pointer. Store it during probe.

Fixes: 8be193c7b1f4 ("Input: add support for PlayStation 1/2 joypads connected via SPI")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260721055551.1714965-1-lilinmao@kylinos.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/psxpad-spi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/psxpad-spi.c
+++ b/drivers/input/joystick/psxpad-spi.c
@@ -373,6 +373,7 @@ static int psxpad_spi_probe(struct spi_d
 		return err;
 	}
 
+	spi_set_drvdata(spi, pad);
 	pm_runtime_enable(&spi->dev);
 
 	return 0;


