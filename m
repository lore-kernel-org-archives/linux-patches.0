Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C832BEC45;
	Tue, 26 Aug 2025 13:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216528; cv=none; b=V8OIe3GHEbtnZdAXdFRtpMDIkj/4ibmLnxuvJWDho3xgKF7fLvZbAmQZc0cf6C9SgiMb59Mx02pPJez6y7e+kLz7w7b7YqTmfipbXLQ94RtFSANDclqzy8SC3lG7fOn3YBfzwu1IRRFchRiRXO2UssT9wGXs3+Xbx8gErK8MiR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216528; c=relaxed/simple;
	bh=7N44qMJNPxQ6yqMJuQQz3GUhStlDKjyCjNcO0Ddui84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2prNkGoTW/7DU6FM9tBqMwAoDNlp7dbVRq1LOFUKwK6pYSElj9Vpb4bqnb1IMyjlRA9eaxyf0eqkkTVr703QY17xlyv5Hobu8gw1k3lI6rfh+K6lfgMJj1mRS+W5ycvCcmD1DN+Rq1rnfWJvcUj0qxDmK7VRFBXrWuCkCGITrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaRNRZHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaRNRZHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A32C4CEF1;
	Tue, 26 Aug 2025 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216527;
	bh=7N44qMJNPxQ6yqMJuQQz3GUhStlDKjyCjNcO0Ddui84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaRNRZHxWKyp0z/Nt+WNLX+P/wVv1BiD/MCP1Vij414M4JPW5E3MKA7APCeRGQvWo
	 dFDDw8xIwF6L1IfRarz1VrcJePnm00erQQkJepd738sjX1zEkZihaIFvuZoXSRAe5p
	 w5LqRkRtYCmhMY+DDVYgNojBUbfAQQOsgqg+Lm+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 445/644] thunderbolt: Fix copy+paste error in match_service_id()
Date: Tue, 26 Aug 2025 13:08:56 +0200
Message-ID: <20250826110957.495558668@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,7 +38,7 @@ static bool match_service_id(const struc
 			return false;
 	}
 
-	if (id->match_flags & TBSVC_MATCH_PROTOCOL_VERSION) {
+	if (id->match_flags & TBSVC_MATCH_PROTOCOL_REVISION) {
 		if (id->protocol_revision != svc->prtcrevs)
 			return false;
 	}


