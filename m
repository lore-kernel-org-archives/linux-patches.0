Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CB447D934;
	Thu, 20 Aug 2026 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244454; cv=none; b=d5YEzlnOdQQYPeYZe3Lxg/M90/IQv+iSo0twMlSF2VlG35D4w/7MgseayzP0zrqF9LclEDCjDJKm/T7+hTA8Wj5SM+lzXq5GbnT9YvQb2ICRyY04kvHy7DRJqIBf9amGNjDxR5h8lJ2ok0adjWkigoeZmcF+PhG1fRSgXXfV2mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244454; c=relaxed/simple;
	bh=15v1hl2xNsDbfCUcIZhJ/qvuXFJp1CdMzRKlIGTqufg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9mB+yan0a9S5YIggf1UsA7LCARTWi7hKrpmLhXS9Qfp4ApKrl5RYqvffzqH7LHOnXbzllWcN7zTK3744EijNWItY4U1PpXz//lY35BSXe/HsWhrHGDz7SYEfLAb2QAfEPWo74gS3Gf/osvMCCPGF9+WuNMBl4QNZUNG5F4O4u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVeYJ0I+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVeYJ0I+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5847F1F00A3F;
	Thu, 20 Aug 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244452;
	bh=HliOdgpWnKmA+YPzvjvbpTivU3/EE3yld5GwhOntJQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVeYJ0I+wxWwe4Nl0kIY5FVzZktG5MEnoy+6j43d7wS0Dz51NJcDiyJDvDWsvoDxm
	 YOksuHDuCuyD6onPzG6QAGkIl5t3qlwhYp7IN8qDEaknSthxSiPuZgLmWenT7iJrli
	 KBcAgmCbSBwhyOKXBkznPDMLzlCO5hmg7kn4yn3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Lech Perczak <lech.perczak@camlingroup.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/235] serial: sc16is7xx: remove obsolete out_thread label
Date: Thu, 20 Aug 2026 16:56:49 +0200
Message-ID: <20260820145221.753923797@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit dabc54a45711fe77674a6c0348231e00e66bd567 ]

Commit c8f71b49ee4d ("serial: sc16is7xx: setup GPIO controller later
in probe") moved GPIO setup code later in probe function. Doing so
also required to move ports cleanup code (out_ports label) after the
GPIO cleanup code.

After these moves, the out_thread label becomes misplaced and makes
part of the cleanup code illogical.

This patch remove the now obsolete out_thread label and make GPIO
setup code jump to out_ports label if it fails.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Lech Perczak <lech.perczak@camlingroup.com>
Tested-by: Lech Perczak <lech.perczak@camlingroup.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20230807214556.540627-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: af071d9e07e5 ("serial: sc16is7xx: implement gpio get_direction() callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1397,7 +1397,7 @@ static int sc16is7xx_probe(struct device
 		s->gpio.can_sleep	 = 1;
 		ret = gpiochip_add_data(&s->gpio, s);
 		if (ret)
-			goto out_thread;
+			goto out_ports;
 	}
 #endif
 
@@ -1423,8 +1423,6 @@ static int sc16is7xx_probe(struct device
 #ifdef CONFIG_GPIOLIB
 	if (devtype->nr_gpio)
 		gpiochip_remove(&s->gpio);
-
-out_thread:
 #endif
 
 out_ports:


