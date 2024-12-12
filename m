Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E137021421C;
	Thu, 12 Dec 2024 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025869; cv=none; b=G/pG/aK9mjqLvNzoLgeFpOFzOuiwijLmf9jq+6FRXaVb9YEEKDwsMh4q9lGOl5F/TWnB9iyhZ8pXz9weD4e7PJL24gDy4X63c/4Rcaf6+JD3EG7hgWwmyK2tHnyb3TLa7teQ49qQnnl/EKrQ2oxuFsNBndWhWTlVAJ7Y1rVy+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025869; c=relaxed/simple;
	bh=YYvAVRVOaF/MYFAjKNoXDMMuj6RaFmcPz5sJcquS0DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIlatlT6NVcHokvDSgt3p5nIvfTqyvcN78jNt2qQrkVWkBIvwRfvrH/TdR/lVSFKQA4DrcgQuG/q/Ns72wogNZ4OlE+DcS86X5rxS6Rbn2UjB+ceZos3zI6Jp/cDG77ghHPvcDLRKYucAHq5d01vSxTLCOKSAOW+MglmVu9iCR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrUoVerA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrUoVerA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B728C4CECE;
	Thu, 12 Dec 2024 17:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025868;
	bh=YYvAVRVOaF/MYFAjKNoXDMMuj6RaFmcPz5sJcquS0DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrUoVerAzMpfrEz2sd/wT/TwC0wf83xCKZepOEPRe7m5YcY4K98CFKTkdaCuJJfzy
	 vpblyUoikKMqrRiQi7ltPGyiAKrBUhnduuHfPEpp1oDzYgNPOvh65e/UsT0okpKhpp
	 6HUeNfdVhnPRG5VMSj7/iSQWFOsBxHw7QuyBYu9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 315/321] jffs2: Fix rtime decompressor
Date: Thu, 12 Dec 2024 16:03:53 +0100
Message-ID: <20241212144242.427013195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


