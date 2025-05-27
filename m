Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA6C3C01;
	Tue, 27 May 2025 17:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367336; cv=none; b=nRUHYmws4Tgwt+RpO51K/yKQHvcHq55VxXWpqV65OVDMXTXSiuJ1Kg52M/fiB9dJU4PUu5yt+p4cE7BdekY3Eg5uPzX8Z8I8VXal0mWA1gs4P79il+qc8f79HJhEVqnzgG76Bb851xuGcFtn9HfDnhX027qybwi475W0XadwsRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367336; c=relaxed/simple;
	bh=xvbZMLwc1jDX1Cu5rPVdg7yxxqY6lJp6W0BGaudPAcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnEaU90xyjPO16Kmd5nEPoHY5+ssemfk2ZuZyNws3tZNbj3qmhOuDeCJp5+4NdksjoaVVLG/MIOQboGsQdmLg/4IqQkGwJQUmC+ptRDei5efhef+c0QIIA15BE4+ydPU0Vi7FpHgGIZ9fRbeh1fW8CFWT+6g5o0qHod9eEcAH5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxYGd2b1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxYGd2b1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D54CC4CEE9;
	Tue, 27 May 2025 17:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367335;
	bh=xvbZMLwc1jDX1Cu5rPVdg7yxxqY6lJp6W0BGaudPAcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxYGd2b1GBGq4r1oqQKTlBfqVDnI4YzfrKiNWj39FwFITih0sZwEl+c6pDdgRZxRn
	 Ah3MBLt0IIdP1IIjTnJAxQN6cGeak7e8BKwIFUdZpqIJFdrW3umUrSP2x7ZkFr9Q/f
	 puCERGWGBpLrO0U+RMopUIYffYFqTVmjYHSlDgs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <Samson.Tam@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 355/783] drm/amd/display: Fix mismatch type comparison in custom_float
Date: Tue, 27 May 2025 18:22:32 +0200
Message-ID: <20250527162527.526947188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samson Tam <Samson.Tam@amd.com>

[ Upstream commit 86f06bcbb54e93f3c7b5e22ae37e72882b74c4b0 ]

[Why & How]
Passing uint into uchar function param.  Pass uint instead

Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.c | 2 +-
 drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.c b/drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.c
index 131f1e3949d33..52d97918a3bd2 100644
--- a/drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.c
+++ b/drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.c
@@ -346,7 +346,7 @@ struct spl_fixed31_32 spl_fixpt_exp(struct spl_fixed31_32 arg)
 		if (m > 0)
 			return spl_fixpt_shl(
 				spl_fixed31_32_exp_from_taylor_series(r),
-				(unsigned char)m);
+				(unsigned int)m);
 		else
 			return spl_fixpt_div_int(
 				spl_fixed31_32_exp_from_taylor_series(r),
diff --git a/drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.h b/drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.h
index ed2647f9a0999..9f349ffe91485 100644
--- a/drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.h
+++ b/drivers/gpu/drm/amd/display/dc/spl/spl_fixpt31_32.h
@@ -189,7 +189,7 @@ static inline struct spl_fixed31_32 spl_fixpt_clamp(
  * @brief
  * result = arg << shift
  */
-static inline struct spl_fixed31_32 spl_fixpt_shl(struct spl_fixed31_32 arg, unsigned char shift)
+static inline struct spl_fixed31_32 spl_fixpt_shl(struct spl_fixed31_32 arg, unsigned int shift)
 {
 	SPL_ASSERT(((arg.value >= 0) && (arg.value <= LLONG_MAX >> shift)) ||
 		((arg.value < 0) && (arg.value >= ~(LLONG_MAX >> shift))));
@@ -203,7 +203,7 @@ static inline struct spl_fixed31_32 spl_fixpt_shl(struct spl_fixed31_32 arg, uns
  * @brief
  * result = arg >> shift
  */
-static inline struct spl_fixed31_32 spl_fixpt_shr(struct spl_fixed31_32 arg, unsigned char shift)
+static inline struct spl_fixed31_32 spl_fixpt_shr(struct spl_fixed31_32 arg, unsigned int shift)
 {
 	bool negative = arg.value < 0;
 
-- 
2.39.5



