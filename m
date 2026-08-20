Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11DB37A858;
	Thu, 20 Aug 2026 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244272; cv=none; b=iZKYcO0nDLnOGu2Ct7ef1pKeR4Kh87YLFv+bm28dAxUt7UsStPrWZg6rBXy3hlyUiIu8PojDBQVcHX4vkrMUkpR9saH/9lxlE9I8SvU2wlZRJAulysVTx9Emx1tgQmLNaPPDHDu/0HXN1mS+ZkqR1SunEmtkzE+XqWxjq5lqGnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244272; c=relaxed/simple;
	bh=XJ87KLZDRegC2cIPl9p1MMKK/GqFibDYprRfYa6aJCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhEWK5WIFpWTy2XBAKfma6vVriX4mpv/2CEdlmGa67Dgd5eVnLNzALQYOKZLCQBSS9meRy27x0+nCLAqQYrfHEJGhflH5t0Yarhhxj/d5csfexaHAZs8cnL4ijJkZXD5V/VifK/IG2O5X6aVID4NySkGjBsEhC94eKShyWmJ51k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnpiREuQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnpiREuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44571F000E9;
	Thu, 20 Aug 2026 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244271;
	bh=0GA0VqXhdcgg99tWHujnQObDT934uu5gd6rhoe2WMi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DnpiREuQ6AkMpEqYHKXcyMm+iTPjH27YEbCErVGAx8yV6JNZ5dz63GgGUsRIEPPsO
	 I83p7KIUNJ5K4i3gG98TIAWSwioUAx8uxBddBeFhLL+O/Z4Q05GkhfD2Szg5TnjDW/
	 9k5r7baUAg+mj7KEN9EO6oHcmEn9XveaZSENa94g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/235] dm-integrity: dont increment hash_offset twice
Date: Thu, 20 Aug 2026 16:55:48 +0200
Message-ID: <20260820145219.848111574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit edf025f083854f80032b73a1aad69a3c90db236f ]

hash_offset is already incremented in the loop "for (i = 0; i < to_copy;
i++, ts--)". Do not increment it again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 84597a44a9d8 ("dm-integrity: dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1377,10 +1377,6 @@ thorough_test:
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size))) {
-			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-		}
-
 		total_size -= to_copy;
 	} while (unlikely(total_size));
 


