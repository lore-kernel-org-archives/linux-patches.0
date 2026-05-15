Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCE335AC09;
	Fri, 15 May 2026 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861239; cv=none; b=a+W8iba7rJe2pG+/12IYmWsbqjXVlnOvaSbZWXZ5ybHQ6obKO9dY16Fo4JXEtB+3lzn9isIRVRNhUwFoq8hYej6YzN6KCIcnNq3AuK3ZPzA5F9TiRTkDu+EsFGidN2OqXZy/dVzZ77tWNSNxoOMJJcpLIHW/QYx9CvH0qked2NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861239; c=relaxed/simple;
	bh=FiXzI15D5XvkAJb40/LZAOfq8naztPqVVbl113jCIqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHBLj0sziGqqBvFbh0Z3OAh8AcFTNLCNZodfkUA9tcbs9YfwpEVg0RMpSYwhcOtKUGjHpTvm0B/UomJUhmctBjQbYsObaR3Dus99a5Jj24RMb61aPyGZ8uPFTKevk7f8sLnsJjKvjpMX6Au5YpkAGiCsJqCxucKi2aCLklRpiRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUnsSzLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUnsSzLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A79C2BCB0;
	Fri, 15 May 2026 16:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861239;
	bh=FiXzI15D5XvkAJb40/LZAOfq8naztPqVVbl113jCIqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUnsSzLzdnqoRJuAlEgX6Ksy9LxrqgFYgT2Dp7CvoZVADtG0BQORM0RW1NEg7yG3N
	 GskumV8eHN1yKwDHyQwD6PBsM4dnVzcbP6NeL18GWowu/4P4+I+fRJtUSKYaZvUmqp
	 l2dFJvUxHKw6gPxl9N5i296feQm/ph/wnJBS99DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 245/474] ASoC: fsl_easrc: fix comment typo
Date: Fri, 15 May 2026 17:45:54 +0200
Message-ID: <20260515154720.301258796@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


