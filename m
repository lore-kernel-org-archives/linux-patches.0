Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7E6356742;
	Thu, 20 Aug 2026 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247961; cv=none; b=tWK0lCoRKhffO9DC06CDjlW/c7EUFTSLxq4PGbkTWkO6Dez68qBYbwBeUHe4Zgk0l9/T7xL4kGy3EXR+7n02s9pYn2nNy3ydg72+36ih/kpqkBRBDBRYx1mz5xpVi/jZMCYUN+pPEPxAY8u2WwNuiPnzxFuJ4lyC+mecOq26oXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247961; c=relaxed/simple;
	bh=GP2CLXiWi2Zdkx3HnEUM6ZRuWdQ3ejuWOJBaC3WWSL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3NEPwOPVrh6IPRCurJMef2W6zd+82840mXDnwgta+h4A8aJ+1hq+erPkoHIeLWf8OA8X08ArLXefw/mdVGDPcRD3LfV/qLzXN2g1biCn34kukzwNyuduIJfKo1xZONUaO0qe+obejEQvCIqOF7xWJ57YEcuw2dEvLysHYQyqYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ot6CKVGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ot6CKVGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990641F000E9;
	Thu, 20 Aug 2026 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247960;
	bh=ThTGyQXta8ovEzcCsUy/1Jo4L1oKWivxWioIH0Wo1RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ot6CKVGqbhXmqHOdvIdpZmPSaz2/5bPVNZTaFleMNik8E795WS34Ly1gKl5T+uxPR
	 sdH0zxOVGamfiNyQIwR0V37uB1QTIo2r22kFZDVZTboqH2446j1kgIFgvOr9uZg4n+
	 BizUkEj+xlB39NUKwCibhFH5gIV9H+L5VfFZrOoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 022/303] Input: psxpad-spi - set driver data before use
Date: Thu, 20 Aug 2026 16:52:38 +0200
Message-ID: <20260820145253.847814097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -366,6 +366,7 @@ static int psxpad_spi_probe(struct spi_d
 		return err;
 	}
 
+	spi_set_drvdata(spi, pad);
 	pm_runtime_enable(&spi->dev);
 
 	return 0;


