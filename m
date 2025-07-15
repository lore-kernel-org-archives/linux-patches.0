Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331DA70831;
	Tue, 15 Jul 2025 13:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586677; cv=none; b=O28rEeH3OgNQIoenoTW0p5ZoLLUjru/rKFx+OcrQCsp9uldJUPzp8V6Yb4g4TWHQ1Z/9knvCZje2tZaxz45ML6xSPPWLLuioJUAPt3nBY1Btw3A8Pm2osy+gx4YnovTli+kg8qEBhWpcTj8yW1VlwwMFVpgmDps25pRm+O8cdR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586677; c=relaxed/simple;
	bh=QKHfm4aZS8MNImHR++I5qY24Vzue4fQbWxRISTboKsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lkq/6gPlE7Mfc5q4WDd4ZuZz5xwymLilR7yPC/B4aOWjyDj4mlkVogcBq5PGyW1snkwejnNkhwnPQCyhjtXe6PJSTyK1VdOThiAhzhWpmAx/XlQwBTaEY/NrrSF6B2sm2YjPmBUeDxoDI4jlGyxcuxq4nWieiDIQJg/Au8CZo90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVeL8jET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVeL8jET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF6DC4CEE3;
	Tue, 15 Jul 2025 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586677;
	bh=QKHfm4aZS8MNImHR++I5qY24Vzue4fQbWxRISTboKsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVeL8jETFqsN4sCRUD+7FQqFGb5dujoQ70mKMtnjlCKd7tQK4CWbemktBUDYzlJes
	 5zhSV83LZ8SkL50BI95GUpvh3gxQZy6HJFhnQugODKbgmytjyB0i/Xf7cKnfAZdhlB
	 gJEmvSzE1fAMdmr3F/xxtqZDuieGaKCzCKtUXivc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/148] vt: add missing notification when switching back to text mode
Date: Tue, 15 Jul 2025 15:14:25 +0200
Message-ID: <20250715130806.004163777@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <npitre@baylibre.com>

[ Upstream commit ff78538e07fa284ce08cbbcb0730daa91ed16722 ]

Programs using poll() on /dev/vcsa to be notified when VT changes occur
were missing one case: the switch from gfx to text mode.

Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://lore.kernel.org/r/9o5ro928-0pp4-05rq-70p4-ro385n21n723@onlyvoer.pbz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index e58dceaf7ff0e..3db8efd58747d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4368,6 +4368,7 @@ void do_unblank_screen(int leaving_gfx)
 	set_palette(vc);
 	set_cursor(vc);
 	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
-- 
2.39.5



