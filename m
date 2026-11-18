Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043044;
	b=GftkBCsuUlj0K6JrQ8kJLdJicQtP0IuGjGIc9P6kSnIm2zceCX8tmDPYkhyVC4yS7hOL
	 6Yb4gumCn6Mc/4Z1gK5h01c1WhUculb5aHCcNfHRTBcUdUGFjHzm2H4Lnauncg1PZzAwY
	 mY1Es6sxK4w01OFodKVJkgbThjP4FEWLlufCNOiDAziXcxAnO77CNcNJgpaauYG7WVMxd
	 tDfdRuN5pxSaC+jOLSc0yfRh1MPFuKgmXnerIMxmMagoSqKx7uvs4T1N+6N59oe8a+O9q
	 MXiVRI66BAJ0E94GDqqb+Rya9HAWjdwGW2zbhE/vab0x7QEGc27LPCT/Qa2OkuTxUfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+YWGLEFjDFNLhscJgzWPOIarhH6ZfNaf/t+3ue/XQTc=;
	b=hEtvEbyG/GgQHW8JvRXeQZJYAASwPxYeR1OSJjZA/2Kts8HxkP6L7sG18zyMS4XRFEJ8
	 eZ3/pd62D9NgSHs190X8pRaymhGudk46T+/eU7Cmgfh0hN3JNWdRKIedyfkLOehwo8HUq
	 HATEs9OBU4xyiD3Y9kTvXLh+UEgShxtmp68kLzv7AtDLvV3Ya5ezQfbhg6v8kVghnq2UO
	 pj6GfqXdVgLH2fQiygTQeyeESKJYXemtI/apOmJ8225BYy0NPgF4nvb0Ax5dkYnAzu6Mu
	 GovmWT9rfYmj4k9XyWNiypIuPJuP+e2C80+stpLWhgBs36mMLx6OaGm20p5OJv/fNfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUtqQTMq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B63160A2603;
	Wed, 18 Nov 2026 23:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUtqQTMq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC2D1F000C5;
	Wed, 18 Nov 2026 23:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043044;
	bh=+YWGLEFjDFNLhscJgzWPOIarhH6ZfNaf/t+3ue/XQTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUtqQTMqVb1etYQBWoCfjApO5/2/pmMpNotqeSH3tAw6erXW9D6AzEVsQ6Zz/bLmq
	 Rsk1bP0tXhWlRTSWlcrIDx3gEzdCLWID5XMYXNV5yKobep+/PXkKXM+26p3pS0HzIk
	 QOcE5yPU/eag3/ArGU2tImBs7RhXDrgUE1HTDSxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0071/2857] media: v4l2-tpg: reduce stack usage for kasan builds
Date: Wed, 18 Nov 2026 15:18:25 +0100
Message-ID: <20261118150203.878159237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a635ce4cd6430..904ea032b4cee 100644
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



