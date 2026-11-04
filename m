Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830902;
	b=p2C1VD9s94FINqyuLy8F9iFBQ132PpD1hq3PodWLKB2SSO2JGirqGQF4X3WflkMdXXNH
	 GYHxs/ucnrT7UlXWd+m2cjqDZPTimuOQxU7F33FZfN4jdP6pZJ+upKG2ubJUH+zdrkglU
	 vzBcHSqoMWSJJ2e0i0C7bX2ZI1RWiu15Lqf6K5j44rikcJp9/KFnaeDr76ZYwCR9/ct4J
	 1mK6M25+xYVWi26LvvxY4VddXdCzR/zaGGuItjyAjEVPXPoOz+0cmKF+UYFio/Ve74h/b
	 cCn8b/ysynY15Dk4l8DGPQ/Ryszu1ahMLaBL4zExlZ8zuNX96XXFPPXruGUed9LJQHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+EohQvh4/tkPsktRJoUzR8rXx5JRomOHgWQH9/7dc4=;
	b=m0U86himUwGZude+B2FTWwheC0xzAbhE7Xpj9a5++K9qb+5TIOfMcmPhn8TRx170xc53
	 4n4zUX5wJGYflXreQvRg2zWvph4GWKqK+FLz/Pv9rJvscZl4jUceYL6haRN6vqBU8dBUA
	 xLeQpW+hxqnH764G1U84O7dDF7t8luJTFQCwH6OpH/6Tt67fUxFhAlPvpwVsE3pofupSa
	 GloK1ASIfWciY24u/J2WYq2k9z5BPqyoPZjANKDcY6AHoF4L/28xdAO7fVsiKKzEYKFaN
	 oxYmccwTxNVOzudOe1dPsqvkvDOXCGM/nRssVlGtijNIlv5F8k0s7+3GDveC2XfXe0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0nZklNi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94026606D804;
	Wed,  4 Nov 2026 22:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0nZklNi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAB61F0093A;
	Wed,  4 Nov 2026 22:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830894;
	bh=x+EohQvh4/tkPsktRJoUzR8rXx5JRomOHgWQH9/7dc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0nZklNi9yJBQmRgOODrTkF1aTsDwrQy+6Kuvsm7TrNxT9RrASaxr1qfDUvTsBU01
	 LGS11JTfPOLGPbjQMzV683S+n1QEeqK6OGRJz9mdohITZ17ekL8vd5ca6DjM13EmKq
	 MezgXNJr8jsZXy8PemBOtzx/aY+mQ0OwIajHSbjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Haufler <andreas@haufler.info>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0343/1005] tools/lib/thermal: Fix misplaced extern "C" closing brace
Date: Wed,  4 Nov 2026 16:01:16 -0500
Message-ID: <20261104211053.572487364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 818ecdfb46e50..d9097271d9fad 100644
--- a/tools/lib/thermal/include/thermal.h
+++ b/tools/lib/thermal/include/thermal.h
@@ -175,8 +175,8 @@ LIBTHERMAL_API thermal_error_t thermal_sampling_handle(struct thermal_handler *t
 
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



