Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749B31DF756;
	Thu, 17 Apr 2025 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913328; cv=none; b=sWysvJI4ZiatEoCbMms2BjfX1RSn5ko3RQnQXszNth5bMpm+BdFluFTckTXoYIcIVh2dK+9JnfbPHiBNBNbEmrY0z9LsfDMRamcHD86Wm0w3Sshnmzelk5DRcV/7wDvYZJLDfM340CTxVk+jtuO0effctb50suN7gCtdZO8BQRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913328; c=relaxed/simple;
	bh=yR4NC6rj2TJa72CQSyeHSYXKNF7tQRL83kAsUbLCbUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MymHTuG6uoK4e1gn8QCcpnU6Difx9aaobmqSW3BFNy7xZEBCtExZyI8/mZJtx7FRgFjwW+fDN2JzhO2zv3QyEbRG8hhmn2/+vWCfum1jwRX47ZevkWMt0fSssgs0OAGJiXHK/YY+XduDWaHK+piB15X+y7Hc826cPlBqmjiJwEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zN2UlzP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zN2UlzP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077B9C4CEE4;
	Thu, 17 Apr 2025 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913328;
	bh=yR4NC6rj2TJa72CQSyeHSYXKNF7tQRL83kAsUbLCbUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zN2UlzP5V8RobqTeE1gBG4KQAgYmtuFq1XQo0wsRbbnTZvPjBdsvhaND1JrsbhZlj
	 V+9zYL/Mp9om4LrOCBS+ifXi0wrKm8ZF+EvQYTrU9AiAheyyEt3cd93hTl8M8FwZL0
	 dfNP3P143/afRLnYRts9TFo+G8+crnsgcSRRx5pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Binderman <dcb314@hotmail.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 6.14 303/449] arm/crc-t10dif: fix use of out-of-scope array in crc_t10dif_arch()
Date: Thu, 17 Apr 2025 19:49:51 +0200
Message-ID: <20250417175130.296298308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 3371f569223c4e8d36edbb0ba789ee5f5cb7316f upstream.

Fix a silly bug where an array was used outside of its scope.

Fixes: 1684e8293605 ("arm/crc-t10dif: expose CRC-T10DIF function through lib")
Cc: stable@vger.kernel.org
Reported-by: David Binderman <dcb314@hotmail.com>
Closes: https://lore.kernel.org/r/AS8PR02MB102170568EAE7FFDF93C8D1ED9CA62@AS8PR02MB10217.eurprd02.prod.outlook.com
Link: https://lore.kernel.org/r/20250326200812.125574-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/lib/crc-t10dif-glue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/lib/crc-t10dif-glue.c b/arch/arm/lib/crc-t10dif-glue.c
index f3584ba70e57..6efad3d78284 100644
--- a/arch/arm/lib/crc-t10dif-glue.c
+++ b/arch/arm/lib/crc-t10dif-glue.c
@@ -44,9 +44,7 @@ u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 			crc_t10dif_pmull8(crc, data, length, buf);
 			kernel_neon_end();
 
-			crc = 0;
-			data = buf;
-			length = sizeof(buf);
+			return crc_t10dif_generic(0, buf, sizeof(buf));
 		}
 	}
 	return crc_t10dif_generic(crc, data, length);
-- 
2.49.0



