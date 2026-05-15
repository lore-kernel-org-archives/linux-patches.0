Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999843016E0;
	Fri, 15 May 2026 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862082; cv=none; b=Z0s963H9aH+QgJLSyc1HVOWRpdzEy6TxrANhbYL5Vky+2NZrNn7hXHP2Fu5pwwBTZjAS6PaLB/zacsemAkeN4fi0fCTBKo1MRaV8llMiqh917dnIjF9iWdRIUPhhHwjNBf57Ar2NZDNYfI8SuD9FC+djR9FxDFbnKWqKjdJfC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862082; c=relaxed/simple;
	bh=jBMf/dJQK5UXuVoDQ+YBsx00uRUoQAa292NZTMlYz1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lrOpEjYIRe9NgNyHMQz0ShkwPPHGIvAGFp4JnQMBM6pqe04qRRdaiqhlz64ow4MTxUpH757Fcw+ZSXU0+Wt9p5/zYv4U0dlgbsWdLk53W/BJ1W33t2noOk4wQZYdnKMeaSFiayBg6FC7GG8Dcv07go9VkOWi7YBFMrDmsM0xa5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuMfCYTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuMfCYTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30063C2BCB0;
	Fri, 15 May 2026 16:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862082;
	bh=jBMf/dJQK5UXuVoDQ+YBsx00uRUoQAa292NZTMlYz1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuMfCYTow+TS3+61zMjL4kgPbPI0jKi7uGMvF0g9qHGBDxtGLEy5ewucAOV3nlaHk
	 c5vXvr9MWKzG0gcp2f0eQApyXEfAHfGTOdiIbNGMLkTcfd4a7oFJzKq+5da22nOQF2
	 7w9G4E9vI6oRd0yZ2ZQrIPbzxgUSB+bYiXfu3nQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Nemesa Garg <nemesa.garg@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.18 100/188] drm/i915/psr: Init variable to avoid early exit from et alignment loop
Date: Fri, 15 May 2026 17:48:37 +0200
Message-ID: <20260515154659.498891478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 314f6179e370988ac00dadf373a4f6166eb3db15 upstream.

Uninitialized boolean variable may cause unwanted exit from et alignment
loop. Fix this by initializing it as false.

Fixes: 1be2fca84f52 ("drm/i915/psr: Repeat Selective Update area alignment")
Cc: <stable@vger.kernel.org> # v6.9+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Nemesa Garg <nemesa.garg@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260413112345.88853-1-jouni.hogander@intel.com
(cherry picked from commit 289678a90b8cf81e3514c9d6c667235cd39c7acf)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2840,7 +2840,7 @@ int intel_psr2_sel_fetch_update(struct i
 		return ret;
 
 	do {
-		bool cursor_in_su_area;
+		bool cursor_in_su_area = false;
 
 		/*
 		 * Adjust su area to cover cursor fully as necessary


