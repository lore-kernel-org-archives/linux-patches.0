Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585804;
	b=Uohlv6sez4Nvdh7rNng/iAz6XE0B3R58sXgSCgg/HXXOpeNS+IYX5F2VNh5nNqsPK2ui
	 peTbCN/BCUQ48h1TmFXVJUsjIXz48Sf49So9cBZS4Kn26Z5k+yBI8xwEHxNfCfhwrOPj0
	 bOjaAlUPtPohwHosjcgv4NT2EG/J/KL7gIMFNTgt2vgVa3SnWT1LC/iT7ydknXqJLFk+p
	 WvVBmv8wrVQrUQuBxNyWcnsYDW2XrGez6gK4eZuT1FacylMyTd5vrw0R39Or1Y2h2AqD8
	 3zCuK5IC2izydzqwacMiKF7XhBsZ749iHguSAB4rJUrIFlJrN65p7f5jcWCX/YWFd0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IY7lzmqL8XwkpYAipHxkCwXqy53P7nxHTLULLtLB5OQ=;
	b=3U8eWmZVJ+ygfoLvmYPwgKDIagPu8fkXOo4sDKfRsnh/6fByLXnvbp1zwfLYeFH+mcTl
	 HLOAktsGIGPPpOGbxcn0MFilKWe5+IFzrylKMORj/u2anEclgRrIbaKugGmlFp9vI89tU
	 etxUUZG2j4BAvJxXxTsLaaRVUpzydBM4wY0yQFrlL9iiApV2HBklN+z0ID43Lhc03eEa3
	 8VcCTOB5K4WHNbLN/HIV+MC4aFpWZAxPRK70QtDZqR/zKh1eQNXtLYtQ1Dt3KRrPdta4u
	 7ZFoyX4vzJO6GGflD9poYXyNe5T8mu/r3NzDrsZTIPA9Miwg9yCjj2/xernTTeXeuGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wD4jkESi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B263606BA9C;
	Fri, 13 Nov 2026 16:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wD4jkESi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4761F000C4;
	Fri, 13 Nov 2026 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585804;
	bh=IY7lzmqL8XwkpYAipHxkCwXqy53P7nxHTLULLtLB5OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wD4jkESi2W6vpirpzW3l1wBMrDf45X/OYlC1C6U5Cmieo5P31C8OegURklstX2kxx
	 PGdDKPGDVPg4QJwoSTXDcHNMlajjS+l4lyKIQ0iM2fzpV5IN0674ELRajuI5+TMuaI
	 LmWy66bLLFGj8P5yUkqh3ICjHxGnR2XOeFTiZVCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Zeruhn <fzeruhn@icloud.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 389/507] drm/dp: keep MOT set between messages when no_zero_sized is set
Date: Fri, 13 Nov 2026 10:51:33 -0500
Message-ID: <20261113153809.780699860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Finn Zeruhn <fzeruhn@icloud.com>

[ Upstream commit 06bb2e5c71e9983519929a8482bea89da6d80ad8 ]

When aux->no_zero_sized is set, drm_dp_i2c_xfer() cannot use a bare
address packet to close the transaction, so it clears MOT on the last
data packet instead. The check only looks at the position within the
current i2c_msg, so MOT is cleared at the end of every message and each
one is terminated by an I2C stop.

This breaks E-DDC reads of EDID blocks 2 and up. Those are read as three
messages: a write of the segment pointer to 0x30, a write of the offset
to 0x50, and the read. The stop after the first message resets the
segment pointer, so the read returns segment 0 again.

On a Pimax Dream Air (three EDID blocks, native timings in a DisplayID
extension in block 2) connected to an RTX 5070 Ti with nouveau, block 2
reads back as a copy of block 0. The checksum is valid, so nothing is
reported, and the connector only offers fallback modes.

Clear MOT only on the last packet of the last message, as the commit
that added the option describes. With this, block 2 reads correctly and
the native 7104x3840 modes are listed for the Dream Air.

The same problem was pointed out by the Sashiko review of the patch that
sets no_zero_sized for all DisplayPort connectors in nouveau.

Fixes: f0ddbb1eed18 ("drm/dp: add option to disable zero sized address only transactions.")
Link: https://lore.kernel.org/all/20260827015758.0B4FB1F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Finn Zeruhn <fzeruhn@icloud.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20261002212833.9674-1-fzeruhn@icloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 488fd123a01ad..7676285c19f87 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2192,7 +2192,8 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 			msg.buffer = msgs[i].buf + j;
 			msg.size = min(transfer_size, msgs[i].len - j);
 
-			if (j + msg.size == msgs[i].len && aux->no_zero_sized)
+			if (aux->no_zero_sized && i == num - 1 &&
+			    j + msg.size == msgs[i].len)
 				msg.request &= ~DP_AUX_I2C_MOT;
 			err = drm_dp_i2c_drain_msg(aux, &msg);
 
-- 
2.53.0



