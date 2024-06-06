Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DF819924D;
	Thu,  6 Jun 2024 14:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683201; cv=none; b=Kr7oHCg0Ej8VMLQMuYEdVq2OzjzfofaXH4JmHXhqIN9CscnTdaW1GsAZR6rCWZYzE2iuFiQVhFbdfHjYoBYRVKp6wae73CMOxYJNoCTe69RdskbtpQbwxB5IIQMYXuwzf2C4vRPhZWNBFWzo96Hna+1chKXU5qkjyq4Q+1Wf2+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683201; c=relaxed/simple;
	bh=zH85zuDH5LNpPEaPZJ+HsIya76zeBWHRH1aThRwp0lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzBWIr/KTY5ibrinMPee6BpyLwrdWEaJID/ofBWcp116gMeY2nRCQb+vN8VJjTLBrXABezXZkdDX4yirt8ftxNkGKu9uskqWPL3Sv+M/j/cGgIX+bSOz87024iFb2EDZTYlGsSQM1Te6IVAwU/iTf6pa27DhBulEdykZYE9EFAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZK3INU6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZK3INU6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CA1C32781;
	Thu,  6 Jun 2024 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683200;
	bh=zH85zuDH5LNpPEaPZJ+HsIya76zeBWHRH1aThRwp0lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZK3INU6jMz3G6RbGaA+q38epBOGX89FmAbnpuIaoLwLxcUBNjS/G22mpX8g+D1RVV
	 SXtDkheNJVACFIneAjsLdO8ghl2TTwOTd3B40nAT8J71iHiTebykq6gtpzWMphZvqR
	 1EC6veG8cvpvRRWrjcEz1gdLXIGDkLp8csAZDiD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/744] bitops: add missing prototype check
Date: Thu,  6 Jun 2024 15:56:56 +0200
Message-ID: <20240606131737.036579301@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 72cc1980a0ef3ccad0d539e7dace63d0d7d432a4 ]

Commit 8238b4579866 ("wait_on_bit: add an acquire memory barrier") added
a new bitop, test_bit_acquire(), with proper wrapping in order to try to
optimize it at compile-time, but missed the list of bitops used for
checking their prototypes a bit below.
The functions added have consistent prototypes, so that no more changes
are required and no functional changes take place.

Fixes: 8238b4579866 ("wait_on_bit: add an acquire memory barrier")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitops.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 2ba557e067fe6..f7f5a783da2aa 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -80,6 +80,7 @@ __check_bitop_pr(__test_and_set_bit);
 __check_bitop_pr(__test_and_clear_bit);
 __check_bitop_pr(__test_and_change_bit);
 __check_bitop_pr(test_bit);
+__check_bitop_pr(test_bit_acquire);
 
 #undef __check_bitop_pr
 
-- 
2.43.0



