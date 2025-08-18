Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35072E22B0;
	Mon, 18 Aug 2025 14:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526283; cv=none; b=SPrAlIr97BaxvXBkhlIioNi1mpZopHvoUaentrKE8ffpD3nBiPDrwalvTrkdMAikJIK+f9y1qDV0Ig8gqSWjUTlI/f7BtkfohjuXmR1jxhJKJyaOlaAsqvIoqDgslIlBlZrLmjgDEobydpC/IfzxVth9Pd8WBSYy8hrFnUy7V68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526283; c=relaxed/simple;
	bh=1Xw/UMJlKYIEDd7MgntElmqiymJfDt4d6rJVBuOPtJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5kaLQcowo+x5gZB41aceOwrSTx+cb6g1VC0SPru+AkV51EyHpHDfmus2qWdrBiHiLgkvqzVD2Wk+O2anl2ksh9MXZSL/yrW2Xlnvs2ZN254wHa8l5Q2mxYWy4WtkT3j1GHwkGnm/JEq5Me8wXwuzoEUhYGzrECH7lTzOqy6sVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDS0TOE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDS0TOE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9FEC4CEEB;
	Mon, 18 Aug 2025 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526282;
	bh=1Xw/UMJlKYIEDd7MgntElmqiymJfDt4d6rJVBuOPtJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDS0TOE3A/BMlwWzF7D/TagYL0HzLoSbWdWMeFICloEFoqhUUrCSilIvXLRfJKJwP
	 MSH85Ne44WJNjaGQqMC2rPcdSUgw1G2QbTOUbU/ZWKZKmcv4Yi4FdF05XFxOapmi0E
	 W2c+e4w4oNRHeRm5QGtGqi8+k004FUzywXBa3MhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.16 509/570] thunderbolt: Fix copy+paste error in match_service_id()
Date: Mon, 18 Aug 2025 14:48:16 +0200
Message-ID: <20250818124525.469593737@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


