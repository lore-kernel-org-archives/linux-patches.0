Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064691;
	b=INr4CyVPJUCuLR6hqpqJLlhXkS4/3eEmK5N/iD/b2Yg4isvwSFnnbSJ9hhYWsJ0QjtHg
	 12kUZsn7ukhcAD1UnQ++R3cPBJrnIxzzM1mHGd7kdtduH+pOlNfYs2+Tf05utSV/D1Iqn
	 dnL6IsCke5LylJBesQO8QS2uLv1kEJ0xtXVrmoGtIr4EJxiX8YWRUQ1aqdpr+eGHnDOnj
	 0T5PF2NO5dtQ8AKBfH90MbJ2uUy3f7vY8Xyd/5XnmCMhfvic+vz6hFcQdDlIYI7OIDygA
	 SP31ot54j+DiXrdPWeyFS0DPoO40SstzGp61f3nlMUmshuMOj3V1yl6g+OWXqoivx8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PHww749hcMMkriwCWcCeOzpF8p0607QyNNUPHAoBY6Y=;
	b=eOU0mI+ZBoGEOLDILYlYADyQc9kpcS4Vs+amy0nIrlTM9uJqygENYzXqGTvp+yPSXpbQ
	 /pLR+hHJjSEh/hSufIAm4ZNcwTr9GJUvZ223yH0mDU+6U1a9+qI06I1SmXs6z9MvTHxnM
	 +Dm27I+jNGO651a4rtFvpP1hcAQMrD0WFECqORP/P1HwaSXesK2TFJDBRDI/f3NLRz/dE
	 ORhqwvgRuLdBV4YgZZO60KyzsBMW6QdqiKtRIRh6NSlCphe+/lznXPQJoafmafobt2FHz
	 0LzzqTiMazkT8fbpiw74t1yrYCKI15nY7sAUQ9N9tdaD8Dor3zuDje4LZOCtIIhHsBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQlWiouY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D0E606B8AE;
	Sat,  7 Nov 2026 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQlWiouY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEB61F0089F;
	Sat,  7 Nov 2026 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064691;
	bh=PHww749hcMMkriwCWcCeOzpF8p0607QyNNUPHAoBY6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQlWiouYgQug0UxboyVUXgIvUEWLZgvraBLK6uPgIQBdlL2QzGTmApHjZU7cCnt4M
	 gS4HlpkROPcI25w5BmqZ/Jh2bWxQAH4JGb5rCfPfautHt1JL6ny/Gd41y1aZ5MqUx4
	 eOrwjLj4liTaO0h3aE+Avgd3ivaGjll0Bf5Lu9ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0684/1257] fbdev: xen-fbfront: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:49:40 -0500
Message-ID: <20261107134958.159670172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 5b234b0dd29d79207c059c7b40851dd1e934fa3a ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently xenfb_probe() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due
to an allocation failure) info->fbdefio_state is left NULL.

When the file is subsequently opened, fb_open() will dereference a NULL
pointer (calling fb_deferred_io_open()).

Fix this by checking for the error.

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/xen-fbfront.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
index 4385976277ac3..7ef909d4242d9 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -443,7 +443,11 @@ static int xenfb_probe(struct xenbus_device *dev,
 	}
 
 	fb_info->fbdefio = &xenfb_defio;
-	fb_deferred_io_init(fb_info);
+	ret = fb_deferred_io_init(fb_info);
+	if (ret < 0) {
+		xenbus_dev_fatal(dev, ret, "fb_deferred_io_init");
+		goto error_cmap;
+	}
 
 	xenfb_init_shared_page(info, fb_info);
 
@@ -465,6 +469,7 @@ static int xenfb_probe(struct xenbus_device *dev,
 
 error_fb:
 	fb_deferred_io_cleanup(fb_info);
+error_cmap:
 	fb_dealloc_cmap(&fb_info->cmap);
 	framebuffer_release(fb_info);
 error_nomem:
-- 
2.53.0



