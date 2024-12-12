Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6A66F2FE;
	Thu, 12 Dec 2024 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024939; cv=none; b=u0xwLwoVNTk1f8khKeabteteaXEUinF95PpvxN7/aAXKx7MW6EbbjsZhV0uJ3C9lL6c/frjyV8mHB52vGzBVjrnS0LWRC80+Y0QEF0ZFPfDY+EN22CohulJ0Q69z49FRFyUFIkBsVUvMYpuIZxbC3hqh26CNhj3zK84TuBOeO8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024939; c=relaxed/simple;
	bh=J5EMf42bcDLPRf+d16bil5z92Lns6Nw7GbzLFgnHnyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rb5ljZC7hOVNvKOGq9XwnAu2XB38WtKha237LYXM2kJDigOMPclt1RQc9iWqAG4yPqN9vqBPm5mJVA3CNvVpCeFUaPUpJKbFgOAdSuwyJXrYis/3YCshyemUrJ93KdogZDGMz0evbi22wgJnv6rD3yllR8770fACH/g5b01RSHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEup1rLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEup1rLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4174C4CECE;
	Thu, 12 Dec 2024 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024939;
	bh=J5EMf42bcDLPRf+d16bil5z92Lns6Nw7GbzLFgnHnyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEup1rLOnLi8FSj37pTKqC69hH1CMku23WPFPf+EMEm3lHcRnxyaEu6bpBRLW+J7i
	 CvBz0e3K9eCuo1lBAKrEwgGXZ8BSEU/bB50ibHUHGspMEuolEhj6fRreTo6ODcYIr0
	 Gs0kN3PLedYtVGwdGTP/HEJxbuyFn/TaAgr9EG9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 447/459] jffs2: Fix rtime decompressor
Date: Thu, 12 Dec 2024 16:03:05 +0100
Message-ID: <20241212144311.429288088@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


