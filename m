Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619428;
	b=K9nDC8d5SqipMHXHE3slAKuPT1fvMPddg61Kjs2ASl62a6ddSNrPDKLo2VHbk1gFWNx4
	 ZqyqJpXASPlTX72eVQWbZt12cX2bJrmQW28GtNsxM30G3b2VZmaIl8Du4lT4zMWChBWA9
	 KpVyXD/fM1jwoT7I++iMfEe6pX7+qAjI+jwFOz7+HU/lFQ6HtU7HXaTcCV1WGucSv2PiC
	 XabkV3VoVRaCwQcFpxkofyCAeFrkeVPZlsAhvvb7OaFQ9ZyhkbhKUef2PdkAYHbRcva7k
	 KQvHct5Hnzxmh3blhM5jNfSYpssZDOE11JrPf0UsB+busD3EnmrVv8jdOC2aqjgGBAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B/weP5CqJomvyK+ZtWfpWoGjtwYU6EY02qW4XWKbsnE=;
	b=2Qswy+gm2turovAerELhTdRI2FypUh1PB/LrssMAbIdYDvvv9heVZyFRhjxNioIk2DOG
	 Yj+Pb5g11GFDY7Myn/uNEeLvMj3FcDpobF9lqby8Oa1CwMmjCrkBDeVxg/Vw3huTH7Q3J
	 UFk3Hu5fMnHxHtE76EFUht19pcxY/jcDpeZUIapkbCFhVzS3Zv/o45cl47pJqPcfUH9T7
	 +1IT/rrQCaOngclcFeWs+4PzLNIrgTNOpcxTiWkxU5+JELsE0GwoAs/ic7dcibXZGWca4
	 x8N+gVuVm+GqNcwACgLXOsI6R6j3hSaGa/3nJ1pjs++xCU4g70jyVCYMKH4OCvuTTow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9gNmM1G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545D0606A336;
	Wed, 25 Nov 2026 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9gNmM1G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A676A1F000D2;
	Wed, 25 Nov 2026 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619428;
	bh=B/weP5CqJomvyK+ZtWfpWoGjtwYU6EY02qW4XWKbsnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9gNmM1G8g3hIKJ2tFmwud0Te3X33G8id00Lsc7SCQw4nMOrFUL7UDfaYUmMQEiF4
	 PsYt1n73+JjqZz1hyKUEwVuO0qZVlx4BN+rLLcnoKZ0GOdVmAKXD3NtjUdtjsxa/+l
	 bdfrjWUl5A+Acv76x3h8rmAyDRk4P6x2bPxwXkqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0591/1005] aio: dont let exit_aio() return before complete() is done
Date: Wed, 25 Nov 2026 15:32:09 +0100
Message-ID: <20261125143835.589579122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit ac4b449b39e605123c12ea10042cafc9b6f39603 upstream.

exit_aio() kills all contexts in one go and waits for them with a
single on-stack struct ctx_rq_wait. The count starts at table->nr, each
killed context drops one count in free_ioctx_reqs() and exit_aio()
subtracts the empty slots afterwards. Whoever drops the last count
either calls complete() or, if it is exit_aio(), skips the wait.

With a full table skipped is zero and atomic_sub_and_test(0, ...) only
tells us whether the count already hit zero. free_ioctx_reqs() runs from
the percpu_ref RCU callback, so if exit_aio() is off the CPU long enough
the last callback can have done its atomic_dec_and_test() but not yet
called complete():

    free_ioctx_reqs()                    exit_aio()
    atomic_dec_and_test() // 1 -> 0
                                         atomic_sub_and_test(0) // true
                                         kfree(table)
                                         return
    complete(&wait.comp)

complete() then locks and writes a completion on a stack frame that is
gone. So hold an extra count for exit_aio() itself. Then the last count
is always dropped by exit_aio() after it waited, or by a callback while
exit_aio() waits for it. An unprivileged user gets there with four
io_setup() calls and an exit without io_destroy().

Reported-by: Kyle Zeng <kylebot@openai.com>
Fixes: dc48e56d7616 ("aio: fix serial draining in exit_aio()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261030-work-aio-exit_aio-v1-1-83942022a4c4@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -962,7 +962,7 @@ void exit_aio(struct mm_struct *mm)
 	if (!table)
 		return;
 
-	atomic_set(&wait.count, table->nr);
+	atomic_set(&wait.count, table->nr + 1);
 	init_completion(&wait.comp);
 
 	skipped = 0;
@@ -986,7 +986,7 @@ void exit_aio(struct mm_struct *mm)
 		kill_ioctx(mm, ctx, &wait);
 	}
 
-	if (!atomic_sub_and_test(skipped, &wait.count)) {
+	if (!atomic_sub_and_test(skipped + 1, &wait.count)) {
 		/* Wait until all IO for the context are done. */
 		wait_for_completion(&wait.comp);
 	}


