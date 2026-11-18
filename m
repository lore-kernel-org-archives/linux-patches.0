Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051031;
	b=yo7EfpmXFVLNY4wQd4AaM1JhA0Prplvi4CXRsjs95u0QRvFqJ5TLYscDERlCKbzAq4Q6
	 Ff+GNyX7IyXJfCpGJFSHbryY0uo74ZbZ7iOe78aOQPbULqryDdrCXz42F+/Bjya6Gp/Fs
	 u3tPjxDvNBFjQ4/2SsS5hdNjcYarHWDHfMbXvEwgen7+/nJK8+ogPTV6NOUZsYH+wgW5G
	 lUxKvzcAXXSmOxjJtbSGb0+rAYLzb8c6Mkq3ei1rvNQZg4Etgerv0J6JtG4PTY/iD5Abs
	 AA5//accToNY+hjKLaDTHJyh239Q5VYufAw+K04UkFNSLuRboxY0bf4DX05WHYaM46w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wMZc3qS+8HGo5Tgg6yr9LaJcdyY9lB05FKUHD6GBwNw=;
	b=GVVQgsp7/1Q0mVChPW06E1iFhUCjQtc4WBBKtLUILKXTUdw9FSNEuuvPzEJyP9Fg/+O/
	 nWuPsad5PnNyM4cCV3+/Ahcsf295eJZTp0aA663Fj/qptNT6OXWbkAisY7wMXNfSAsyJW
	 j4B2KF/oZU0J17Z8/3/G7Y9+0HiFpuYW46A2syEJ2fTdm0F3ywuhOn6aTzKtBl0RZa906
	 ABxvExzfLICXarbOuBF6zxmZ0uxrL3Ro/r88eT/BqZdEi+LodXGwVT3xvYr/YuceB0GLo
	 Pdr5OjfZOn68ilzWJGFi+VKGcggyjPRSzjqH7cMT1O0vUlQAv27PvNJP6l9Y9i+vZ4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkokCCRE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2136960A2602;
	Thu, 19 Nov 2026 01:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkokCCRE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753AD1F000C9;
	Thu, 19 Nov 2026 01:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051031;
	bh=wMZc3qS+8HGo5Tgg6yr9LaJcdyY9lB05FKUHD6GBwNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkokCCREM4iDbVHogpIQ0s9PtzQQF89Txv8ttCUyay4zs0taHKwUpb9/LNLc+SVwP
	 mtW4wjdQcoutSF08O7S7pB8gIauWmVrEqTyuo3KyNEkjurmlQSc/gJTxdYBolQF2xE
	 h57dNe/kDN7nDyY4JvoLKPc1b/cgqsLpgt2NSsGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0064/2214] media: v4l2-tpg: reduce stack usage for kasan builds
Date: Wed, 18 Nov 2026 15:29:00 +0100
Message-ID: <20261118150012.576347175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c49cdaafa443ccf861a72d3191121294742c28c7 ]

tpg_fill_plane_buffer() is a rather complex function. While there is
nothing wrong with it per se, I have run into corner cases with clang-22
on s390 using KASAN that makes it run out of registers and blow the
stack warning limit from excessive spills:

drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:2629:6: error: stack frame size (1560) exceeds limit (1536)
      in 'tpg_fill_plane_buffer' [-Werror,-Wframe-larger-than]
 2629 | void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std,

Forcing the two largest callees out of line completely avoids the problem
and prevents all the register spills, with the stack usage for each function
going down to a few bytes for the local variables.

Arguably this is a problem caused by clang rather than the code, but
a noinline_for_stack annotation is an easy workaround.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 533c8bb8fd886..fffbf6d6467c0 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -2340,9 +2340,11 @@ static void tpg_fill_params_extras(const struct tpg_data *tpg,
 			(params->is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
 }
 
-static void tpg_fill_plane_extras(const struct tpg_data *tpg,
-				  const struct tpg_draw_params *params,
-				  unsigned p, unsigned h, u8 *vbuf)
+/* noinline to work around clang KASAN issues */
+static noinline_for_stack void
+tpg_fill_plane_extras(const struct tpg_data *tpg,
+		      const struct tpg_draw_params *params,
+		      unsigned p, unsigned h, u8 *vbuf)
 {
 	unsigned twopixsize = params->twopixsize;
 	unsigned img_width = params->img_width;
@@ -2439,9 +2441,9 @@ static void tpg_fill_plane_extras(const struct tpg_data *tpg,
 	}
 }
 
-static void tpg_fill_plane_pattern(const struct tpg_data *tpg,
-				   const struct tpg_draw_params *params,
-				   unsigned p, unsigned h, u8 *vbuf)
+static noinline_for_stack void
+tpg_fill_plane_pattern(const struct tpg_data *tpg, const struct tpg_draw_params *params,
+		       unsigned p, unsigned h, u8 *vbuf)
 {
 	unsigned twopixsize = params->twopixsize;
 	unsigned img_width = params->img_width;
-- 
2.53.0



