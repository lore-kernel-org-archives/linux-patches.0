Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB521487CD;
	Thu, 12 Dec 2024 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021590; cv=none; b=IN9xuCqpx3h556Fh6nJp6Mm9KbUC6alckEXm4xbJUJf7HiRTtTBe6lK+S2a2GVwq6v/t0coW5wLZdmWKAfxB5IGrl+tFhFJPa9YzFdwLntljKNPY8XoIMeA5tGAEM4YOocGOqkDL7YiyKCUmAE30GkS2FE5x3B7ofo+ZIGPx10A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021590; c=relaxed/simple;
	bh=xaSKFI/87jME0pzLwWkKhPDOav535gglkASX8X0096E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVwWrbwJAYlbfUkdHlUV84EQm+hYwIalUq4BZh7lE4WppOGOTjEua77NWX1uS9qouKsKZGhUEt6GRYRojy9ITa9c5stqzvtbxcTcNI5Ft2L1PtvZarIh4+Cm/9NK6EiYZTm2hCB/qyEP4cRjvrrv4L/WV6yihmE5YcVjsjdK6pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6yGilc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6yGilc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E7DC4CECE;
	Thu, 12 Dec 2024 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021590;
	bh=xaSKFI/87jME0pzLwWkKhPDOav535gglkASX8X0096E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6yGilc3EpYaUWpffSxH2vrdYdWuOFgFXXABDi5Cgtkklhr088tJCPs1A8RnAfMK+
	 OLL+dZl7ddREMs29I5kEA1VX6p64v0vYimQl7h20nCmMmFPURc6vcWHZlCuwx80KLD
	 IhS7z7gApmEuMTHIScCUxkxIkgq2/0KlDWzyn1dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.1 744/772] jffs2: Fix rtime decompressor
Date: Thu, 12 Dec 2024 16:01:29 +0100
Message-ID: <20241212144420.675280418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


