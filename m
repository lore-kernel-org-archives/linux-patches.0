Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E043A784F;
	Wed, 30 Sep 2026 17:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788774; cv=none; b=OXCrtMlPUUMaLOSJ7DYGg7KWNhwyLLQZTkPT0osHDpy5Iz3M2zWVvR3+dlHA7v2f7X9RxT6gtBqt8LKIGxyOAYP8GoSfESMVSiX39mXM9+bN8x4XrlBz2VIquQ0BlR8sxEeocM3Na5dfgA8Y92dcWrC8Y+Rf1556Lq+CDcA2M08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788774; c=relaxed/simple;
	bh=mEW9RIGwJK/Q+EhOGH+bhjaMoizAJJh8+q1RNy6LemQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEW+UcQrWLkGrAxYoRNf2FuqEMqf9OEQnPsnhxRPIHIc+3IPrU7iCK8zsrZ2AzOPioVrUDuZ6WKkum03pWdZRqH3F0+ZzdIHnaazx4kJZZ1H1iNZ7h/IUuo/73YfabUPRc8h4/NSKh8KDp+sUnr8k0ab94B1UoSdRHlzUghLnrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6ejxc2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6ejxc2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9732A1F000FF;
	Wed, 30 Sep 2026 17:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788773;
	bh=XsfkbbTImyzafwmSPEwnkjZkorYxVTjG6L1qTMrritU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6ejxc2s+0Y/Q2ykdRgL+3+czo2S6ZX0ph+ZJnYkyDpuKq1jKMWtWhJ3NxBZSJizk
	 JT9TVbB/y467vP3qbLjPHsKxzq4ynnVuSuH/gSTJ7ESi9fhaEyPX2flO3c2PXZXHtR
	 pzig87QUqmU919ioSSXeY5E20RVuRtihOk9pkDDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashiko <sashiko-bot@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 242/877] Input: soc_button_array - check btns_desc->package.count
Date: Wed, 30 Sep 2026 17:19:13 +0200
Message-ID: <20260930152419.948892440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit fb5022278b6ea7f1838e3ef78028d5d5e3375f65 upstream.

Check that btns_desc->package.count is not 0 before accessing
btns_desc->package.elements[0].

Fixes: 4c3362f44980 ("Input: soc_button_array - add support for ACPI 6.0 Generic Button Device")
Cc: stable@vger.kernel.org
Reported-by: Shashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-input/20260909091440.3384C1F00A3A@smtp.kernel.org/
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909093934.29411-2-johannes.goede@oss.qualcomm.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/soc_button_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -377,7 +377,7 @@ static struct soc_button_info *soc_butto
 		}
 	}
 
-	if (!btns_desc) {
+	if (!btns_desc || !btns_desc->package.count) {
 		dev_err(dev, "ACPI Button Descriptors not found\n");
 		button_info = ERR_PTR(-ENODEV);
 		goto out;


