Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061664;
	b=F8fhHF370niYdDsv8PbvS/tCz+vzpaNfV2P0w1Y6VBio4gEXLgEuxoveG0U/TjOpy6by
	 J/VLOkkOKFFbj5SBYGTzc4fMmTNnpQtOOsIbNwwGoB0FSMjFBieFRP6vZyCb8C1rbE2j9
	 sMLbN0AKBpnbiLRDfk2w+fJAET38vEHVGTKVytmjRPhf/xKRtC5pykF2j8OAyK8Rnp+7x
	 z4iMK54+GsrZERZVI9UsjNpgA4Qv1d3HClYc52khSuMyqKQlijjl299R8R/Dgm517SNiA
	 P6lDkxIqvUgo6kdgZQ4CgHrpGIY14DLZFfN+4YKK+/JXasGpYz83aTuVLv0bMR1VQFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NCeZ4iZ+DhPfWN7GH5BeoJBhvwCBP8DWekWgjQOwpSk=;
	b=nxXRFhh+1R6uAiSaUGl5VStYTwXNvgZIcHHCIyudd5XvxxG43y2v41p4GSlm6jtvL7kw
	 qN/Ehm/25Qqbxv6zWkMzA6kWy9iC4A6S76CRTy2dpYZ0BoSpaGhA/kYdigfmsUGaJEQcq
	 BV8iGiA85s9JvE2Wfv6YgOc+ynFOU9r3VNJFm0KlD/VEOz694+Ama3gyuCxr/HpnUGjtd
	 6HpSS8+BzNvEDffDCfdepg8AtJ74Yo+o3ef+32kdhKgCiIUsw+CYbIrR6LONeHQCnHlyx
	 cwlP348NcGGDKp3ymWDbVfU/ka/w1smxv0fPOjfUZyL7wOn5Zf6E+bS8Rzy74J4WabA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyKwrlER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FA5606A326;
	Sat,  7 Nov 2026 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyKwrlER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25001F0089F;
	Sat,  7 Nov 2026 14:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061664;
	bh=NCeZ4iZ+DhPfWN7GH5BeoJBhvwCBP8DWekWgjQOwpSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyKwrlERfNQU4cFH1kwewWgocAxcPkDU281czuINZZNQNycl5ZbGWlCbxuxSbz/uR
	 eranCBXrY41pCck/RPZ2Mk+BrVi8EP20ZmqL5dekIrY9g4pj/PKdNwXYCI0HO645Vw
	 v1Kw741MllA5qOJONoFXNA/Sz6ivPiX9MtIU3MSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0703/1536] xfs: dont repair fs summary counters with garbage
Date: Sat,  7 Nov 2026 08:45:19 -0500
Message-ID: <20261107135017.239102192@linuxfoundation.org>
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

commit 22a8a7501c0146dba4ce99b8256975ffe945125d upstream.

LOLLM noticed that if we scan the filesystem and come up with totally
garbage numbers for the summary counters, we don't actually mark the
scan incomplete.  Because we don't do this, repair can install the
garbage values into the filesystem, making things worse.  Don't do that.

Cc: stable@vger.kernel.org # v6.9
Fixes: 4ed080cd7cb077 ("xfs: repair summary counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -368,8 +368,10 @@ retry:
 	/* Bail out if the values we compute are totally nonsense. */
 	if (fsc->icount < fsc->icount_min || fsc->icount > fsc->icount_max ||
 	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
-	    fsc->ifree > fsc->icount_max)
+	    fsc->ifree > fsc->icount_max) {
+		xchk_set_incomplete(sc);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If ifree > icount then we probably had some perturbation in the


