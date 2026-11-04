Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828915;
	b=aSnJ3o/wtJk+FYsY/ZreRYKw+kyuq4xC2LQFzsYjtXwfHozyT8HpoFD14YGY8+QRYoDC
	 ZVO24GNDS7hvcXg8OUsluV7OER9SHr0yQWGOoUyj2NJIuDODcmyprTmWu22TDDt/FhRj+
	 YQMS83qZDbaUntJeiRdhfEpGnkO/KUWZyL8mQteJQOez7so/gXyfhmpT17uckfdTkK5K1
	 Byl7fs0AqofQMUBRjDwqHGG9twK8brncZl3a06imoFd/bG0hLsg6rx2TAnGov2Ug0jsI2
	 0PYgwFYi9Up4/CO/q/XwfnmzHWmR1wWXAsAKo4MqRp7fNwAQlDEq9HbCgq/fs+pQ4jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQ+9CiHCU6dYJJ/xaK+GA7iVtgdG+8bBHJvnZuI9Hnk=;
	b=S9ywXqul9WEImpwHFkmxfzPoJ9831KYGzeWEnVa3+IvtFIBxPkeX9k604snUOCGZ/nFk
	 v0KblwwReInyGUcaAZAFfqfiwo3HcQgVB/G1BBXaIucCcLVhpAsvk1JgdApqWNCIZlOkK
	 0XxKkqrJvj/vku533SvCnxmKrr4QOGy8w3q9FkDYO1ZsscPfzPkIIt6nj6EPe3HfKLsdr
	 HK+JfPYgebN6bqh6rNnACKkU4PtPMtCowl/OrIYGlW/F1mvtfUhKBNqF92h84Kan8BrX4
	 Ly5r1kM4/0PVzl/lSs12ToOk9YIvUAeewNfx1DM3jDITaPNN8TK1+531rQwaG/AOExQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Bti/KqAb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2961D607031B;
	Wed,  4 Nov 2026 21:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bti/KqAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4D61F00A15;
	Wed,  4 Nov 2026 21:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828915;
	bh=lQ+9CiHCU6dYJJ/xaK+GA7iVtgdG+8bBHJvnZuI9Hnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bti/KqAbJ0WEQF4Uv53Pitz7rDsSJOd8OcZij0rBX41M2NR5zX6pWv8xyBEaJ2t/r
	 xqSegbRZFZIgpHbLBVv8pE/gNwA+ORLOKjUlLqtqcq/FdXZqhbLrsyyeRr7XY+DY8O
	 WwS7irRc6hJais9dr+waebdqIJhQ/PHXslS4tt+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 323/547] xfs: assign an owner to scrub_stats_fops
Date: Wed,  4 Nov 2026 16:08:27 -0500
Message-ID: <20261104211047.398884929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit fe67a493c7a76cf75556152af24285a114f69d34 upstream.

LOLLM complains that file_operations structs for debugfs files are
supposed to have an owner set so that the module can't get unloaded if
someone's sitting on a debugfs file long after unmount/rmmod.  Fix that.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -300,6 +300,7 @@ out:
 }
 
 static const struct file_operations scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.read			= xchk_scrub_stats_read,
 };
@@ -327,6 +328,7 @@ xchk_clear_scrub_stats_write(
 }
 
 static const struct file_operations clear_scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.write			= xchk_clear_scrub_stats_write,
 };


