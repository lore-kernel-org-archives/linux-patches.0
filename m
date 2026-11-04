Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831698;
	b=UFTvXMMFvvLSOPzO/1DTjv9jtv07a/aG0wdMYpQDAPlADEh2R0C96oOLlaEQBxKs6y1h
	 9e/06fPq7MHj2ZrOmoJQjv4kOo29nWMDIXu0f+ilBFTDerStcPT/3+dTzV5Kjdki7wtez
	 rEieTjAMsquTV8y5ZMbtSAiDa2nOgGc7naNsasSzy6Da0U6HHRDmrYZypXq/ty6Khx8MN
	 vNfeKGeebXVwVmSieL0aUSCqNK6udeBGFhoMTdthomas8pMkLZQPhbyOYXJvHT02v1rF0
	 JCiFEHf/ECA4cbZrT3JfFGqqyQh+v9vrhXgfBZ9s1bHB42CIQw9aEjVDEe335p3XmgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pu5r5Ds3XYGae9UPegl0hBCGIKI1BZSSo5UEVjZ2AZE=;
	b=yuTHoGE4Nw6B5fMKnQjlyFdy4PewqeUpAraXcqvEiVmnac9GVKbh/OdEe27DKYCKozKk
	 X/kFW31dXw0YggA6GJWz/vS8kzdNRTs6ImZYUaDTqCF9ZjXpKUbOQ7s2TI/7i08y/2wAP
	 Efali1S8Pyr1933FaJHG9pfsiDFgz42BvRTcwkBpklujdCEz0knjrQwUwdealW5A4EHel
	 fSb0A/u8HItqOTSFgcffQy3rmjc6qf+AVaXQ/pQ/Jwxg4OZdBjm0+LbEEKa55CgDF9W3+
	 vQH0zo0/134cxMzHM4VtEYyocZNX3eMvAQnHfV8hHMPFdl443K3OVtA2DFWxItshNWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k5S4qU43;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A46606AB02;
	Wed,  4 Nov 2026 22:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k5S4qU43
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D080A1F000C1;
	Wed,  4 Nov 2026 22:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831698;
	bh=pu5r5Ds3XYGae9UPegl0hBCGIKI1BZSSo5UEVjZ2AZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5S4qU43wtr1/r5J1QtkUdETci6ULbjcvwvgxJWL/wyHIn/C+LmkPyqF4emcnKheW
	 gzfI2NhMCBqXzYoMs1RJVnTHPcklfkSnvmMa4ENi8fpaiz4RlsdNvXC1J9Pc5Hjeze
	 CHXInU2q3P0uh+p41EauhDMg6cQfx9GSkG9EL04M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0862/1005] xfs: propagate errors while checking null siblings
Date: Wed,  4 Nov 2026 16:09:55 -0500
Message-ID: <20261104211107.423459186@linuxfoundation.org>
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

commit e5bde75a816b3549942f4b09a8bf09006b7ea9de upstream.

LOLLM observes that if xfs_da3_path_shift returns an error here, scrub
doesn't handle it the way that it handles most runtime errors.  Instead,
it drops the error and keeps going, even though that's not how that's
supposed to work.  Fix that by calling xchk_da_process_error to set
corruption flags and then jump out of the flow of execution.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -257,9 +257,10 @@ xchk_da_btree_block_check_sibling(
 	if (sibling == 0) {
 		error = xfs_da3_path_shift(ds->state, altpath, direction,
 				false, &retval);
-		if (error == 0 && retval == 0)
+		if (!xchk_da_process_error(ds, level, &error))
+			goto out;
+		if (retval == 0)
 			xchk_da_set_corrupt(ds, level);
-		error = 0;
 		goto out;
 	}
 


