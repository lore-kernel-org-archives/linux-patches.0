Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340BE373BE0;
	Wed, 20 May 2026 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294465; cv=none; b=tUxbBIgx99AZ7zeInpgs7qS+fmHFnZZOlsfYghLrLomuJNuxl2dXuc5e7zYjURzCfzSimiqDj3AeVHAubOSF68y+h+uPLzORfyPrLfDMUilw+wbQxG/xcY3/XF4GTjn1djrxZDRLkqOhTjVCeNCf/zWKwh5h0iSDjSUJasbZBh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294465; c=relaxed/simple;
	bh=E668TJIsyI6GBFKiF1YAUf8ZHlW8yROGoyAUSd+Xea0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmuVlXOqmbah1rRhETnoXyHnMpmEDe96js2kg3iIuKEJNKw9yWsSkI10C0rnlxbaE03SJ8aM7uqPsuPvz+NIijhInYyRP+zK19BGbTsA6j/DEE2WCxzmRGQbS3hwMKCWHJ7SVs0uewObEdQwDDHEW/DcgyQyg2EfUEkVkxsFr38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TU/oOdWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TU/oOdWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572C01F000E9;
	Wed, 20 May 2026 16:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294463;
	bh=PzqXj7rKfcAHGHdMShz+NkTUSX8EB8bd8XbUEn7DNHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TU/oOdWy+3ZMAPKPYUIDnvb5McrnBYNwA/k2VdmcDZNRb+HkCFtioY+5VwvtYk/eY
	 uFNgwuX4SUOWNGCur2VkxtGdRByUZ/VQm/P2fboRGW+mIT50zFNqEwyFN9AHs1qkUt
	 NlfMPy3HcLRyYOS4Ifute/pofwZijT0aUkYQffXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0050/1146] ww-mutex: Fix the ww_acquire_ctx function annotations
Date: Wed, 20 May 2026 18:05:00 +0200
Message-ID: <20260520162149.507535069@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 3dcef70e41ab13483803c536ddea8d5f1803ee25 ]

The ww_acquire_done() call is optional. Reflect this in the annotations of
ww_acquire_done().

Fixes: 47907461e4f6 ("locking/ww_mutex: Support Clang's context analysis")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Acked-by: Marco Elver <elver@google.com>
Link: https://patch.msgid.link/20260225183244.4035378-4-bvanassche@acm.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ww_mutex.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index 85b1fff02fde9..0c95ead5a2977 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -181,7 +181,7 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
  * data structures.
  */
 static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
-	__releases(ctx) __acquires_shared(ctx) __no_context_analysis
+	__must_hold(ctx)
 {
 #ifdef DEBUG_WW_MUTEXES
 	lockdep_assert_held(ctx);
@@ -199,7 +199,7 @@ static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
  * mutexes have been released with ww_mutex_unlock.
  */
 static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
-	__releases_shared(ctx) __no_context_analysis
+	__releases(ctx) __no_context_analysis
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	mutex_release(&ctx->first_lock_dep_map, _THIS_IP_);
-- 
2.53.0



