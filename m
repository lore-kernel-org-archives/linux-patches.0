Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29C72E1758;
	Tue, 15 Jul 2025 13:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585766; cv=none; b=OeqPq2BoA5VQe20s+PgPXVA5F4C16RTd9KPpYYBfM08OMK/JOVK2ZejpOt5MNsMJfO36rc23A0nA0YwZelvYexg59wgpKdfWP4sh2v1WTgsuflTMatXepsA7ipL7TC8aRzT8zf+oXjP1xj6g73eD1stbZjcwOt7TBXlsb3yRy4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585766; c=relaxed/simple;
	bh=llJT89xUxt1n3XOPj2ZYYTvLlYCsr5/vZ08PblGJ3ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTOeTWOfknHUAhOv7Lrc8uxTCuvKMaBh5wuk6NUlNZ50ygFoCirwkJFbwmbUCBIp55aVE1P/Mipma2BwywJTsYJVIzteP9mDfS8D5eA4XFaftTI4b3/BmLJklxD8trvWVhEez3psZSw/duNbKLAG8S4hNuSwrL3kd2wK3YFRHiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpsfy1Ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpsfy1Ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44203C4CEE3;
	Tue, 15 Jul 2025 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585766;
	bh=llJT89xUxt1n3XOPj2ZYYTvLlYCsr5/vZ08PblGJ3ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpsfy1Phegk6kGxPOBWs3fzNqyMkXjORE8tgFw/LHUKebEWhn0zsJd8m2eENw/BIW
	 WMfXhUYY/PKtCvTK2gn34oXV+ze9P8vV7q99Wbc4VC0wPkAWyKrawQdELtpFp7zJpy
	 164sChlsQ0BUdXE8ZkSBXh3QmU2VB7eXI4b4DL2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/163] vt: add missing notification when switching back to text mode
Date: Tue, 15 Jul 2025 15:13:40 +0200
Message-ID: <20250715130814.938537704@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index be5564ed8c018..5b09ce71345b6 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4566,6 +4566,7 @@ void do_unblank_screen(int leaving_gfx)
 	set_palette(vc);
 	set_cursor(vc);
 	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
-- 
2.39.5



