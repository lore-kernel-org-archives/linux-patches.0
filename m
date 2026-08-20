Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503B9272E53;
	Thu, 20 Aug 2026 16:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244067; cv=none; b=eq7L6Rbs6vnVssUF3vY5W4u1wb/ZbComHTZtDZ3Y+t7vyYie8SJ9LwkLQ+71A4fGtkkqU5MD4+lhVkyNmuB9MAeaktaab/vodwGbaoeJ5biO+GGP6pqysYu+BLUpeO5EowXij88dzOaeXJTu/I5wxPr9CFksV8ZiYvKC/WLuhrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244067; c=relaxed/simple;
	bh=in/tKpthyalLkJRWWTER2aJ2NBysl+pZM2ZAMo9rrMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/u+84VJNQJS85DSUfrUGVJMEGaebXw4npQwbmzXYk2Os4TFaM3i7hBoADwNhwzRtzB0pfU1oexGghYZuK9xU6e1VuvWnHOMCaulYBQ96dMYig6M31RCjUjvnfMxWpeMAGwRNvPUlwJ2OVfO+W9rG2pzdbGWebHdER8AygW1YzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hY4+sOQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hY4+sOQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE101F000E9;
	Thu, 20 Aug 2026 16:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244066;
	bh=ojpF8Ynv1x7BAKMYruilQKvNJ9u/24QxBzhMQ70ynFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hY4+sOQP3UdyOS+dnxm+lsdJVoUt25q8Nz/oAOGwhqUYEtU4IIApe8GcvBdtOaKvm
	 ngs6D+MrXRrKQwjfpXwrqQA0raKhV+SD5R4APAGb75/uq3NtLJ0xcYQ6w7V3UG5eVW
	 uSOmTpNaZCAZqLAgoy/ycdkQ+ngsE34dXfsaiofU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 013/235] Input: psxpad-spi - set driver data before use
Date: Thu, 20 Aug 2026 16:54:09 +0200
Message-ID: <20260820145216.844351906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


