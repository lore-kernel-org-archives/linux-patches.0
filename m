Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C561487CD;
	Thu, 12 Dec 2024 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023471; cv=none; b=i5cAXuP+FvdKuFgULSAAEbXyANxxG8Rx/kgw7NlR8P1wGrruhViuxST164QnAKHjsH4JZ8SfGHp4sowzAfsz1nzM3iQa9JzPotAQLOjey/51jzEppXaKwJKi95A/X8ISjpcD3F6NhDAmgvAjqDqfdZrl5H9jMgW8vdHOPGDUzOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023471; c=relaxed/simple;
	bh=Qmn8Z9srcrK9N2gktM3HX0PyVFeZ8vyjhrbQegczij4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJVAKqkJO+PRklMxdinc4ggs/oD33GlLYJfWgr6s3K/evdVOGckk3ilctIuoip8vuapN3h80DJk05zp/hqITc1G7oC5lyMc/TZRNP8xaKEvGbDk2cZ5rkcLB16ntzvtZeca7XZivRuagk+7wBRNh0/MdfXKZ2rqV6aeqKamHuxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byhTzXL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byhTzXL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33777C4CECE;
	Thu, 12 Dec 2024 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023470;
	bh=Qmn8Z9srcrK9N2gktM3HX0PyVFeZ8vyjhrbQegczij4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byhTzXL3JP9AkACso1V1FtVj1/4Htf0t//KwHoWYdwQJdoTGsT6QrzjVWOIHXTOX9
	 xo2w8v4yalVnU5vLEl6p5pKnjVx1S3qaap3sQFJUKmsEuoczOBqq9DZdp62JKM2ZXN
	 zmL7ANfY+qovXALeSibCPflnxWnVg8DQ3IdOGUWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 543/565] jffs2: Fix rtime decompressor
Date: Thu, 12 Dec 2024 16:02:18 +0100
Message-ID: <20241212144333.320522082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


