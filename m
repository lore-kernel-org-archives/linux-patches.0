Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831652;
	b=fN6qAlcKnvJaERhIL4WDo4mWBIqTn5E+8/cJivHsOJGtWVoVxWTEu2kbOPFTGiyDvOot
	 nru0CGI7iR6M8kRA9M74EGN42zyyg4uRSGBrihunjAf9mn9w47s1pA72ChcmPQzJck2hG
	 NYTgtikSsW39XB0A5QT971k4VFskBTTlAbd873beWGxdpIzkRhbH/+qdou8YEmT6qdR8q
	 WUSp4mWPk+hNcIrmSviEyhpaWdJJF/XXG5ttBj+l5Ri50aF+z097vABOP7NjLHbla3yH+
	 EYCd7TjnTWm/8624NN/UGKTqygfsk2mLXSfrR3uRpqMwlr1DDErSFIqYgbXRAIVj8PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9/zMc/3G6IewNblvc72IGjm7dyq0LdqXZWcNDe8tVng=;
	b=1+d2Lz4L5qqU+wewR2hE3TVX2blifJZmxkPVJkb8gqztEXy4bo7XGqt+m2LAq8Sp0ILH
	 WcLGxw/VwUiNzbbnSchvOA3ceJJBsgKbi8/QT2tB1tpDCaGwfcHmHiXljjJTgy9iwleNz
	 Ue13Yev7hQm/0buEXpqAuQ0zEv8hyjQzqB/DrAbuRMr886XLsHLFVHxfSMfEMwkjTi+76
	 EUO/EfEi8v409OjdtzY6G0XT8kLK/Fg8na74YE4u6FV43zBpwgAuKaqhBF1MWya5vH2nK
	 nE34qQJJQRzlrnc0T5WQgQ3KJ8xYFP1mpqr2/r8aWK+g/5TW/CfXsXzbDG2m3uyF0aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fef2NTlu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C39D606B2E2;
	Wed,  4 Nov 2026 22:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fef2NTlu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1412C1F000C1;
	Wed,  4 Nov 2026 22:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831652;
	bh=9/zMc/3G6IewNblvc72IGjm7dyq0LdqXZWcNDe8tVng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fef2NTluX5G4eVhBvuTamrsOdUi3Pi1NjC0yKViplOMjkS/arhadJDh2GD1N3ua5I
	 CsiXTZkyuyM5nmV3bcWNFRslChq9jifjwZPtE4ir7stxLyDLqWIxPKDCmoCBPPwiX1
	 /zw6TJnWXeps0cR86FXRBPJs29YErpygIakFH2Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0834/1005] xfs: abort directory tree repair whenever dl->aborted is set
Date: Wed,  4 Nov 2026 16:09:27 -0500
Message-ID: <20261104211106.688011524@linuxfoundation.org>
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

commit 4582327e7068194d55941b49dd66be211b9e3f90 upstream.

LOLLM observed that if the live update hooks for the directory tree
repair code ever fail, they'll set dl->aborted, but then the main repair
code path won't check it to exit early.  This can cause incorrect
repairs, so let's check for hook errors and abort the repair.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -575,6 +575,8 @@ xrep_dirtree_delete_path(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 
@@ -720,6 +722,11 @@ xrep_dirtree_adopt(
 		error = -ESTALE;
 		goto out_trans;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans;
+	}
 	error = xrep_dirtree_create_adoption_path(dl);
 	mutex_unlock(&dl->lock);
 	if (error)
@@ -780,6 +787,8 @@ xrep_dirtree_move_to_orphanage(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 


