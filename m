Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86792352077;
	Tue, 26 Aug 2025 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219162; cv=none; b=bRiAGWRKGLW7S8g4Wh9wdBEi+RNd4CkFm+FXJlcW/mBFbtA8GzAjk51E4btqVmDuKfIUIpoUXZRVNOKUs/PjXVcDUcrIliG85OYPe+LngE8a63GpqEgsWa/SWM+S2JQqjA+jia0YCfeAOWeK+0eIhaIes/OUoEy9xINfz5QBXFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219162; c=relaxed/simple;
	bh=9zbl3SUUCrHhINly2+n5Ixt6jDMnUqUZ4x4tYgTtrxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8E3pSYStrIspHcTJuo6F/3/GHNsDOHhUwA3Lw9O1bcXQfh7y/+yIEtCu1Ofdka2WyiasIkp3DOsRdF47JBDx8sUBgOhxI79p3d8sUyO3i9jyCYsUHm6SWR1yAUdbGz09qn3QcLWjZyvKqzgRG7p7uHqZmmv2ZIKV8Ozcj51SFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6nz4SOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6nz4SOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA43C4CEF1;
	Tue, 26 Aug 2025 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219162;
	bh=9zbl3SUUCrHhINly2+n5Ixt6jDMnUqUZ4x4tYgTtrxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6nz4SOgd/kAEimeRrK1Ox5Me6tZvoEzEnTSqEYnqgXD+GantjEhnaTiyQcKF73IA
	 igqgOCPW/Nf12PjDG4kc8VETctEoBUbk/NTydkzOFcIIZU2iKN2vDIw5SsCDA6gN2f
	 iPq90yWQfciv0VIE4czWzUZj5BZzeqCDAFqAzf0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.4 276/403] thunderbolt: Fix copy+paste error in match_service_id()
Date: Tue, 26 Aug 2025 13:10:02 +0200
Message-ID: <20250826110914.422529694@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


