Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150DF2E7181;
	Tue, 15 Jul 2025 13:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586277; cv=none; b=DXVFHn3rq0CyHDSaw9eOadIvzXuLufUvQZXBCWELwopUdw4Dydbvyr39PLEzuGWAOdz8qc5uRjgaz0QBoXkyo6Wb8FCG1q/CSnDju2+26FsxIOrVu/nsMIUxjzoFwujggF8eZkAe5umYwO/BeHMWG5AqgQI54VGVVfL5xJpDkgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586277; c=relaxed/simple;
	bh=nas2GMrfPR3214DI9ZaT00V403hEOTPsAMGPUlnqs6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyhbB90ZogmAyh3v7bS02rjJnt883IYP/plfqy392WVUWdIBFpEx77BY87mq/l6Ou5k7ZxFdG4zzTo1PhzCQ6qZYhKCkDPVJ/vnvfQXh5iC0cp5M9mJ8czdJOd4QgwfjDJSkERiAT9FdBXlhhDUTfI0XWt7iKY31sYXlM6Ej/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzb4lJcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzb4lJcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D78C4CEE3;
	Tue, 15 Jul 2025 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586277;
	bh=nas2GMrfPR3214DI9ZaT00V403hEOTPsAMGPUlnqs6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzb4lJcu4v8Yt4Xlqscg590VpAj935TliqoHZx+WYYEQYpk0xWfwBYrAmPuoE+0tF
	 SfEC0GSQGYw6qAAC80fKBp/HaiLCW5bbZhkx3S7gb5BR9mA6uVIAjhxBRaiH8RHgmQ
	 V+pgcc58LbZTYAXqb3v+IoD/Ys5C+12bn2JbG7oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 71/77] vt: add missing notification when switching back to text mode
Date: Tue, 15 Jul 2025 15:14:10 +0200
Message-ID: <20250715130754.573879185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a6e0c803e96ec..a10b7ebbbe918 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4443,6 +4443,7 @@ void do_unblank_screen(int leaving_gfx)
 	set_palette(vc);
 	set_cursor(vc);
 	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
-- 
2.39.5



