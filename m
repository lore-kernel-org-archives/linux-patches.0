Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC99626B2A4;
	Tue,  8 Apr 2025 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111760; cv=none; b=YIrF55nnQO4myMzUdS17AiaPgjkB8OKhhos9YQLf6FhCRmJmHhp+NbarVQ9MW+E/wRiv/FCeTLPBhULUFhjBPEqSFJHxtnkFCciq3jznPBCpaj2M2Wj7kmsYACLRdkV2lA+lEKp9/YYA5AyVWw1HergxL/9y7JXo1rdhfzI76jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111760; c=relaxed/simple;
	bh=SpR5KjNIQpFm1wAwhCXsWAEkZi/3lYJJPeYOCBU2OXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dk/Uv0eMEYT2Rl9aZ8kEYR6G3zlPI1eQ6K8mIORDQMjr689qiJnF68fQYNBqoy8RNwx/pO3SNqvRx4E11qoLpPMzlpug6Dp+F91M0yRRMk6pFias22eUn6/NtpdKvziUhw/IW/L592xipQhp4ru3J4ZqdkBVqHjzrQQcxzgMW9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDT6ttN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDT6ttN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0762EC4CEE5;
	Tue,  8 Apr 2025 11:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111759;
	bh=SpR5KjNIQpFm1wAwhCXsWAEkZi/3lYJJPeYOCBU2OXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDT6ttN5WS8flrOfYEQgKlqOFTGbEb69/3h0uKDlfs6cZNu11L9d4627dFageYEfS
	 CEQB6r23bBn67L92V6LDCasVi1czXbCZJ+mVA9dVcLvsYujw5rUWAaqHAWVPNKVhj8
	 OsBWygcArSD6QwcKx89Gi/QXbSZx3MVjdsbJmQQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xueqin Luo <luoxueqin@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 547/731] thermal: core: Remove duplicate struct declaration
Date: Tue,  8 Apr 2025 12:47:24 +0200
Message-ID: <20250408104926.999961566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 9e6ec8cf64e2973f0ec74f09023988cabd218426 ]

The struct thermal_zone_device is already declared on line 32, so the
duplicate declaration has been removed.

Fixes: b1ae92dcfa8e ("thermal: core: Make struct thermal_zone_device definition internal")
Signed-off-by: xueqin Luo <luoxueqin@kylinos.cn>
Link: https://lore.kernel.org/r/20250206081436.51785-1-luoxueqin@kylinos.cn
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/thermal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 69f9bedd0ee88..0b5ed68210807 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -86,8 +86,6 @@ struct thermal_trip {
 #define THERMAL_TRIP_PRIV_TO_INT(_val_)	(uintptr_t)(_val_)
 #define THERMAL_INT_TO_TRIP_PRIV(_val_)	(void *)(uintptr_t)(_val_)
 
-struct thermal_zone_device;
-
 struct cooling_spec {
 	unsigned long upper;	/* Highest cooling state  */
 	unsigned long lower;	/* Lowest cooling state  */
-- 
2.39.5



