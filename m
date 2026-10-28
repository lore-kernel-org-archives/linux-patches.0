Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212735;
	b=NXT350j935jktdStuRGRDSescpMMXeQkSYESym9O83EnZz9QhJ5IJB19IEQePP3ng/4i
	 24RJJfOIk/emaoA9xEOR+8AqAk0LDwR2u8+cjAqdAnu4/EyEEUDNwZLiw7NAlO1lAJt+B
	 KE0Pr5/MhMAFZf++//SUXxn8GekU9na2aDxgQW9DHUuz4cVyfC/WUL3XiMz/hgGlEu7Ko
	 UfX9d0MpgLlug+fYW7cYXx5TXYMtlQgrMXQJeQiDGhPAj05n38k+Y+7Fh6pK92RGnE8kD
	 FhtjlKT+duJiDCknSlNM/RhgzCSczrTuF028lPN4FjBSInGSeJzrGADsj98aRNeteYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J0Js98amIMJpHvgQ9K/Z7gZ4QGk6Zntp8HltN0IOdXs=;
	b=vYN+8J9g4ONeLVWFTD6M5PxstL54Biv646PteAYMp9vM2xgjvemd2IkRZhalm72oi1hN
	 yPPmFyWYiP/39b/djVLLhg32Ex3NcFTmbkuBXl0PWK6TujjQz7jmPmVs0dHdZsvc/qQtS
	 Rmfuj56SUyTuddWSfaFMQnR2cJzr/uVKiytIXbN5bP380ze3d22/8UQ0VW6svNtJYybxn
	 eyff5Xut7SRBVyy71TYRJYYC5nKgwSGmfYhABUH/NSCkxmq3MYVQdkLQRSRV+0wG18XKO
	 +3efgPmA4miVwfy1EZXGJnCez1qDTCmN1FuaIY5CwJmb4SZmX5zvSLVjdn+iOgKAGsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqPzkPXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0180D606A31C;
	Wed, 28 Oct 2026 18:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqPzkPXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4961F01828;
	Wed, 28 Oct 2026 18:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212734;
	bh=J0Js98amIMJpHvgQ9K/Z7gZ4QGk6Zntp8HltN0IOdXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqPzkPXEOuYVverUnYgEkN81rBsLlQfSZy03SRgAdgiefQMJtn1HMR6pcdvsZVGRA
	 mHZFGoqhT2NzyYKGhXvzernSoGoPXp5Np7oYGNS8UvoJ53EgjLpZRLs4ED7AYkv+nG
	 nMoeykH+l5a7fyeG7jJaHvfdtAgyaaekMZ4TZf+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.1 0259/1887] kgdboc: Fix tty driver reference leak in configure_kgdboc()
Date: Wed, 28 Oct 2026 17:39:15 +0100
Message-ID: <20261028170505.124744250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit ef3134cd0d4831ae2137aee2883987859b80b2c6 upstream.

tty_find_polling_driver() returns the tty driver with an extra
reference taken by tty_driver_kref_get(). configure_kgdboc() stores it
in kgdb_tty_driver but the reference is never dropped: it is leaked when
kgdb_register_io_module() fails, when the configuration is cleared, and
on every reconfigure.

Release the reference both when unconfiguring and on the error path.

Fixes: 7d7b93c1452f ("tty: kref the tty driver object")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260917155523.2161202-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/kgdboc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -190,6 +190,11 @@ static void cleanup_kgdboc(void)
 		return;
 	kgdboc_unregister_kbd();
 	kgdb_unregister_io_module(&kgdboc_io_ops);
+
+	if (kgdb_tty_driver) {
+		tty_driver_kref_put(kgdb_tty_driver);
+		kgdb_tty_driver = NULL;
+	}
 }
 
 static int configure_kgdboc(void)
@@ -250,6 +255,10 @@ nmi_con_failed:
 	kgdb_unregister_io_module(&kgdboc_io_ops);
 noconfig:
 	kgdboc_unregister_kbd();
+	if (kgdb_tty_driver) {
+		tty_driver_kref_put(kgdb_tty_driver);
+		kgdb_tty_driver = NULL;
+	}
 	configured = 0;
 
 	return err;


