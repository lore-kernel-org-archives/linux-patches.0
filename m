Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062018;
	b=JaQ9nZ70G7V6ALwiZV/9Unu1YmQU+lqwIfCY0sTx0Z4y/2c84sZB1mLso1owTunNUBpg
	 BxghYOgEqW3JB3Q7qEIICWudjKT4Kit75La8LWYlwcJYhokjqiZG09ydKhFY9GhtFIPRv
	 2ZFt0xNtCFvkW13jGAmhKT0cc+id1D7vJREJxJ8tUGwCt7GwG/8PsmrXe109yZKxBW9rM
	 X3DfaaRrwp3fuOtsr/cffxk3wbA3zl4pZFj4Y+MANIxoVwZ5uyHM1I5LSeXJDlkf2VpsY
	 YXI4JFa6sMzld8/nDk6k7OUaVEJneWt/O0pWrSUJlwb+Pjg8ZAKi3Bv//FL94prQR8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1J34ZVGouZf4TN2zxxXpMkAsyJ3b3xKKc6dd+U/jvlE=;
	b=wWDNlPpq0fqgBQAipzmnIArWbzojC8bMRgwTMl/aiGonj/ja9cuF5CQce7mpaD+OM5xM
	 29uTXZ70d9kGQDd/8tNUBgBkjrGrH5jrK9dB3EwTHInlTcgnrscqMyjY3YwYFxQlkundx
	 EGhpIc16w2NyMWMf+u5Ud/mwSNW3hfOiDmeU09H1cjcelIrfwAIRD9bK627BJ3QgllmRm
	 D3iW/IpLDYseotCyv9Em6CxOH/S4ZQ7cVOimx0B1e0QUJAhSUTRAzCgBaVXhVtxVttOOz
	 TddYxT+U9TEJbPBlehLqtlLHuB/ZSMVl5ZDVA7sowj7XoOHGCxuFSautzLtKueIFsdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wTXJKVHi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420F606A332;
	Sat,  7 Nov 2026 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wTXJKVHi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8101B1F0089F;
	Sat,  7 Nov 2026 14:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062017;
	bh=1J34ZVGouZf4TN2zxxXpMkAsyJ3b3xKKc6dd+U/jvlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTXJKVHiv5rTXNhlWDkD/vTWaUfPYyeAaS/KkOsmYJKHnHgpXdkyTrTX8dGyfJ3jp
	 BF0M1cavqgb69Pfu6kNdS8SzaMJr3vN6o5QW/DYnZYE9+RKTr0WlHZ/U4d2e9SUOyt
	 ErsjaK8wYuZGDd/giXa4os/W/QpEvGteloV3UVKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1006/1536] fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs
Date: Sat,  7 Nov 2026 08:50:22 -0500
Message-ID: <20261107135025.926544063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit ac02245b0ca28388ba16273f2fa683c90da2e5dc ]

The fpga_mgr_lock() comment lists of_fpga_mgr_put() as a source of a
manager pointer. The helper which obtains that pointer is
of_fpga_mgr_get(). Correct the reference.

Fixes: ebf877a51ad7 ("fpga: mgr: separate getting/locking FPGA manager")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260912100937.86316-1-kmehltretter@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/fpga-mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index 0f4035b089a2e..f6856aabf27d5 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -744,7 +744,7 @@ EXPORT_SYMBOL_GPL(fpga_mgr_put);
  * @mgr:	fpga manager
  *
  * Given a pointer to FPGA Manager (from fpga_mgr_get() or
- * of_fpga_mgr_put()) attempt to get the mutex. The user should call
+ * of_fpga_mgr_get()) attempt to get the mutex. The user should call
  * fpga_mgr_lock() and verify that it returns 0 before attempting to
  * program the FPGA.  Likewise, the user should call fpga_mgr_unlock
  * when done programming the FPGA.
-- 
2.53.0



