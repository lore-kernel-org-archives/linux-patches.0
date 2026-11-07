Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061786;
	b=ZTRvrGo3Y4vnICCNUnltDsvTUtaKRffikibcEFpgitiSXJzH6dmhHetdnZLqI3tg36rm
	 pjJbzjCOVFag/iQ9NZjXVVnSg79vsgJbY+ojho37KJx/3Ufs17jSaR48D+AKTRx+3TDqv
	 xnhPFsXrE/z5PK31UE3eY4vI1EItdXnYCFwSTkVZzU1CMtoaphE+ybQY06J6F1OeID5fE
	 C0m31wTMsy2GXkuSvqJs8v5iO9/Eb2qAoqjTBvllj6etMbvOpZPZT2g0gHqIe36VgLeik
	 GvL/Zhyx9hmWCgtGMwoGnftbgBX1QvMdsAccJwc9PEoMgfreZZ4z7pn0mjNgPiVBdjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hw0QIEgl2hmNIG/SRkpECNPQXs/5l30uJox3SSesUKg=;
	b=2AVbMHyBp/lTm25k4hH4XO/WW/broVc+iuyECzo77ZHCbfLxxOe8OiA9ObGS3QOwW+/P
	 PoHaMJoLcCBeuS83jXyQvUI+S0oA3hlfw6i75j/PfwC8uPHSAszAplAOZyILLm9YJBos9
	 fxW3TiZ5/0eyUJXlVZkssbfR12jdLzctJIHoi5zF2SoKcvJtNGrIsc5y2HLGibbzcHsGG
	 lbNOjqsuKfPgY0fNhMaRHo2YnX5mtgvNb+GIsWpfnr/77W41HC/a8sgBjLBxDlGz1s538
	 LU1Nf4SKbT3sqOs393atJ8C+JPUsSVefk7BqyZU6ndnOiHML1TfcS/xBnDhlnkIXSYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9QaSaA3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A5606A32C;
	Sat,  7 Nov 2026 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9QaSaA3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF7A1F0089F;
	Sat,  7 Nov 2026 14:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061786;
	bh=Hw0QIEgl2hmNIG/SRkpECNPQXs/5l30uJox3SSesUKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9QaSaA3j0sLvPg7+SSTFfuf2guJ3DqwrpFht6BwtQPKaGJoI1rYhxgSTHqzBX06i
	 52SQNxg8SEJcxIMHeYyCIidjQ2cJx97zwBMW0HwV4Cra0dcu/kmVYOZtyTcRKbNNSt
	 bmhE3+wcA7xjl/r1PaUhEArC0bJYDt6z6s8WdQ4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0816/1536] HID: picoLCD: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:47:12 -0500
Message-ID: <20261107135020.464405606@linuxfoundation.org>
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

commit feade898fc958ff355101adf12d5632272e64220 upstream.

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently picolcd_init_framebuffer() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due
to an allocation failure) info->fbdefio_state is left NULL.

When the file is subsequently opened, fb_open() will dereference a NULL
pointer (calling fb_deferred_io_open()).

Fix this by checking for the error.

Also correct cleanup ordering - defio is initialised after the sysfs file,
so cleanup defio first.

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-picolcd_fb.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -527,17 +527,23 @@ int picolcd_init_framebuffer(struct pico
 		goto err_cleanup;
 	}
 
-	fb_deferred_io_init(info);
+	error = fb_deferred_io_init(info);
+	if (error) {
+		dev_err(dev, "failed to initialize deferred I/O\n");
+		goto err_sysfs;
+	}
+
 	error = register_framebuffer(info);
 	if (error) {
 		dev_err(dev, "failed to register framebuffer\n");
-		goto err_sysfs;
+		goto err_defio;
 	}
 	return 0;
 
+err_defio:
+	fb_deferred_io_cleanup(info);
 err_sysfs:
 	device_remove_file(dev, &dev_attr_fb_update_rate);
-	fb_deferred_io_cleanup(info);
 err_cleanup:
 	data->fb_info    = NULL;
 


