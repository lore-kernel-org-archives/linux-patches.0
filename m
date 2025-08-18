Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2275A220696;
	Mon, 18 Aug 2025 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524397; cv=none; b=aLT9n1h9OL4D9XxF+7VYrKKsIFmBzXOjXOJkjO3YtmtOpbzF/lZCC07Mpv4Uk06zO5GGwMbKPWQV4sRDHmBl1c8azxEmMTAuC2zGu9vQCoWNFmRLCEYWrCllMsmr3Yymof1CatmqPcqghgGMUyLVpUnYmRGHRrR/bvLlR8TrfZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524397; c=relaxed/simple;
	bh=hl2MC7hvbAtqv+95wtQQ4fJz7Uhx99KPUChMznOIO7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHltWiv3xYKQV6aqF1kASnn7LYV6g6kISF7Mf0j0R6AcVmj2ozMqqc+3ON5IIkL0f6O0E2cg+WWsaSR/RVZWy6QUklpbjge59Rp+AkQxPkM9Krz82XdvYMCUzQHgRz1yJBgecBZFPuBqFtc9c9DrJI5/lFeCO6J2HDgGZDKs/e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evHnR8Dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evHnR8Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B97C4CEF1;
	Mon, 18 Aug 2025 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524397;
	bh=hl2MC7hvbAtqv+95wtQQ4fJz7Uhx99KPUChMznOIO7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evHnR8DyJoxryHgLXV8QfRdCA2UAZwSGr2H/C92zUKVdg1n8lq9uub7o4ommeDS1p
	 JuTYL2ElUwlVe4zVtxjiysBej/A5t8v5EYuCjr96FyPSGn9tX3GR/waAethe3F5oyY
	 Bulyv0hU9CaIEfz9BjSVE2gqdrUDWCyEIipHkReI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.15 459/515] thunderbolt: Fix copy+paste error in match_service_id()
Date: Mon, 18 Aug 2025 14:47:25 +0200
Message-ID: <20250818124516.090517506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


