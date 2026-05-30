Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3281F41A8F;
	Sat, 30 May 2026 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166123; cv=none; b=ppvhG0VlhGEJq1mFg4cmsrXmZfV/WA50r4BWyBk0BOhACPkxOf7fVaVoScW9HGnvBbslyD97oYXDYaKYBuUXCyMM4zEhsU5LFb5zfFl/f0oGh/yTYkCt/8Rgx542+27ehReWwOW+rM0Zyc9AFXKnWB6CEBYTI/tBpk4qVXdUf0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166123; c=relaxed/simple;
	bh=he6XtE8Mj9HvPVSpDLU8P+q5Gs7xXSBRQ7kNkGp9X64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCcDYBv0KkkTpIhsynIhzzgF2ysaPTR7wxPytQ253zboU2pDMUV3TjkBnNihT9D3+lUHoMjWf6RO3jjZu5CUo9Yawe+0aZA9oCeSejk8K1j2V5+kK3/x1L+PKY8JyiAyh+KpcM68MmBkfWJ5aroWw0lRfydmqk8gh5gzDr0sHUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK49kpSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK49kpSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3AF1F00893;
	Sat, 30 May 2026 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166122;
	bh=mzJtdakt6+Zmu2M9zzcz9T76m7/9jK52oAHcdAMVHUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VK49kpSdbY8q6uImOV3rWLB5iRV7CPQTk4hBOkMOjrqWROdfZ0ixwuYUgtKvq+xMO
	 JJqNTMcfjhC7ChspPV+aqs+Ot2od+uzWYLlrFss+JQGyhe1jYLB/E1h75/yR9y4NAU
	 qjIPgR7JKuw2ZLh9R7BA7P60bLHs77hUYa+EnXr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 246/589] ASoC: fsl_easrc: fix comment typo
Date: Sat, 30 May 2026 18:02:07 +0200
Message-ID: <20260530160231.462889841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


