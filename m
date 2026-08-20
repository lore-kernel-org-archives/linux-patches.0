Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F51477E58;
	Thu, 20 Aug 2026 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243210; cv=none; b=U+y9racX4OuMPybOq4spw8ZKEfP6dECD5I30ibZRcBE6qiFYX59NZuZYnTfmdM+ZdNjrTvVq1FmwaZbT/lz1PkDH6jYnbX5+z7ajGL3tVOSw4qJ1ntY6iFRQB9v+mXqcimL5CCTxJoIkODTrsnU0P8DCSOujQHEMI8KCfWSWlJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243210; c=relaxed/simple;
	bh=qNY6NRsNYwGwftVftq69Rxk46LbbbCiOROMDQcCrMh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xirk1n7jL+OJfIoh38+yq2H/FDoQCK05kxl4suvfaKOTsA5zbAshLnE2mvs5yDruarop7ddy+qojFofGxcbKMl5ML1wakBXto8Hn0BmiX121qGecndMu5AdhDrOt4V9m0ASkez4jjQ24QNXINZjq8ebb4bvn2o3ICWhM3V0dqtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA71iLeO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA71iLeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8D51F000E9;
	Thu, 20 Aug 2026 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243209;
	bh=F6NhohMi7Izh4V4MZHa7/1LZZcbPuY7D68vrDECnAjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RA71iLeOVmkNl3ZYBu39thvwndYmXbIDGtx1L9iYdZu+LqB1TGdMfVgvY7now0Gjo
	 jlo+9nI2dM8E6v08/YivRPhc3/7lqVF/M/seBPWzMx0nGx2Ivu1S6LpHQ7e4ybBU+7
	 mQVIf81iWMx+i8ZLBXFEN6ohE9IKsGQ1A1ac+YKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 016/272] Input: psxpad-spi - set driver data before use
Date: Thu, 20 Aug 2026 16:53:20 +0200
Message-ID: <20260820145231.722849205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


