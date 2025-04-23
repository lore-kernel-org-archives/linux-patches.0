Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB58E269B07;
	Wed, 23 Apr 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420756; cv=none; b=hURvx4vcL/GUhcc75TLdQS7F9cwytFKaP+dB9Y4jA2pxb1SSFdGUuO2ZCJelnJyWi6qDbVV3VJ0LW662o4aIaoEpTW4RAVC9tSt4MjUMwY987Knv4NThkT6Rlub8TpOaaonsKKFaGFhP8ybLWBsO2Gr8xCBFU+0TAI/QcU5SdZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420756; c=relaxed/simple;
	bh=tEzl66fiS2bFum9+7+E1V2gtBsPISk988CsvpQWo44A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=An4fk9CM9Al5AU34ogBaF0eFKK9B9a3ajGxlL35iSRfMDt91RcWNrykIiClhO9V2EsL3zsmRquZpibZmeHKI/GmLzDTFcHUOMFhY1IXpTT1Nf4bK45sLIWLpxMTm5fpZ5N7JtpvmWQq5zicagq/eVyhXL743YdAZfc91JCbzYp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1021qgck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1021qgck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E042C4CEE2;
	Wed, 23 Apr 2025 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420756;
	bh=tEzl66fiS2bFum9+7+E1V2gtBsPISk988CsvpQWo44A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1021qgckIX73Ge2jFKwoDlYdKJCHFnWDiLiqHRvOpahqH/HZE0paJryxnpuzOHUwe
	 1co50hw6uRmNynpoea5QU1H6AYVDayL95sztfzlwRX+wbWOBLCGUfqcWXZBMyjEZ9e
	 f6e7Q9Xa07faD7ZRJOogrwnMXEYbInf6eivOrszE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 078/291] media: i2c: adv748x: Fix test pattern selection mask
Date: Wed, 23 Apr 2025 16:41:07 +0200
Message-ID: <20250423142627.556504180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -322,7 +322,7 @@ struct adv748x_state {
 
 /* Free run pattern select */
 #define ADV748X_SDP_FRP			0x14
-#define ADV748X_SDP_FRP_MASK		GENMASK(3, 1)
+#define ADV748X_SDP_FRP_MASK		GENMASK(2, 0)
 
 /* Saturation */
 #define ADV748X_SDP_SD_SAT_U		0xe3	/* user_map_rw_reg_e3 */


