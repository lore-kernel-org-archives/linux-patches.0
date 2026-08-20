Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BB9471D1D;
	Thu, 20 Aug 2026 17:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247382; cv=none; b=buxJMvgWuQ3hCLLEw4I/z9R2xhNEcSYuqcdTW8uWSUWb5ITtvzxgJqj/jBdz5wWDw+7elhprk/N+XU2W/5vgIZX3K0jCiZtEp2UKEfVISG0+3szSUbBPEznV2QG/LcnRzmbo0057jIVFTYRL5zS37rRmQ/VasEp+5KqT8dVY55U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247382; c=relaxed/simple;
	bh=E9NtGisNRT16jypFPpTYk1XS6aOPdBo4y50g5qr4tI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcoKijR4QqnbadRY25xJfxLt83NrNhEceNujkNDEB7VFAJhAPxhSIMhaqT70n5Oyd8epvw9cwFx8cyqsZgDyDAwIrqUItenqv4dg+DxpUh/Sd1DYzW0gGO5IsjbMz2Wyt5JYu2Yg/UD5eMUlUO+Kt1HhgNgFI5qrpsTemxvVwjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPzp36Q+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPzp36Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DAE1F00A3A;
	Thu, 20 Aug 2026 17:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247377;
	bh=nUEx9r1fI10GAHGbwrq7V0YrbU2Duqw7GUbFTIND3tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPzp36Q+EzHBRwYa+eQ8MwJzIU8oBJGeWXBe4fkbLsV8nQg74Eq4fXclzRZP4olEL
	 AEfk09yoopqs3CNHp3nAeSJk2T0Z5R8dk6wEj8ZC2f/L8XPpb/6zjduAgul8SNWHlV
	 FVwu62xt7SHnol8hMFcDwMp/fZI71gSMBlmU5Wpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 025/166] Input: psxpad-spi - set driver data before use
Date: Thu, 20 Aug 2026 16:54:44 +0200
Message-ID: <20260820145211.943118126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -369,6 +369,7 @@ static int psxpad_spi_probe(struct spi_d
 		return err;
 	}
 
+	spi_set_drvdata(spi, pad);
 	pm_runtime_enable(&spi->dev);
 
 	return 0;


