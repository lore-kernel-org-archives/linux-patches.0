Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBCC349B1E;
	Fri, 21 Nov 2025 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733138; cv=none; b=ZYhBoUssgvKmBP6me3FeT8KAIuTcl+CLDlBauzMt80Pl9HAmyfJEDJJyVHlMaaDhesc+XzdnVCN0oN+sGSfqHAOTvIFkgbrinYU1Y6G/mNobkX85MeeqyDi/OmcfyFqsB/iRCC9HGNuINWLQk+9m8n3szfi/sEOiFl9mQvhiaS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733138; c=relaxed/simple;
	bh=v3OQCgnAS8f2ZCNQDgW/N3rWOpZ1mfQziZidChXt3is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgKmm8ErlaGqtxigDV/xKN3iNrLkj4gsVp9UgH/DwPEh6oYK0nj4hDqZ/ifG6izruAKRwDGpVUZQUQvLdBWvsKMiU+a3RBdG0XmoZJDL07HxhVlktq+MmqZZD6nQo+e7wXlhgvnfMUD89Qh0dRS9wO1dXyU/TgFmQf9SvmB16h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZl2HfXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZl2HfXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E171C4CEF1;
	Fri, 21 Nov 2025 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733137;
	bh=v3OQCgnAS8f2ZCNQDgW/N3rWOpZ1mfQziZidChXt3is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZl2HfXgC1To9mmPRkidAcKpWI83qoPk84fvzD2imKdRAzgfE+wzgOKcU7lyXjroF
	 IlOu6HoFzXQYWBTS8OxZF/KUQlkqgquTv7nQxx8cwbeKQzn0rR1qjJ1db6ql6DDePw
	 8vdpmqnajijmsxNJpxLuNkSz6D2J0P0tQPZzj8is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuta Hayama <hayama@lineo.co.jp>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 365/529] rtc: rx8025: fix incorrect register reference
Date: Fri, 21 Nov 2025 14:11:04 +0100
Message-ID: <20251121130244.015970319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yuta Hayama <hayama@lineo.co.jp>

commit 162f24cbb0f6ec596e7e9f3e91610d79dc805229 upstream.

This code is intended to operate on the CTRL1 register, but ctrl[1] is
actually CTRL2. Correctly, ctrl[0] is CTRL1.

Signed-off-by: Yuta Hayama <hayama@lineo.co.jp>
Fixes: 71af91565052 ("rtc: rx8025: fix 12/24 hour mode detection on RX-8035")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/eae5f479-5d28-4a37-859d-d54794e7628c@lineo.co.jp
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-rx8025.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -316,7 +316,7 @@ static int rx8025_init_client(struct i2c
 			return hour_reg;
 		rx8025->is_24 = (hour_reg & RX8035_BIT_HOUR_1224);
 	} else {
-		rx8025->is_24 = (ctrl[1] & RX8025_BIT_CTRL1_1224);
+		rx8025->is_24 = (ctrl[0] & RX8025_BIT_CTRL1_1224);
 	}
 out:
 	return err;


