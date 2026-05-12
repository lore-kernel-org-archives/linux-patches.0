Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4BF3EDE41;
	Tue, 12 May 2026 17:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608603; cv=none; b=E9zIF3JiaVsISa8WwHf3XzYc+MxH3UbrMhpskyqESkYG9KA1+lGx9yUiJzHR4u3j4w5EtW8U19p4LXNnS+cbkqrbnvV/hG1RkNjGxBgSAqSnFyAtc+HGYgu05xO0dtpEaX1gtiqroZAEUpnuatkvmTrFRUawIhzAvlCWtE0d148=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608603; c=relaxed/simple;
	bh=YT9ll4aB7iaklVy8LZrzZGpcttXVwVbm56wecNG/OIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+oql79MRqACloIvavEK1CVV+U+65zoRmZ25WXr1bczFJFflC0BkhmfYdrRU2jkXW5xKmbch+5/cujoRvZOrzx/fhNX8fYtOPmEqO0MZ0EKgltQoz9/N6VJNX4CLFV8NB5fvardPtzqnH9NQXEOddzDi/CR46uG/svcKPaUMJ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9qTnYi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9qTnYi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94F6C2BCB0;
	Tue, 12 May 2026 17:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608603;
	bh=YT9ll4aB7iaklVy8LZrzZGpcttXVwVbm56wecNG/OIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9qTnYi38x9dV65zNW/KWbP7RgsHsHyIuJjCPh0RTEJJg4LAGL+C4YQLjBwlbxaxa
	 91jaJU9rfUG9JqjvRLAGQblKHCvxChc6bRvwZqFaxySZXL5ykGYPTqVOo4YmwT71FK
	 R8wa1aZQBaZLtVpOwx6UUIf0hqLa7gNX6KO6xlT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 143/270] ASoC: fsl_easrc: fix comment typo
Date: Tue, 12 May 2026 19:39:04 +0200
Message-ID: <20260512173941.460873607@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


