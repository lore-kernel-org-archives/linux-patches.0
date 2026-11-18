Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030922;
	b=2JsOtQC+IKTGfgzmfKrzvenkbqMeaL8Ih4KDfcrFOAYFxLBqbg00N+ss9gVtnJGlMIIC
	 b4KJ2oXqgoV6PAFLoKeh5TOZt9mXgCiPLkCH2TKb8wMTGxmjP+8eEGYjcCmg2nEzl58+z
	 SDyjMBll8AaEoyM3veDcIXIXyCrEXV9d/xM0sc4a/N6jd8hwCpWxDeFP+h9SOfJVbKMot
	 N2zpj977NYS1fW9UAvYtnrsIH+BRe4zn4DDKqkE1hLsKb3KPVOYm8FsDcl/kt10cFRJkr
	 ociOz0Iu9FrcaZSsLkV2TFk7KZaQYbegT8qR261UpOfJp6D1Gv2JtFvAok6Ly2PIRBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYy6yJwqzKB2On+qylphQyLDDy7PvwDgF4YK6ezYx7k=;
	b=rAhSDLwbed8s7cQyMah5oaTD5K0R9q4OblMsIfikXtExHWC5U1Ao5LVrpZoQX7CUAN8U
	 t7GAt8uSUjGVj6h+Paaw41Zx99oTY9XK6ptqfYcl1pmvbnKsBydvhlqdfFoxAbGMBH4D7
	 Ss72JpKe9XdGAEOh1BQkXftlGfQ9faOv8aEZNJS0hO8nikUFCCzdYfZpWqfAvftMy9Ke6
	 /wrT82pcb8jqsvPTQSi6FcI8IxPHCZTzTEt3Zqntf4d/7xvxIp7RLa/P/zaJz9xzil0Kx
	 95AD622jEEUgKN2+UOS9X5augrtNmaDOr1jYTr4WrDxzjHm0bRBFpta7xTk4QWhlFBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJ5iDU4Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFD8606A7DE;
	Wed, 18 Nov 2026 19:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJ5iDU4Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07C41F000C4;
	Wed, 18 Nov 2026 19:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030922;
	bh=cYy6yJwqzKB2On+qylphQyLDDy7PvwDgF4YK6ezYx7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJ5iDU4YUloB0Yi1prmM8yEbKzTCfszwEygKaY9j4f58zcUfNZphiSi/TENuKDNnw
	 k96bA+JbGjW3YmAQX8XOu7T0ffqqOPTTkdqVuOsyPDKwcDbOXK1wSj7W2MyhnkPjYh
	 q3JOwNp3m0i+2DuwRkyuA9BEW+1fB8NfRekIGf+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0873/1756] floppy: flush pending work before releasing resources on init failure
Date: Wed, 18 Nov 2026 15:50:00 +0100
Message-ID: <20261118150044.167976047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 74c2e2eeb7e51cdeb5e3eceaf324cfcf8dcd0d32 ]

do_floppy_init() probes each FDC with user_reset_fdc(), which queues a
redo_fd_request() work item on floppy_wq that may still be pending when
the probe finishes. When no controller is found, the error path calls
floppy_release_irq_and_dma() to free the IRQ and DMA channel, and only
later destroys the workqueue. destroy_workqueue() drains the queued work
last, so it can run after the IRQ and DMA are already gone:

  floppy0: no floppy controllers found
  work still pending

The flush used to be here. Commit 070ad7e793dc ("floppy: convert to
delayed work and single-thread wq") renamed the label out_flush_work to
out_release_dma and dropped it. Restore it so the work drains before the
IRQ and DMA are released, as floppy_module_exit() already does.

Fixes: 070ad7e793dc ("floppy: convert to delayed work and single-thread wq")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260722034435.13432-1-kmehltretter@gmail.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index f1dc62565ea5f..95fa91a5f7f89 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4751,6 +4751,8 @@ static int __init do_floppy_init(void)
 		}
 	}
 out_release_dma:
+	/* Drain the queued redo_fd_request() before releasing IRQ and DMA. */
+	flush_workqueue(floppy_wq);
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 out_unreg_driver:
-- 
2.53.0



