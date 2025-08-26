Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6967A1E502;
	Tue, 26 Aug 2025 13:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214782; cv=none; b=saoZkUFn+CltT/DYBg0cxg2wWmDXh4XEPRUQmXVj3iKtDuJqB+bZWxEYXY0OCW3qt04SzrBx3OHj5//oj+zp0iTxI3jjGMSaEqYqDsruCYIkBMu059bexVOQkRXQgXo85jXxphmNMFJixgrTVxYpa2ST1MPmFsOtBM4ceZZCzjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214782; c=relaxed/simple;
	bh=oxRj9kAuVRkj4cZmno7Ne0Ch3EfJSekAtY0MtD/j2UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiiy1QV4i/irPqghYJZ/q/1GJUZabSqdXDJ6a4R4fUKfp9VceazRp4FMpKid0IyIsqAI9YnBmqQ1faLjR16x4hYwtUwVA4Pe1QARaAaBOuXSXD/L/gkjmUhuFiZtnRz1uFSciixcyCa9AEoPQe6UenOw5XJReZSewGJcPZV/VAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rcb2xyWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rcb2xyWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F148EC4CEF1;
	Tue, 26 Aug 2025 13:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214782;
	bh=oxRj9kAuVRkj4cZmno7Ne0Ch3EfJSekAtY0MtD/j2UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rcb2xyWyFOagkT7OzmD2LvPzTpmwzo+EQddvcnX/0ZBWdePQ+oE1uJVNcZBoLeimi
	 dY39xZfh1DZqCFw4R8qKb/ahcPqT0dPRvtm+Ntgufa8clTrR64b2pah7bknavk9Hka
	 dTeufuDKFuWm4j8wm3892colpadu8qsVaDi1GgXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 250/482] thunderbolt: Fix copy+paste error in match_service_id()
Date: Tue, 26 Aug 2025 13:08:23 +0200
Message-ID: <20250826110936.944396008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 5cc1f66cb23cccc704e3def27ad31ed479e934a5 upstream.

The second instance of TBSVC_MATCH_PROTOCOL_VERSION seems to have been
intended to be TBSVC_MATCH_PROTOCOL_REVISION.

Fixes: d1ff70241a27 ("thunderbolt: Add support for XDomain discovery protocol")
Cc: stable <stable@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20250721050136.30004-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -36,7 +36,7 @@ static bool match_service_id(const struc
 			return false;
 	}
 
-	if (id->match_flags & TBSVC_MATCH_PROTOCOL_VERSION) {
+	if (id->match_flags & TBSVC_MATCH_PROTOCOL_REVISION) {
 		if (id->protocol_revision != svc->prtcrevs)
 			return false;
 	}


