Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA79A223708;
	Tue, 21 Jul 2026 17:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654834; cv=none; b=fQN2leaUDJ+8p7FN4S0cmq4Yjn+tP70E2RUxBMt7H/swp2fRBYwWtUTUHDtRDanCI2gIdNzV2TbAEi/7uboLRQCgjKebrZsWXnfuiCejcFMW6eqrxfMG9bAWvnVxW8heo64lC3nSTmPwX5KQrZOje7EZAF69BFcEyUJOOIZKJCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654834; c=relaxed/simple;
	bh=BzGBAXM4bfvRLZ0igW746pTKxP6WHEJLcUJsPx2WhDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU2h92sqH7pSI9SZGHQIyIHDlZ2Yil1r846rfzcVC6XTtvQjr0od+Ck2/zdqkXl19M7HVpeH4/FyjmaLKYjh/3iSRPKOBYMT6CFOozwJf53Y9MslPWpINsB4q2U+z/vDrFAxRrR/HroaBTxsB8YE4U/MUSqyq2r1y2XHbvaVNRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORiC3QEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORiC3QEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1691F000E9;
	Tue, 21 Jul 2026 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654833;
	bh=0kSV6xu6ACaA+MTiZXwESmCT+LDopXDhw0R3Mn7fLIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORiC3QEwqhEk5zwBkTym3Rm1FeR7ctHRPw5c4XWsprdY64C0r18OhiodEJp/RMQ67
	 wue2kRfwYBFzZehUvR4lrZ6diM/ulXAQS4fzO4TXy2AJ615NdVv6IcXD/BwzNDeAm+
	 vgM0veePmh9JwfSzYb0V3YygLyLJ74+8kOYPwXcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1856/2077] dm-integrity: dont increment hash_offset twice
Date: Tue, 21 Jul 2026 17:25:29 +0200
Message-ID: <20260721152636.511239896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit edf025f083854f80032b73a1aad69a3c90db236f upstream.

hash_offset is already incremented in the loop "for (i = 0; i < to_copy;
i++, ts--)". Do not increment it again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 84597a44a9d8 ("dm-integrity: dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1480,9 +1480,6 @@ thorough_test:
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size)))
-			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-
 		total_size -= to_copy;
 	} while (unlikely(total_size));
 


