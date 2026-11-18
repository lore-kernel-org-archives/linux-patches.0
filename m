Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035970;
	b=mLQh2teJdzCKFgLrvP7c59L7BevxgYdx6nVxYYvKukOfz3WzRBOGc2n2Eml5p53kdkgx
	 fM7ITBoWvet6gNRQH6Ie7bAx2b9WIYYfsM9HdObCDr7xjjjNgndJ0iIyyUBq2CEaJ13nY
	 Dwng2rFoGP86JunqctQzzoOuTRUlTNDPATotTJnxZ6DFGuY1lFi/M5aa8TPpyxWOx77TW
	 GZIqokezMJ5VMPjur9JKtJY5+gb+npQ0ADGqV35B8WurP8Yf/NeQlyWmRl/n9EWXLdR5r
	 yHVU4lCU36rBU9ESLSmJneW7o1HS47dU5RqjLcYxVUu0P3zXkQn1IRaTIFV/l31dgtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RtPCdvOT77CgrJdML1YmHnBE4nmo8LmUMDfqXU7Mv2g=;
	b=oX87lIPJSrfMn6Fgt6AHeZREBldow+2rsDGlu2h2khKEqLiWPBffpBJavd3eIt8KUGkS
	 lxwjHwO5IslWFp3muswRrNki8GyDfbIYiirLZWctncSLDvlpkK5SEiq1Pj9LHPAJDmBhv
	 Z5+jIR5MZ2TeC5F9RZdLFPb/2Q0YYdh0BdsPI41OgT8F4cNXNjUNLIIlH/1jvv9kwZC9H
	 /Ztn+FUkPb7glagzfT/KWtfQJkHWhkmOzLHhR11VYyN46cU4fmbtTG/UJ2GvK8lUrt4II
	 UeNS4i+6aNX/k3hckQTV4dWRTJ1snrXQ6kL89N5ipJr8TyzY5w2NBmAson+sXtPP8CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXU6F5s8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7727760A2602;
	Wed, 18 Nov 2026 21:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXU6F5s8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16431F000C6;
	Wed, 18 Nov 2026 21:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035970;
	bh=RtPCdvOT77CgrJdML1YmHnBE4nmo8LmUMDfqXU7Mv2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXU6F5s8Vnh/7PibBZGjpmd+xtVooz7ynske/77jgatX09QaaRsSa0guASBQmvdzL
	 6P7XC02sAQHKv1Pyuie3aBKrCLtzu1I0Y4tp/Ajt7+60BR9jmIuNfxrO6OBcFbmcAU
	 FUCjG2qd2VXkVR7+IHBpO5iDRXNCKiPXgLHZmnNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0893/3318] fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs
Date: Wed, 18 Nov 2026 15:25:15 +0100
Message-ID: <20261118150346.226526758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



