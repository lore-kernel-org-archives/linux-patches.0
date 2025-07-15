Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32764246BD7;
	Tue, 15 Jul 2025 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587382; cv=none; b=KoDQWlql919zwfZjpxU5XBOknLy2gdB+8vkpfx5ML6x/bWjuWZaXiYW3mpYzTRkW91uEqWR9JVYjAvaV874xLltsBg4F1Gn6MS4/MKS/Ky3WQodGtVFKwiWUJ5iX+iBKLbwIml7bDErsCXgnbvowOlRPvjCDbRHte2oOzqpSh5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587382; c=relaxed/simple;
	bh=HOqunTnjL5LRXZEgT0BtHnTrWAAAlCG5pDsy6oPePwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvvOCT07urtdO+Ojw4ReCgjrO1pUxxx0jB/ey1sAo1uaK+1+6zQaZThPBFKja/d5lxNtQBRnHgEIYm1NvV8+ZSfNaw2/fqFB8ACNmL3PeuNk/jWqNkEIF0bhX3umV4ef1M+jS91cuIrbanvpT4nw3gVmarIiqglHbNXhvhA12oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUE4WAjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUE4WAjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706FBC4CEE3;
	Tue, 15 Jul 2025 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587381;
	bh=HOqunTnjL5LRXZEgT0BtHnTrWAAAlCG5pDsy6oPePwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUE4WAjq6T6hIE4HInBgpPy6qM/H5cdxE2UJaExli8bI/6mrFYfm+ujY/+PCCQZTI
	 +WQLF4nV2u3YbQsrau9dmuwBb/te7uH/Rjkvwzxk9zjLXn0tTng2qYz0t2d8U/COsA
	 XwtOMzBz1oiA91J97W392mC/IBvwdqsjSQ76BloQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 80/88] vt: add missing notification when switching back to text mode
Date: Tue, 15 Jul 2025 15:14:56 +0200
Message-ID: <20250715130757.783739984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ccfd9d93c10c5..f6457263354ba 100644
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



