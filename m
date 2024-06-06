Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C901A38C5;
	Thu,  6 Jun 2024 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683224; cv=none; b=nvj7Ota05LlXcvy62ptS+v4yJDQx3t1UwUtZZp7K6CBcAwS5osMrbNmlb1rWig0skUlD+v1iyBKOenXaXm67r5QnDliF5OTZfuJNzPyIGVoX5I6gKwPTPah3osZF+tnUdhEQG9C775LA6siEIoAwAH9rXgdyyXlHY6gWIFKkFwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683224; c=relaxed/simple;
	bh=2G1gk/MyJjIQyuwB/e1w5tME9dnY97hlgx6871IfKpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nvb0CTOKaD1SPdFWMDUqhswOoyXZ31VNbkDIKh8zk3CLw8o31lI9jjl+xDVkhEcVs0vO+BuQVI8vM4oUSDGtn1/Rt+o3pZlkLJzacMT3Ul3AQBjTY491zUG3RR9b6d0zd657yIRz0XsCR/Z/ezZzsgsPMy3s1EtnSSYaiDn0BFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdahlBtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdahlBtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB5BC32782;
	Thu,  6 Jun 2024 14:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683223;
	bh=2G1gk/MyJjIQyuwB/e1w5tME9dnY97hlgx6871IfKpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdahlBtm5eqGwqXGdegMTbo0+k+21sJkdVB7yhLQD9WcY0cBAwVIclWeaucCa/E+Z
	 OzpOMBYLMRBANhx4lig+9np/vs+MeDLBZxcer66lWaGeEmLV9K9KORE3JRoZeoG9Le
	 ip+nOcKyMpBnZAZaIXTml+k5CDQAazM+dnOt1lX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/473] bitops: add missing prototype check
Date: Thu,  6 Jun 2024 16:00:29 +0200
Message-ID: <20240606131703.203735435@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



