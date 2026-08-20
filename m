Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8437F00E;
	Thu, 20 Aug 2026 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238854; cv=none; b=k7UTWnA1ehrndEhuPJD55uKQWo9LvLUpdEHDuQ3//JW/3zP0V4UPPomtqhfdZGkP9+B0msOBniCrJH1H7wwRVLVYyTXJf8mGqH+MW78Prhfw/CSkbQOB6m3LiUmrw05PGCtGARdVJBzYZrgJhVcst0SGS4vvF2vPQPhf7XfuSGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238854; c=relaxed/simple;
	bh=XkuWaH/ajWKgJOojehAVQ4BTAZEIba2Xk/A9SZveHeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWS6n2qF4XHem6m83wu27woSTvFv/Q/GWTuvWXNUrq3zqBS+OIwLBxlgmOYYvFgR7Cntsjci3EXTBo7AJ5WFIC4rIvR81O7cSi5jEP1BZzw6pVl+HqgoiNxKjSzWGARleit1m5Qp/HuYoviXiYKlUJ0SavG1vLtLqpGDiOGPL4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aK+UVmL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aK+UVmL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A985D1F000E9;
	Thu, 20 Aug 2026 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238853;
	bh=nmvfJmUg4qgWiM1Jan4S0hhqRxyyGKkygrVeaLRqBFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aK+UVmL4zwUwcmqTovWneVgzzCSVm26sm5bUVgXM6PWDhwS0KtJd/z5kYs37iEqFk
	 WC/npjdPx2meI9+SnqNJz3S9vIQ9pEGQTHjs7d0PRPPWTjPhGrJ8+dvsQpTjwdkKAw
	 oeX2Mdb3UMFgtBonMNv5m5XBtDZz870K7ZDCYYT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 037/217] Input: psxpad-spi - set driver data before use
Date: Thu, 20 Aug 2026 16:53:25 +0200
Message-ID: <20260820145238.733461765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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


