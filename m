Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C86225EF9D;
	Tue, 11 Mar 2025 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705379; cv=none; b=EzxhTfq2rYHmkiHXa5ORCu84V2tspftyxa1s6HJfMEg4YsM8mArK3jRBnglqGgPX4lJjxW/eE+QOUoreWCkDCLrJ9QpF/9wVFxi2GkyWKxIGUUTQ9EROOWqH63Nnn7EcPxBLjoIaOG5izU1D8GgzBPLQV68SpjNwJMcGjR9yfuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705379; c=relaxed/simple;
	bh=L5r7rf7p4h8L7mfyIeugorK8BQLTvh9N6GbJ1NgbJd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+BBLO+mjteyRIJajOEV7sm0gvMf/NffVLsEyVkopOm8NKMAB7XakAxfngixpZ27PyKdv9j5ZFb7CPxb1gieawNblFW/JoJB2pE3jIIMiWmaMUuNmnpV3UGlr/zwa01enhOQv8QeH9i9YY25y656Rs9b8JqwnWQMQPOFKO0ZqsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5v2mAkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5v2mAkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42243C4CEE9;
	Tue, 11 Mar 2025 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705378;
	bh=L5r7rf7p4h8L7mfyIeugorK8BQLTvh9N6GbJ1NgbJd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5v2mAkx8aHlXC08jGRoeRSpqQ1wvF1J4X2Hf21Rt5zkZ447sHBh12FySRtE4xvD+
	 UYIzieb8vTDFt0Tqr/HHfajHj5RMECwimaK69pBP2TPFmqAuUXEm8KprqyqB8z85Ic
	 QvRLP//UKIfPm4pX6NhXWFFRiMpwy3EkAtiImxCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Keith Busch <kbusch@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.4 004/328] overflow: Correct check_shl_overflow() comment
Date: Tue, 11 Mar 2025 15:56:14 +0100
Message-ID: <20250311145715.048859969@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 4578be130a6470d85ff05b13b75a00e6224eeeeb upstream.

A 'false' return means the value was safely set, so the comment should
say 'true' for when it is not considered safe.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Fixes: 0c66847793d1 ("overflow.h: Add arithmetic shift helper")
Link: https://lore.kernel.org/r/20210401160629.1941787-1-kbusch@kernel.org
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/overflow.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -235,7 +235,7 @@ static inline bool __must_check __must_c
  * - 'a << s' sets the sign bit, if any, in '*d'.
  *
  * '*d' will hold the results of the attempted shift, but is not
- * considered "safe for use" if false is returned.
+ * considered "safe for use" if true is returned.
  */
 #define check_shl_overflow(a, s, d) __must_check_overflow(({		\
 	typeof(a) _a = a;						\


