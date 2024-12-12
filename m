Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A142210CA;
	Thu, 12 Dec 2024 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018615; cv=none; b=dFaL0ASaA9aZYrh02VY8pOm1FIj2Jz87Fcj/iDzvjL6wrEdNGHQqyngjZ62Frg13DeLovQkwWO/Jjnv5IJCgYJTsz/4wNau4deboc+Zg0zaNU6tAMsuqtRIYs+1Yqv9pZ1gJo4hiUeApS80ZOGcz7OOn+g2/GXtgD5NULKcpWHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018615; c=relaxed/simple;
	bh=FLR7QwKPza99dPtJjlH/j74sLPvCeeLn8Ctf+zAfsiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/D6nZwMEJsHkiFb2hViKazJgBtnlXJaqIk1kyph/7Ac007Jse91MD41K0jv8Od8EZCB0nvQVjf+Zd7EsgjuKiODWMd10DWIvV0wLDpuoAq6+UJiGMkquunuoYw/LIf97ZHnMcn3dI06eM3H7XeH6VsvootPwjf3vcsYd20dRsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eu+NpwqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eu+NpwqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729CAC4CECE;
	Thu, 12 Dec 2024 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018614;
	bh=FLR7QwKPza99dPtJjlH/j74sLPvCeeLn8Ctf+zAfsiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eu+NpwqTBMLWHxSNxvXw6qNIf/HRxZXhfhSHxEgZUXmvfzuhDhCfYw3VSNlH+7ikZ
	 NG7Un6QLdpNodrqeKkg9D9xv7yEKzwtdNjfuDBju41nz295B4KGr8jE++WZXiXPq9L
	 QoPXxhDr8THAkrns4Tqeq0uhVq1P939GdJSCgORY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.6 341/356] jffs2: Fix rtime decompressor
Date: Thu, 12 Dec 2024 16:01:00 +0100
Message-ID: <20241212144258.040279523@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Richard Weinberger <richard@nod.at>

commit b29bf7119d6bbfd04aabb8d82b060fe2a33ef890 upstream.

The fix for a memory corruption contained a off-by-one error and
caused the compressor to fail in legit cases.

Cc: Kinsey Moore <kinsey.moore@oarcorp.com>
Cc: stable@vger.kernel.org
Fixes: fe051552f5078 ("jffs2: Prevent rtime decompress memory corruption")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/compr_rtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jffs2/compr_rtime.c
+++ b/fs/jffs2/compr_rtime.c
@@ -95,7 +95,7 @@ static int jffs2_rtime_decompress(unsign
 
 		positions[value]=outpos;
 		if (repeat) {
-			if ((outpos + repeat) >= destlen) {
+			if ((outpos + repeat) > destlen) {
 				return 1;
 			}
 			if (backoffs + repeat >= outpos) {


