Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DAD392829;
	Sat, 17 Oct 2026 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257664; cv=none; b=MogLA9c4HG5+tRNYWTbw132V7Jf1xfthMKE4WicJYA54PrDOWiFpSp7z+BRZJD1BP5ynKnhNaX4YiZ/VsC9FcsXqldhLJsAaZQ55u2fZ2IOtslQfczPMFy6ubxtGXkKqpmgjqwjulxnYqqm9B0PS+pzEMSlE+VasNs1s2zs2eoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257664; c=relaxed/simple;
	bh=ui8IMcNq/0WqAb0WpoBLO91AcNyO10ygMgsbO43fTHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7Waq7Okura7xBaMHQF5ufA+8cdZk0kS6LaZ4EX5MTs9NgrtDtkx1wZ57xSjKoOYFrGUDnvbxdo/KUKn+pjqhxcw9EuzAKIOF2TZfoez6jK9Yl08pzirl6jQ655fDxHVYy+UOWV9nciqXk7Ylznkrhoogi9n7zoT7GtX7frNlA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVH0Aeju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVH0Aeju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6481F000C4;
	Sat, 17 Oct 2026 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257663;
	bh=xdHnaMe5DcZCL7/3zaZciQOuHBMrx/d/mcnY7V07FfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVH0Aeju3ljGLbJurcGgSHF2sgN4oGT+3Z+8e+kQE0Ritwn4qJgEqpXGeau69zp4e
	 5V9Z3fsbgDPbR8XmIuPFIhQfFX2XNc9U8/2D4GyaSWKdnBf/XCxNp3YzSfKlRCNbzO
	 en5VglVtMG+swxuforTA8YSfsj6jgtBd3SGZvpAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0614/1674] tty: add break_wait kernel-doc
Date: Sat, 17 Oct 2026 17:48:06 +0200
Message-ID: <20261017160446.838332471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5dad87615c9861cfa366ca984b52f581e861df20 ]

Add the missing kernel-doc description for the new break_wait field in
struct tty_struct.

Fixes: 845a2737e0f5 ("tty: abort break signalling on hangup")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/20d75a7a-2e7a-484f-a267-c21db82dd922@infradead.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260925094222.18303-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tty.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 54dfc9e8e75d0..e4b17886d9988 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -173,6 +173,7 @@ struct tty_operations;
  * @write_wait: concurrent writers are waiting in this queue until they are
  *		allowed to write
  * @read_wait: readers wait for data in this queue
+ * @break_wait: wait queue for timed breaks
  * @hangup_work: normally a work to perform a hangup (do_tty_hangup()); while
  *		 freeing the tty, (re)used to release_one_tty()
  * @disc_data: pointer to @ldisc's private data (e.g. to &struct n_tty_data)
-- 
2.53.0



