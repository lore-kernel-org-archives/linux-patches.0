Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043425;
	b=JkChDxnynRS2U9fVLJ8fw3ZgCAeij3+sVNqEoyeaBjZeQ1dvW6t8HSb6+0iTS2w5k3Zm
	 Ook0NgOpdQo/SCwD1Y+XddLwA9vhgKAAP6ir+jSczP1kSjxyvKfaRmArkMlci6WkohqfH
	 vh5KwQpMsvRwHcp9XnVybUp3Gz3FsNsVeh5JQxXcahavtJbxgNB+CzcVEUKeZlXEZdvbj
	 XbiBvaPR8ltsGyxk198UqwMxcSxnvL6pid/S4n4B7+m8afUVADqyVkTyNa6cDQ7Pd1ZvT
	 FOmGwm9x3ZYTjapwvkpKLDNGulx7HOFhT+XBquNHJS1MzqUbst0oHApIn2i64k/hdPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WlyW34mMGW7IUAdXi6DSXAZEMRnlbvlpVPlzys5GN7Q=;
	b=f/Rqe8qbrUO3tyCYUui6zawUyQX9r+5k5l69jfRd9eV7j+/45lu288eCw4peRN5eSNec
	 gg59kN1FTiI+x2NpGM0mBekGa3kCJVos0hfdLmkUPR6W4hpRggZvTwtMYUvBKVMq+VnON
	 RylxD7jEeWdjT3U4n3X9Lr1VUhZt/T9QnUx3c9r4/yQ3mpjyjvRptEtGaAZIoW6OgiRbv
	 /izS6OFgKp8tgSJuTsE4YV+VHaBXJ/aQ5nHzOn1C7YU2KzirMivvn6H/Ta9ZhYeWDgUd/
	 hylaxDwBq+ZM3Mx5ZFzbk6tKARg2PoE12/fZdiDCtc+GKDgSaX2kJLIO38N2NRj0U0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzLtjKAJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9678606A320;
	Wed, 18 Nov 2026 23:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzLtjKAJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50EE1F000CC;
	Wed, 18 Nov 2026 23:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043425;
	bh=WlyW34mMGW7IUAdXi6DSXAZEMRnlbvlpVPlzys5GN7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzLtjKAJLRLg3bkkOJbSiMVuPX1eNgonbuYdwFLLLrwycgLmv9mUxU9Li9DJgLDSK
	 0gN+dCw5yqUqCyVfHZ3QeFuNEGWXH3Qp8lv68+/faoxYvTBtp/5B5vlKspong0EoeE
	 woFaRe8RINKp9f52mTMCxxkqWmln/L/BulHGRqBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Haufler <andreas@haufler.info>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0207/2857] tools/lib/thermal: Fix misplaced extern "C" closing brace
Date: Wed, 18 Nov 2026 15:20:41 +0100
Message-ID: <20261118150208.809311017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Andreas Haufler <andreas@haufler.info>

[ Upstream commit cb0ec27efac2aaf92393ad563a35fb6f00d0a6cd ]

The public libthermal header opens the C++ 'extern "C" {' block inside
the __LIBTHERMAL_H include guard, but places the closing brace after
the guard has already ended:

	#endif /* __LIBTHERMAL_H */

	#ifdef __cplusplus
	}
	#endif

On a single inclusion the braces still balance, so the problem is
invisible. On the second inclusion of the header in the same C++
translation unit the include guard skips the opening 'extern "C" {',
while the closing '}' lives outside the guard and is emitted anyway.
This leaves a stray '}' and breaks compilation for any C++ consumer
that includes the header more than once.

Move the closing block inside the include guard so both halves of the
'extern "C"' declaration are guarded consistently.

Signed-off-by: Andreas Haufler <andreas@haufler.info>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260721083230.91246-1-andreas@haufler.info
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/include/thermal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/thermal/include/thermal.h b/tools/lib/thermal/include/thermal.h
index 1abc560602cfb..cf8381121c78e 100644
--- a/tools/lib/thermal/include/thermal.h
+++ b/tools/lib/thermal/include/thermal.h
@@ -135,8 +135,8 @@ LIBTHERMAL_API thermal_error_t thermal_sampling_handle(struct thermal_handler *t
 
 LIBTHERMAL_API int thermal_sampling_fd(struct thermal_handler *th);
 
-#endif /* __LIBTHERMAL_H */
-
 #ifdef __cplusplus
 }
 #endif
+
+#endif /* __LIBTHERMAL_H */
-- 
2.53.0



