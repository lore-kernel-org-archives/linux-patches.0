Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1412B3932E5
	for <patches@lists.linux.dev>; Thu,  3 Sep 2026 08:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788422981; cv=none; b=OoX1dOZ5LBDaqZGsthfxPnRRC0FZJuHN3+CAfujy/FFNV/AL4LLOfY5XsHq+lfPlBOA//pAcH92VI8p7MhPeQSCllB07fMJ9OfPddvtboP2uEkNJykyXKM9xdo4Tn8NPj5Bplb8I/5G3crlFuRueXjmvlirtUXa2DTJvb+TMdI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788422981; c=relaxed/simple;
	bh=wddQWovUxe2uKJyvwdvKzdgZhQJpx+9myOGJmM3ZFx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfmLmRSUhqvAJ4sacbJ0inDPgp1mBhLhqFHnTG7MxwaCPzvOjXzNiM6p2udiBDbCh6xMwoYjwkM10aVLTcandIJqrBat9unHOmciUPcLCRlnu8/xpGRlgUNOqWgBGujfrON2nPxTRwZ0e53v0S7ce502UOht6swTJpt1Y+UuYJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UDWW6EOW; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UDWW6EOW"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc1c73645a1so1669104a12.1
        for <patches@lists.linux.dev>; Thu, 03 Sep 2026 01:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788422979; x=1789027779; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wddQWovUxe2uKJyvwdvKzdgZhQJpx+9myOGJmM3ZFx4=;
        b=UDWW6EOW2j5Hl/ifsk5ZoEmBTSJpYOmG2Qt+nu467sXeEvINAr+7Vdw2VctIMjjJYP
         me4nZJA4/ebcBoZ6weZlXfn1ygqBX43N8ptB9y1Z5OKxKalYuzL55r+fbyttfNpgPbj2
         LUlCl5d7bjPDrAIvUTGo2/J/1QaG68s+AGGZ23Zx4N1ALSvhpWKbRHh6yp+GYkyrI1o3
         5hNyV6PUo3Eyc3AZXZfpOpcdyfi5ni0IvjDDHyl4+bulHnnDbIsejd8ZIS6lVdpW256x
         Pavfp1RQhicD8HJsWzyQAHujmBajkZqaNoXfuwCZIsMyX1Qg2xmEKCuQuqsqdpQ20iVY
         Jitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788422979; x=1789027779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wddQWovUxe2uKJyvwdvKzdgZhQJpx+9myOGJmM3ZFx4=;
        b=pQBtMg127YVlfkI8zDwe/oegO0amiD93v/p1eYqWsQ5xtLVsDV1Nn1KIbWilY0U0CL
         QaN7TrC7X72P3mZbKKwOfLMol1d4nFP+bpv3KcM/EaAPevTyEaSmGI3wphvXJev0p7eI
         mAtKH3ib8/+w4YIY7LTA/AgZKEb+PJnAkTCo5pYwHYwKpr+/AmMmmj+4Gi3m0E9yKA/g
         urifRlh8D3324+l2gb/pa0zF/MZNVUmSZUBTmFrgGvg8to4Id/2LzPq0gefblNlRv9pP
         rFiTsxUFoMmVdGGjuty+deQfDyaVrepcva7OLFqZl8yKwElFFNCNzoYiuXsxclBLCx/Y
         iyQQ==
X-Forwarded-Encrypted: i=1; AKwUvBybci3w7Oj9UGimDJOE61uaklaEKwwWEzHpwZivHdftUkLA98xlGZZFlQnNWlofrhBoeumjg1gA@lists.linux.dev
X-Gm-Message-State: AFuF++m5vvjUuG6p4ugcIxf9X22F/8PUEXKDg3QJrxrSyGfTuNXcd81m
	j4GQC125f6JKletm4UCP0QhDO+rj9wueR6WCMi//u6N4DYUsfS8TgwCM
X-Gm-Gg: AYBFou15HG66C85ggSXu1Iq9Ah0ph8IvGcjkn0apU0VtF3YDKbvLBeFX+zqjut+skts
	R5AIFM1qE1CqkJK8xD73Ub6pB8bVuzdVB0luEItj5FcomPNbXz4zNAXBBMLTvjvdIycN3k2INuv
	qlhAB6JKaiF2E86mH1jvfZNgvL2NrXxvbESPZsFNi6ZxU/Ho3kC7ZooJ+gWokm29t/y3RJyjjHL
	pty7dWDwmWiJ46tcAxuwt8W+ezvBGvFrDGsjZv1LSB5n3qIHtY1fBYLU6zVx0Prqkw2JTQ/wqkw
	kjPn/KR/yBVUfupdiwQihBLBv8x1hvULKROBrGdzmQgSTAeqQ08e0ricD04J2z6e+lspSXQDJ/l
	3axSGjw6qrLtnTyhxGrG72RgrdwDeQaxk+VtN6BtaPomEWmuOjepT7mLObWnoNrWq/7fkQOYGv3
	3/rgextrtJzlUErJKvR04cgJtN5+ANhhNeMl4hBikXzOgxIHHPdHM4zN/+aY90vt8U+SF9F/RxU
	kTqsDUq7407aG0KVVuD4vtamuIj6r+WpgbBptbEAcsdOPvbGA==
X-Received: by 2002:a17:90b:3f84:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39aedf1922dmr16176799a91.6.1788422979169;
        Thu, 03 Sep 2026 01:09:39 -0700 (PDT)
Received: from WR5220G5-Peking-BMC.labs.lenovo.com ([103.244.59.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b087b59a0sm4004345a91.17.2026.09.03.01.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 01:09:38 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.12] wifi: cfg80211: reject duplicate wiphy cipher suite entries
Date: Thu,  3 Sep 2026 16:09:32 +0800
Message-ID: <20260903080932.92286-1-xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831133314.4125787-367-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org> <20260831133314.4125787-367-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 31, 2026 at 09:26:35AM -0400, Sasha Levin wrote:
> [PATCH AUTOSEL 6.18-6.12] wifi: cfg80211: reject duplicate wiphy cipher suite entries

ACK for 6.18.y and 6.12.y.

I'm the author of the upstream commit. This AUTOSEL backport matches
7187d145d904, which has been in mainline since v7.2-rc1.

The change is a small wiphy_register() sanity check: reject duplicate
cipher suite entries, and reject n_cipher_suites > 0 with a NULL
cipher_suites pointer. Duplicate WEP entries can overflow the fixed
iw_range::encoding_size array in cfg80211_wext_giwrange(). In-tree
drivers already advertise unique cipher lists, so this should not
affect legitimate hardware.

Johannes preferred this over adding a bounds check in the WEXT compat
path, which is why the fix lives in core.c rather than wext-compat.c.

Acked-by: Yuqi Xu <xuyuqiabc@gmail.com>
