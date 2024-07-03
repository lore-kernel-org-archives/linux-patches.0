Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D321849D3;
	Wed,  3 Jul 2024 11:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005085; cv=none; b=LSLJdToM4wl3u8UXuA4+PKze9Pz4H1PGZJzYs5t4AP0V2ddLNcikSBGua9pM6dy4UjDC3coHd75FISwVsgWZDjGYiCQeFQhObQmRML6t8uNnVdg+w1zaFtQ9tpp+7FgahLc2sQk9thtF7zQmIvA7Rw4C0H2OOyNxspeKF5YsblA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005085; c=relaxed/simple;
	bh=yUdhOO0MBoHyByiVixXn6eDcLK2MbKy91joRw2sZxQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDxaTtuYXaslDfGzkQiG2GXUxNUmZb2y0p0IIWAh00wxZtR+/1mKHY/M4N17fwoYetKekdbD7IreIeCGpC+Z3de/HNRW2No295QLuIbqPHqecGoanHdzNM/T9PstE5H5J8PstZj5z+7UFHRrY8O2slyOZ95uxLpBBmV4yrjdqwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GERMp19W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GERMp19W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56C0C2BD10;
	Wed,  3 Jul 2024 11:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005085;
	bh=yUdhOO0MBoHyByiVixXn6eDcLK2MbKy91joRw2sZxQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GERMp19W2PAs/Mt85qointa6NYFmAfYqs2896h+hMm3RKB/5DQVGHrTsYj5Yn5/O9
	 h9E5PAepaoRBEzO+7KNyJForuuZPLM/sS+11soKX2Kc5/NBwttHpY+/3tneUwDTFB5
	 hLzZan7JaMA6wtomdydFdMVW1FaxuYGAv/Ep5xpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 254/290] usb: gadget: printer: SS+ support
Date: Wed,  3 Jul 2024 12:40:35 +0200
Message-ID: <20240703102913.741231002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oliver Neukum <oneukum@suse.com>

commit fd80731e5e9d1402cb2f85022a6abf9b1982ec5f upstream.

We need to treat super speed plus as super speed, not the default,
which is full speed.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240620093800.28901-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -208,6 +208,7 @@ static inline struct usb_endpoint_descri
 					struct usb_endpoint_descriptor *ss)
 {
 	switch (gadget->speed) {
+	case USB_SPEED_SUPER_PLUS:
 	case USB_SPEED_SUPER:
 		return ss;
 	case USB_SPEED_HIGH:


