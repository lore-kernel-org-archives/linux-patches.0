Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061624;
	b=i83cO0FrzJNxOxhqrjxwIyW55x3ChYum5vonNZnrRdO1SvPMR+q0n0v2jYVaIhkjiEsp
	 0AZwilMhJyJu4zO+EOFfk07U/QFkdKwoEY6mr+ePp5hntJ3wWoFCZukFp4pwYKcF71x/K
	 4upjsfK5y1d8QzuPuWLMrogYfpw5S+EBAhEBxNvRmGGt0pT+vBL16dVJ1KSheFGgKBC7+
	 acuj7Rif+XnrzKOH5c0B2DnZvx/Sq8ng83KU2sQYu6U8dBGhTNK1ux091mlU+iF6SfeFb
	 a8uyCoSm+4OuCqQPM5WX5LGFRvz6pCM7YFfzGgFQp5JrLTlc11mhn80XOX1Vsw7uPww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FS0Jbfsf6iRn81Much3fpE/s0CH1sYF4UKnix+1B7ic=;
	b=UqR+Ie37qKYbKPxsMOv/BhmF+YH4RjiPpqeeSVj/ktzbE8nddfV1jPy74raxbdUn8jDH
	 toya1rge74zwa0cn00dvkMIpjZ1mEWO0YUiPybC/m3kqyr2xQ8oFT7cYdbckiV+mj+u9u
	 fArHaMexPKs4D0/0pjQ02JXJ4azNSsHyiinHUOmxJd4JR89fwSJrihPP2q2aax7QEbFex
	 1S3vbVUf31xs57CJvTj0gw7cmqYZ934EBTNN/+T6jX45zufKudOwxGpZaivoEKPk0p2vk
	 Zny6OsT9nrS0NRFOhpVoH2LsIrdSQOf71FgiIZQCr6MM0EPUtPs6anBm7pTb2CZ92NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z0h4J6/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F67606A326;
	Sat,  7 Nov 2026 14:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0h4J6/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F6D1F008A1;
	Sat,  7 Nov 2026 14:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061623;
	bh=FS0Jbfsf6iRn81Much3fpE/s0CH1sYF4UKnix+1B7ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0h4J6/PKH6rhYw+aa7VWDRdImoQitAY3tgMvB6hTHbzF5/s+zqtMpbvsTXpAQNeA
	 aFc3zpHGmQgRoMytXIAuLa+hSxeHr5Z6VuODf3GSILwX7OORAu3gJ1e/qaXo1ptZzz
	 8HrRcViRPCiMSjAIdyZIqRPSqsOp3YHOv0O3CxME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0690/1536] xfs: fix xfs_rename_space_res for non-pptr filesystems
Date: Sat,  7 Nov 2026 08:45:06 -0500
Message-ID: <20261107135016.867460521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit a800b926346c3aa2482421f5c0272280ee7d32e8 upstream.

We don't need to reserve space for a parent pointer update for an
existing target if parent pointers are disabled.  Fix this regression
(which LOLLM noticed) so that rename reservations go back to what they
were before parent pointers.

Cc: stable@vger.kernel.org # v6.10
Fixes: 5a8338c88284df ("xfs: Add parent pointers to rename")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_trans_space.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -112,10 +112,10 @@ xfs_rename_space_res(
 		if (has_whiteout)
 			ret += xfs_parent_calc_space_res(mp, src_namelen);
 		ret += 2 * xfs_parent_calc_space_res(mp, target_namelen);
-	}
 
-	if (target_exists)
-		ret += xfs_parent_calc_space_res(mp, target_namelen);
+		if (target_exists)
+			ret += xfs_parent_calc_space_res(mp, target_namelen);
+	}
 
 	return ret;
 }


