Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060669;
	b=GXG2bIL/26gMlBOSyx8PlgcSu741kxRuvHqolirLsKd1nZc9tlwU8EFG/8y/Z8BSOt5C
	 u5+lsNEotBO9d1oU5tyxh4nAWY82cUbtzO6iaZ8xU9IB9lArqAMRWYkWyEaNHRK6Tv1zk
	 zrPCNIi1jEYbyTLB7XAfrhjsr4qgWRucRwQ/GxSH6dyKJuN1AmMVxgmKrkOcoa6ukyqgA
	 CNcAvx8gvaU/oHZgGCR9dADRQeQVzyyJ9LT6yrcthDCYSQbhyY47TswOTKQo9QWvD8i7P
	 jis3xViDapicFjnn0Brj5hic3tl19daBU53bfM7ufbX4Xdz338BiogbxgIk9slIGhjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hJ0SipUcZN/uJoJaoEMCcWUUavRCaGpZyBxzT95DbXQ=;
	b=o3Mr/VdVhP0+mY9Fdx+8764XF/y742gQuXKgybBHoPScOhz847/1FkP82zd5EaodV5GM
	 ZPvBWlpzp9EWTxEcxZ+LNID5lcmvwf5CCuh2c2ZHXqvQQUiCEzieGakDDYH9mRU4zDkm0
	 E1GaMa9XCgCSPG5NhbZI8Z4BE4JObevtcleEYf9PVl2b6e07B9GyoqGB6w2nTW7iKqSXS
	 jb6z552c2jKbh3SpZiRaCN48o3hxy3TOkYRm03qwpSrf4UIGVINBbxHGxna7n18vXusvA
	 Tt97c+sEMS/gtvltgQGBnery+7p5C2FuzeodHmxyT/nCwuwOJJwl+qkO7wZaZKFfdYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMNS6Hx+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0FD606A326;
	Sat,  7 Nov 2026 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMNS6Hx+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEF21F0089F;
	Sat,  7 Nov 2026 14:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060669;
	bh=hJ0SipUcZN/uJoJaoEMCcWUUavRCaGpZyBxzT95DbXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMNS6Hx+e1RXruyBeuTRxaaiJASiLs7rueicAatT9HaI8vmXPu0/O7rtAvEyHnIYy
	 3Vmre5O3w9pbSsyZ1Gif+zFH5m2EY+19fdq26qh/WAHUZXO3TByQpou5vNFiqn6Fwi
	 7UQzKmgJXQEHRdzJgTVbyy1QzgS41B31y69nLfEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0105/1536] media: v4l2-tpg: reduce stack usage for kasan builds
Date: Sat,  7 Nov 2026 08:35:21 -0500
Message-ID: <20261107135000.620533697@linuxfoundation.org>
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
index ded11cd8dbf7c..9ff4499677221 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -2346,9 +2346,11 @@ static void tpg_fill_params_extras(const struct tpg_data *tpg,
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
@@ -2483,9 +2485,9 @@ static void tpg_fill_plane_extras(const struct tpg_data *tpg,
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



