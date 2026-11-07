Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064312;
	b=Wm07DpFJAzlgvyO5liYry0XYplILBdVUd+nXDG2CEuXEQillQdwM3st+jAHHDi4zSYHX
	 yvypqfzoNjoon4CII0z6sNIurkDoeUamnIO+cUOxIe5S52kq2Ox+ZOdif6fQh3u5M7uSe
	 W4yxe+J8MpwO9KQAMmYF4+mB03rAs/W0IEYE55xIOOGTF5FGX+2jDuooSkuXbhn528Rxx
	 yglWyPopAwJdyr9D59we16WITae04OteEKBfpY1ao94mXhIO4ARkkykXiDy+qVfe1u/Ca
	 HLn5iHVdHEEormtqkGrPWIbhdpHM61nzlG8G3zXNgHseLW7pVrJszukxDJi5HNLxhDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RYa5bx89O5vyGOt2z+v0NLeixrUtGWmv8r0G6+IyTgA=;
	b=IbnR4Qa1gGOUfTFTE5qWDvjdpaMXvq646bvEVhWDWP6MOryMb7jjDHyw0Vf1zyINxO7L
	 /RaSqTuCH0CihbDWUoNzlrpLAWdnemB1LafEMvpRtgTWYLlVJt+weYwP3y8HgjV1MxT69
	 5/go/nsxWQA3YyuwCvDtOQtOstFrnv/mBFfC0DtpB9wfjEtcLm2jjSkJkAEPj6Ub91UcS
	 nAxeaqUYxKbyA8BpXDlcBNMpLWI8DYencv7b1IKPxnHIx4SRZRX79d4cxtd2FNVx218dy
	 WDQAIql7pNHrpWYM1nZkRP1qzJX47bkK80r22wuLwSyy4VhZn2NzhCcjkeVvLuEoB4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5kJ++hJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9473606C02E;
	Sat,  7 Nov 2026 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5kJ++hJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EE61F0089F;
	Sat,  7 Nov 2026 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064311;
	bh=RYa5bx89O5vyGOt2z+v0NLeixrUtGWmv8r0G6+IyTgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5kJ++hJLfqrSQPY7I2JidDxpNQftr7KO3aMBBq65vrUe8a6ZNTPy0VHFJhrfeNLt
	 BSJhRrqfCPzpOhfX7oB3wRWW5eZXoyc8u4tQIGGiUOjLR7D2do9I7SfycX39K0VrvG
	 wweYHaUEff/1bsBuKzfo3PtDu2fTlwqbFRqp6DLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0402/1257] media: mali-c55: add padding to mali_c55_params_ccm structure
Date: Sat,  7 Nov 2026 08:44:58 -0500
Message-ID: <20261107134950.635240644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2d3873cadda8537d8991abb24484bc590001fcbe ]

The newly added structure has extra padding on the on
some architectures, which triggers a pedantic uapi check:

./usr/include/linux/media/arm/mali-c55-config.h:807:1: error: padding struct size to alignment boundary with 2 bytes [-Werror=padded]

Add explicit padding here to avoid risking information leaks
and incompatibilities between architectures.

Fixes: bb401df68c06 ("media: mali-c55: Add support for CCM")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/media/arm/mali-c55-config.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/media/arm/mali-c55-config.h b/include/uapi/linux/media/arm/mali-c55-config.h
index ef0fe17df96e7..3ba416d81cd70 100644
--- a/include/uapi/linux/media/arm/mali-c55-config.h
+++ b/include/uapi/linux/media/arm/mali-c55-config.h
@@ -794,12 +794,14 @@ struct mali_c55_params_mesh_shading_selection {
  *		Q4.8 format
  * @gains:	Gains for red, green and blue channels in unsigned Q4.8 format
  * @offs:	Offsets for red, green and blue channels
+ * @__pad:	Reserved bytes
  */
 struct mali_c55_params_ccm {
 	struct v4l2_isp_params_block_header header;
 	__u16 coeffs[3][3];
 	__u16 gains[3];
 	__u16 offs[3];
+	__u16 __pad;
 };
 
 /**
-- 
2.53.0



