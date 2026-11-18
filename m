Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033639;
	b=lxZoWPQvezlOaletBQoGnkknuQnOk0ZNMVnqQLBFEGqPzR4AXQE/GBXhcl5uqN9i46hr
	 UwqiOF7gFZO0h903Eu7lqDt435+aWXeHWG5/FWwAYiUutkE3CTlG4RLV8hQYqOsfPo2gu
	 4xoTNFi+9GzQFN4T7dFYZBNXjvJRLyKTRz4RlDwOX1ToCvoxg/nJu9yn/lG5QWrtN3y9G
	 6wErjfY0fVXl9nPUuIOhU6c3Dk0C4FvZE9umB7f/S63prn7XA29QizWSF3GlEaVzi9VZv
	 hLnasqr26lFP1T8LwsWVIrjFqVeM32teKnV2BgXyxMJjcW2pe2kDKhjM2FjmIrcGeYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q6O5l3rgn8ibmDbt5Ino0LcP4O2hWSs2Hc8pZXS4b1g=;
	b=fleT4plInvZDYwHwBuiLsD/zU84mM5+KBujs/GYZ17eKD9Gb+oBDC1XljJK6IkqsCj03
	 7hVx3NLkhXHqCJKjSEK8rl569yA/IEtxcbNrXMBrsqiTIrdGDNg57/KKmEiTa08zArBcb
	 SV4mAxYrEtSKuzmDjhugYcy0EZaYxLHBotFx0yLUIYPr/O0HN6utGz8hDfSTdTr7fenaS
	 m5A9r78DsKxI4M8ncm4CP9lfeB+8Y7LUSdbdwh6awlCV9oMk2qrs3ch1Wkset2O23aIww
	 7I7R87TGfihgbs7uu1L5eJPfJim7LoA1rwX4t59sArGHzYmXJPKmw5poUSel3ot6HDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O82tz4Ls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290CE606A31C;
	Wed, 18 Nov 2026 20:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O82tz4Ls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305BF1F000C4;
	Wed, 18 Nov 2026 20:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033638;
	bh=Q6O5l3rgn8ibmDbt5Ino0LcP4O2hWSs2Hc8pZXS4b1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O82tz4Ls1239QlDan6BjPWjygszhgLNyxkL+/r+vwAUqOrQkcPhSeWmPDG6r1oumC
	 KWhhRHoGgJF/VXcGv+/JP2kCzB8Y34NKkJ0Zn4gj/PGUqn2+tWn3bEvxTNDuPDCjkJ
	 lIvYBC3SgMnRQNXXPnPybP3Js6arJS0v+L69FaK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0087/3318] media: v4l2-tpg: reduce stack usage for kasan builds
Date: Wed, 18 Nov 2026 15:11:49 +0100
Message-ID: <20261118150316.738317823@linuxfoundation.org>
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



