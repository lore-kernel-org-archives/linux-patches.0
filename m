Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046408;
	b=I6OXz7p4cV7i0DFfHaEPXDAfLqtVoMHAxX8s2HCDCCnn56fjUwghd0PqTBQennKOg4WG
	 7Mnhz4KtyYCIzLHhn6Gf8R3Hx8azVS2BDzal87j5vRij8+B33IpGusqtf7h3MezgrdSYW
	 yAB/GVSW5HLJmAmlXlFT/It/lqjKlvGUIZBfIDJhTQTWI9mvfhyaR2JuvZg7pixq7jbLT
	 3PAcdGK0ueRw8fxStfN2Xw6fXEdTkZNoDHmM5KOEF8MBx9ClBnyE4JYy+bRJo7HUxK330
	 GQmy827BViB1L08E04iTigEeBLwbgWp9TV8fwKupVsRhFFTymnqnD1S8fN2GfAZ0lVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7JnRzDIS2cBn3jea+Wy6R0deD4I3ISBBFBJEr7MfoCc=;
	b=sBP9EpEbkT1M30hb2irYChZl7SE28m70z9RrXkGLx6K3fkZOuU1TYHsgRnjPvaGz/0SE
	 jh22wDzFY8MlyOkybmhPOIOJAR13S3/xRFUe6xFziOCZxa99O6Yyjy2yCmGZjwCVgmwKX
	 CF1H3fV2MVq+E7Ar+8Keyy9KqAE2zuJF7xpZ7cTAnvq1o26tYL6+2+Pl5W+9q2qEAjpim
	 7PktheWtUbS3CDQ4Go0jNDy1MX+oZWwcgmkqhfvfuRJsraAr0G/ii0W9YpPzwfAiPaMmz
	 3lzgQvjKzX+P7oaOjL3+Omd/Smkk2LeZILGpagpOR5rjvxACexaQroU1AzwDBE3lvhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m72kKoPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914BF606A32A;
	Thu, 19 Nov 2026 00:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m72kKoPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA711F000CA;
	Thu, 19 Nov 2026 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046408;
	bh=7JnRzDIS2cBn3jea+Wy6R0deD4I3ISBBFBJEr7MfoCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m72kKoPi9uGDdtM71tDWZCQXGpR034SjdmHYoWAoPkhyYnABJzwmgVP/HC/Rn+yuf
	 jShxiakEM7UjMYORwNiM95PdrY1PD3k5IkV4eB/wsn/A5t7VteT6YSduioqirhnzyN
	 SSu9g8x4w11gXwORelmrefes6XGVS2X+NJ0Hup2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Downing <skibletz@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1270/2857] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Wed, 18 Nov 2026 15:38:24 +0100
Message-ID: <20261118150247.248199684@linuxfoundation.org>
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

From: Reid Downing <skibletz@gmail.com>

[ Upstream commit b7eb276a39b14e685c2fe578f8ac22fc48ff9e6c ]

bs_blocks and bs_xflags were both read from bstat32->bs_size.
Read each one from its own field instead.

Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
Cc: stable@vger.kernel.org # v2.6.29
Signed-off-by: Reid Downing <skibletz@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 2f54b701eeadd..54fb3de1fbcc1 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -122,8 +122,8 @@ xfs_ioctl32_bstat_copyin(
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
-	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
-	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_blocks,	&bstat32->bs_blocks)	||
+	    get_user(bstat->bs_xflags,	&bstat32->bs_xflags)	||
 	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
 	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
 	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
-- 
2.53.0



