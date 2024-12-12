Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E6A2153F4;
	Thu, 12 Dec 2024 15:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017396; cv=none; b=u3bRtAbEO1gDJUFXv/ZSEVh2ZxeEi2F952qRYcKPQDI/up9nJDxGUBRDwa+bwf4iqX+0NhyX/twcBBsPuW8553gn4eFqIPj08PZ0uB0NsnM5h3u4Vc4UPur6nBUC1J+lGiUVFiPNQnzWb/OtrIw2JBzYX06RW70K7lQvn+C0OBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017396; c=relaxed/simple;
	bh=L4H/NjPSiAFvPj9RaW65+gjaGKp/qEaXgpmsuBf+csU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je7e7WPGmQXYhDFyWOcSM2TqjRXdQskZSZn/h2xqIeb8L8l2EbzibhGiIc0RbFNSMKK4duTglkN/NWKm4XrdsYuDUwLeeSs0GoXSbL561R8YpELtcRVl+0GThIGIgy3ixi9GnzCbKMLWHgpCHx6p4EQkXYGnwZ1Ft/QfT+Xwycg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE0CkUV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE0CkUV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD71C4CECE;
	Thu, 12 Dec 2024 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017396;
	bh=L4H/NjPSiAFvPj9RaW65+gjaGKp/qEaXgpmsuBf+csU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PE0CkUV5UhXoizqMumonpRNzseC8G/Y4yJcrBMi2Mmzv2Y1M5PSTyE+qr21pV2IEx
	 VMwhhwolhmZDb8md5Xfi6bkt4ZJVS7dhN9W9ebdfSCRu0JGEVK97UGBISatNPLIxue
	 PT5okEBJZhgVgL6kqpDDZ4+2zeLSAsQZ3ekPUSI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.12 456/466] jffs2: Fix rtime decompressor
Date: Thu, 12 Dec 2024 16:00:25 +0100
Message-ID: <20241212144324.884620812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


