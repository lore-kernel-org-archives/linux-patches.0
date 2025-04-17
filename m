Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71C725335D;
	Thu, 17 Apr 2025 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914396; cv=none; b=mHSxjEZoQS3l3g5Qvz1cCpLSoXm0F9GcAaDOxBIIDL3Wi0ya+U/GnJUPCx8i6LWa5TLoLqqjLBS8wgCdpFnoz71Ww8Ijwo/pVkiYtx+5z0A+7S9/4aC5IaWqlxYhEwf7az2v4YFfg3l/IOVpUQdl0xeUiRA9NZgQS4To4Vr4cPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914396; c=relaxed/simple;
	bh=Z5DZ5NwE2OBLxKOYB9VZLqz04vCbXHCl/7Cyg6Qbml0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5Yn0d5qzw2/3RAg4kKbNTQEO1Ymxs8Os/O6aZmUQEe0PbQt/DEcZY8dxRwGXm0lYGLlVZOFEAwQUxX6CArzv/SEmv0NkLVG4OMgCSTVpWTTCT9RhsZqxnr9+hlc9OX59jCn6MMSC3LPlb6x/G2mAKUD4DJWCqCKphMIAHJd8GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEaZmYSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEaZmYSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6118C4CEE4;
	Thu, 17 Apr 2025 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914396;
	bh=Z5DZ5NwE2OBLxKOYB9VZLqz04vCbXHCl/7Cyg6Qbml0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEaZmYSZT9TskZiaxjAY5Rv1V/26MpvsmnOa33/J1LW8RBajbrZpQuwNcHAfRBUh5
	 2ynXoWrlL73ufwJ+tlnpWunGBwcZUou4yyi9icHK6AQNrSEBLmeW6NHEeJB3aBtlcE
	 DG1DOyMTH2fzWhVFWDAX45c/ne/sBfeUEbc4LKqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 201/414] media: i2c: adv748x: Fix test pattern selection mask
Date: Thu, 17 Apr 2025 19:49:19 +0200
Message-ID: <20250417175119.527837420@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

commit 9e38acacb9d809b97a0bdc5c76e725355a47158a upstream.

The mask to select the test-pattern in register ADV748X_SDP_FRP is
incorrect, it's the lower 3 bits which controls the pattern. The
GENMASK() macro is used incorrectly and the generated mask is 0x0e
instead of 0x07.

The result is that not all test patterns are selectable, and that in
some cases the wrong test pattern is activated. Fix this by correcting
the GENMASK().

Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: fixed tiny typo in commit log: my -> by]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/adv748x/adv748x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -320,7 +320,7 @@ struct adv748x_state {
 
 /* Free run pattern select */
 #define ADV748X_SDP_FRP			0x14
-#define ADV748X_SDP_FRP_MASK		GENMASK(3, 1)
+#define ADV748X_SDP_FRP_MASK		GENMASK(2, 0)
 
 /* Saturation */
 #define ADV748X_SDP_SD_SAT_U		0xe3	/* user_map_rw_reg_e3 */


