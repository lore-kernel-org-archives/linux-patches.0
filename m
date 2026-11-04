Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829436;
	b=sflVQnIcXNrreExw52KWoaOBUca2jykWczhprWl9UbmCeROMJQMp6Hlv1BR1KBKwEXq7
	 HbsuR9T3JfM8NMYGmTabOJkn+fo+dRlqbhXwczykkTuIz+xNmlAkT9YvYzwJAO2kyszJj
	 3bQHS3y8mOO4XiZC6Pem4Cfja9y0H5ONzbZRyPH8DW/NKoh73H+65lZOC41/QXc4RO2DO
	 DkzNAFtyZYEblfpQlmphK/vFrMBzX0U2ZFkyc63YRtCaT76CSG2NvphmnPDBK64AxNXZR
	 XPNR9ObObnTGc3YsgJgdhlW2RNEutAIkZJmM+9cJ7BNMrDwTK4QyOx+Px3+W81YiGMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0MMGrg6YJf+JmGNinygTm7RFZ2jCEXmYYSo86GH/5Eg=;
	b=BR8zyeop7JeIPMmfJiZtV0mx7uo3L8i4VwoZcSLRGJtF/0CauqTDULXuPAFzV1w7EFuO
	 AiD2BUi66ImfKAmQou84zYIU7hggr8wmihgjUjiYiCb+dBJjvP34QLXq0IB0xG5S2VRIu
	 8y/8bdR1Ens+dffz2Ly8wrp3zqZZ3CbS5gR+PdyVQ983UjqPNR89bC1StZSemHO4zhp0M
	 YRR4zYaaAdDkTKtWvVKQhu3RsqWJG3HYpMGhUa4OUqVzpL1gijnIHdbULYaP2hJJXt1V9
	 LonRYCa6YAHiXel19Is45hRF9zo1nc0bKVlr9dBjbvnji0FPra/aX7JJZouzfTF8k6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VdulfDQT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F29606A863;
	Wed,  4 Nov 2026 21:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VdulfDQT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA631F00919;
	Wed,  4 Nov 2026 21:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829436;
	bh=0MMGrg6YJf+JmGNinygTm7RFZ2jCEXmYYSo86GH/5Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdulfDQTg96hv8nDYq6ErEWQTOzLTN5aIUY4/xEiBJfU3eR4Tu2rGZ/Klp06v7fKq
	 E5B+GHHd/aFdm5DhpIwsrS05IW/TsrIgT6YQQOv4M28nVY7gBbl9WJDA3SZXEaPbp/
	 8kieNbUcTL1Zo9ytqphQwZFJdJkDdJ3j1rO5kzSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0124/1005] media: v4l2-tpg: reduce stack usage for kasan builds
Date: Wed,  4 Nov 2026 15:57:37 -0500
Message-ID: <20261104211047.151069272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 931e5dc453b90..e1d5c220f7381 100644
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



