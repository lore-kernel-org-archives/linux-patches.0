Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B9B37F32A;
	Thu, 20 Aug 2026 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239415; cv=none; b=tYbCozwFenwa/FoCsBxV4rsswBVEr2tffQV/AqpLnhCGQkrQZwSlWV4xzp5zzTpM0IDsZPxJxIaUmulYnQs5eQQY2ECH7h3u/NVXFCkcvjxj0gtftmZTtfO94OAJXdgp9wz6dbvBhtCbyB5PBqmS97EhSAo27H+rVGAd4qg58Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239415; c=relaxed/simple;
	bh=CaBAFFv80QGm7PF5vwiXPYjUcaS29USRC8KsLDxMOHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESrLXTX4n68CwrHMy4ii+LZLNQLub8S+Pjcz5mhWPJqvgeYtZC6sMrxJpZY0Uqx0yZDoY+ef/xXtebepG+daceDAWQReQBwePKUh/t7Bq1ywf8SMUYrtxUsD6s/M7tCbxwa4lIABQ5hhpIHv+B4CD5R+FJ0Jb5cUJdx0OE0LsgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiAkxgBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiAkxgBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7DF1F000E9;
	Thu, 20 Aug 2026 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239414;
	bh=DyNMnpfcCjM2BGIslfy5BapZjo+jNCeF4llOjQ4u4qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yiAkxgBMVoQ0/VQ3soEVLni6kpovyLEy8q1tia5T2OcUAoRxM7k7Y6KKhoXKZjg43
	 fIuYcOfFPKHys4r1jVFmzYcwcHqmulaP3ovTuXzOTvAk3jXwT9UIJVCkLP0Hj9aRcI
	 MDbb/eYzwe6Dq3fgT2GxiS084grldYIwD0iWUeoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 041/220] Input: psxpad-spi - set driver data before use
Date: Thu, 20 Aug 2026 16:53:51 +0200
Message-ID: <20260820145224.728388593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


