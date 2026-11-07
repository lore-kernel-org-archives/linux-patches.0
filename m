Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060916;
	b=BI5BU1PfLFF0nnqXFF0ctPSlNv05bdWSrPkBRvHl4MW1OxxZc0OXM+UKo9oSurF0Q2h5
	 bN5x9Cn/BDTHpGGA8umPJM6MiyAAd1UIRideDm7mO5g7UvW5+vYxcd1TkbLRwU8Q9qkMz
	 86CNDwJ4A84quOeu31GhhKprSBNlAKqc1ViJXiiH8UoOeHF0GwtJCzpTD+vp03OUIxFk7
	 A93WPYE5vXLo9BTxQvOu9nbwvHMVFRA6HK5kUaw8hpBUMeiCyLFKRJCxX0nmZWPnhQvAX
	 nFYmzugCFbOf0OofB6jUMhgfhwSVqHVk4zXzQ/wTXC3AIaRtFOoYJXxVxC4XDe5JBOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9+BeZLhJfW3HdUAl1xTbQqL6A8YbK1ibixIjpapoCE4=;
	b=zde7vjt5domK8kummhfLahynOU/hwk+44WUtmbL9DNkxu0DlHMlEpF77wp65DM1ZLjsk
	 14MLFIuG+IkPJqdVCOgF2XJuv766uIh9aGp+ZlQH9sf3cxE2mWN2x35PY8ehsKX7CzQsa
	 /9FVloASxRkXqx/PSIuLrN0TBwQJX3DwZHNq6qGgJ+zVBU4ys6dGq7RKGiQhB6GnG6lPx
	 UTabpsbGLC0KBEphJ1DBH1/7jKO5M50miYQMnrvqm/48/yA2CVd01chGGyBUCnTnaAJlo
	 lpoxX7N28B9C5oV1WzzegcNlO8X9nQArkAEF4XGcD+Lu9+zgrsATYqnAIpx20oYmBww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hq0zF0Lq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BF8606D80F;
	Sat,  7 Nov 2026 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hq0zF0Lq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D551D1F0089F;
	Sat,  7 Nov 2026 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060916;
	bh=9+BeZLhJfW3HdUAl1xTbQqL6A8YbK1ibixIjpapoCE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hq0zF0Lq2W0jaxD/3RiCMLs2sD1F0KabOY4GZy3r7dfp1pdjUhN3Ar+aEq3xJVHCG
	 8nX7dU2R+bo4JZhCv+I66CU87aQ/AtwiKB3BTYrpTzM2EjbGJpeUTceTTcVyOGjSgq
	 ZQgDKnJM7ydlHStsW+cl4Cxf3CwI8y0YgjfxKpuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Haufler <andreas@haufler.info>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0284/1536] tools/lib/thermal: Fix misplaced extern "C" closing brace
Date: Sat,  7 Nov 2026 08:38:20 -0500
Message-ID: <20261107135005.638841347@linuxfoundation.org>
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



