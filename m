Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034076;
	b=BUu13KJbfSfI20e1wdqxONd5/ln3EQKheFOciR8xE3zHHFr45R2Nx++AZhJT04Yv9aXS
	 nkciV2WJFQ+xUpccwlQveR9ONgbGc1/qrl0TL9sNgNeguidWTI/9sxE1EV6MatzCS0OZn
	 WoiiJCTQcJXUa53WO1qEQ8l3nwkW1zEHfTpEQ06XPnUcVAPHB5C9n8hZoaDVumdh2iB3D
	 GZfm4nXCDvTYsm8Vld3v6HXnV+Lpf36iyXvilosANm6IhU1UZ1mIiuYXTezJBJLXia5If
	 y/0eSq9E5Pq/cZIKVzifhpjHsUCBhwZXWOeqLleZbelY/6EpvBkF1vJAn9kb4w+69lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5OarVjU2duB2r0M5xwbyBfjgIkdmFogF0+9ynMLtYxQ=;
	b=P0RDJDJoqHMCE861Rwuo2C/6nR5dEbh4XJG1wAFjybQkbDvOI2dPh1+xyIW3zoFffV38
	 NvPvydocDmtowq237cozrOh6sgxj1cMhpYL3o6ADKJfSTqI0EnLw9TEdsdbx0QuOaZbFR
	 M0w/qa20jSQiHhwjNRdfV727W9Qk59Pyj7G0MYMy+zKLiZ5jjHDUHIbZdnCy60N7YHiYq
	 z0bh21V0DyTNDj+uCTApicMP5S4hTyI2LejNJrqW6LiBGoK2nSp2sxyHuLbPatOnnJr9M
	 aLzFD4LZ7p/bfPM62tXJzH4ItYYPMN7VJ5rZ+rzfEKbpXkG5ZlPw4zU5AR/YFxa8WPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPQun9dN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA83606A320;
	Wed, 18 Nov 2026 20:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPQun9dN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92AA1F000C4;
	Wed, 18 Nov 2026 20:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034076;
	bh=5OarVjU2duB2r0M5xwbyBfjgIkdmFogF0+9ynMLtYxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPQun9dNu44zP5vLGhGFkgtBVAj7DOc53ztze7nk2wO/xHWGTeTG2+e4o1BhGfPvk
	 cmqXou5eETbp1O1HKbe+B4FYunXj5DZaQXZWqYN0nHNXh98oMIB+Ls+FwaTCG0PaAj
	 YE9PtQY9qIS8rY1zjAGvYVGCJklDs9UD/HVEYGu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Haufler <andreas@haufler.info>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0240/3318] tools/lib/thermal: Fix misplaced extern "C" closing brace
Date: Wed, 18 Nov 2026 15:14:22 +0100
Message-ID: <20261118150322.325516603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



