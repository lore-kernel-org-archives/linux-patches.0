Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8FD2E7BA6;
	Tue, 15 Jul 2025 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586038; cv=none; b=JCWfMVHAm6DszO+r+K9iAOPKOeVU8uIjmKk8wqIUajHOzJA/30t+yau3cbhx09wFinkuUccuUQre4kMg806R1VYrBzW/K/B7tM5z5V4ge6BPZdhLW6QzJXFo95NidEjosnJPWGCQU7wfehmLbXwtlb7QUP5dNTrM1Q7HTokwbJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586038; c=relaxed/simple;
	bh=xBcSekSrm41u6rO5p87J1IEo606P1k/tmHDwqESgAlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG+LAJ9r52010qTKXy9YjG8ic9BsEL5PyHnkvC66rZkOU4y4+Tx4jKrlv+NJaA/IgWVcgiCH1Wv0XGH2Y5RuK/YesSQYA9d5F6hQ49bZ7ORk9ggd7XHzZ06CQkl90uhz+OisDBGZYnLiEzq9XuqhlssgXyVsGx2ZjYNcUw80L9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0+HN81K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0+HN81K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B39C4CEE3;
	Tue, 15 Jul 2025 13:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586038;
	bh=xBcSekSrm41u6rO5p87J1IEo606P1k/tmHDwqESgAlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0+HN81KNWUJj6Z95cmhreIWLy3Y30bjBx59vy1Gh3yC5h8qJSgT1bdsBCUDb5V4P
	 BpIiU6Op+BeC/BhEKUkP4WIl2VfAR2pDcIA5n0sfkNZ5zRd7aRbOOYxBTBgDkQQ+FK
	 4dQUeeyiN3rCSePT3MrrLQQ9kpsSI+ghj+mF4M68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/109] vt: add missing notification when switching back to text mode
Date: Tue, 15 Jul 2025 15:13:57 +0200
Message-ID: <20250715130802.924226522@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c5ec7306aa713..60c878ea95f92 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4392,6 +4392,7 @@ void do_unblank_screen(int leaving_gfx)
 	set_palette(vc);
 	set_cursor(vc);
 	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
-- 
2.39.5



