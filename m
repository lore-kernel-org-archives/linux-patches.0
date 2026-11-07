Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062320;
	b=5FbFvboz4DiDC89IWMw6oAKpJmCdBgoUP6LwJJLC9gchwQWek833IcFueii43m/RsO0y
	 brwcvpu9zU9LxmT+amuMuvtjpSjQ2YjUCYhDhfy+T66XURj+iYj4XzzsPont2ohl2fFqB
	 O2/X2btBUh6xBfECS5fJ6Tlo7GvCP9kIu61fADlOZG7OG1Qg4cjduoCW/umTdOBfC3NLc
	 Ah0M6W9gDxKKyxsCwm4vTLbs+btBqiRMsX1nLIS9Xnq5rtWuzM9S32ZdiP9U87hx/zjzK
	 wzeFMGRfF7+KxjVRTrJtq2K7WDBWbW5nsgMJx1jNLBpCQuTHhv9i2+fg7Mj5fCRjWHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7gjqXepMXMkq7fP+wKuRe0oG1RkqDwljnPFNoVqtTXk=;
	b=THSY5bZzD7fynoxwx/xOB5ZckqKxNf33GWdAjTLL/oxWEG/8QfROFIxgRCYPQ36nHC5z
	 SEGHQWKe4LsrTiBYDaRpO4mU+gld6tn/HNEPzJsVnhwL5P9Mjm1F+GKSIDHlndV5G72fo
	 HJytBslHEM3Q9EPVxz3xKWSjCAQNE9C9XC+rDkf46QEwZzqWafvSG0fpC5xkFCCbNnDNt
	 P2WNSGMHamLP55e3i0sA+jvdQWZQLAuU2sMj7XMDmVoCinWD26J9gsDGPD4UFopPvppfo
	 OU2FmbJzQLzrXJfnL31t40kx0veC8WFdwBNo9jx+ik8nsE8SU28bWlG1YVH3AfOZJJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1V/AhKrw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5A5606A663;
	Sat,  7 Nov 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1V/AhKrw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D56F1F0089F;
	Sat,  7 Nov 2026 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062320;
	bh=7gjqXepMXMkq7fP+wKuRe0oG1RkqDwljnPFNoVqtTXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1V/AhKrwJGIsFQ0ESd6ByZCjcfZlOb96dHOkJ4lAHEoZZVa82E/05/hH7brt2i7PO
	 NJvE0nGsqUVW5SPmKeTGNE6MWx0IHQZQuJT4dlq2grxzA8LlkrMLCLSFBrdPWhgowW
	 wlHOcuWsfww34Y1Oa2e1NQoKrm4mxQQUhwckVfHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1254/1536] fbdev: ssd1307fb: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:54:30 -0500
Message-ID: <20261107135032.992955128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 81ae1f9a6c850efab3e5dec6b7c9aa5c587f92b7 ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently ssd1307fb_probe() ignores its return value.

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
 drivers/video/fbdev/ssd1307fb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index 0df3ac694f4e0..e4559312a9265 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -763,7 +763,11 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
-	fb_deferred_io_init(info);
+	ret = fb_deferred_io_init(info);
+	if (ret) {
+		dev_err(dev, "failed to init fb deferred io: %d\n", ret);
+		goto fb_defio_error;
+	}
 
 	i2c_set_clientdata(client, info);
 
-- 
2.53.0



