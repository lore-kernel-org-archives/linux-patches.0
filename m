Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6232C261B9E;
	Sat, 30 May 2026 17:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163689; cv=none; b=SQkxz1G9pZnCt9sYA9XMpNmmmmYznLlorG4hFvXI05c23BlbosT8jV9Zl8OKUgWjhRKmGWex740owhqBehh8Rsl/OG4rXbM0Vy5tySnR3PDvq/s1vnUqgTfvFhJlhULwWlcVSimQycJ/uaDsO+wjvk9BKC0qS8RsPzhWSqnrPeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163689; c=relaxed/simple;
	bh=XGhKS22g9YTKX/lRf3VOCp7ouevarpqQhVkKJduCok4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/g5D9J5Tw1BBDezK7ihDXw/qXqQ19y5aU9WuNBQ9BsNq+2VnnWYFWBCLDrN1EhR5QKyBNXg2VvjdVpDtTv15LWFl0ImaAyAUYdFT3Eq2zv+qKNYhTCp48LK9YjwuHW9SXLf6IM9QCoOTk4RV2eoQfeOBhVVAxdWCiHB2p/cvTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jE7SmmCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jE7SmmCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69051F00893;
	Sat, 30 May 2026 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163688;
	bh=nRGrAUxgj3xrksW1BXf0lv8u1evmTYaUp4YY4nS2J0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jE7SmmCibdZp25tCMAmEixkxuOyTr5VhMHqtfWvnHgNBygQkof+ACINUVtTNDP6Ly
	 Z1Afo4xh9LapCCXWmrkJSJul9xDbeaT/6BMX5/EY/xDw1RMDCzJH6PodLjBKzhpBgt
	 mSGZmzqGsd+C6+XZX49rYzvrRGnjg8EAzK3YNOfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 325/776] ASoC: fsl_easrc: fix comment typo
Date: Sat, 30 May 2026 18:00:39 +0200
Message-ID: <20260530160248.971252639@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


