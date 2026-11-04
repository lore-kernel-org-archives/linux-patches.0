Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831694;
	b=5kY662fywhGzsWoCNasyfQ5cAm0vX5IMyRQUXsm4peYutMc6tXRz4kNpYKgCW9Mu2gUZ
	 2iQxgpg/MHVezjp+cspQ5VG6wRq5DQwemcoZO+w3nsIS+ff8Jls7Z9xIKX2scuxIJkyzg
	 A9S8yo3gNVcdvyLKhig5clzyjeNGyFd9vRcLb5itshxOK17tcbiYOd9f0uQZ8Gjx6PAIZ
	 RElek2bSP4zDhICQ0xH8RvAHbjFf2V9+Wjz0FI9yJxeC487uWVPDL2t7zxFzH8ysNoN/G
	 9k6WLYpLsFoGtjaKqIoxJD34WosP/ZULCZGDsaq2csvLWgB2FRF/SSE6vkdCaBgEo4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g3fsJcnCFk43N2fq1JjTJF5GXZWGG8XB5gHhAJXGgAw=;
	b=vqtxAb0/7TbCmnNAlDOq5LUPi2YG2TTfi8Z2oTKXWB2YZyhpRTM2OX4Tyx4yWlqQ0BFO
	 Re11ADeeFLWk3t+DtfBwf4ePwJ9dDCIbVuJenjsVVyjZcAVoKOnrc/cmEnaABib+OF+Ja
	 CGL6B//dqTidW6sOCa2hIDjA7FXRYDWuz3oYrvJpT1L3LEuqNBvFTP2xKJrBiNx5vrw9N
	 yibrVP6QIgd08jNtl3m2hiPiieMhy2gbJJONlguXKRnTkrpQiHSRDx/kRMqZb3RoUyKtw
	 sqlBeW5NW3wOSCbWcVygWPaCHWAbJdqUeVfHN/y3kQbcMNcjFrXwxebrNfMbJuY52HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9DSQIL7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E4E606A332;
	Wed,  4 Nov 2026 22:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9DSQIL7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAA41F000C1;
	Wed,  4 Nov 2026 22:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831693;
	bh=g3fsJcnCFk43N2fq1JjTJF5GXZWGG8XB5gHhAJXGgAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9DSQIL719m21GYCguuHCVYwHAlDiGuqcIJ9qTfUc7fkrGC+PjckxP73zaUV8ggBD
	 J2yHmT4/1CRmabgNw06zvpn3qq28NuIATcGzbCCMco7wkkEo4Xqt6Av/BtcxSLHQz2
	 QUaKOYIpkUIwHgze/U8qh2VgqS08JS0GY/SjC28k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0859/1005] xfs: never reset the default quota timer
Date: Wed,  4 Nov 2026 16:09:52 -0500
Message-ID: <20261104211107.344609863@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit ddf4fe30c3fd7d37cf9bad3887ddb69984954cf4 upstream.

LOLLM notices that xrep_quota_fix_timer doesn't check the dquot id,
which means that it can inadvertently reset the default quota timer when
we really meant to ensure that a (non-root) quota overage timeout has a
sane timestamp.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -274,6 +274,9 @@ xrep_quota_fix_timer(
 	time64_t		new_timer;
 	uint32_t		t;
 
+	/* never reset the default quota timer */
+	if (ddq->d_id == 0)
+		return;
 	if (!soft || count <= soft || *timer != 0)
 		return;
 


