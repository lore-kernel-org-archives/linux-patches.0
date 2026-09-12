Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6A14BEE38;
	Sat, 12 Sep 2026 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229939; cv=none; b=X/b5RFZRTyHb2r0nbYb8hJlaNjJ/ohQpyEOt6p3uDKzmmscciF/+HvA8AYDKKZJRtQRcCMUgAUV6FvEPQyH1fpa9qt65NdCGBh0ywGD7ixuM3b0GPacCgPDZ8sfvfBYPQ2jNjQcBi0fii3sDuYQGEGfCwoKe7cnQ5i5JUvABTZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229939; c=relaxed/simple;
	bh=LZrx90nRCMZKYJDZMbsZWoGrJLpjCR8bJrVJ66MicZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzcGQB4mPBFc9cCQEOaqnkoaIc4/AndrPLwg5mntsHjHGhmr87931uNxs0zuq1lFHch/Tfq+YwbWrh1fRLridXCEaJhtNcnHao/HgiBmjy+PZ5KZ54FJEipgErEt7GeEJIZqBbI5tH6wVI2ny2Jy7JGxkdUkv6sINx8+LQNFAd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwykMRqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwykMRqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41B01F000FF;
	Sat, 12 Sep 2026 16:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229938;
	bh=gplcZgkxSlNDRbDmgAzkFgcg1m+dKIxgJ0YQ05pTMIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwykMRqGvZIdT9nxerBfR9UJDHN7wSKsoQuiQNugY0Uus6vx1W0k3yD+JHKUG6ArU
	 oNikayIX1XK+u7/tTYiDDcvlU9qHRb9E8fjpk5SCXYu9XyXIkyCRGCoKqoVjq37LhG
	 22shHV2BsIEirP6J10FB1ghtkRxhxXfb9HHJdT+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0649/1191] tty: hvsi: remove an extra variable from hvsi_write()
Date: Sat, 12 Sep 2026 08:56:17 +0200
Message-ID: <20260912065602.833416537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jirislaby@kernel.org>

[ Upstream commit d3352ab0a9701a6d4c88b814815d7320c339f4a8 ]

'source' is the same as 'buf'. Rename the parameter ('buf') to
'source' and drop the local variable.

Likely, the two were introduced to have a different type. But 'char' and
'unsigned char' are the same in the kernel for a long time.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230731080244.2698-4-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b6b5d64cb161 ("ipack: ipoctal: fix UAF, null-ptr-deref, and use-after-free in cleanup on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index a200d01eceed6..c1b8a4fd8b1ee 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -905,10 +905,9 @@ static unsigned int hvsi_chars_in_buffer(struct tty_struct *tty)
 }
 
 static int hvsi_write(struct tty_struct *tty,
-		     const unsigned char *buf, int count)
+		     const unsigned char *source, int count)
 {
 	struct hvsi_struct *hp = tty->driver_data;
-	const char *source = buf;
 	unsigned long flags;
 	int total = 0;
 	int origcount = count;
-- 
2.53.0



