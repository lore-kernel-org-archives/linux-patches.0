Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057346;
	b=zIkB1cRa5IjET3swOIkGJsXZ0tZVH1aQnn0Pfm7fjGcGr96Sq9/NGHhwX8dcnYoJCaIU
	 esQzO3f69L4R9qBIKl95p8/4aifRJ8f8T5zjJM1usp9xVgSJ7slwJ4TZc1KPWtjksWFtZ
	 x0Du+YlOzt6acDcNClKChYbH+m1uNw7vMQ9he3CKwLvf7x6ltQirCqgP+ADl4KtZB7gZR
	 4hIKTa206BoRtdflmwTMd1ii8WGDGg+Olzvh4IpD288BVICC/3m2dXChSxojs27EtBqy5
	 x62qgeoS1XvHPQrUxmS6DjnGjgivRrh/RVnMJKTObnB9cZq+CuHuerkwy1kRKJYOqkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/vaID3+tJb6LW1OdtcCmHW0lDdlO4mOjw49x8DXyXLg=;
	b=ssCYkFpUFyipdGqTmIvINGZNjoVw9SsYTaoFWTboRveRv1KZcTIlNzNufqzeX9l7gLwJ
	 9QW/Oh1wlmiOGdFLmRXTWGGKfyOqFIANCx2FVDCzuyT6lZifZBxMvAa2wrt1NMU27EbDo
	 bJbWPgi30Lnu34if+ZGUmYdpb+xHqucse4D9XjCyAuv1zDwEH8hcWVzisyOiGdBS8VLQ7
	 eBGy4N8V9Hvj/SiPuJnC2c5J1dwlLM/xOag60MrLX9QNFANEUcP23GCvANGqJ8DSgLcSh
	 mOmy1qDl7Q+HXLEoIz1WejIe1OOmoeKDqIb8GRIeIA9qCGGdDmKvKZeYX3358jg4M5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgvycQxb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A89E60A2622;
	Thu, 19 Nov 2026 03:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgvycQxb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4F71F000C4;
	Thu, 19 Nov 2026 03:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057346;
	bh=/vaID3+tJb6LW1OdtcCmHW0lDdlO4mOjw49x8DXyXLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgvycQxbrPpiLf86kxIHS9bp3yqLGxKGobzep/Q1rLHqe9ozNKP/F9vztV5zGD7R9
	 FNwitH0AbLthcgVevfDJpl8mgrVN+DzjK/dnaOvrQOoAdUVYh68fg8Vefmup0N1upG
	 g22/lZyxFUynK7ZXMohc6GyCadTNL2L33pk6Dk9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0057/1848] media: v4l2-tpg: reduce stack usage for kasan builds
Date: Wed, 18 Nov 2026 15:34:55 +0100
Message-ID: <20261118145913.488515883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



