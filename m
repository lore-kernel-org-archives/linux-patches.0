Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DF03955C1;
	Tue, 12 May 2026 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608093; cv=none; b=A7deAd8vKCGhBhVAJ5Nf5jiwV8LI6OHTtI08wj6ZQIGtRVAyiZpc347lANg0jpHszkRUhYsyJJmLFdeWFm/coCcENC9hq2m42rsijIf13OOqdGjNoWDAUnYL4ethwJq7WPXwvZmOL7yPrpkVQTeT7fXtlfLEhpF2KUeTfrk04gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608093; c=relaxed/simple;
	bh=HIKkYfRJpG7cN+0ooBzm7G+XugF/a0idy/Udc71b85I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryiEM3h17pWlD/5TQ8iETBgj+NvADbnx0/rmuq7nd610C6O9mUAR5BPzWYjYQ0jjuseyb2sows3tezOSWKss0iU1PJWividht2HWq7sFP6a5jNKvpdfJb05CoddMwwSGRieZAaaMRB3krpff+yBN5h89GEsD+hTbLh5t5/FKsgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3KgonU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3KgonU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77625C2BCB0;
	Tue, 12 May 2026 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608093;
	bh=HIKkYfRJpG7cN+0ooBzm7G+XugF/a0idy/Udc71b85I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3KgonU9DgKvI5LRarN/0+U5qKLYGwWV4+Q3cwciJpaAHva4SKK7QbdTyUrA7Yhlh
	 L0lp+OmnppWRXl+6SC5sGUlDIzj4zW8Fq8q2mvh8BwzuIYbn2jjLBJcfiM394494h5
	 pMgAgbbutd8jFd9s0QkTwHl3TSxWrJVSA5cSZGq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 109/206] ASoC: fsl_easrc: fix comment typo
Date: Tue, 12 May 2026 19:39:21 +0200
Message-ID: <20260512173935.164000096@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Salisbury <joseph.salisbury@oracle.com>

commit 804dce6c73fdfa44184ee4e8b09abad7f5da408f upstream.

The file contains a spelling error in a source comment (funciton).

Typos in comments reduce readability and make text searches less reliable
for developers and maintainers.

Replace 'funciton' with 'function' in the affected comment. This is a
comment-only cleanup and does not change behavior.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Salisbury <joseph.salisbury@oracle.com>
Link: https://patch.msgid.link/20260316180545.144032-1-joseph.salisbury@oracle.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_easrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -1286,7 +1286,7 @@ static int fsl_easrc_request_context(int
 /*
  * Release the context
  *
- * This funciton is mainly doing the revert thing in request context
+ * This function is mainly doing the revert thing in request context
  */
 static void fsl_easrc_release_context(struct fsl_asrc_pair *ctx)
 {


