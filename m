Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448702EA46C;
	Tue, 15 Jul 2025 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587963; cv=none; b=ph1yOd45UPf8luiTnNOIW4u0RtEwZNVdZBytWkE4tc/NYrgDFlaQnYFTQrobfDxV/+++Ly+TiaIEXi1KwRo5ttlh6lPrDI/X1FyGFcXVDovet2cXBKzTjJckJmtmjKlJ+Ve7sMoOPPzuBRZnTjwp2O7jFqAA2eunQzXvUb4mlLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587963; c=relaxed/simple;
	bh=/i5I74Zk+bQ0HVDpyLCMrpa77wL/y+Q39e+/JlVX6Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryVVzz7MwcOFEkT85JGDqd90eptgA97L/EAag1nqY8BhQPj5QEuOSZ7zUotMwL1uPAqL9j7gD3k2lbCoDGHafKAs5pPdyPGnlvO08iR8LSmdySyZynVbAEdo+e4dHh1rDxJJV2V08g2J35Ptl/difSbulGy6OnCWk9aqpRQFeqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/M+eEh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/M+eEh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C408DC4CEE3;
	Tue, 15 Jul 2025 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587963;
	bh=/i5I74Zk+bQ0HVDpyLCMrpa77wL/y+Q39e+/JlVX6Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/M+eEh0o+QiMaO38rk8sXxOhOL0IIizM6meezH8nOyD+4+DT8mwZs8eJG4tildkB
	 fgGc6jFx5U3qkh/Y93buevdNxOmUhpqZOT7M37Eb3TjlSVVeS05dL+lYQH9taBx2w+
	 mluGWub6pm4lu9Y7PYZxIuKebfBuL7YdYGTuQRpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/208] vt: add missing notification when switching back to text mode
Date: Tue, 15 Jul 2025 15:15:07 +0200
Message-ID: <20250715130818.871831486@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5d9de3a53548b..98ca54330d771 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4452,6 +4452,7 @@ void do_unblank_screen(int leaving_gfx)
 	set_palette(vc);
 	set_cursor(vc);
 	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
-- 
2.39.5



