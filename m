Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52D219ABC6;
	Thu, 17 Apr 2025 18:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915736; cv=none; b=pbSP984S80NpnzNl9Cpd8RvvpEy65W3f8UADkkKK8dt27ipA3bwxkMK0unc/4HRKLuQV1z450+ncU8Y9k0OxbniCfeEEs1KTXxs3R0H4472NnZ1tFnaeFV/N7bbFnjmtRhPZ01OqKeNEpnjsqYay7Jwtyo4JbGQJDavSI9AwvLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915736; c=relaxed/simple;
	bh=gWn4mnb+1f/BQ2QT/0IY8obW+SUroLcCqz3bCOqRNZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RZsEq13WJO+1ro6G4PwisnrOcTqIcwFd5OuMS3/o2/tJZMPd1U8+bOKBb+CreON/LjsqpxjgWv4z9I1VpTZtUTAT20uDPCMbT1/sZG7qBu/pmZjZa6h8BUKJlNPE8cfj8rOyh/hK47kYD/w9AR591ohT9SNEeDjLxsvk8EVQok0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNAK3lMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNAK3lMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE29C4CEE4;
	Thu, 17 Apr 2025 18:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915736;
	bh=gWn4mnb+1f/BQ2QT/0IY8obW+SUroLcCqz3bCOqRNZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNAK3lMaNukyJhKSUJMg3HoKEXjsMKAcqh8iliDqK3ty4XbcXKSAVx0ewsss1elj9
	 E1TxHGtovnK6bcy3RpKKUqz/a4RMoeqqclW/izJKzEcbmt3gU9rN9qtdjdDFO8W49K
	 RPpbqy2RCdPgX/MgFO434kOUeXnMdjmWIUhgtiXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 193/393] media: i2c: adv748x: Fix test pattern selection mask
Date: Thu, 17 Apr 2025 19:50:02 +0200
Message-ID: <20250417175115.351985890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


